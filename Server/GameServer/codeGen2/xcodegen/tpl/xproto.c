/*
  +----------------------------------------------------------------------+
  | PHP Version 5                                                        |
  +----------------------------------------------------------------------+
  | Copyright (c) 1997-2007 The PHP Group                                |
  +----------------------------------------------------------------------+
  | This source file is subject to version 3.01 of the PHP license,      |
  | that is bundled with this package in the file LICENSE, and is        |
  | available through the world-wide-web at the following url:           |
  | http://www.php.net/license/3_01.txt                                  |
  | If you did not receive a copy of the PHP license and are unable to   |
  | obtain it through the world-wide-web, please send a note to          |
  | license@php.net so we can mail you a copy immediately.               |
  +----------------------------------------------------------------------+
  | Author:                                                              |
  +----------------------------------------------------------------------+
*/

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "php_xproto.h"

#define IS_PROPERTY(p) Z_STRLEN_P(propname) == sizeof(p)-1 && memcmp(propname->value.str.val,p,sizeof(p)-1)==0
#define SET_MEMBER(__pv,type,convert){ \
	if (__pv != NULL) FREE_ZVAL(__pv);\
		MAKE_STD_ZVAL(__pv);\
	ZVAL_ZVAL(__pv,param_value,1,1);\
	if (Z_TYPE_P(__pv) != type)\
		convert(__pv);\
}
	
#define FREE_MEMBER(__pv){\
     if (__pv != NULL) \
          FREE_ZVAL(__pv);\
     __pv = NULL;\
     }
	
#define STRING_SIZE(ps) if(ps!=NULL) len += (Z_STRLEN_P(ps)+5);

#define NEW_ZVAL_LONG(z, l){\
	MAKE_STD_ZVAL(z);\
	ZVAL_LONG(z,l);\
	}

#define NEW_ZVAL_DOUBLE(z, d){\
	MAKE_STD_ZVAL(z);\
	ZVAL_DOUBLE(z,d);\
	}

#define NEW_ZVAL_EMPTY_STRING(z){\
	MAKE_STD_ZVAL(z);\
	ZVAL_EMPTY_STRING(z);\
	}

#define NEW_ZVAL_ARRAY(z){\
	MAKE_STD_ZVAL(z);\
	array_init(z);\
	}

#define NEW_ZVAL_OBJECT(z,cname,cfun){\
	zend_class_entry *ce;\
	MAKE_STD_ZVAL(z);\
	ce = zend_fetch_class(cname, sizeof(cname)-1, ZEND_FETCH_CLASS_AUTO TSRMLS_CC);\
	object_init_ex(z,ce);\
	cfun(z TSRMLS_CC);\
	}


#define PROP_FROM_BUFF_SAFE(SOB,type,subtype,static_array_len, obj_decode_func) \
	if(SOB != NULL) FREE_ZVAL(SOB);\
	MAKE_STD_ZVAL(SOB);\
	__ret = decode_xproto_data(SOB TSRMLS_CC, type,subtype,static_array_len,__src+__xsize, __maxlen-__xsize, obj_decode_func, &__xsize);\
	if(__ret<0) return __ret;

#define PROP_TO_BUFF_SAFE(SOB,type,subtype,static_array_len, obj_encode_func) \
	__ret = encode_xproto_data(SOB TSRMLS_CC, type,subtype,__dst+__xsize,__maxlen-__xsize,static_array_len, obj_encode_func, &__xsize);\
	if(__ret<0) return __ret;

int decode_xproto_data(zval *dst_obj TSRMLS_DC, int type, int  sub_type, int static_array_len, const char *__src,  int  maxlen, TPFN_XDECODE obj_decode_func, int *ret_size)
{
	int cur_size = *ret_size ;
	switch(type)
	{
		case echar:
			{
				char c = *(__src);
				if(maxlen<1) return -1;
				*ret_size = cur_size + 1 ;
				ZVAL_LONG(dst_obj,c);
			}
			break;
		case euchar:
			{
				unsigned char c = (unsigned char) * (__src);
				if(maxlen<1) return -1;
				ZVAL_LONG(dst_obj,c);
				*ret_size = cur_size + 1 ;
			}
			break;
		case eshort:
			{
				short s  = 0;
				if(maxlen<2) return -1;
				s =  * (short *)(__src);
				ZVAL_LONG(dst_obj,s);
				*ret_size = cur_size + 2 ;							
			}
			break;
		case eushort:
			{
				unsigned short s  = 0;
				if(maxlen<2) return -1;
				s =  * (unsigned  short *)(__src);
				ZVAL_LONG(dst_obj,s);
				*ret_size = cur_size + 2 ;							
			}
			break;
		case eint:
			{
				int s  = 0;
				if(maxlen<4) return -1;
				s =  * (int *)(__src);
				ZVAL_LONG(dst_obj,s);
				*ret_size = cur_size + 4 ;
			}
			break;
		case euint:
			{
				unsigned int s  = 0;
				if(maxlen<4) return -1;
				s =  * (unsigned int *)(__src);
				ZVAL_LONG(dst_obj,s);
				*ret_size = cur_size + 4 ;
			}
			break;
		case elonglong:
			{
				//TODO
				LONGLONG s  = 0;
				if(maxlen<8) return -1;
				s =  * (LONGLONG *)(__src);
				ZVAL_LONG(dst_obj,s);
				*ret_size = cur_size + 8 ;
			}
			break;
		case eulonglong:
			{
				//TODO
				ULONGLONG s  = 0;
				if(maxlen<8) return -1;
				s =  * (ULONGLONG *)(__src);
				ZVAL_LONG(dst_obj,s);
				*ret_size = cur_size + 8 ;
			}
			break;
		case efloat:
			{
				float s  = 0;
				if(maxlen<4) return -1;
				s =  * (float *)(__src);
				ZVAL_DOUBLE(dst_obj,s);
				*ret_size = cur_size + 4 ;
			}
			break;
		case edouble:
			{
				double s  = 0;
				if(maxlen<8) return -1;
				s =  * (double *)(__src);
				ZVAL_DOUBLE(dst_obj,s);
				*ret_size = cur_size + 8 ;
			}
			break;
		case estringa:
			{
				int  len  = 0;
				if(maxlen<4) return -1;
				len  =  *(int *)(__src);
				if(len<0) return -1;
					
				dst_obj->type = IS_STRING;
				Z_STRLEN_P(dst_obj) = len-1;
				Z_STRVAL_P(dst_obj) = estrndup(__src+4,len);
				*ret_size = cur_size + 4+len ;
			}
			break;
		case ebytearray:
			{
				int  len  = 0;
				if(maxlen<4) return -1;
				len  =  *(int *)(__src);
				if(len<0) return -1;
				dst_obj->type = IS_STRING;
				Z_STRLEN_P(dst_obj) = len;
				Z_STRVAL_P(dst_obj) = estrndup(__src+4,len);
				*ret_size = cur_size + 4+len ;
			}
			break;
		case eobject:
			return obj_decode_func(dst_obj TSRMLS_CC,__src, maxlen, ret_size);
			break;
		case earray:
			{
				if (sub_type!=earray && Z_TYPE_P(dst_obj) == IS_ARRAY) {
					int xsize= 0;
					int ret = 0;
					int tmp_size = 0;
					int i=0;

					zval *value;
					
					if(static_array_len >0)
					{
						//TODO?	
					}	
					else
					{
						if(maxlen<4) return -1;
						static_array_len = *(int *)__src;
						xsize +=4;
					}	
					
					for(i=0;i<static_array_len;i++)
					{
						 MAKE_STD_ZVAL(value);
						 if(sub_type==eobject)
						 {
								TSRMLS_FETCH();
							 	if(object_init(value)!=SUCCESS)
								{
								    return -1;
								}
						 }
						 tmp_size = 0;
						 ret = decode_xproto_data(value TSRMLS_CC, sub_type,-1, 0, __src+xsize, maxlen-xsize, obj_decode_func, &tmp_size);
						 if(ret<0)
						 {
						 		return -1;
						 }
						 xsize += tmp_size;
						 
						 add_index_zval(dst_obj, i, value);
					}
					
					
					*ret_size = cur_size +xsize;
				}
				else
				{
					 return -1;
				}
				
			}
			break;
		default: 
			return -1;
	};		
	
	return 0;
		
}

int encode_xproto_data(zval *src_obj TSRMLS_DC, int type, int sub_type,   char *__dst,  int maxlen,  int static_array_len, TPFN_XENCODE obj_encode_func, int *ret_size)
{
	 
	int cur_size = *ret_size ;
	switch(type)
	{
		case echar:
			{
				
				char c =0; 
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}
					c = (char)Z_LVAL_P(src_obj);
				}			
				if(maxlen<1) return -1;
				if(__dst) memcpy(__dst, &c,1);
				*ret_size = cur_size + 1 ;
				
			}
			break;
		case euchar:
			{
				unsigned char c = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}
					c = ( unsigned char)Z_LVAL_P(src_obj);
				}
				if(maxlen<1) return -1;
				if(__dst) memcpy(__dst, &c,1);
				*ret_size = cur_size + 1 ;
			}
			break;
		case eshort:
			{
				short c = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
                    if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}					
					c = ( short)Z_LVAL_P(src_obj);
				}
				if(maxlen<2) return -1;
				if(__dst) memcpy(__dst, &c,2);
				*ret_size = cur_size + 2 ;							
			}
			break;
		case eushort:
			{
				unsigned short c = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
				    if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}
					c = (unsigned short)Z_LVAL_P(src_obj);
				}
				if(maxlen<2) return -1;
				if(__dst) memcpy(__dst, &c,2);
				*ret_size = cur_size + 2 ;							
			}
			break;
		case eint:
			{
				int c = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}
					c = (int)Z_LVAL_P(src_obj);
				}
				if(maxlen<4) return -1;
				if(__dst) memcpy(__dst, &c,4);
				*ret_size = cur_size + 4 ;		
			}
			break;
		case euint:
			{
				unsigned int c = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}
					c = (unsigned int)Z_LVAL_P(src_obj);
				}
				if(maxlen<4) return -1;
				if(__dst) memcpy(__dst, &c,4);
				*ret_size = cur_size + 4 ;	
			}
			break;
		case elonglong:
			{
				//TODO
				LONGLONG c = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}
					c = (LONGLONG)Z_LVAL_P(src_obj);
				}
				if(maxlen<8) return -1;
				if(__dst) memcpy(__dst, &c,8);
				*ret_size = cur_size + 8 ;	
			}
			break;
		case eulonglong:
			{
				//TODO
				ULONGLONG c = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_LONG){
						convert_to_long(src_obj);
					}
					c = (ULONGLONG)Z_LVAL_P(src_obj);
				}
				if(maxlen<8) return -1;
				if(__dst) memcpy(__dst, &c,8);
				*ret_size = cur_size + 8 ;	
			}
			break;
			
		case efloat:
			{
				float c  = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_DOUBLE){
						convert_to_double(src_obj);
					}
					c = (float)Z_DVAL_P(src_obj);
				}
				if(maxlen<4) return -1;
				if(__dst) memcpy(__dst, &c,4);
				*ret_size = cur_size + 4 ;
			}
			break;
			
		case edouble:
			{
				double c  = 0;
				if (Z_TYPE_P(src_obj) != IS_NULL){
					if (Z_TYPE_P(src_obj) != IS_DOUBLE){
						convert_to_double(src_obj);
					}
					c = (double)Z_DVAL_P(src_obj);
				}
				if(maxlen<8) return -1;
				if(__dst) memcpy(__dst, &c,  8);
				*ret_size = cur_size + 8 ;
			}
			break;
			
		case estringa:
			{
				int  len = 0;
				if(maxlen<5) return -1;							
				if (Z_TYPE_P(src_obj) == IS_NULL)
				{
					if(__dst) memcpy(	__dst,   &len,   4);
				}
				else
				{				
					len = Z_STRLEN_P(src_obj)+1;					
					if(__dst) memcpy(	__dst,   &len,   4);
					if(__dst) memcpy(	__dst+4, Z_STRVAL_P(src_obj), len);									
				}
				//if(__dst) __dst[4+len]=0;	
				*ret_size = cur_size + 4 + len ;
			}
			break;
		case ebytearray:
			{
				int  len  = Z_STRLEN_P(src_obj);
				if(maxlen<4) return -1;
				if(__dst) memcpy(	__dst,   &len,   4);
				if(__dst) memcpy(	__dst+4, Z_STRVAL_P(src_obj), len);							
				*ret_size = cur_size + 4+len ;
			}
			break;
			
		case eobject:
			return obj_encode_func(src_obj TSRMLS_CC,__dst, maxlen, ret_size);
			break;
		case earray:
			{
				if (sub_type!=earray && Z_TYPE_P(src_obj) == IS_ARRAY) {
					int xsize= 0;
					int ret = 0;
					int tmp_size = 0;
					int i=0;
					zval **value_ptr/*, *value*/;
					HashTable * ht = Z_ARRVAL_P(src_obj);
					int num =  zend_hash_num_elements(ht);
					
					if(static_array_len >0)
					{
						 if(num != static_array_len)
						 {
						 		return -1;
						 }
					}	
					else
					{
						static_array_len = zend_hash_num_elements(ht);
						if(__dst) memcpy(__dst+xsize,&static_array_len,4);
						xsize +=4;
					}	
					
					for(i=0;i<static_array_len;i++)
					{
							if(zend_hash_index_find(ht, i,(void**)&value_ptr) == SUCCESS )
							{
								tmp_size = 0;
								ret = encode_xproto_data(*value_ptr TSRMLS_CC,
									sub_type, 
									-1, 
									__dst+ xsize, 
									maxlen-xsize, 
									0,
									obj_encode_func, 
									&tmp_size);
								if(tmp_size<0)
								{
									return -1;
								}
								xsize +=tmp_size;
							}	
							else
							{
								return -1;
							}	
					}
					
					
					*ret_size = cur_size +xsize;
				}
				else
				{
					 return -1;
				}
				
			}
			break;
		default: 
			return -1;
	};		
	
	return 0;
}

inline int str_hash(char* str,int len)
{
	int v = 0;
	int i;
	for(i = 0; i < len; i++)
	{
		v = 3*v + str[i] - len;		
	}	
	return v;
}

inline int ARRAY_LEN(zval * src_obj TSRMLS_DC,int array_elem_size,int isObject,TPFN_XSIZE_OF object_size_func)
{
	int i = 0;
	HashTable * ht = NULL;
	zval **value_ptr;
	int len = 0;
	int num =0;
	
	if(Z_TYPE_P(src_obj) != IS_ARRAY)
	{
		return 0;
	}
		
	ht= Z_ARRVAL_P(src_obj);	
	if (ht == NULL){
		return 0;
	}
	num =  zend_hash_num_elements(ht);
	
	if (num <= 0 ){
		return 0;
	}
	
	if (!isObject){
		return num * array_elem_size;
	}
	
	if (isObject == 1){ //string 
		for(i=0; i < num; i++){
			if(zend_hash_index_find(ht, i,(void**)&value_ptr) == SUCCESS ){		    
				len += (Z_STRLEN_P(*value_ptr)+5);
        	}							
		}	
	}else {	 //object
		for(i=0; i < num; i++){
			if(zend_hash_index_find(ht, i,(void**)&value_ptr) == SUCCESS ){		    
				len += object_size_func( *value_ptr TSRMLS_CC );
        	}							
		}	
	}
	
	return len;
}

/* If you declare any globals in php_xproto.h uncomment this:
ZEND_DECLARE_MODULE_GLOBALS(xproto)
*/

/* True global resources - no need for thread safety here */
static int le_xproto;

/* {{{ xproto_functions[]
 *
 * Every user visible function must have an entry in xproto_functions[].
 */
zend_function_entry xproto_functions[] = {	
	PHP_FE(__HandleReceiveDataAndDispatch,NULL)
/*::EN_XCMD_DEFINE_CODE::*/
	{NULL, NULL, NULL}	/* Must be the last line in xproto_functions[] */
};
/* }}} */


#ifdef COMPILE_DL_XPROTO
ZEND_GET_MODULE(xproto)
#endif

/* {{{ PHP_INI
 */
/* Remove comments and fill if you need to have entries in php.ini
PHP_INI_BEGIN()
    STD_PHP_INI_ENTRY("xproto.global_value",      "42", PHP_INI_ALL, OnUpdateLong, global_value, zend_xproto_globals, xproto_globals)
    STD_PHP_INI_ENTRY("xproto.global_string", "foobar", PHP_INI_ALL, OnUpdateString, global_string, zend_xproto_globals, xproto_globals)
PHP_INI_END()
*/
/* }}} */

/* {{{ php_xproto_init_globals
 */
/* Uncomment this function if you have INI entries
static void php_xproto_init_globals(zend_xproto_globals *xproto_globals)
{
	xproto_globals->global_value = 0;
	xproto_globals->global_string = NULL;
}
*/
/* }}} */

/* {{{ PHP_MINIT_FUNCTION
 */
//PHP_MINIT_FUNCTION(xproto)
//{
	/* If you have INI entries, uncomment these lines 
	REGISTER_INI_ENTRIES();
	*/
	//return SUCCESS;
//}
/* }}} */

/* {{{ PHP_MSHUTDOWN_FUNCTION
 */
PHP_MSHUTDOWN_FUNCTION(xproto)
{
	/* uncomment this line if you have INI entries
	UNREGISTER_INI_ENTRIES();
	*/
	return SUCCESS;
}
/* }}} */

/* Remove if there's nothing to do at request start */
/* {{{ PHP_RINIT_FUNCTION
 */
PHP_RINIT_FUNCTION(xproto)
{
	return SUCCESS;
}
/* }}} */

/* Remove if there's nothing to do at request end */
/* {{{ PHP_RSHUTDOWN_FUNCTION
 */
PHP_RSHUTDOWN_FUNCTION(xproto)
{
	return SUCCESS;
}
/* }}} */

/* {{{ PHP_MINFO_FUNCTION
 */
PHP_MINFO_FUNCTION(xproto)
{
	php_info_print_table_start();
	php_info_print_table_header(2, "xproto support", "enabled");
	php_info_print_table_end();

	/* Remove comments if you have entries in php.ini
	DISPLAY_INI_ENTRIES();
	*/
}
/* }}} */

/* {{{ xproto_module_entry
 */
zend_module_entry xproto_module_entry = {
#if ZEND_MODULE_API_NO >= 20010901
	STANDARD_MODULE_HEADER,
#endif
	"xproto",
	xproto_functions,
	PHP_MINIT(xproto),
	PHP_MSHUTDOWN(xproto),
	PHP_RINIT(xproto),		/* Replace with NULL if there's nothing to do at request start */
	PHP_RSHUTDOWN(xproto),	/* Replace with NULL if there's nothing to do at request end */
	PHP_MINFO(xproto),
#if ZEND_MODULE_API_NO >= 20010901
	"0.1", /* Replace with version number for your extension */
#endif
	STANDARD_MODULE_PROPERTIES
};
/* }}} */


/* Remove the following function when you have succesfully modified config.m4
   so that your module can be compiled into PHP, it exists only for testing
   purposes. */

/* Every user-visible function in PHP should document itself in the source */
/* {{{ proto string confirm_xproto_compiled(string arg)
   Return a string to confirm that the module is compiled in */
   
/*::BEAN_DEFINE_CODE::*/

PHP_MINIT_FUNCTION(xproto)
{
/*::CLASS_ENTRY_DEFINE_CODE::*/     
		return SUCCESS;
}

PHP_FUNCTION(__HandleReceiveDataAndDispatch)
{
	int arglen;
    zval *buff;
	int ret;
    
    if(zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "z", &buff,&arglen) == FAILURE) 
	{       
		RETURN_LONG(-1);
    }

	if (Z_TYPE_P(buff) != IS_STRING)
	{
		RETURN_LONG(-1);
	}

	ret = HandleReceivedData(Z_STRVAL_P(buff) TSRMLS_CC,Z_STRLEN_P(buff));

	RETURN_LONG(ret);
}

int HandleReceivedData(char *buf TSRMLS_DC, int len)
{
	XPROTO_PACKET_HEADER *phdr = NULL;
	
	int byteAvailable = len;
	const char *pCurrentBuf=buf;
		
	int res =0;

	while(byteAvailable>0)
	{
		phdr = (XPROTO_PACKET_HEADER *)pCurrentBuf;
						
		if((UINT)byteAvailable < phdr->len)
		{
			//header  not completed
			//				
			return -1;
		}

		//Use it with no copy immediately
		//
		pCurrentBuf += phdr->len;
		byteAvailable -= phdr->len;
		
		if((res = DispAction(phdr TSRMLS_CC))<0)
		{
			return res;
		}
		
	}//while
	return len;
}

int CheckValidAction(int cmd TSRMLS_DC)
{
	zval dispatch_func;
	zval *uf_result = NULL;
	zval ** params[1];
	zval * param;
	
	
	ZVAL_STRINGL(&dispatch_func, "__CheckValidAction", sizeof("__CheckValidAction") - 1, 0);
	
	NEW_ZVAL_LONG(param,cmd);
	
	params[0] = &param;
	
	call_user_function_ex(CG(function_table), NULL, &dispatch_func, &uf_result, 1, params,1,NULL TSRMLS_CC);

    FREE_MEMBER(param);
    
    if ( uf_result != NULL )
    {
    	return Z_LVAL_P(uf_result);
    }
    
    return 0;
}

int DispAction(XPROTO_PACKET_HEADER *phdr TSRMLS_DC)
{
	char * __src = (char*)phdr + PACKET_HEADER_SIZE;		
	
	int ret = CheckValidAction(phdr->cmd TSRMLS_CC);	
	if (ret < 0)
	{
		return ret;
	}
	
	switch( phdr->cmd )
	{
		case 0: return NullActionHandler(__src TSRMLS_CC, (int)phdr->len);
/*::XCMD_DISPATCH_DEFINE_CODE::*/
	}	
	
	return -1;
}

int NullActionHandler(const char *__src TSRMLS_DC,int  __len)
{
	return 0;
}

/*::XCMD_DISPATCH_IMP_CODE::*/

/*::XCMD_EVENT_IMP_CODE::*/

