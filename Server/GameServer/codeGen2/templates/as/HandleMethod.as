		private function _/*::HANDLER_METHOD_NAME::*/(__src:ByteArray):int
		{
			var pPacket:/*::XPACKET_CLASS_NAME::*/ =  new /*::XPACKET_CLASS_NAME::*/();
			if(!useAMF)
			{
				var __len:int = __src.bytesAvailable;
				if(pPacket.FromBuffer(__src)!=__len)
				{
					return -1;
				}
			}
			else
			{
				__src.readInt();
				__src.readInt();
				__src.endian  =Endian.BIG_ENDIAN;;
			    var obj:Object = __src.readObject();
				__src.endian  =Endian.LITTLE_ENDIAN;
				pPacket.fromAMFObject(obj);
			}
			
			if(_m_bOutputNetworkDetails)
			{
				GameMessage.debugTrace((new Date()).time + " PROTOCOL - /*::HANDLER_METHOD_NAME::*/" + pPacket.ToDebugString());
			}
			
			dispatchEvent(pPacket);
			return 0;
		}

