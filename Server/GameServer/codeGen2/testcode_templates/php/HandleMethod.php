
		private function _/*::HANDLER_METHOD_NAME::*/($__src)
		{
			//require_once("/*::XPACKET_CLASS_NAME::*/.php");
			$pPacket  =  new /*::XPACKET_CLASS_NAME::*/();
			
			if(!$this->useAMF)
			{
				$__len		= $__src->getBytesAvailable();
				if($pPacket->FromBuffer($__src)!=$__len)
				{
					return -1;
				}
			
			//	if (DEBUG)
			//	{
			//	    Logger::getLogger()->debug("/*::HANDLER_METHOD_NAME::*/".$pPacket->ToDebugString());
			//	}
				
				return $this->/*::HANDLER_METHOD_NAME::*/($pPacket);			
			}
			else
			{
				

				$obj = ReadAMF3Object($__src);
				$pPacket->fromAMFObject($obj);
				
			//	if (DEBUG)
			//	{
			//	    Logger::getLogger()->debug("/*::HANDLER_METHOD_NAME::*/".$pPacket->ToDebugString());
			//	}

				return $this->/*::HANDLER_METHOD_NAME::*/($pPacket);
			}


		}