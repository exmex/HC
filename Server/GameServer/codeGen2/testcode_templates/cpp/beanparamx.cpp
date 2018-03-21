
INT /*::CLASS_NAME::*/::_Size(/*{::REF_PARAMETERS::}*/)
{
		INT __xv =0;
/*{::SIZE_CALC_CODES::}*/
		return __xv;
}

INT  /*::CLASS_NAME::*/::_FromBuffer(const char *__src,INT    __len,/*{::REF_PARAMETERS::}*/)
{
		INT __xv=0;
/*{::FROM_BUFFER_CODES::}*/
		return __xv;
}

INT  /*::CLASS_NAME::*/::_ToBuffer(char *__dst,INT    __len,/*{::REF_PARAMETERS::}*/)
{
		INT __xv=0;
/*{::TO_BUFFER_CODES::}*/
		return __xv;
}

INT  /*::CLASS_NAME::*/:: Size()
{
		return /*::CLASS_NAME::*/::_Size(/*{::PASS_PARAMETERS::}*/);
}
	
INT  /*::CLASS_NAME::*/::FromBuffer(const char *__src,INT    __len)
{
		return /*::CLASS_NAME::*/::_FromBuffer(__src,__len,/*{::PASS_PARAMETERS::}*/);
}
	
INT  /*::CLASS_NAME::*/::ToBuffer(char *__dst,INT    __len)
{
		return /*::CLASS_NAME::*/::_ToBuffer(__dst,__len,/*{::PASS_PARAMETERS::}*/);
}

INT  /*::CLASS_NAME::*/::FromXml(XP_XMLNODE_PTR pNode)
{
/*{::FROM_XML_CODES::}*/
	    return 0;
}
INT  /*::CLASS_NAME::*/::ToXml(XSTRING_STREAM & out)
{
/*{::TO_XML_CODES::}*/
	    return 0;
}
//---------------------------------------------------------------------------------------------

