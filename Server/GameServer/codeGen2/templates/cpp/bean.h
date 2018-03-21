


class /*::CLASS_NAME::*//*::PARENT_CLASS_NAME::*/
{
public:
/*{::PACKET_COMMAND_DEFINES::}*/
//fields
/*{::CLASS_MEMBER_DEFINES::}*/

public:
	INT  Size();
	INT  FromBuffer(const char *__src,INT    __len);
	INT  ToBuffer(char *__dst,INT    __len);
#if !defined(CC_TARGET_OS_IPHONE) && !defined(CC_TARGET_OS_MAC) && !defined(ANDROID)
	INT  FromXml(XP_XMLNODE_PTR pNode);
	INT  ToXml(XSTRING_STREAM & out);
#endif


private:
	/*::CLASS_NAME::*/(/*::CLASS_NAME::*/& src);//avoid bit constructor
public:
	
	//static int Clone(/*::CLASS_NAME::*/* src, /*::CLASS_NAME::*/* dst);
	

	static /*::CLASS_NAME::*/* CreateInstance()
	{
		 /*::CLASS_NAME::*/* p =  new (::std::nothrow) /*::CLASS_NAME::*/();
		 return p;
	}
	
protected:
	/*::CLASS_NAME::*/()
	{
/**::SMART_POINTER_CONSTRUCT::**/
	}

	virtual ~/*::CLASS_NAME::*/()
	{
	}

};

typedef _bean_ptr_t</*::CLASS_NAME::*/>  /*::CLASS_NAME::*/Ptr;

//--------------------------------------------------------------

