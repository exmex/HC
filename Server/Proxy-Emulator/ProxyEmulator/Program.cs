using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Sockets;

namespace ProxyEmulator
{
    internal class ProxyClient
    {
        private readonly NetworkStream _ns;
        private readonly ProxyServer _parent;
        private readonly TcpClient _tcp;

        private byte[] _buffer;

        public ProxyClient(TcpClient tcp, ProxyServer parent)
        {
            _tcp = tcp;
            _parent = parent;

            _ns = tcp.GetStream();
            try
            {
                _buffer = new byte[2048];
                _ns.BeginRead(_buffer, 0, 2048, OnPacket, null);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                _tcp.Close();
            }
        }

        private void OnPacket(IAsyncResult result)
        {
            try
            {
                var bytesRead = _ns.EndRead(result);
                if (bytesRead == 0)
                {
                    _buffer = new byte[2048];
                    _ns.BeginRead(_buffer, 0, 2048, OnPacket, null);
                    return;
                }

                Array.Resize(ref _buffer, bytesRead);

#if DEBUG
                Console.WriteLine("Sending API to API: " + _buffer.Length);
                Console.WriteLine(Program.HexDump(_buffer));
#endif

                // Verify if this doesn't actually block other clients?

                var byteArrayContent = new ByteArrayContent(_buffer);
                byteArrayContent.Headers.ContentType = new MediaTypeHeaderValue("application/x-protobuf");
                var httpResult = Program.HttpClient.PostAsync("", byteArrayContent).Result;
                var byteArr = httpResult.Content.ReadAsByteArrayAsync().Result;

                Console.WriteLine("API Result: " + byteArr.Length);

                _ns.Write(byteArr, 0, byteArr.Length);
                
                _buffer = new byte[2048];
                _ns.BeginRead(_buffer, 0, 2048, OnPacket, null);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                _tcp.Close();
            }
        }
    }

    internal class ProxyServer
    {
        private TcpListener _server;

        public ProxyServer(int port)
        {
            _server = new TcpListener(IPAddress.Any, port);
#if DEBUG
            Console.WriteLine("Server will listen on port {0}", port);
#endif
        }

        public void Start()
        {
            _server.Start();
            _server.BeginAcceptTcpClient(OnAccept, _server);
#if DEBUG
            Console.WriteLine("Server accepting clients!");
#endif
        }

        private void OnAccept(IAsyncResult result)
        {
            var tcpClient = _server.EndAcceptTcpClient(result);

            var client = new ProxyClient(tcpClient, this);

#if DEBUG
            Console.WriteLine("Accepted client from {0}", tcpClient.Client.RemoteEndPoint);
#endif

            _server.BeginAcceptTcpClient(OnAccept, _server);
        }
    }

    internal static class Program
    {
        public static readonly HttpClient HttpClient = new HttpClient();
        private static ProxyServer _server;

        private static void Main(string[] args)
        {
            HttpClient.DefaultRequestHeaders.Accept.Clear();
            HttpClient.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/x-protobuf"));

            HttpClient.BaseAddress = new Uri("http://localhost:8080/");

            _server = new ProxyServer(10001);
            _server.Start();

            while (true)
            {
            }
        }

        public static string HexDump(byte[] bytes, int bytesPerLine = 16)
        {
            if (bytes == null) return "<null>";
            var bytesLength = bytes.Length;

            var hexChars = "0123456789ABCDEF".ToCharArray();

            const int firstHexColumn = 8 + 3; // 8 characters for the address + 3 spaces

            var firstCharColumn = firstHexColumn
                                  + bytesPerLine * 3 // - 2 digit for the hexadecimal value and 1 space
                                  + (bytesPerLine - 1) / 8 // - 1 extra space every 8 characters from the 9th
                                  + 2; // 2 spaces 

            var lineLength = firstCharColumn
                             + bytesPerLine // - characters to show the ascii value
                             + Environment.NewLine.Length; // Carriage return and line feed (should normally be 2)

            var line = (new string(' ', lineLength - Environment.NewLine.Length) + Environment.NewLine).ToCharArray();
            var expectedLines = (bytesLength + bytesPerLine - 1) / bytesPerLine;
            var result = new StringBuilder(expectedLines * lineLength);

            for (var i = 0; i < bytesLength; i += bytesPerLine)
            {
                line[0] = hexChars[(i >> 28) & 0xF];
                line[1] = hexChars[(i >> 24) & 0xF];
                line[2] = hexChars[(i >> 20) & 0xF];
                line[3] = hexChars[(i >> 16) & 0xF];
                line[4] = hexChars[(i >> 12) & 0xF];
                line[5] = hexChars[(i >> 8) & 0xF];
                line[6] = hexChars[(i >> 4) & 0xF];
                line[7] = hexChars[(i >> 0) & 0xF];

                var hexColumn = firstHexColumn;
                var charColumn = firstCharColumn;

                for (var j = 0; j < bytesPerLine; j++)
                {
                    if (j > 0 && (j & 7) == 0) hexColumn++;
                    if (i + j >= bytesLength)
                    {
                        line[hexColumn] = ' ';
                        line[hexColumn + 1] = ' ';
                        line[charColumn] = ' ';
                    }
                    else
                    {
                        var b = bytes[i + j];
                        line[hexColumn] = hexChars[(b >> 4) & 0xF];
                        line[hexColumn + 1] = hexChars[b & 0xF];
                        line[charColumn] = (b < 32 ? '·' : (char) b);
                    }

                    hexColumn += 3;
                    charColumn++;
                }

                result.Append(line);
            }

            return result.ToString();
        }
    }
}