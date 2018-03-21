

INT /*::PROTOCLASSNAME::*/::/*::SEND_METHOD_NAME::*/(/*::SENDMETHOD_REF_PARAMETERS::*/)
{
	INT __xvpacketlen = /*::XPACKET_CLASS_NAME::*/::_Size(/*::SENDMETHOD_PASS_PARAMETERS::*/);


	CHAR *__xvbuf = GetSendBuffer(__xvpacketlen);

	if(!__xvbuf)
	{
		return -1;
	}

	INT __xvres = 0;
	__xvres = /*::XPACKET_CLASS_NAME::*/::_ToBuffer(__xvbuf,__xvpacketlen,/*::SENDMETHOD_PASS_PARAMETERS::*/);

	if(__xvres !=__xvpacketlen)
	{
		return -1;
	}
	
	if(_m_bEnableNetworksDebugOutput)
	{
		OutputNetworkDetails(true,/*::XPACKET_CLASS_NAME::*/::_m_xcmd, (UCHAR*)__xvbuf,__xvpacketlen);
	}

	__xvres = WriteDataToSocket();
	return __xvres;
}
