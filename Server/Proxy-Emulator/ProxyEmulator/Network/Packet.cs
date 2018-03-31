using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Network.Packets;

namespace Network
{
    public class Packet
    {
        public const int CMSG_DoLogin = 1;
        public const int CMSG_SendInternalNotifyByProxy = 12;
        public const int CMSG_OnKickout = 25;
        public const int CMSG_SendPing = 34;
        public const int CMSG_SendProtoBuff = 35;
        public const int CMSG_MAX = 36;

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
                    if (reader.BaseStream.Length - reader.BaseStream.Position < 8)
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
            /*
            public function OnDoLogin($pPacket XPACKET_DoLogin) :int
            {
                $this->SetServerId($pPacket->userId,$pPacket->server);
                return 0;
            }
            
            public function SetServerId($puid,$ret)
            {
                $key = "SERVER_ID_".$puid;
                $mem = CMemcache::getInstance();
                $mem ->setData($key, $ret,86400); 
            }
            */
        }

        private void Parse_InternalNotifyByProxy(byte[] data)
        {
            /*
             * This function is PROXY program used to notify the client disconnected, notification is the event reference _EINTERNAL_NOTIFY_BY_PROXY_A
             * It is mainly used for the temporary data clean-up of the disconnection line, offline notification of buddies, and the sending state of the previous instruction.
             * Note that any response here will not continue to be sent to CLIENT.
             */
            /*
            public function OnInternalNotifyByProxy($pPacket XPACKET_SendInternalNotifyByProxy) : int
            {
                return 0;
            }
            */
            // Ignored
        }

        private void Parse_Kickout(byte[] data)
        {
            /*
		    public function OnKickout($pPacket XPACKET_OnKickout) : int
            {
                return 0;
            }
            */
            // Ignored
        }

        private void Parse_Ping(byte[] data)
        {
            /*
		    public function OnPing($pPacket XPACKET_SendPing) : int
            {
                return 0;
            }
            */
            // Ignored
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

                    if (__lpLen > 0x2fffffff || __lpLen < 0)
                        throw new Exception("????");

                    //var encodedPacketData = reader.ReadBytes(__lpLen);
                    var mode = (int)reader.ReadByte();
                    var count1 = reader.ReadByte();
                    var count2 = reader.ReadByte();
                    var uinLen = count2 * 256 + count1;

                    var uin = reader.ReadBytes(uinLen);
                    var uinStr = Encoding.UTF8.GetString(uin);
                    var cryptCodeLen = (int)reader.BaseStream.Length - (int)reader.BaseStream.Position;
                    var cryptCode = reader.ReadBytes(cryptCodeLen);

                    // TODO: Fetch SessionKey from DB
                    decryptedMsg = Encryption.Decrypt(cryptCode, "123456789");
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

                    var len = count4 * 256 * 256 * 256 + count3 * 256 * 256 + count2 * 256 + count1;
                    output = reader.ReadBytes(len);
                }
            }

            var obj = Class1.ParseUpMsg(output);
        }
    }
}
