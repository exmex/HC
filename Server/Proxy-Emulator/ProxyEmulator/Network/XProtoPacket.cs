using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Network
{
    [AttributeUsage(AttributeTargets.Method, Inherited = false, AllowMultiple = true)]
    public class XProtoPacketAttribute : Attribute
    {
        public XProtoPacketAttribute(int id)
        {
            Id = id;
        }

        public int Id { get; }
    }

    public static class XProtoPackets
    {
        public const int DoLogin = 1;
        public const int SendInternalNotifyByProxy = 12;
        public const int OnKickout = 25;
        public const int SendPing = 34;
        public const int SendProtoBuff = 35;
    }

    public class XProtoPacket
    {
        public enum XProtoPackets
        {
            DoLogin = 1,
            SendInternalNotifyByProxy = 12,
            OnKickout = 25,
            SendPing = 34,
            SendProtoBuff = 35,
            MAX = 36
        }

        public XProtoPackets Id;
        public byte[] Payload;

        public XProtoPacket(XProtoPackets id, byte[] payload)
        {
            Id = id;
            Payload = payload;
        }

        public XProtoPacket()
        {
        }

        public static List<XProtoPacket> ReadPackets(byte[] buffer)
        {
            var packets = new List<XProtoPacket>();
            using (var ms = new MemoryStream(buffer))
            {
                using (var reader = new BinaryReader(ms))
                {
                    if (reader.BaseStream.Length - reader.BaseStream.Position < 8)
                        throw new Exception("XPROTO_ERROR_CODE::XPROTO_PACKET_LESS_THAN_HDRLEN");

                    // while($br->getBytesAvailable()>=8)
                    // Is this ever be true a 2nd time?
                    while (reader.BaseStream.Length - reader.BaseStream.Position >= 8)
                    {
                        var packet = new XProtoPacket();
                        var savePosition = reader.BaseStream.Position;

                        var len = reader.ReadInt32();
                        packet.Id = (XProtoPackets)reader.ReadInt32();

                        if (len > ms.Length)
                            throw new Exception("XPROTO_ERROR_CODE::XPROTO_PACKET_LENGTH_OVERFLOW");

                        if (packet.Id <= 0 || packet.Id > XProtoPackets.MAX ||
                            packet.Id < XProtoPackets.DoLogin)
                            throw new Exception("XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE");

                        reader.BaseStream.Seek(savePosition, SeekOrigin.Begin);

                        packet.Payload = reader.ReadBytes(len);

                        packets.Add(packet);
                    }
                }
            }

            return packets;
        }
    }
}
