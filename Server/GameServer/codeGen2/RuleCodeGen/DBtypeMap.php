<?php

class DBtypeMap 
{		
	public static $JAVA_RAW_TYPE_MAP = array(
	              'Integer'=>'int',
	              'Long'=>'long',
		          'Float'=>'float',
		          'Double'=>'double',
		          'String'=>'string');
	
	public static function dbType2Php($type)
	{
		if (strncasecmp($type,'int',3) == 0)
		{
			return 'int';			
		}	
	    if (strncasecmp($type,'tinyint',7) == 0)
		{
			return 'int';			
		}	
		if (strncasecmp($type,'smallint',8) == 0)
		{
			return 'int';			
		}
		if (strncasecmp($type,'mediumint',9) == 0)
		{
			return 'int';			
		}
		if (strncasecmp($type,'integer',7) == 0)
		{
			return 'int';			
		}
		if (strncasecmp($type,'bigint',6) == 0)
		{
			return 'string';
		}
	    if (strncasecmp($type,'float',5) == 0)
		{
			return 'float';
		}
	    if (strncasecmp($type,'double',6) == 0)
		{
			return 'double';
		}				
				
		return 'string';
	}
	
	public static function typeVal($type)
	{
		if (strcasecmp($type,'int') == 0)
		{
			return 'intval';			
		}	

		if (strcasecmp($type,'float') == 0)
		{
			return 'floatval';			
		}
		
		if (strcasecmp($type,'float') == 0)
		{
			return 'doubleval';			
		}
		
		return "SQLUtil::toSafeSQLString";
	}
	
	public static function noStringTypeVal($type)
	{
		if (strcasecmp($type,'int') == 0)
		{
			return 'intval';			
		}	

		if (strcasecmp($type,'float') == 0)
		{
			return 'floatval';			
		}
		
		if (strcasecmp($type,'float') == 0)
		{
			return 'doubleval';			
		}
		
		return '';	
	}
	
	public static function rawStringTypeVal($type)
	{
		if (strcasecmp($type,'int') == 0)
		{
			return 'intval';
		}
	
		if (strcasecmp($type,'float') == 0)
		{
			return 'floatval';
		}
	
		if (strcasecmp($type,'float') == 0)
		{
			return 'doubleval';
		}
	
		return 'strval';
	}
	
	public static function isString($type)
	{
		if (strcasecmp($type,'string') == 0)
		{
			return true;
		}
		return false;
	}

}

?>