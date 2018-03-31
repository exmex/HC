using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using GameServer.Utils;
using Network.Packets;
using NLog;

namespace GameServer.Protocol
{
    public class Packet
    {
        public const int CMSG_DoLogin = 1;
        public const int CMSG_SendInternalNotifyByProxy = 12;
        public const int CMSG_OnKickout = 25;
        public const int CMSG_SendPing = 34;
        public const int CMSG_SendProtoBuff = 35;
        public const int CMSG_MAX = 36;

        private const string KEY_PREFIX = "darogn";

        private static Logger Logger = LogManager.GetCurrentClassLogger();

        public Packet()
        {
        }

        public Packet(byte[] data) : this()
        {
            ParsePacket(data);
        }

        public void ParsePacket(byte[] data)
        {
            using (var ms = new MemoryStream(data))
            {
                using (var reader = new BinaryReader(ms))
                {
                    if(reader.BaseStream.Length - reader.BaseStream.Position < 8)
                        throw new Exception("XPROTO_ERROR_CODE::XPROTO_PACKET_LESS_THAN_HDRLEN");
                    while (reader.BaseStream.Length - reader.BaseStream.Position >= 8)
                    {
                        var savePosition = reader.BaseStream.Position;
                        /*
                         * Packet Length
                         */
                        var len = reader.ReadInt32();

                        /*
                         * Packet Command
                         */
                        var cmd = reader.ReadInt32();

                        Logger.Debug("--------------------");
                        Logger.Debug("Len {0}, CMD: {1}", len, cmd);
                        Logger.Debug("--------------------");

                        if (len > ms.Length)
                            throw new Exception("XPROTO_ERROR_CODE::XPROTO_PACKET_LENGTH_OVERFLOW");

                        if (cmd <= 0 || cmd > CMSG_MAX || cmd < CMSG_DoLogin)
                            throw new Exception("XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE");
                        
                        reader.BaseStream.Seek(savePosition, SeekOrigin.Begin);
                        
                        var packetData = reader.ReadBytes(len);
                        switch (cmd)
                        {
                            default:
                                throw new Exception("XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE");
                            case CMSG_DoLogin: // OnDoLogin
                                Parse_DoLogin(packetData);
                                break;
                            case CMSG_SendInternalNotifyByProxy: // OnInternalNotifyByProxy
                                Parse_InternalNotifyByProxy(packetData);
                                break;
                            case CMSG_OnKickout: // OnKickout
                                Parse_Kickout(packetData);
                                break;
                            case CMSG_SendPing: // OnPing
                                Parse_Ping(packetData);
                                break;
                            case CMSG_SendProtoBuff: // OnProtoBuff
                                Parse_ProtoBuff(packetData);
                                break;
                        }
                    }
                }
            }
        }

        private void Parse_DoLogin(byte[] data)
        {
            throw new NotImplementedException();
        }

        private void Parse_InternalNotifyByProxy(byte[] data)
        {
            throw new NotImplementedException();
        }

        private void Parse_Kickout(byte[] data)
        {
            throw new NotImplementedException();
        }

        private void Parse_Ping(byte[] data)
        {
            throw new NotImplementedException();
        }

        private void Parse_ProtoBuff(byte[] data)
        {
            byte[] decryptedMsg;
            using (var ms = new MemoryStream(data))
            {
                using (var reader = new BinaryReader(ms))
                {
                    var __xvtemp1 = reader.ReadInt32();
                    var __xvtemp2 = reader.ReadInt32();
                    var __lpLen = reader.ReadInt32();
                    Logger.Debug($"xvtemp1: {__xvtemp1}, xvtemp2: {__xvtemp2}, lplen: {__lpLen}");
                    if (__lpLen > 0x2fffffff || __lpLen < 0)
                        throw new Exception("????");

                    //var encodedPacketData = reader.ReadBytes(__lpLen);
                    var mode = (int) reader.ReadByte();
                    var count1 = reader.ReadByte();
                    var count2 = reader.ReadByte();
                    var uinLen = count2 * 256 + count1;
                    Logger.Debug($"Mode: {mode}, count1: {count1}, count2: {count2}, uinLen: {uinLen}");

                    var uin = reader.ReadBytes(uinLen);
                    var uinStr = Encoding.UTF8.GetString(uin);
                    var cryptCodeLen = (int) reader.BaseStream.Length - (int) reader.BaseStream.Position;
                    var cryptCode = reader.ReadBytes(cryptCodeLen);

                    Logger.Debug($"uin: {uinStr}, cryptCodeLen: {cryptCodeLen}");

                    // TODO: Fetch SessionKey from DB
                    decryptedMsg = Decrypt(cryptCode, "123456789");
                }
            }

            byte[] output;
            using (var ms = new MemoryStream(decryptedMsg))
            {
                using (var reader = new BinaryReader(ms))
                {
                    var count1 = reader.ReadByte();
                    var count2 = reader.ReadByte();
                    var count3 = reader.ReadByte();
                    var count4 = reader.ReadByte();
                    Logger.Debug($"count1: {count1}, count2: {count2}, count3: {count3}, count4: {count4}, ");

                    var len = count4 * 256 * 256 * 256 + count3 * 256 * 256 + count2 * 256 + count1;
                    output = reader.ReadBytes(len);
                }
            }

            var obj = Class1.ParseUpMsg(output);
            Logger.Debug(((Up_Login)obj[0]).ToString());
            Logger.Debug(((Up_SdkLogin)obj[1]).ToString());

            Logger.Debug("--------------------");
        }

        private byte[] Decrypt(byte[] data, string key)
        {
            if (key.Length < 10)
                for (var i = 0; i < 10 - key.Length; i++)
                    key += "\0";
            else if (key.Length > 9)
                key = KEY_PREFIX + key.Substring(0, 10);
            
            using (var rj = new RijndaelManaged())
            {
                rj.Padding = PaddingMode.None;
                rj.Mode = CipherMode.CBC;

                rj.KeySize = 128;
                rj.BlockSize = 128;
                rj.Key = Encoding.Default.GetBytes(KEY_PREFIX + key);
                rj.IV = new byte[16];
                var ms = new MemoryStream();

                using (var cs = new CryptoStream(ms, rj.CreateDecryptor(rj.Key, rj.IV), CryptoStreamMode.Write))
                {
                    cs.Write(data, 0, data.Length);
                    cs.Close();
                    return ms.ToArray();
                }
            }
        }
    }
}