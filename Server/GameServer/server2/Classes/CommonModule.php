<?php
/**
 * Created by PhpStorm.
 * User: xumanli
 * Date: 14-12-26
 * Time: 下午5:26
 */

class CommonModule
{

    public static function getCountryCode() {
        $user_ip = CommonModule::getIp ();
        return CommonModule::getCountryCodeByIP($user_ip);
    }

    /**
     * 获取顾客的ip.
     * @return unknown_type
     */
    public static function getIp() {
        $alt_ip = $_SERVER ['REMOTE_ADDR'];

        if (isset ( $_SERVER ['HTTP_CLIENT_IP'] )) {
            $alt_ip = $_SERVER ['HTTP_CLIENT_IP'];
        } else if (isset ( $_SERVER ['HTTP_X_FORWARDED_FOR'] ) and preg_match_all ( '#\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}#s', $_SERVER ['HTTP_X_FORWARDED_FOR'], $matches )) {
            // try to avoid using an internal IP address, its probably a proxy
            $ranges = array (
                '10.0.0.0/8' => array (
                    ip2long ( '10.0.0.0' ),
                    ip2long ( '10.255.255.255' )
                ),
                '127.0.0.0/8' => array (
                    ip2long ( '127.0.0.0' ),
                    ip2long ( '127.255.255.255' )
                ),
                '169.254.0.0/16' => array (
                    ip2long ( '169.254.0.0' ),
                    ip2long ( '169.254.255.255' )
                ),
                '172.16.0.0/12' => array (
                    ip2long ( '172.16.0.0' ),
                    ip2long ( '172.31.255.255' )
                ),
                '192.168.0.0/16' => array (
                    ip2long ( '192.168.0.0' ),
                    ip2long ( '192.168.255.255' )
                )
            );
            foreach ( $matches [0] as $ip ) {
                $ip_long = ip2long ( $ip );
                if ($ip_long === false or $ip_long == - 1) {
                    continue;
                }

                $private_ip = false;
                foreach ( $ranges as $range ) {
                    if ($ip_long >= $range [0] and $ip_long <= $range [1]) {
                        $private_ip = true;
                        break;
                    }
                }

                if (! $private_ip) {
                    $alt_ip = $ip;
                    break;
                }
            }
        } else if (isset ( $_SERVER ['HTTP_FROM'] )) {
            $alt_ip = $_SERVER ['HTTP_FROM'];
        }

        return $alt_ip;

    }

    public static function getCountryCodeByIP($ip){
        if(function_exists("geoip_country_code_by_name")){
            //返回数组
            $record = @geoip_country_code_by_name($ip);
        }else{
            $record='';
        }
        return $record;
    }

    public static function getRechargeProductionIdList($platform = 1)
    {
        $rechargeProductionIdList = "";

        $field = "ios_product_id";
        if ($platform != 1) {
            // -- android
            $field = "android_product_id";
        }

        $listArr_ = array();
        $sql = " select product_id, {$field} as platform_product_id from `product_id_map` where 1 ";
        $fixedSql = MySQL::getInstance()->RunQuery($sql);
        $payArr = MySQL::getInstance()->FetchArray($fixedSql);
        foreach ($payArr as $pay_) {
            $listArr_[] = $pay_['product_id'] . ":" . $pay_['platform_product_id'];
        }

        $rechargeProductionIdList = implode(";", $listArr_);

        return $rechargeProductionIdList;
    }

    /**
     * 加密方法
     * @static
     * @param $s 字符串或者数组
     * @param $key 加密密钥
     * @return mixed 返回字符串类型
     */
    public static function encrypt($s, $key)
    {
        is_array($s) && $s = serialize($s);
        return str_replace(array('+', '/', '='), array('-', '_', '.'), base64_encode(self::xxtea_encrypt($s, $key)));
    }

    /**
     * 解密方法
     * @static
     * @param 待解密的加密字符串
     * @param 密钥
     * @param bool $isArray 是否是数组加密过来的
     * @return bool|mixed|string 返回解密后的字符串
     */
    public static function decrypt($e, $key, $isArray = false)
    {
        $c = str_replace(array('-', '_', '.'), array('+', '/', '='), $e);
        if ($isArray === false) {
            return self::xxtea_decrypt(base64_decode($c), $key);
        } else {
            return unserialize(self::xxtea_decrypt(base64_decode($c), $key));
        }
    }

    private static function long2str($v, $w)
    {
        $len = count($v);
        $n = ($len - 1) << 2;
        if ($w) {
            $m = $v[$len - 1];
            if (($m < $n - 3) || ($m > $n)) return false;
            $n = $m;
        }
        $s = array();
        for ($i = 0; $i < $len; $i++) {
            $s[$i] = pack("V", $v[$i]);
        }
        if ($w) {
            return substr(join('', $s), 0, $n);
        } else {
            return join('', $s);
        }
    }

    private static function str2long($s, $w)
    {
        $v = unpack("V*", $s . str_repeat("\0", (4 - strlen($s) % 4) & 3));
        $v = array_values($v);
        if ($w) {
            $v[count($v)] = strlen($s);
        }
        return $v;
    }

    private static function int32($n)
    {
        while ($n >= 2147483648) $n -= 4294967296;
        while ($n <= -2147483649) $n += 4294967296;
        return (int)$n;
    }

    private static function xxtea_encrypt($str, $key)
    {
        if ($str == "") {
            return "";
        }
        $v = self::str2long($str, true);
        $k = self::str2long($key, false);
        if (count($k) < 4) {
            for ($i = count($k); $i < 4; $i++) {
                $k[$i] = 0;
            }
        }
        $n = count($v) - 1;
        $z = $v[$n];
        $y = $v[0];
        $delta = 0x9E3779B9;
        $q = floor(6 + 52 / ($n + 1));
        $sum = 0;

        while (0 < $q--) {
            $sum = self::int32($sum + $delta);
            $e = $sum >> 2 & 3;
            for ($p = 0; $p < $n; $p++) {
                $y = $v[$p + 1];
                $mx = self::int32((($z >> 5 & 0x07ffffff) ^ $y << 2) + (($y >> 3 & 0x1fffffff) ^ $z << 4)) ^ self::int32(($sum ^ $y) + ($k[$p & 3 ^ $e] ^ $z));
                $z = $v[$p] = self::int32($v[$p] + $mx);
            }
            $y = $v[0];
            $mx = self::int32((($z >> 5 & 0x07ffffff) ^ $y << 2) + (($y >> 3 & 0x1fffffff) ^ $z << 4)) ^ self::int32(($sum ^ $y) + ($k[$p & 3 ^ $e] ^ $z));
            $z = $v[$n] = self::int32($v[$n] + $mx);
        }
        return self::long2str($v, false);
    }

    private static function xxtea_decrypt($str, $key)
    {
        if ($str == "") {
            return "";
        }
        $v = self::str2long($str, false);
        $k = self::str2long($key, false);
        if (count($k) < 4) {
            for ($i = count($k); $i < 4; $i++) {
                $k[$i] = 0;
            }
        }
        $n = count($v) - 1;

        $z = $v[$n];
        $y = $v[0];
        $delta = 0x9E3779B9;
        $q = floor(6 + 52 / ($n + 1));
        $sum = self::int32($q * $delta);

        while ($sum != 0) {
            $e = $sum >> 2 & 3;
            for ($p = $n; $p > 0; $p--) {
                $z = $v[$p - 1];
                $mx = self::int32((($z >> 5 & 0x07ffffff) ^ $y << 2) + (($y >> 3 & 0x1fffffff) ^ $z << 4)) ^ self::int32(($sum ^ $y) + ($k[$p & 3 ^ $e] ^ $z));
                $y = $v[$p] = self::int32($v[$p] - $mx);
            }
            $z = $v[$n];
            $mx = self::int32((($z >> 5 & 0x07ffffff) ^ $y << 2) + (($y >> 3 & 0x1fffffff) ^ $z << 4)) ^ self::int32(($sum ^ $y) + ($k[$p & 3 ^ $e] ^ $z));
            $y = $v[0] = self::int32($v[0] - $mx);
            $sum = self::int32($sum - $delta);
        }
        return self::long2str($v, true);
    }

}