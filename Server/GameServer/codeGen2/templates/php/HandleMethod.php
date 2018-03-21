
		private function _/*::HANDLER_METHOD_NAME::*/($__src)
		{
			require_once($GLOBALS['GAME_ROOT'] . "protocol//*::XPACKET_CLASS_NAME::*/.php");
			$pPacket  =  new /*::XPACKET_CLASS_NAME::*/();
			
			$ret = -1;
			$start_time = microtime(TRUE);
			
			if(!$this->useAMF)
			{
				$__len		= $__src->getBytesAvailable();
				if($pPacket->FromBuffer($__src)!=$__len)
				{
					
				}
				else
				{
					if (DEBUG)
					{
					    Logger::getLogger()->debug("/*::HANDLER_METHOD_NAME::*/");
					}
					$ret = $this->/*::HANDLER_METHOD_NAME::*/($pPacket);			
				}
				
				
			}
			else
			{				

				$obj = ReadAMF3Object($__src);
				$pPacket->fromAMFObject($obj);
				
				if (DEBUG)
				{
				    Logger::getLogger()->debug($_SERVER[_ECUSTOM_HEADER::socket_id]." /*::HANDLER_METHOD_NAME::*/".$pPacket->ToDebugString());
				}

				$ret = $this->/*::HANDLER_METHOD_NAME::*/($pPacket);
			}


			$run_time = microtime(TRUE) - $start_time;
			
			if($run_time >= 0.01){
				LogProfile::getInstance()->log("/*::HANDLER_METHOD_NAME::*/ " . $run_time . " MYSQL_CONNECT_TIME:" . MySQL::$connect_time . " QUERY_TIME:" . MySQL::$query_time . " WRITE_LOG_TIME:" . Logger::$log_time);
			}
			
			return $ret;
		}