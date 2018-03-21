
INT /*::PROTOCLASSNAME::*/::_/*::HANDLER_METHOD_NAME::*/(const char *__src,INT    __len)
{
		/*::XPACKET_CLASS_NAME::*/Ptr pPacket;
		pPacket.CreateInstance();
		if(pPacket==NULL) return -1;
		if(XFROM_BUFFER(pPacket,__src,__len)!=__len)
		{
			return -1;
		}
		int __xvres = /*::HANDLER_METHOD_NAME::*/(/*::HANDLER_PASS_PARAMETERS::*/);
		return __xvres;
}

