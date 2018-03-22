<?php

class AESMcryptMgr
{
    public $bit = 128;
    public $key = NULL;
    public $iv = NULL;
    private $cipher;
    private $rcKey = "";

    public function __construct()
    {
        $this->bit = 128;
        $this->key = "0";
        $this->iv = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
        $this->mode = MCRYPT_MODE_CBC;
        $this->rcKey = "gota123|}{";

        switch ($this->bit) {
            case 192:
                $this->cipher = MCRYPT_RIJNDAEL_192;
                break;
            case 256:
                $this->cipher = MCRYPT_RIJNDAEL_256;
                break;
            default:
                $this->cipher = MCRYPT_RIJNDAEL_128;
        }

        switch ($this->mode) {
            case 'ecb':
                $this->mode = MCRYPT_MODE_ECB;
                break;
            case 'cfb':
                $this->mode = MCRYPT_MODE_CFB;
                break;
            case 'ofb':
                $this->mode = MCRYPT_MODE_OFB;
                break;
            case 'nofb':
                $this->mode = MCRYPT_MODE_NOFB;
                break;
            default:
                $this->mode = MCRYPT_MODE_CBC;
        }
    }

    public function setKey($key)
    {
        if(strlen($key) > 9)
            $this->key = 'darogn' . substr($key, 0, 10);
        else
            $this->key = 'darogn' . $key . str_repeat("\0", 10 - strlen($key));
    }

    public function encrypt($data)
    {
        //$ret = mcrypt_encrypt($this->cipher, $this->key, base64_encode($data), $this->mode, $this->iv);
        $ret = mcrypt_encrypt($this->cipher, $this->key, $data, $this->mode, $this->iv);
        //$ret = openssl_encrypt($data, "aes-128-cbc", $this->key, OPENSSL_RAW_DATA, $this->iv);
        $ret = $this->rc4($ret);

        return $ret;
    }

    public function decrypt($data)
    {
        //$ret1 = mcrypt_decrypt($this->cipher, $this->key, base64_decode($data), $this->mode, $this->iv);
        //$ret = rtrim(rtrim($ret1), "\x00..\x1F");
        $data = $this->rc4($data);
        $ret = mcrypt_decrypt($this->cipher, $this->key, $data, $this->mode, $this->iv);
        //$ret = openssl_decrypt($data, "aes-128-cbc", $this->key, OPENSSL_RAW_DATA, $this->iv);

        return $ret;
    }

    public function rc4($data)
    {
        if (!defined('OpenRc4Encrypt') || !OpenRc4Encrypt) {
            return $data;
        }

        for ($i = 0, $c = array(); $i < 256; ++$i) {
            $c[$i] = $i;
        }

        $a = $this->rcKey;
        for ($i = 0, $d = 0, $e = 0, $g = strlen($a); $i < 256; ++$i) {
            $d = ($d + $c[$i] + ord($a[$i % $g])) % 256;
            $e = $c[$i];
            $c[$i] = $c[$d];
            $c[$d] = $e;
        }

        for ($y = 0, $i = 0, $d = 0, $f = "", $len = strlen($data); $y < $len; ++$y) {
            $i = ($i + 1) % 256;
            $d = ($d + $c[$i]) % 256;
            $e = $c[$i];
            $c[$i] = $c[$d];
            $c[$d] = $e;
            $f .= chr(ord($data[$y]) ^ $c[($c[$i] + $c[$d]) % 256]);
        }

        return $f;
    }
}