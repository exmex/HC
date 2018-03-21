<?php

	define("PRODUCTION_SERVER", true);

interface XPROTO_ERROR_CODE {
	const XPROTO_SUCCEED = 0;
	const XPROTO_FAILED = - 1;
	const XPROTO_REMAIN_LENGTH_ERROR = - 2;
	const XPROTO_XCMD_OUT_OF_RANGE = - 3;
	const XPROTO_PACKET_LENGTH_OVERFLOW = - 4;
	const XPROTO_PACKET_NOT_COMPLETED = - 5;
	const XPROTO_PACKET_LESS_THAN_HDRLEN = - 6;
	const XPROTO_DISPATCH_EXCEPTION = - 7;
	const XPROTO_OUT_OF_MEMORY = - 8;
	const XPROTO_GET_SEND_BUFF_FAILED = - 9;
	const XPROTO_FROM_BUFF_FAILED = - 10;
	const XPROTO_TO_BUFF_FAILED = - 11;
  const XPROTO_CONNECTION_STATE_CHECK_FAILED = -12;
};

function HexStringToBytes($pBinStr, $istrlen) {
	if ($istrlen == 0) {
		return "";
	}
	
	$pbBeg = 0;
	$pbEnd = $istrlen;
	//while(pbBeg < pbEnd && *pbBeg ==0x0020 )
	for($i = 0; $i < $istrlen; $i ++)
		if (ord ( $pBinStr [$pbBeg] ) == 0x20 || ord ( $pBinStr [$pbBeg] ) == 9 || ord ( $pBinStr [$pbBeg] ) == 0x0A || ord ( $pBinStr [$pbBeg] ) == 0x0D)
			$pbBeg ++;
	
	$istrlen = $pbEnd - $pbBeg;
	if ($istrlen <= 0) {
		return "";
	}
	
	$binLen = floor ( ($istrlen + 1) / 2 );
	
	$hexTable = array (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15 );
	
	$bHi = true;
	$fc = 0;
	$pBins = 0;
	while ( $pbBeg < $pbEnd ) {
		$wc = ord ( $pBinStr [$pbBeg] );
		
		if ($wc != 0x20) {
			
			if ($wc > ord ( 'F' )) {
				$wc -= ord ( 'a' ) - ord ( 'A' );
			}
			
			if (! $bHi) {
				$idx = $wc - ord ( '0' );
				$val = $hexTable [$idx];
				$fc += $val;
				if (is_int ( $pBins ))
					$pBins = pack ( "c", $fc );
				else
					$pBins .= pack ( "c", $fc );
			
			} else {
				
				$idx = $wc - ord ( '0' );
				$val = $hexTable [$idx] * 16;
				$fc = $val;
			
			}
			$bHi = ! $bHi;
		}
		$pbBeg ++;
	}
	
	return $pBins;
}

function BytesToString($pbin, $len, $seperator) {
	$pBinStr = "";
	if ($len == 0 || empty ( $pbin )) {
		return $pBinStr;
	}
	
	$ncLen = 0;
	for($i = 0; $i < $len; $i ++) {
		if ($seperator != "")
			$pBinStr .= sprintf ( "%02X", ord ( $pbin [$i] ) ) . $seperator;
		else
			$pBinStr .= sprintf ( "%02X", ord ( $pbin [$i] ) );
	}
	return $pBinStr;
}


function LoadXmlFromString($xml_str)
{
	$pnode = simplexml_load_string($xml_str);
	return $pnode;
	//return simplexml2array($pnode);
}


function XTO_XML($__xv, $__xv_name, $__xv_type, $__xv_elem_type = 0) {
	if ($__xv_type == 3) //object
	{
		$__xv_tmp = "<" . $__xv_name . ">";
		$__xv_tmp .= $__xv->ToXml ();
		$__xv_tmp .= "</" . $__xv_name . ">\n";
		return $__xv_tmp;
	} 
	else if ($__xv_type == 4) // byte array
	{
		$__xv_tmp = "";
		$_count = strlen ( $__xv );
		for($i = 0; $i < $_count; $i ++) {
			$__xv_tmp .= XTO_XML ( ord ( $__xv [$i] ), $__xv_name, 0 );
		}
		return $__xv_tmp;
	} 
	else if ($__xv_type == 5) //array
	{
		$__xv_tmp = "";
		foreach ( $__xv as $__elem ) {
			$__xv_tmp .= XTO_XML ( $__elem, $__xv_name, $__xv_elem_type );
		}
		return $__xv_tmp;
	} 
	else 
	{
		return "<" . $__xv_name . ">" . $__xv . "</" . $__xv_name . ">\n";
	}
}

function XFROM_XML($__xv_val, $pNode, $__xv_name, $__xv_type,  $__xv_array_elem_type_name = "",$__xv_elem_type=0) {
	
	if ($__xv_type == 0) //int	
	{
		if($__xv_name!="")
			return ( int ) $pNode->{$__xv_name};
		else
			return ( int ) $pNode;
		
	} 
	else if ($__xv_type == 1) //float
	{
		if($__xv_name!="")
			return ( float ) $pNode->{$__xv_name};
		else
			return ( float ) $pNode;
			
	} 
	else if ($__xv_type == 2) //string
	{
		if($__xv_name!="")
			return ( string ) $pNode->{$__xv_name};
		else
			return ( string ) $pNode;
			
	} 
	else if ($__xv_type == 3) //object
	{
		if($__xv_name!="")
			return $__xv_val->FromXml ( $pNode->{$__xv_name} );
		else
			return $__xv_val->FromXml ( $pNode);
			
	} 
	else if ($__xv_type == 4) // byte array
	{
		$__xv_val = "";
		foreach ( $pNode->{$__xv_name} as $__xv_elem ) {
			$__xv_tmp_val = XFROM_XML ( 0,$__xv_elem, "", 0 );
			$__xv_val .= pack ( "c", $__xv_tmp_val );
		}
		return $__xv_val;
	} 
	else if ($__xv_type == 5) //array 
	{
		$__xv_val = array ();
		
		foreach ( $pNode->{$__xv_name} as $__xv_elem ) {
			$__xv_tmp_val = 0;
			if ($__xv_array_elem_type_name == "") {
				$__xv_tmp_val = XFROM_XML ( 0, $__xv_elem,  "", $__xv_elem_type);
			} else {
				$__xv_tmp_val = new $__xv_array_elem_type_name();
				$__xv_tmp_val = XFROM_XML ( $__xv_tmp_val,$__xv_elem,"", 3 );
			}
			
			array_push ( $__xv_val, $__xv_tmp_val );
		}
		
		return $__xv_val;
	}

}

function XFROM_AMFOBJECT($__xv_val, $pNode, $__xv_name, $__xv_type,  $__xv_array_elem_type_name = "",$__xv_elem_type=0) {
	
	if ($__xv_type == 0 || $__xv_type == 1 || $__xv_type == 2 ||$__xv_type == 4) //int	 //float //string
	{
		 return  $pNode[$__xv_name];
	} 
	else if ($__xv_type == 3) //object
	{
			return $__xv_val->FromXml($pNode[$__xv_name]);
			
	} 
  else if ($__xv_type == 5) //array 
	{
		$__xv_val = array ();
		$__xv_tmp_obj= $pNode[$__xv_name];
		foreach ( $__xv_tmp_obj as $__xv_elem ) {
			$__xv_tmp_val = 0;
			if ($__xv_array_elem_type_name == "") {
				$__xv_tmp_val = XFROM_AMFOBJECT ( 0, $__xv_elem,  "", $__xv_elem_type);
			} else {
				$__xv_tmp_val = new $__xv_array_elem_type_name();
				$__xv_tmp_val = XFROM_AMFOBJECT ( $__xv_tmp_val,$__xv_elem,"", 3 );
			}
			
			array_push ( $__xv_val, $__xv_tmp_val );
		}
    
		return $__xv_val;
	}
  
}


class PolynomialItem {
	public $coefficient = 0;
	public $degree = 0;
	public function compare($a, $b) {
		if ($a->degree < $b->degree)
			return - 1;
		else if ($a->degree == $b->degree)
			return 0;
		else
			return 1;
	}

}

class Polynomial {
	private $list;
	private $negative = false;
	private $base;
	private $base_exp;
	
	public function Polynomial($base = 10000) {
		if ($base == 0 || $base % 10 != 0 || ($base / 10 != 1 && ((( int ) ($base / 10)) % 10) != 0))
			throw new Exception ( "base failed " );
		
		$this->base = $base;
		
		$base_exp = 0;
		$tmp = ( int ) floor ( $base / 10 );
		while ( $tmp != 0 ) {
			$base_exp ++;
			$tmp = ( int ) floor ( $tmp / 10 );
		}
		
		if ($base_exp > 4) {
			throw new Exception ( "$base_exp > 4" );
		}
		
		$this->base_exp = $base_exp;
		
		$this->list = array (new PolynomialItem ( ) );
	}
	
	private function merge($degree, $inc) {
		if ($inc < 0) {
			throw new Exception ( "merge inc negative" );
			return;
		}
		
		$num = count ( $this->list );
		for($j = $num; $j <= $degree; $j ++) {
			$pi = new PolynomialItem ( );
			$pi->degree = $j;
			$pi->coefficient = 0;
			array_push ( $this->list, $pi );
		}
		
		$cur = $this->list [$degree];
		$cur->coefficient += $inc;
		$x = $cur->coefficient;
		$x = ( int ) floor ( $x / $this->base );
		while ( $x != 0 ) {
			$degree ++;
			$this->merge ( $degree, $x );
			$x = ( int ) floor ( $x / $this->base );
		}
		
		$cur->coefficient = $cur->coefficient % $this->base;
	
	}
	
	private function domerge($temparr) {
		foreach ( $temparr as $item ) {
			$this->merge ( $item->degree, $item->coefficient );
		}
	}
	
	private function normalize() {
		$arr = $this->list;
		$this->list = array (new PolynomialItem ( ) );
		$this->domerge ( $arr );
	}
	
	private function borrow($degree) {
		$c = count ( $this->list );
		for($i = $degree; $i < $c; $i ++) {
			if ($this->list [$i]->coefficient != 0) {
				$this->list [$i]->coefficient --;
				return true;
			} else {
				$this->list [$i]->coefficient = $this->base - 1;
				return $this->borrow ( $i + 1 );
			
			}
		}
		
		return false;
	
	}
	
	private function align_base($poly, $dst_base) {
		if ($dst_base == $poly->base) {
			return $poly;
		}
		
		$res = new Polynomial ( $dst_base );
		$res->from_decimal_string ( $poly->to_decimal_string () );
		return $res;
	}
	
	public function add($poly) {
		$poly = $this->align_base ( $poly, $this->base );
		$res = new Polynomial ( $this->base );
		$res->domerge ( $this->list );
		$res->domerge ( $poly->list );
		return $res;
	}
	
	public function sub($poly) {
		$poly = $this->align_base ( $poly, $this->base );
		
		$res = new Polynomial ( $this->base );
		
		$v = $this->compare ( $poly );
		if ($v > 0) {
			$res->domerge ( $this->list );
			for($i = 0; $i < count ( $poly->list ); $i ++) {
				$cp = $poly->list [$i]->coefficient;
				$cr = $res->list [$i]->coefficient;
				if ($cr < $cp) {
					
					if (! $res->borrow ( $i + 1 )) {
						throw new Exception ( "sub borrow failed" );
					}
					
					$res->list [$i]->coefficient = $cr + $this->base - $cp;
					//echo $res->list[$i]->coefficient."<br>";
				} else {
					$res->list [$i]->coefficient = $cr - $cp;
					//echo $res->list[$i]->coefficient."<br>";
				}
			}
		} else if ($v < 0) {
			$res->negative = true;
			$res->domerge ( $poly->list );
			
			for($i = 0; $i < count ( $this->list ); $i ++) {
				$cp = $this->list [$i]->coefficient;
				$cr = $res->list [$i]->coefficient;
				if ($cr < $cp) {
					
					if (! $res->borrow ( $i + 1 )) {
						throw new Exception ( "sub borrow failed" );
					}
					
					$res->list [$i]->coefficient = $cr + $this->base - $cp;
					//echo $res->list[$i]->coefficient."<br>";
				} else {
					$res->list [$i]->coefficient = $cr - $cp;
					//echo $res->list[$i]->coefficient."<br>";
				}
			}
		
		}
		$num = count ( $res->list );
		for($i = $num - 1; $i > 0; $i --) {
			if ($res->list [$i]->coefficient == 0) {
				array_pop ( $res->list );
			} else {
				break;
			}
		}
		
		return $res;
	}
	
	public function multiple($poly) {
		$poly = $this->align_base ( $poly, $this->base );
		
		$tmp = new Polynomial ( $this->base );
		
		foreach ( $poly->list as $pi ) {
			foreach ( $this->list as $pt ) {
				$c = $pt->coefficient * $pi->coefficient;
				$d = $pt->degree + $pi->degree;
				$tmp->merge ( $d, $c );
			}
		}
		
		return $tmp;
	}
	
	public function divide($poly) {
		if($poly->is_zero())
		{
			throw new Exception("poly can not div by zero");
			
		}
		
		$poly = $this->align_base ( $poly, $this->base );
		$remain = new Polynomial ( $this->base );
		$remain->domerge ( $this->list );
		$result = new Polynomial ( $this->base );
		
		//echo "remain:".$remain->show()."<br>";
		//echo "poly:".$poly->show()."<br>";
		

		$pmax = $poly->max ();
		
		while ( $remain->compare ( $poly ) >= 0 ) 
		{
			$tmax = $remain->max ();
			
			$test = new PolynomialItem ( );
			
			$test->degree = $tmax->degree - $pmax->degree;
			
			$test->coefficient = ( int ) floor ( $tmax->coefficient / $pmax->coefficient );
			
			
			
			while(1)
			{
				if ($test->coefficient == 0) {
					$num = count ( $remain->list );
					if ($num < 2) {
						break;
					}
					
					$tnext = $remain->list [$num - 2];
					$test->coefficient = ( int ) floor ( ($tmax->coefficient * $this->base + $tnext->coefficient) / $pmax->coefficient );
					$test->degree --;
				}
				
				$tmp = new Polynomial ( $this->base );
				$tmp->merge ( $test->degree, $test->coefficient );
				$tmp = $tmp->multiple ( $poly );
				
				if($remain->compare($tmp)>=0)
				{
					break;
				}
				$test->coefficient--;
			}
			
			
			$result->merge ( $test->degree, $test->coefficient );
			//echo "result:".$result->show()."<br>";
			
			$remain = $remain->sub ( $tmp );
			
		//echo "remain:".$remain->show()."<br>";
		

		}
		
		return array ($result, $remain );
	}
	
	public function compare($poly) {
		
		if ($this->negative && ! $poly->negative) {
			return - 1;
		} else if (! $this->negative && $poly->negative) {
			return 1;
		} else if (! $this->negative && ! $poly->negative) {
			$nparam = $poly->max ()->degree;
			$nthis = $this->max ()->degree;
			
			if ($nthis > $nparam)
				return 1;
			else if ($nthis < $nparam)
				return - 1;
			else {
				for($i = $nthis; $i >= 0; $i --) {
					$left = $this->list [$i]->coefficient;
					$right = $poly->list [$i]->coefficient;
					if ($left < $right) {
						return - 1;
					} else if ($left > $right) {
						return 1;
					}
				}
			}
		} else if ($this->negative && $poly->negative) {
			if ($nthis > $nparam)
				return - 1;
			else if ($nthis < $nparam)
				return 1;
			else {
				for($i = $nthis; $i >= 0; $i --) {
					$left = $this->list [$i]->coefficient;
					$right = $poly->list [$i]->coefficient;
					if ($left < $right) {
						return 1;
					} else if ($left > $right) {
						return - 1;
					}
				}
			}
		}
		
		return 0;
	
	}
	
	public function max() {
		$c = count ( $this->list );
		for($i = $c - 1; $i >= 0; $i --) {
			if ($this->list [$i]->coefficient != 0) {
				return $this->list [$i];
			}
		}
		return $this->list [0];
	}
	
	public function min() {
		return $this->list [0];
	}
	
	public function is_zero() {
		foreach ( $this->list as $item ) {
			if ($item->coefficient != 0)
				return false;
		}
		return true;
	}
	
	public function set_zeror() {
		$this->list = array (new PolynomialItem ( ) );
	}
	
	public function is_negative() {
		return $this->negative;
	}
	
	public function show() {
		$str = "";
		foreach ( $this->list as $i ) {
			if ($str == "")
				$str .= $i->coefficient . "*" . $this->base . "^" . $i->degree;
			else
				$str .= " + " . $i->coefficient . "*" . $this->base . "^" . $i->degree;
		}
		return $str;
	}
	
	public function from_decimal_string($str) {
		$this->list = array ();
		$len = strlen ( $str );
		$st_pos = 0;
		if ($len < 1)
			return;
		if ($str [0] == '-') {
			$this->negative = true;
			$st_pos ++;
		}
		
		$exp = 0;
		$degree = 0;
		$dec = "";
		for($i = $len - 1; $i >= $st_pos; $i --) {
			$exp ++;
			$dec = $str [$i] . $dec;
			if ($exp == $this->base_exp || $i == $st_pos) {
				$exp = 0;
				$t = new PolynomialItem ( );
				$t->degree = $degree;
				$t->coefficient = ( int ) $dec;
				array_push ( $this->list, $t );
				$dec = "";
				$degree ++;
			}
		
		}
	
	}
	
	public function to_decimal_string() {
		if ($this->is_zero ()) {
			return "0";
		}
		
		$len = count ( $this->list );
		$str = "";
		
		$bfill = true;
		for($i = $len - 1; $i >= 0; $i --) {
			if ($bfill && $this->list [$i]->coefficient == 0)
				continue;
			$bfill = false;
			$item = $this->list [$i];
			if ($i != $len - 1) {
				$tt = "" . $item->coefficient;
				for($j = strlen ( $tt ); $j < $this->base_exp; $j ++) {
					$tt = "0" . $tt;
				}
				
				$str .= $tt;
			} else {
				$str .= $item->coefficient;
			}
		
		}
		
		return $str;
	}
	
	public function from_byte_array($byte_array, $pos, $num) {
		$max_int = new Polynomial ( $this->base );
		$max_int->from_decimal_string ( "256" );
		$curmp = new Polynomial ( $this->base );
		$curmp->from_decimal_string ( "1" );
		$this->list = array (new PolynomialItem ( ) );
		
		for($i = 0; $i < $num; $i ++) {
			$cur_val = new Polynomial ( $this->base );
			$cur_val->from_int ( ord ( $byte_array [$pos + $i] ) );
			
			$cur_val = $cur_val->multiple ( $curmp );
			$this->domerge ( $cur_val->list );
			//echo $this->show()."\n";
			$curmp = $curmp->multiple ( $max_int );
			//echo $curmp->show()."\n";
		}
	}
	
	public function to_byte_array() {
		$max_int = new Polynomial ( $this->base );
		$max_int->from_decimal_string ( "256" );
		
		$tt = $this->divide ( $max_int );

		$res = pack ( "c", $tt [1]->to_int () );
		
		while ( ! $tt [0]->is_zero () ) {
			$tt = $tt [0]->divide ( $max_int );
			$res .= pack ( "c", $tt [1]->to_int () );
		}
		
		return $res;
	}
	
	private function from_int($val) {
		$str = "";
		$str .= $val;
		$this->from_decimal_string ( $str );
	}
	
	private function to_int() {
		return ( int ) $this->to_decimal_string ();
	}
	
	public function from_hex_string($str) {
		$len = strlen ( $str );
		if ($len % 2 != 0) {
			$str = "0" . $str;
			$len ++;
		}
		$bytes = HexStringToBytes ( $str, $len );
		$bytes = strrev ( $bytes );
		
		$len = strlen ( $bytes );
		$valid_len = $len;
		for($i = $len - 1; $i >= 0; $i --) {
			if (ord ( $bytes [$i] ) == 0) {
				$valid_len --;
			} else {
				break;
			}
		}
		$this->from_byte_array ( $bytes, 0, $valid_len );
	
	}
	
	public function to_hex_string() {
		$bytes = $this->to_byte_array ();
		$bytes = strrev ( $bytes );
		return BytesToString ( $bytes, strlen ( $bytes ), "" );
	}
}

class XInteger {
	public $_value = 0;
}

class XLONGLONG {
	private $m_low32;
	private $m_high32;
	private $m_uint64;
	 
	
	public function XLONGLONG() {
		$this->m_low32 = "0";
		$this->m_high32= "0";
		$this->m_uint64= "0";
	}
	
	public function set($low32, $high32) {
		$this->m_low32 = (string)$low32;
		$this->m_high32 = (string)$high32;
		
		$low = new Polynomial();
		$low->from_decimal_string($this->m_low32);
		
		$high = new Polynomial();
		$high->from_decimal_string($this->m_high32);
		
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");

		$high = $high->multiple($maxint);
		$high = $high->add($low);
				
		$this->m_uint64 =$high->to_decimal_string(); 	 
	}
	
	public function getlow() {
		return $this->m_low32;
	}
	
	public function gethigh() {
		return $this->m_high32;
	}
	
	/**
	 * add to itself.
	 * */
	public function add($intvalue) {
		$a = new Polynomial();
		$a->from_decimal_string ( ( string ) $intvalue );
		$poly = new Polynomial();
		$poly->from_decimal_string($this->m_uint64);
		$poly = $poly->add($a);
		$this->m_uint64 =$poly->to_decimal_string();
		
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");
		$arr = $poly->divide($maxint);
		
		$this->m_high32 = $arr[0]->to_decimal_string();
		$this->m_low32 = $arr[1]->to_decimal_string();
		 		
		return $this->m_uint64;
	}
	
	/**
	 * sub to itself.
	 * */
	public function sub($intvalue) {
		$a = new Polynomial();
		$a->from_decimal_string ( ( string ) $intvalue );
		$poly = new Polynomial();
		$poly->from_decimal_string($this->m_uint64);
		$poly = $poly->sub($a);
		$this->m_uint64 =$poly->to_decimal_string();
		
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");
		$arr = $poly->divide($maxint);
		
		$this->m_high32 = $arr[0]->to_decimal_string();
		$this->m_low32 = $arr[1]->to_decimal_string();
		 		
		return $this->m_uint64;
	}
	
	/**
	 * div to itself.
	 * this object save the result
	 * */
	public function div($intvalue) {
		$a = new Polynomial();
		$a->from_decimal_string ( ( string ) $intvalue );
		$poly = new Polynomial();
		$poly->from_decimal_string($this->m_uint64);
		
		$arr = $poly->divide($a);
		$this->m_uint64 =$arr[0]->to_decimal_string();
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");
		$arr = $poly->divide($maxint);
		
		$this->m_high32 = $arr[0]->to_decimal_string();
		$this->m_low32 = $arr[1]->to_decimal_string();
		 		
		return $this->m_uint64;
	}
	
	/*
	 * mod to itself , 
	 * this object store the mod result.
	 * **/
	public function mod($intvalue) {
		$a = new Polynomial();
		$a->from_decimal_string ( ( string ) $intvalue );
		$poly = new Polynomial();
		$poly->from_decimal_string($this->m_uint64);
		$arr = $poly->divide($a);
		$this->m_uint64 =$arr[1]->to_decimal_string();
		
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");
		$arr = $poly->divide($maxint);
		
		$this->m_high32 = $arr[0]->to_decimal_string();
		$this->m_low32 = $arr[1]->to_decimal_string();
		 		
		return $this->m_uint64;
	}
	
	public function multi($intvalue) {
		$a = new Polynomial();
		$a->from_decimal_string ( ( string ) $intvalue );
		$poly = new Polynomial();
		$poly->from_decimal_string($this->m_uint64);
		$poly = $poly->multiple($a);
		
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");
		$arr = $poly->divide($maxint);
		
		$this->m_uint64 = $poly->to_decimal_string();
		$this->m_high32 = $arr[0]->to_decimal_string();
		$this->m_low32 = $arr[1]->to_decimal_string();
		 		
		return $this->m_uint64;
	}
	
	public function FromBuffer($__src/*:XByteArray*/)/*:int*/
	{
		if ($__src->getBytesAvailable () >= 8) {
			$poly = new Polynomial();
			$bytes = $__src->readBinary ( 8 );
			$poly->from_byte_array ( $bytes, 0, 8 );
			
			$maxint = new Polynomial();
			$maxint->from_decimal_string("4294967296");
			$arr = $poly->divide($maxint);
			
			
			$this->m_uint64 =$poly->to_decimal_string();
			$this->m_high32 = $arr[0]->to_decimal_string();
			$this->m_low32 = $arr[1]->to_decimal_string();
			
		} else
			return 0;
		
		return 8;
	}
	
	public function ToBuffer($__dst/*:XByteArray*/)/*:int*/
	{
		
		$poly = new Polynomial();
		$poly->from_decimal_string($this->m_uint64);
		$bytes =$poly->to_byte_array();
		
		$c = strlen ( $bytes );
		for($i = $c; $i < 8; $i ++) {
			$bytes .= pack ( "c", 0 );
		}
		
		$__dst->writeBinary ( $bytes, 8 );
		
		return 8;
	}
	
	public function Size()/*:int*/
	{
		return 8;
	}
	
	public function Equal($other/*:XLONGLONG*/)/*:Boolean*/
	{
		if ($this->m_uint64 == $other->m_unit64) {
			return true;
		}
		return false;
	}
	
	public function ToHexString() {
		$poly = new Polynomial();
		$poly->from_decimal_string($this->m_uint64);
		return $poly->to_hex_string();
	}
	
	public function FromHexString($str) {
		$poly = new Polynomial();
		$poly->from_hex_string($str);
		
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");
		$arr = $poly->divide($maxint);
		
		$this->m_uint64 =$poly->to_decimal_string();
		$this->m_high32 = $arr[0]->to_decimal_string();
		$this->m_low32 = $arr[1]->to_decimal_string();
	}
	
	public function ToDecString() {
		return $this->m_uint64;
	}
	
	public function FromDecString($str) {
		$poly = new Polynomial();
		$poly->from_decimal_string($str);
		
		$maxint = new Polynomial();
		$maxint->from_decimal_string("4294967296");
		$arr = $poly->divide($maxint);
		
		$this->m_uint64 =$poly->to_decimal_string();
		$this->m_high32 = $arr[0]->to_decimal_string();
		$this->m_low32 = $arr[1]->to_decimal_string();
		
	}
	
	/**
	 * @return 
	 * 0  equal
	 * -1 less
	 * 1  greater
	 * */
	public function Compare($other/*:XLONGLONG*/)/*:int*/
	{
		return $this->poly->compare ( $other->poly );
	}
	
	public function ToXml() {
		return $this->m_uint64;
	}
	
	public function FromXml($pNode) {
		$this->FromDecString( ( string ) $pNode );
		return $this;
	}
	
	public function toDebugString() {
		return $this->m_uint64;
	}
}

class XByteArray {
	/**
	 * The raw data input
	 * 
	 * @access private 
	 * @var string 
	 */
	var $raw_data;
	
	/**
	 * The current seek cursor of the stream
	 * 
	 * @access private 
	 * @var int 
	 */
	var $position;
	
	/**
	 * The length of the stream.  Since this class is not actually using a stream
	 * the entire content of the stream is passed in as the initial argument so the
	 * length can be determined.
	 * 
	 * @access private 
	 * @var int 
	 */
	var $length;
	
	/**
	 * Constructor method for the deserializer.  Constructing the deserializer converts the input stream
	 * content to a Object.
	 * 
	 * @param object $is The referenced input stream
	 */
	function set_data($rd) {
		$this->position = 0;
		$this->raw_data = $rd; // store the stream in this object
		$this->length = strlen ( $this->raw_data ); // grab the total length of this stream
	}
	
	function XByteArray() {
		$this->position = 0;
		$this->length = 0;
	}
	
	/**
  	bytes not read
	 */
	function getBytesAvailable() {
		return $this->length - $this->position;
	}
	
	//  function reserve($len)
	//  {
	//		$this->raw_data = str_repeat('0',$len);
	//		$this->length = $len;
	//		$this->position = 0;
	//  }
	

	/**
	 * readByte grabs the next byte from the data stream and returns it.
	 * 
	 * @return int The next byte converted into an integer
	 */
	function readByte() {
		return ord ( $this->raw_data [$this->position ++] ); // return the next byte
	}
	
	/**
	 * readInt grabs the next 2 bytes and returns the next two bytes, shifted and combined
	 * to produce the resulting integer
	 * 
	 * @return int The resulting integer from the next 2 bytes
	 */
	function readInt16() {
		$bytes = substr ( $this->raw_data, $this->position, 2 );
		$this->position += 2;
		$zz = unpack ( "s", $bytes ); // unpack the bytes
		return $zz [1]; // return the number from the associative array
	

	//return ((ord($this->raw_data[$this->position++]) ) |
	//	(ord($this->raw_data[$this->position++])<< 8)); // read the next 2 bytes, shift and add
	}
	
	function readUnsignedInt16() {
		$bytes = substr ( $this->raw_data, $this->position, 2 );
		$this->position += 2;
		$zz = unpack ( "S", $bytes ); // unpack the bytes
		return $zz [1]; // return the number from the associative array
	

	//return ((ord($this->raw_data[$this->position++]) ) |
	//	(ord($this->raw_data[$this->position++])<< 8)); // read the next 2 bytes, shift and add
	}
	
	/**
	 * readUTF first grabs the next 2 bytes which represent the string length.
	 * Then it grabs the next (len) bytes of the resulting string.
	 * 
	 * @return string The utf8 decoded string
	 */
	function readUTF($length) {
		//BUg fix:: if string is empty skip ahead
		if ($length <= 1) {
			$this->position += $length; 
			return "";
		} else {
			$val = substr ( $this->raw_data, $this->position, $length - 1 ); // grab the string
			$this->position += $length; // move the seek head to the end of the string
			return $val; // return the string
		}
	}
	
	function readBinary($length) {
		//BUg fix:: if string is empty skip ahead
		if ($length < 1) {
			return "";
		} else {
			$val = substr ( $this->raw_data, $this->position, $length );
			$this->position += $length;
			return $val; // return the string
		}
	}
	
	/**
	 * readLong grabs the next 4 bytes shifts and combines them to produce an integer
	 * 
	 * @return int The resulting integer from the next 4 bytes
	 */
	function readInt32() {
		$bytes = substr ( $this->raw_data, $this->position, 4 );
		$this->position += 4;
		$zz = unpack ( "i", $bytes ); // unpack the bytes
		return $zz [1]; // return the number from the associative array
	

	//return ((ord($this->raw_data[$this->position++]) ) |
	//	(ord($this->raw_data[$this->position++]) << 8) |
	//	(ord($this->raw_data[$this->position++]) << 16) |
	//	(ord($this->raw_data[$this->position++])<< 24)
	//	); // read the next 4 bytes, shift and add
	}
	
	function readUnsignedInt32() {
		$bytes = substr ( $this->raw_data, $this->position, 4 );
		$this->position += 4;
		$zz = unpack ( "I", $bytes ); // unpack the bytes
		return $zz [1]; // return the number from the associative array
	

	//return ((ord($this->raw_data[$this->position++]) ) |
	//	(ord($this->raw_data[$this->position++]) << 8) |
	//	(ord($this->raw_data[$this->position++]) << 16) |
	//	(ord($this->raw_data[$this->position++])<< 24)
	//	); // read the next 4 bytes, shift and add
	}
	
	function readUnsignedInt64() {
		$bytes = substr ( $this->raw_data, $this->position, 4 );
		$this->position += 4;
		$zz = unpack ( "I2", $bytes ); // unpack the bytes
		

		return ($zz [2] << 32 | $zz [1]); // return the number from the associative array
	}
	
	function readFloat() {
		$bytes = substr ( $this->raw_data, $this->position, 4 );
		$this->position += 4;
		$zz = unpack ( "f", $bytes ); // unpack the bytes
		return $zz [1]; // return the number from the associative array
	}
	
	/**
	 * readDouble reads the floating point value from the bytes stream and properly orders
	 * the bytes depending on the system architecture.
	 * 
	 * @return float The floating point value of the next 8 bytes
	 */
	function readDouble() {
		$bytes = substr ( $this->raw_data, $this->position, 8 );
		$this->position += 8;
		$zz = unpack ( "d", $bytes ); // unpack the bytes
		return $zz [1]; // return the number from the associative array
	}
	
	/**
	 * writeByte writes a singe byte to the output stream
	 * 0-255 range
	 * 
	 * @param int $b An int that can be converted to a byte
	 */
	function writeByte($b) {
		$tmp = pack ( "c", $b ); // use pack with the c flag
		

		if ($this->getBytesAvailable () >= 1) {
			$this->raw_data [$this->position ++] = $tmp [0];
		} else {
			$this->raw_data .= $tmp;
			$this->position ++;
			$this->length ++;
		}
	}
	
	/**
	 * writeInt takes an int and writes it as 2 bytes to the output stream
	 * 0-65535 range
	 * 
	 * @param int $n An integer to convert to a 2 byte binary string
	 */
	function writeInt16($n) {
		$tmp = pack ( "s", $n ); // use pack with the s flag
		$this->writeBinary ( $tmp, 2 );
	}
	
	function writeUnsignedInt16($n) {
		$tmp = pack ( "S", $n ); // use pack with the s flag
		$this->writeBinary ( $tmp, 2 );
	}
	
	/**
	 * writeLong takes an int, float or double and converts it to a 4 byte binary string and
	 * adds it to the output buffer
	 * 
	 * @param long $l A long to convert to a 4 byte binary string
	 */
	function writeInt32($l) {
		$tmp = pack ( "i", $l ); // use pack with the I flag
		$this->writeBinary ( $tmp, 4 );
	}
	
	function writeUnsignedInt32($l) {
		$tmp = pack ( "I", $l ); // use pack with the I flag
		$this->writeBinary ( $tmp, 4 );
	}
	
	function writeUnsignedInt64($l) {
		$tmp = pack ( "I2", $l & 0xffffffff, ($l >> 32) ); // use pack with the I flag
		$this->writeBinary ( $tmp, 4 );
	}
	
	/**
	 * writeUTF takes and input string, writes the length as an int and then
	 * appends the string to the output buffer
	 * 
	 * @param string $s The string less than 65535 characters to add to the stream
	 */
	function writeUTF($s, $len) {
		$this->writeBinary ( $s, $len );
	}
	
	/**
	 * writeBinary takes and input string, writes the length as an int and then
	 * appends the string to the output buffer
	 * 
	 * @param string $s The string less than 65535 characters to add to the stream
	 */
	function writeBinary($s, $len) {
		if ($this->getBytesAvailable () >= $len) {
			for($i = 0; $i < $len; $i ++) {
				$this->writeByte ( ord ( $s [$i] ) );
			}
			//       xp_str_replace($this->raw_data,$s,$this->position,$len);
		//       $this->position +=$len;
		} else {
			$this->raw_data .= $s; // write the string chars
			$this->position += $len;
			$this->length += $len;
		}
	}
	
	function writeFloat($d) {
		$tmp = pack ( "f", $d ); // pack the bytes
		$this->writeBinary ( $tmp, 4 );
	}
	
	/**
	 * writeDouble takes a float as the input and writes it to the output stream.
	 * Then if the system is big-endian, it reverses the bytes order because all
	 * doubles passed via remoting are passed little-endian.
	 * 
	 * @param double $d The double to add to the output buffer
	 */
	function writeDouble($d) {
		$tmp = pack ( "d", $d ); // pack the bytes
		$this->writeBinary ( $tmp, 8 );
	}
	
	public static function GetDynamicLengthNumBytes($length) {
		if ($length < 0) {
			return 4;
		} else if ($length <= 0x7f) {
			return 1;
		} else if ($length <= 0x3FFF) {
			return 2;
		} else if ($length <= 0x1FFFFF) {
			return 3;
		}
		
		return 4;
	}
	
	public static function StringASize($__lpsz/*:String*/)/*:int*/
{
		return strlen ( $__lpsz ) + 1 + 4;
	}
	
	public static function StringABytesNum($__lpsz/*:String*/)/*:int*/
{
		return strlen ( $__lpsz ) + 1;
	}
	
	public static function ReadStringA($__src/*:XByteArray*/,$__offset/*:XInteger*/)/*:String*/
{
		$offset/*:int*/  = 0;
		$__offset->_value = 0;
		
		$szSize/*:XInteger*/ = new XInteger ( );
		$offset += XByteArray::ReadDynamicArrayLength ( $__src, $szSize );
		
		if ($offset == 0 || $szSize->_value < 1 || $szSize->_value > $__src->getBytesAvailable ()) {
			return "";
		}
		
		$szValue/*:String*/ = $__src->readUTF ( $szSize->_value );
		$offset += $szSize->_value;
		$__offset->_value = $offset;
		return $szValue;
	}
	
	public static function WriteStringA($__dst/*:XByteArray*/,$__lpsz/*:String*/)/*:int*/
{
		$offset/*:int*/ = 0;
		
		$szSize/*:int*/ = XByteArray::StringABytesNum ( $__lpsz );
		
		$offset += XByteArray::WriteDynamicArrayLength ( $__dst, $szSize );
		
		if ($offset == 0) {
			return 0;
		}
		
		$_save_pos/*:uint*/ = $__dst->position;
		$__dst->writeUTF ( $__lpsz, $szSize - 1 );
		$__dst->writeByte ( 0 );
		$offset += ($__dst->position - $_save_pos);
		
		return $offset;
	
	}
	
	public static function ReadDynamicArrayLength($__src, $__lplen) {
		if ($__src->getBytesAvailable () < 4)
			return 0;
		
		$__lplen->_value = $__src->readInt32 ();
		
		if ($__lplen->_value > 0x2fffffff) {
			return 0;
		}
		return 4;
	
	}
	
	public static function WriteDynamicArrayLength($__dst, $len) {
		if ($len > 0x2fffffff) {
			return 0;
		}
		
		$__dst->writeInt32 ( $len );
		return 4;
	
	}

}



  
  function ReadAMF3Object($br)
  {


	  //Include things that need to be global, for integrating with other frameworks
	  include_once("amf/globals.php");
    include_once("amf/core/amf/app/Gateway.php");
	  include_once(AMFPHP_BASE . "amf/io/AMFDeserializer.php");

    $len = $br->readInt32();
    if(($len-8)>0)
    {
	    $deserializer = new AMFDeserializer($br->raw_data); // deserialize the data
      $deserializer->current_byte = $br->position+3; //skip two len and cmd
      $br->position+=($len-4);
      $br->raw_data[$deserializer->current_byte]="\x11";
	    return $deserializer->readAny();
    }
    else
    {
      $br->readInt32();
    }
    return array();
  }

  function WriteAMF3Object($obj)
  {
  
	  include_once("amf/globals.php");
    include_once("amf/core/amf/app/Gateway.php");
	  include_once(AMFPHP_BASE . "amf/io/AMFSerializer.php");
	  $serializer = new AMFSerializer();
    if($serializer->native)
    {
      $encodeCallback = array(&$serializer,"encodeCallback");
      $data = amf_encode($obj,3,$encodeCallback);
      $len = strlen($data );
      if($len>1)
      {
        return substr($data,1,$len-1);
      }
      else
      {
        return $data;
      }
    }
    else
    {
	    return $serializer->writeAmf3Object($obj);
    }
  }
  

?>
