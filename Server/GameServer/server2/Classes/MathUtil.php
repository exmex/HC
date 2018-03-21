<?php

class MathUtil
{

    public static function bits($num, $start, $count)
    {
        $remain = $num >> $start;
        $mask = pow(2, $count) - 1;
        return $remain & $mask;
    }

    public static function makeBits($arg_array)
    {
        $num_args = count($arg_array);

        $value = 0;
        $b0 = 0;

        for ($i = $num_args; $i > 1; $i = $i - 2) {
            $b = $arg_array[$i - 2];
            $v = $arg_array[$i - 1];

            $v2 = self::bits($v, 0, $b);
            if ($v != $v2) {
                Logger::getLogger()->error("makebits value out of bit range : " . $v);
                return null;
            }

            $v = $v << $b0;
            $value = $value + $v;
            $b0 = $b0 + $b;
        }

        return $value;
    }

}