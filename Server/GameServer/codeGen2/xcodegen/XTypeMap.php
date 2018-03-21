<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
class TypeMap {
	
	public static $TYPE_MAP = array('INT'=>'int','SHORT'=>'int','ULONGLONG'=>'long','FLOAT'=>'float','DOUBLE'=>'double','STRINGA'=>'String');

	public static $SIZE_MAP = array('INT'=>'4','SHORT'=>'4', 'ULONGLONG'=>'8','FLOAT'=>'4','DOUBLE'=>'8','int'=>'4','long'=>'8','float'=>'4','double'=>'8');
	
	public static $E_TYPE_MAP = array('int'=>'eint','long'=>'eulonglong','float'=>'efloat','double'=>'edouble','String'=>'estringa');	
	
	public static $IS_TYPE_MAP = array('int'=>'IS_LONG','long'=>'IS_LONG','float'=>'IS_DOUBLE','double'=>'IS_DOUBLE','String'=>'IS_STRING');	
	
	public static $CV_TYPE_MAP = array('int'=>'convert_to_long','long'=>'convert_to_long','float'=>'convert_to_double','double'=>'convert_to_double','String'=>'convert_to_string');	

	public static $TYPE_CONSTRUCT_MAP = array('int'=>'NEW_ZVAL_LONG','long'=>'NEW_ZVAL_LONG','float'=>'NEW_ZVAL_DOUBLE','double'=>'NEW_ZVAL_DOUBLE','String'=>'NEW_ZVAL_EMPTY_STRING');
	
	public static function _XIS_STRING($type)
	{
		if (strcasecmp($type,"STRINGA")==0){
			return true;
		}

	   if (strcasecmp($type,"String")==0){
			return true;
		}
		
		return false;
	}
	
    public static function _XIS_INT($type)
	{
		if (strcasecmp($type,"int")==0){
			return true;
		}		
		return false;
	}
	
	public static function _XIS_FLOAT($type)
	{
		if (strcasecmp($type,"float")==0){
			return true;
		}		
		return false;
	}
	
	public static function _XIS_LONG($type)
	{
		if (strcasecmp($type,"ULONGLONG")==0){
			return true;
		}

	   if (strcasecmp($type,"long")==0){
			return true;
		}
		
		return false;
	}
	
	public static function _XIS_DOUBLE($type)
	{
		if (strcasecmp($type,"double")==0){
			return true;
		}		
		return false;
	}
}

?>