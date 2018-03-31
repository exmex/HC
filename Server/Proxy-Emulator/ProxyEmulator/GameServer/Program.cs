using System;
using System.CodeDom;
using System.IO;
using GameServer.Protocol;
using GameServer.Utils;
using Network;
using NLog;

namespace GameServer
{
    internal class Program
    {
        public static Logger Logger = LogManager.GetLogger("Main");

        public static void ExportProtoPackets()
        {
            Directory.CreateDirectory("files");
            foreach (var file in Directory.EnumerateFiles(@"H:\Source\HG\Client\Resource_Client\packets\"))
            {
                Console.WriteLine($"Reading {new FileInfo(file).Name}");
                var pkts = XProtoPacket.ReadPackets(File.ReadAllBytes(file));
                foreach (var packet in pkts)
                {
                    var protoBuf = new ProtoBuffPacket(packet.Payload);
                    File.WriteAllBytes($"files/{new FileInfo(file).Name}.bin", protoBuf.Payload);
                }
            }
        }

        public static void Main(string[] args)
        {
            var data = File.ReadAllBytes(@"H:\Source\HG\Client\Resource_Client\packets\2system_setting");

            Console.WriteLine(data.HexDump());

            var packets = XProtoPacket.ReadPackets(data);

            foreach (var packet in packets)
            {
                switch (packet.Id)
                {
                    case XProtoPacket.XProtoPackets.SendProtoBuff:
                        var p = new ProtoBuffPacket(packet.Payload);
                        Console.WriteLine(packet.Payload.HexDump());
                        Console.WriteLine(p.Payload.HexDump());
                        foreach (var message in p.Messages)
                        {
                            Console.WriteLine(message);
                        }
                        break;
                    default:
                        throw new NotImplementedException();
                }
            }

            Console.ReadKey();
            
            //var data = File.ReadAllBytes(@"H:\Source\HG\Client\Resource_Client\packets\0login");
            //var data = File.ReadAllBytes(@"H:\Source\HG\Client\Resource_Client\packets\1system_setting");
            //var data = File.ReadAllBytes(@"H:\Source\HG\Client\Resource_Client\packets\2get_svr_time");
            //var data = File.ReadAllBytes(@"H:\Source\HG\Client\Resource_Client\packets\2login");

            //var pkt = new Packet(data);

            /*using (var ms = new MemoryStream(data))
            {
                using (var reader = new BinaryReader(ms))
                {
                    if(reader.BaseStream.Length - reader.BaseStream.Position < 8)
                        throw new Exception("XPROTO_ERROR_CODE::XPROTO_PACKET_LESS_THAN_HDRLEN");

                    // while($br->getBytesAvailable()>=8)
                    // Is this ever be true a 2nd time?
                    while (reader.BaseStream.Length - reader.BaseStream.Position >= 8)
                    {
                        var savePosition = reader.BaseStream.Position;
                        var len = reader.ReadInt32();
                        var cmd = reader.ReadInt32();

                        Console.WriteLine($"Len: {len}, CMD: {cmd}");

                        if (len > ms.Length)
                            throw new Exception("XPROTO_ERROR_CODE::XPROTO_PACKET_LENGTH_OVERFLOW");
                        
                        if (cmd <= 0 || cmd > _EMSG_ServerInterface.CMSG_MAX ||
                            cmd < _EMSG_ServerInterface.CMSG_DoLogin)
                            throw new Exception("XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE");

                        reader.BaseStream.Seek(savePosition, SeekOrigin.Begin);

                        var packetData = reader.ReadBytes(len+1);
                        switch (cmd)
                        {
                            default:
                                throw new Exception("XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE");
                            case 1: // OnDoLogin
                                OnDoLogin(packetData);
                                break;
                            case 12: // OnInternalNotifyByProxy
                                OnInternalNotifyByProxy(packetData);
                                break;
                            case 25: // OnKickout
                                OnKickout(packetData);
                                break;
                            case 34: // OnPing
                                OnPing(packetData);
                                break;
                            case 35: // OnProtoBuff (WorldSvc.php:218)
                                OnProtoBuff(packetData); 
                                break;
                        }
                    }
                    
                    /*
                    // HandleReceivedData (GameProtocolServer.php:88)
                    var len = reader.ReadInt32();
                    var cmd = reader.ReadInt32();

                    if (len > ms.Length)
                        throw new Exception("XPROTO_ERROR_CODE::XPROTO_PACKET_LENGTH_OVERFLOW");

                    Console.WriteLine($"Len: {len}, CMD: {cmd}");

                    if (cmd <= 0 || cmd > _EMSG_ServerInterface.CMSG_MAX ||
                        cmd < _EMSG_ServerInterface.CMSG_DoLogin)
                        throw new Exception("XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE");

                    byte[] packet = new byte[ms.Length-8];
                    Array.Copy(ms.ToArray(), 8, packet, 0, ms.Length-8);
                    switch (cmd)
                    {
                        default:
                            throw new Exception("XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE");
                        case 1: // OnDoLogin
                            OnDoLogin(packet);
                            break;
                        case 12: // OnInternalNotifyByProxy
                            OnInternalNotifyByProxy(packet);
                            break;
                        case 25: // OnKickout
                            OnKickout(packet);
                            break;
                        case 34: // OnPing
                            OnPing(packet);
                            break;
                        case 35: // OnProtoBuff (WorldSvc.php:218)
                            OnProtoBuff(packet); 
                            break;
                    }
                }
            }*/

            LogManager.Shutdown();
        }

        public static void OnDoLogin(byte[] data)
        {
            Console.WriteLine("Login request.");
        }

        public static void OnInternalNotifyByProxy(byte[] data)
        {
            Console.WriteLine("OnInternalNotifyByProxy");
        }

        public static void OnKickout(byte[] data)
        {
            Console.WriteLine("OnKickout");
        }

        public static void OnPing(byte[] data)
        {
            Console.WriteLine("OnPing");
        }

        public static void OnProtoBuff(byte[] data)
        {
            Console.WriteLine("OnProtoBuff");
            using (var ms = new MemoryStream(data))
            {
                using (var reader = new BinaryReader(ms))
                {
                    /*
                    if ($__src->getBytesAvailable () < 4)
                                return 0;
                    
                    $__lplen->_value = $__src->readInt32 ();
                    
                    if ($__lplen->_value > 0x2fffffff) {
                        return 0;
                    }
                    return 4;
                    */
                    
                    var __xvtemp1 = reader.ReadInt32();
                    var __xvtemp2 = reader.ReadInt32();
                    var __lpLen = reader.ReadInt32();
                    Console.WriteLine($"xvtemp1: {__xvtemp1}, xvtemp2: {__xvtemp2}, lplen: {__lpLen}");
                    if(__lpLen > 0x2fffffff || __lpLen < 0)
                        throw new Exception("????");

                    //var encodedPacketData = reader.ReadBytes(__lpLen);
                    var mode = (int)reader.ReadByte();
                    var count1 = reader.ReadByte();
                    var count2 = reader.ReadByte();
                    var uinLen = count2 * 256 + count1;
                    Console.WriteLine($"Mode: {mode}, count1: {count1}, count2: {count2}, uinLen: {uinLen}");

                    var uin = reader.ReadBytes(uinLen);
                    var uinStr = System.Text.Encoding.UTF8.GetString(uin);
                    var cryptCodeLen = (int)reader.BaseStream.Length - (int)reader.BaseStream.Position;
                    var cryptCode = reader.ReadBytes(cryptCodeLen);

                    Console.WriteLine($"uin: {uinStr}, cryptCodeLen: {cryptCodeLen}");
                    /*
                     * $tbUserInfo = PlayerCacheModule::getUserInfoData($uin, $mode);
                     * $GLOBALS['SERVERID'] =  $_SERVER['FASTCGI_PLAYER_SERVER'] = self::GetServerId($uin);
                     */

                    /*
$byArr = new XByteArray();
$byArr->set_data($input);
$mode = intval($byArr->readByte());
$count1 = $byArr->readByte();
$count2 = $byArr->readByte();
$uinLen = $count2 * 256 + $count1;

// user id
$uin = $byArr->readBinary($uinLen);
$GLOBALS['USER_PUID'] = $uin;
$cryptCodeLen = $byArr->getBytesAvailable();
$cryptCode = $byArr->readBinary($cryptCodeLen);
$tbUserInfo = PlayerCacheModule::getUserInfoData($uin, $mode);
$GLOBALS['SERVERID'] =  $_SERVER['FASTCGI_PLAYER_SERVER'] = self::GetServerId($uin);
Logger::getLogger()->debug("OnProtoBuff Process Star".$GLOBALS['SERVERID']);
                     */

                    // Continuation on WorldSvc.php:218
                    /*
                    $retPacket = new Down_DownMsg();
                    $retCode = OnProtoBuff($this, $pPacket, $retPacket);
                    //Logger::getLogger()->debug("getLoginReplyPacket OnProtoBuff " . json_encode($pPacket));
                    $this->SendClientPacket($retCode, $retPacket);
                    if ($profileMode) {
                           // stop profiler
                        $xhprof_data = xhprof_disable();
                        // save raw data for this profiler run using default
                        // implementation of iXHProfRuns.
                        $xhprof_runs = new XHProfRuns_Default();
                    
                        // save the run under a namespace "xhprof_foo"
                        $run_id = $xhprof_runs->save_run($xhprof_data, "OnProtoBuff");
                    
                        LogProfile::getInstance()->log("OnProtoBuff RunID = " . $run_id);
                    }
                     */

                }
            }
        }
    }

    /*
private static $_s_OpHandlers=  array(
	"_NullActionHandler","_NullActionHandler",

	"CMSG_DoLogin","_OnDoLogin",
	"CMSG_SendInternalNotifyByProxy","_OnInternalNotifyByProxy",
	"CMSG_OnKickout","_OnKickout",
	"CMSG_SendPing","_OnPing",
	"CMSG_SendProtoBuff","_OnProtoBuff",

);
     
private $_s_msg_index_map= array(

		0x00000001=>1, // 1
		0x0000000C=>2, // 12
		0x00000019=>3, // 25
		0x00000022=>4, // 34
		0x00000023=>5, // 35
    );
     
private function get_index_of_msg($msg)
{
   if(!array_key_exists($msg,$this->_s_msg_index_map))
   {
      return 0;
   }
   return $this->_s_msg_index_map[$msg] ;
}

$br->position = $savePos;
          
$msg_idx = $this->get_index_of_msg($cmd);
if($msg_idx<=0)
{
	return XPROTO_ERROR_CODE::XPROTO_XCMD_OUT_OF_RANGE;  
}

$action  = GameProtocolServer::$_s_OpHandlers[2*$msg_idx];	
if (!$this->CheckValidAction($action, $cmd))
{
	return XPROTO_ERROR_CODE::XPROTO_CONNECTION_STATE_CHECK_FAILED;						
}				
	
$func = GameProtocolServer::$_s_OpHandlers[1+2*$msg_idx];			
$tmp = $br->readBinary($len);	
$packet = new XByteArray();
$packet->set_data($tmp);
$ret = $this->$func($packet);		
if($ret<0)
{
	return $ret;
}
     */

    internal class _EMSG_ServerInterface
    {
        public const int CMSG_DoLogin = 1;
        public const int CMSG_SendInternalNotifyByProxy = 12;
        public const int CMSG_OnKickout = 25;
        public const int CMSG_SendPing = 34;
        public const int CMSG_SendProtoBuff = 35;
        public const int CMSG_MAX = 36;
    }
}