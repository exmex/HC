
		public function /*::SEND_METHOD_NAME::*/(/*::SENDMETHOD_REF_PARAMETERS::*/):int
		{
			var __xvbuf:ByteArray = new ByteArray();
			__xvbuf.endian = Endian.LITTLE_ENDIAN;
			if(!useAMF)
			{
				var __xvpacketlen:int = /*::XPACKET_CLASS_NAME::*/._Size(/*::SENDMETHOD_PASS_PARAMETERS::*/);
			
			
				
			
				var __xvres:int = 0;
			
				__xvres = /*::XPACKET_CLASS_NAME::*/._ToBuffer(__xvbuf,/*::SENDMETHOD_PASS_PARAMETERS::*/);
				if(__xvres !=__xvpacketlen)
				{
					return -1;
				}
				if(_m_bOutputNetworkDetails)
				{
					OutputNetworkDetails(true,/*::XPACKET_CLASS_NAME::*/._m_xcmd,__xvbuf);
				}
				__xvres = WriteDataToSocket(__xvbuf);
				
				return __xvres;
			}
			else
			{
				
				/*::XPACKET_CLASS_NAME::*/.toAMFObject(__xvbuf,/*::SENDMETHOD_PASS_PARAMETERS::*/);

				__xvres = WriteDataToSocket(__xvbuf);
				return __xvres;
			}

			
		}

