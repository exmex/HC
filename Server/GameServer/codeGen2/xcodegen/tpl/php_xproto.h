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

#ifndef PHP_XPROTO_H
#define PHP_XPROTO_H

extern zend_module_entry xproto_module_entry;
#define phpext_xproto_ptr &xproto_module_entry

#ifdef PHP_WIN32
#define PHP_XPROTO_API __declspec(dllexport)
#else
#define PHP_XPROTO_API
#endif

#ifdef ZTS
#include "TSRM.h"
#endif


enum _EXPROTO_TYPE{
	echar=0,euchar,eshort,eushort,eint,euint,elonglong,eulonglong,efloat,edouble,estringa,estringw,eobject,earray,ebytearray
};

#ifdef WIN32

typedef __int64 					LONGLONG;
typedef unsigned __int64	ULONGLONG;

#else 
#if defined(__amd64__) || defined(__x86_64__)
typedef long						LONGLONG;
typedef unsigned long		ULONGLONG;
#else
typedef long long 			LONGLONG;
typedef unsigned long long	ULONGLONG;
#endif

#endif	

#define PACKET_HEADER_SIZE 8

typedef int ( *TPFN_XSIZE_OF)(zval *src_obj TSRMLS_DC);
typedef int ( *TPFN_XDECODE)(zval *src_obj TSRMLS_DC, const char *__src,  int  maxlen, int *ret_size);
typedef int (* TPFN_XENCODE)(zval *dst_obj TSRMLS_DC, char *__dst,  int  maxlen, int *ret_size);
typedef	int (* _TOPCODEHANDLER)(const char *__src,int    __len);

typedef struct XPROTO_PACKET_HEADER_t
{
	int len;
	int cmd;
}XPROTO_PACKET_HEADER;

PHP_MINIT_FUNCTION(xproto);
PHP_MSHUTDOWN_FUNCTION(xproto);
PHP_RINIT_FUNCTION(xproto);
PHP_RSHUTDOWN_FUNCTION(xproto);
PHP_MINFO_FUNCTION(xproto);

PHP_FUNCTION(__HandleReceiveDataAndDispatch);

/*::XCMD_EVENT_DEFINE_CODE::*/

/*::BEAN_S_FUNCTION_CODE::*/

#ifdef ZTS
#define XPROTO_G(v) TSRMG(xproto_globals_id, zend_xproto_globals *, v)
#else
#define XPROTO_G(v) (xproto_globals.v)
#endif

#endif	/* PHP_XPROTO_H */


