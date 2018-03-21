<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");

class MailTemplateModule
{

    /**
     * 服务器端的常用邮件模板定义
     *
     * @var array
     */
    private static $mailTemplate = array(
        1 => array( //开服活动提醒
            'title' => "New Server Events",
            'from' => 'System',
            'content' => "
Promotion 1: Daily attendence for \"Mystic\"
Promotion period: Permanently available
Content: Upon logging in the game, players can click the \"Sign\" button to check daily Sign and receive massive rewards. With a specified number of Sign records, players can receive the latest award \"Mystic\" of this month!

Promotion 2 : Enjoy double amount of gems
Promotion period : Permanently available
Content : Receive double amount of gems by buying your gem package . Good luck !
        		
Promotion 3: Soul stones will be given as gifts at the new server in the first seven days.
Promotion period:The first week of the new server
Content: After the server is turned on, from day 2 to day 8, all players with a team level equal to or higher than 10 will receive soul stones via in-game mails at around 12:00 each noon.

Promotion 4: Receive massive rewards after first payment
Promotion period:Permanently available
Content:During the promotion period, any payments made by the players will be rewarded with massive gifts, including hero, coins ,experience and and so on.",
            'titleParam' => array(), //替换参数的宏
            'contentParam' => array('day4' => 'serverOpen4Days', 'date' => 'serverOpen7Days', 'end' => 'serverOpen4DaysEnd'), //替换参数的宏
            'expire' => 604800, //7*24*3600
            'money' => 0,
            'gem' => 0,
            'items' => array(),
            'points' => array(),
        ),

        2 => array( //支付日活动邮件
            'title' => "pay activity",
            'from' => 'dota',
            'content' => "....",
            'titleParam' => array(), //替换参数的宏
            'contentParam' => array('day4' => 'serverOpen4Days', 'date' => 'serverOpen7Days', 'end' => 'serverOpen4DaysEnd'), //替换参数的宏
            'expire' => 604800, //7*24*3600
            'money' => 0,
            'gem' => 0,
            'items' => array(),
            'points' => array(),
        ),

        3 => array( //每日登录活动邮件
            'title' => "New Server Events",
            'from' => 'dota',
            'content' => "",
            'titleParam' => array(), //替换参数的宏
            'contentParam' => array('day4' => 'serverOpen4Days', 'date' => 'serverOpen7Days', 'end' => 'serverOpen4DaysEnd'), //替换参数的宏
            'expire' => 6048000, //7*24*3600
            'money' => 0,
            'gem' => 0,
            'items' => array(),
            'points' => array(),
        ),

        4 => array( //vip附加赠送邮件
            'title' => "VIP Bonus for Purchase",
            'from' => 'dota',
            'content' => "As a thank you for supporting Heroes Charge, we are offering you VIP Bonus for purchasing Gems. Good luck hunting!",
            'titleParam' => array(), //替换参数的宏
            'contentParam' => array(), //替换参数的宏
            'expire' => 6048000, //7*24*3600
            'money' => 0,
            'gem' => 0,  //是动态可变的
            'items' => array(),
            'points' => array(),
        ),

    );

    private static $_title = "";
    private static $_from = "";
    private static $_content = "";

    private static $_userId = 0;

    private static $_tbMail = null;


    /**
     * 解析邮件模板中的内容
     *
     * @param int $template 邮件模版的数字ID
     */
    public static function parseTemplate($template, $userId, $tbMail = null)
    {
        if (!isset(self::$mailTemplate[$template])) {
            self::$_title = self::$_from = self::$_content = "";
            return;
        }

        self::$_tbMail = $tbMail;

        self::$_userId = $userId;

        $aMailInfo = self::$mailTemplate[$template];

        self::$_title = isset($aMailInfo['title']) ? $aMailInfo['title'] : "";
        self::$_content = isset($aMailInfo['content']) ? $aMailInfo['content'] : "";
        self::$_from = isset($aMailInfo['from']) ? $aMailInfo['from'] : "";

        $titleParam = isset($aMailInfo['titleParam']) ? $aMailInfo['titleParam'] : array();
        $contentParam = isset($aMailInfo['contentParam']) ? $aMailInfo['contentParam'] : array();

        //self::$_title = preg_replace_callback("~{(\w+)}~is", "self::replaceParams('\\1', \$titleParam)", self::$_title);
        self::$_title = preg_replace_callback("~{(\w+)}~is", function ($match) use ($titleParam) {
            return MailTemplateModule::replaceParams($match[1], $titleParam);
        }, self::$_title);
        self::$_content = preg_replace_callback("~{(\w+)}~is", function ($match) use ($contentParam) {
            return MailTemplateModule::replaceParams($match[1], $contentParam);
        }, self::$_content);
    }

    /**
     * 插入新的模板邮件
     *
     * @param $template
     * @param $userId
     */
    public static function insertNewTemplateMail($template, $userId)
    {
        if (!isset(self::$mailTemplate[$template])) {
            return false;
        }

        $aMailInfo = self::$mailTemplate[$template];
        $expire = $aMailInfo['expire'];
        $money = $aMailInfo['money'];
        $gem = $aMailInfo['gem'];
        $items = $aMailInfo['items'];
        $points = $aMailInfo['points'];

        $mail = new SysPlayerMail();
        $mail->setUserId($userId);
        $mail->setType(0);
        $curTime = time();
        $expireTime = $curTime + $expire;
        $mail->setMailTime($curTime);
        $mail->setExpireTime($expireTime);
        if ($money > 0) {
            $mail->setMoney($money);
        }

        if ($gem > 0) {
            $mail->setDiamonds($gem);
        }

        if (is_array($items) && count($items) > 0) {
            $itemStr = "";
            foreach ($items as $key => $vv) {
                $itemStr .= "{$key}:{$vv};";
            }
            $mail->setItems($itemStr);
        }

        if (is_array($points) && count($points) > 0) {
            $itemStr = "";
            foreach ($points as $key => $vv) {
                $itemStr .= "{$key}:{$vv};";
            }
            $mail->setPoints($itemStr);
        }

        $mail->setTemplate($template);
        $mail->setStatus(0);
        $mail->inOrUp();

        return true;
    }


    /**
     * This function is solely used by the parseTemplate method
     *
     * @param mixed $matches
     * @return String
     */
    public static function replaceParams($matches, $par)
    {
        if (isset($par[$matches])) {
            $function = $par[$matches];
            if (!method_exists("MailTemplateManager", $function)) {
                return "";
            }

            return call_user_func(array("MailTemplateManager", $function));
        }
        return "";
    }

    /***********自定义的常用宏begin************************************************************************/
    private static function serverOpen4Days()
    {
        $tbPlayer = PlayerModule::getPlayerTable(self::$_userId);
        $serverId = $tbPlayer->getServerId();

        //开服
        $tbServerList = ServerModule::getServerInfoByServerId($serverId);
        $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServerList->getServerStartDate()));
        $endTime = $beginTime + 4 * 24 * 3600;

        $beginMonth = date("M", $tbServerList->getServerStartDate());
        $beginDate = date("jS", $tbServerList->getServerStartDate());
        $endMonth = date("M", $endTime - 1);
        $endDate = date("jS", $endTime - 1);

        return "{$beginMonth} $beginDate to $endMonth $endDate";
    }

    private static function serverOpen7Days()
    {
        $tbPlayer = PlayerModule::getPlayerTable(self::$_userId);
        $serverId = $tbPlayer->getServerId();

        //开服
        $tbServerList = ServerModule::getServerInfoByServerId($serverId);
        $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServerList->getServerStartDate()));
        $endTime = $beginTime + 8 * 24 * 3600;

        $beginMonth = date("M", $beginTime + 24 *3600);
        $beginDate = date("jS", $beginTime + 24 *3600);
        $endMonth = date("M", $endTime - 1);
        $endDate = date("jS", $endTime - 1);

        return "{$beginMonth} $beginDate to $endMonth $endDate";
    }

    private static function serverOpen4DaysEnd()
    {
        $tbPlayer = PlayerModule::getPlayerTable(self::$_userId);
        $serverId = $tbPlayer->getServerId();

        //开服
        $tbServerList = ServerModule::getServerInfoByServerId($serverId);
        $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServerList->getServerStartDate()));
        $endTime = $beginTime + 4 * 24 * 3600;

        $beginMonth = date("M", $tbServerList->getServerStartDate());
        $beginDate = date("jS", $tbServerList->getServerStartDate());
        $endMonth = date("M", $endTime - 1);
        $endDate = date("jS", $endTime - 1);

        return "$endMonth $endDate";
    }

    /***********************************************************************************/

    /**
     * @return string
     */
    public static function getContent()
    {
        return self::$_content;
    }

    /**
     * @return string
     */
    public static function getFrom()
    {
        return self::$_from;
    }

    /**
     * @return string
     */
    public static function getTitle()
    {
        return self::$_title;
    }

}
 