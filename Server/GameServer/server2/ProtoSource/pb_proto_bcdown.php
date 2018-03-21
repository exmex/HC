<?php
/**
 * Auto generated from bcdown.proto at 2014-09-10 01:47:48
 *
 * bcdown package
 */

/**
 * result enum
 */
final class Bcdown_Result
{
    const victory = 0;
    const defeat = 1;
    const canceled = 2;
    const timeout = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'victory' => self::victory,
            'defeat' => self::defeat,
            'canceled' => self::canceled,
            'timeout' => self::timeout,
        );
    }
}

/**
 * battlecheck message
 */
class Bcdown_Battlecheck extends \ProtobufMessage
{
    /* Field index constants */
    const _PVE_MSG = 1;
    const _PVP_MSG = 2;
    const _TBC_MSG = 3;
    const _EXCAV_MSG = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_PVE_MSG => array(
            'name' => '_pve_msg',
            'repeated' => true,
            'type' => 'Bcdown_PveCheckMsg'
        ),
        self::_PVP_MSG => array(
            'name' => '_pvp_msg',
            'repeated' => true,
            'type' => 'Bcdown_PvpCheckMsg'
        ),
        self::_TBC_MSG => array(
            'name' => '_tbc_msg',
            'repeated' => true,
            'type' => 'Bcdown_TbcCheckMsg'
        ),
        self::_EXCAV_MSG => array(
            'name' => '_excav_msg',
            'repeated' => true,
            'type' => 'Bcdown_ExcavCheckMsg'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_PVE_MSG] = array();
        $this->values[self::_PVP_MSG] = array();
        $this->values[self::_TBC_MSG] = array();
        $this->values[self::_EXCAV_MSG] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_pve_msg' list
     *
     * @param Bcdown_PveCheckMsg $value Value to append
     *
     * @return null
     */
    public function appendPveMsg(Bcdown_PveCheckMsg $value)
    {
        return $this->append(self::_PVE_MSG, $value);
    }

    /**
     * Clears '_pve_msg' list
     *
     * @return null
     */
    public function clearPveMsg()
    {
        return $this->clear(self::_PVE_MSG);
    }

    /**
     * Returns '_pve_msg' list
     *
     * @return Bcdown_PveCheckMsg[]
     */
    public function getPveMsg()
    {
        return $this->get(self::_PVE_MSG);
    }

    /**
     * Returns '_pve_msg' iterator
     *
     * @return ArrayIterator
     */
    public function getPveMsgIterator()
    {
        return new \ArrayIterator($this->get(self::_PVE_MSG));
    }

    /**
     * Returns element from '_pve_msg' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_PveCheckMsg
     */
    public function getPveMsgAt($offset)
    {
        return $this->get(self::_PVE_MSG, $offset);
    }

    /**
     * Returns count of '_pve_msg' list
     *
     * @return int
     */
    public function getPveMsgCount()
    {
        return $this->count(self::_PVE_MSG);
    }

    /**
     * Appends value to '_pvp_msg' list
     *
     * @param Bcdown_PvpCheckMsg $value Value to append
     *
     * @return null
     */
    public function appendPvpMsg(Bcdown_PvpCheckMsg $value)
    {
        return $this->append(self::_PVP_MSG, $value);
    }

    /**
     * Clears '_pvp_msg' list
     *
     * @return null
     */
    public function clearPvpMsg()
    {
        return $this->clear(self::_PVP_MSG);
    }

    /**
     * Returns '_pvp_msg' list
     *
     * @return Bcdown_PvpCheckMsg[]
     */
    public function getPvpMsg()
    {
        return $this->get(self::_PVP_MSG);
    }

    /**
     * Returns '_pvp_msg' iterator
     *
     * @return ArrayIterator
     */
    public function getPvpMsgIterator()
    {
        return new \ArrayIterator($this->get(self::_PVP_MSG));
    }

    /**
     * Returns element from '_pvp_msg' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_PvpCheckMsg
     */
    public function getPvpMsgAt($offset)
    {
        return $this->get(self::_PVP_MSG, $offset);
    }

    /**
     * Returns count of '_pvp_msg' list
     *
     * @return int
     */
    public function getPvpMsgCount()
    {
        return $this->count(self::_PVP_MSG);
    }

    /**
     * Appends value to '_tbc_msg' list
     *
     * @param Bcdown_TbcCheckMsg $value Value to append
     *
     * @return null
     */
    public function appendTbcMsg(Bcdown_TbcCheckMsg $value)
    {
        return $this->append(self::_TBC_MSG, $value);
    }

    /**
     * Clears '_tbc_msg' list
     *
     * @return null
     */
    public function clearTbcMsg()
    {
        return $this->clear(self::_TBC_MSG);
    }

    /**
     * Returns '_tbc_msg' list
     *
     * @return Bcdown_TbcCheckMsg[]
     */
    public function getTbcMsg()
    {
        return $this->get(self::_TBC_MSG);
    }

    /**
     * Returns '_tbc_msg' iterator
     *
     * @return ArrayIterator
     */
    public function getTbcMsgIterator()
    {
        return new \ArrayIterator($this->get(self::_TBC_MSG));
    }

    /**
     * Returns element from '_tbc_msg' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_TbcCheckMsg
     */
    public function getTbcMsgAt($offset)
    {
        return $this->get(self::_TBC_MSG, $offset);
    }

    /**
     * Returns count of '_tbc_msg' list
     *
     * @return int
     */
    public function getTbcMsgCount()
    {
        return $this->count(self::_TBC_MSG);
    }

    /**
     * Appends value to '_excav_msg' list
     *
     * @param Bcdown_ExcavCheckMsg $value Value to append
     *
     * @return null
     */
    public function appendExcavMsg(Bcdown_ExcavCheckMsg $value)
    {
        return $this->append(self::_EXCAV_MSG, $value);
    }

    /**
     * Clears '_excav_msg' list
     *
     * @return null
     */
    public function clearExcavMsg()
    {
        return $this->clear(self::_EXCAV_MSG);
    }

    /**
     * Returns '_excav_msg' list
     *
     * @return Bcdown_ExcavCheckMsg[]
     */
    public function getExcavMsg()
    {
        return $this->get(self::_EXCAV_MSG);
    }

    /**
     * Returns '_excav_msg' iterator
     *
     * @return ArrayIterator
     */
    public function getExcavMsgIterator()
    {
        return new \ArrayIterator($this->get(self::_EXCAV_MSG));
    }

    /**
     * Returns element from '_excav_msg' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_ExcavCheckMsg
     */
    public function getExcavMsgAt($offset)
    {
        return $this->get(self::_EXCAV_MSG, $offset);
    }

    /**
     * Returns count of '_excav_msg' list
     *
     * @return int
     */
    public function getExcavMsgCount()
    {
        return $this->count(self::_EXCAV_MSG);
    }
}

/**
 * pve_check_msg message
 */
class Bcdown_PveCheckMsg extends \ProtobufMessage
{
    /* Field index constants */
    const _CHECKID = 1;
    const _USERID = 2;
    const _STAGEID = 3;
    const _RESULT = 4;
    const _STARS = 5;
    const _HEROES = 6;
    const _OPRATIONS = 7;
    const _RSEED = 8;
    const _CLI_BATTLE_TIME = 9;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHECKID => array(
            'name' => '_checkid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERID => array(
            'name' => '_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGEID => array(
            'name' => '_stageid',
            'required' => true,
            'type' => 5,
        ),
        self::_RESULT => array(
            'default' => Bcdown_Result::victory, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_STARS => array(
            'name' => '_stars',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Bcdown_Hero'
        ),
        self::_OPRATIONS => array(
            'name' => '_oprations',
            'repeated' => true,
            'type' => 5,
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_CLI_BATTLE_TIME => array(
            'name' => '_cli_battle_time',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHECKID] = null;
        $this->values[self::_USERID] = null;
        $this->values[self::_STAGEID] = null;
        $this->values[self::_RESULT] = null;
        $this->values[self::_STARS] = null;
        $this->values[self::_HEROES] = array();
        $this->values[self::_OPRATIONS] = array();
        $this->values[self::_RSEED] = null;
        $this->values[self::_CLI_BATTLE_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_checkid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCheckid($value)
    {
        return $this->set(self::_CHECKID, $value);
    }

    /**
     * Returns value of '_checkid' property
     *
     * @return int
     */
    public function getCheckid()
    {
        return $this->get(self::_CHECKID);
    }

    /**
     * Sets value of '_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserid($value)
    {
        return $this->set(self::_USERID, $value);
    }

    /**
     * Returns value of '_userid' property
     *
     * @return int
     */
    public function getUserid()
    {
        return $this->get(self::_USERID);
    }

    /**
     * Sets value of '_stageid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageid($value)
    {
        return $this->set(self::_STAGEID, $value);
    }

    /**
     * Returns value of '_stageid' property
     *
     * @return int
     */
    public function getStageid()
    {
        return $this->get(self::_STAGEID);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_stars' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStars($value)
    {
        return $this->set(self::_STARS, $value);
    }

    /**
     * Returns value of '_stars' property
     *
     * @return int
     */
    public function getStars()
    {
        return $this->get(self::_STARS);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Bcdown_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Bcdown_Hero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Bcdown_Hero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_Hero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }

    /**
     * Appends value to '_oprations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOprations($value)
    {
        return $this->append(self::_OPRATIONS, $value);
    }

    /**
     * Clears '_oprations' list
     *
     * @return null
     */
    public function clearOprations()
    {
        return $this->clear(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' list
     *
     * @return int[]
     */
    public function getOprations()
    {
        return $this->get(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' iterator
     *
     * @return ArrayIterator
     */
    public function getOprationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPRATIONS));
    }

    /**
     * Returns element from '_oprations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOprationsAt($offset)
    {
        return $this->get(self::_OPRATIONS, $offset);
    }

    /**
     * Returns count of '_oprations' list
     *
     * @return int
     */
    public function getOprationsCount()
    {
        return $this->count(self::_OPRATIONS);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Sets value of '_cli_battle_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCliBattleTime($value)
    {
        return $this->set(self::_CLI_BATTLE_TIME, $value);
    }

    /**
     * Returns value of '_cli_battle_time' property
     *
     * @return int
     */
    public function getCliBattleTime()
    {
        return $this->get(self::_CLI_BATTLE_TIME);
    }
}

/**
 * pvp_check_msg message
 */
class Bcdown_PvpCheckMsg extends \ProtobufMessage
{
    /* Field index constants */
    const _CHECKID = 1;
    const _USERID = 2;
    const _USERNAME = 3;
    const _LEVEL = 4;
    const _AVATAR = 5;
    const _OPPO_USERID = 6;
    const _OPPO_NAME = 7;
    const _OPPO_LEVEL = 8;
    const _OPPO_AVATAR = 9;
    const _OPPO_ROBOT = 10;
    const _RESULT = 11;
    const _SELF_HEROES = 12;
    const _OPPO_HEROES = 13;
    const _RSEED = 14;
    const _SELF_ROBOT = 15;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHECKID => array(
            'name' => '_checkid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERID => array(
            'name' => '_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERNAME => array(
            'name' => '_username',
            'required' => false,
            'type' => 7,
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => false,
            'type' => 5,
        ),
        self::_AVATAR => array(
            'name' => '_avatar',
            'required' => false,
            'type' => 5,
        ),
        self::_OPPO_USERID => array(
            'name' => '_oppo_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_OPPO_NAME => array(
            'name' => '_oppo_name',
            'required' => false,
            'type' => 7,
        ),
        self::_OPPO_LEVEL => array(
            'name' => '_oppo_level',
            'required' => false,
            'type' => 5,
        ),
        self::_OPPO_AVATAR => array(
            'name' => '_oppo_avatar',
            'required' => false,
            'type' => 5,
        ),
        self::_OPPO_ROBOT => array(
            'name' => '_oppo_robot',
            'required' => false,
            'type' => 5,
        ),
        self::_RESULT => array(
            'default' => Bcdown_Result::victory, 
            'name' => '_result',
            'required' => false,
            'type' => 5,
        ),
        self::_SELF_HEROES => array(
            'name' => '_self_heroes',
            'repeated' => true,
            'type' => 'Bcdown_Hero'
        ),
        self::_OPPO_HEROES => array(
            'name' => '_oppo_heroes',
            'repeated' => true,
            'type' => 'Bcdown_Hero'
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_ROBOT => array(
            'name' => '_self_robot',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHECKID] = null;
        $this->values[self::_USERID] = null;
        $this->values[self::_USERNAME] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_AVATAR] = null;
        $this->values[self::_OPPO_USERID] = null;
        $this->values[self::_OPPO_NAME] = null;
        $this->values[self::_OPPO_LEVEL] = null;
        $this->values[self::_OPPO_AVATAR] = null;
        $this->values[self::_OPPO_ROBOT] = null;
        $this->values[self::_RESULT] = Bcdown_Result::victory;
        $this->values[self::_SELF_HEROES] = array();
        $this->values[self::_OPPO_HEROES] = array();
        $this->values[self::_RSEED] = null;
        $this->values[self::_SELF_ROBOT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_checkid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCheckid($value)
    {
        return $this->set(self::_CHECKID, $value);
    }

    /**
     * Returns value of '_checkid' property
     *
     * @return int
     */
    public function getCheckid()
    {
        return $this->get(self::_CHECKID);
    }

    /**
     * Sets value of '_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserid($value)
    {
        return $this->set(self::_USERID, $value);
    }

    /**
     * Returns value of '_userid' property
     *
     * @return int
     */
    public function getUserid()
    {
        return $this->get(self::_USERID);
    }

    /**
     * Sets value of '_username' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setUsername($value)
    {
        return $this->set(self::_USERNAME, $value);
    }

    /**
     * Returns value of '_username' property
     *
     * @return string
     */
    public function getUsername()
    {
        return $this->get(self::_USERNAME);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAvatar($value)
    {
        return $this->set(self::_AVATAR, $value);
    }

    /**
     * Returns value of '_avatar' property
     *
     * @return int
     */
    public function getAvatar()
    {
        return $this->get(self::_AVATAR);
    }

    /**
     * Sets value of '_oppo_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoUserid($value)
    {
        return $this->set(self::_OPPO_USERID, $value);
    }

    /**
     * Returns value of '_oppo_userid' property
     *
     * @return int
     */
    public function getOppoUserid()
    {
        return $this->get(self::_OPPO_USERID);
    }

    /**
     * Sets value of '_oppo_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setOppoName($value)
    {
        return $this->set(self::_OPPO_NAME, $value);
    }

    /**
     * Returns value of '_oppo_name' property
     *
     * @return string
     */
    public function getOppoName()
    {
        return $this->get(self::_OPPO_NAME);
    }

    /**
     * Sets value of '_oppo_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoLevel($value)
    {
        return $this->set(self::_OPPO_LEVEL, $value);
    }

    /**
     * Returns value of '_oppo_level' property
     *
     * @return int
     */
    public function getOppoLevel()
    {
        return $this->get(self::_OPPO_LEVEL);
    }

    /**
     * Sets value of '_oppo_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoAvatar($value)
    {
        return $this->set(self::_OPPO_AVATAR, $value);
    }

    /**
     * Returns value of '_oppo_avatar' property
     *
     * @return int
     */
    public function getOppoAvatar()
    {
        return $this->get(self::_OPPO_AVATAR);
    }

    /**
     * Sets value of '_oppo_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoRobot($value)
    {
        return $this->set(self::_OPPO_ROBOT, $value);
    }

    /**
     * Returns value of '_oppo_robot' property
     *
     * @return int
     */
    public function getOppoRobot()
    {
        return $this->get(self::_OPPO_ROBOT);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_self_heroes' list
     *
     * @param Bcdown_Hero $value Value to append
     *
     * @return null
     */
    public function appendSelfHeroes(Bcdown_Hero $value)
    {
        return $this->append(self::_SELF_HEROES, $value);
    }

    /**
     * Clears '_self_heroes' list
     *
     * @return null
     */
    public function clearSelfHeroes()
    {
        return $this->clear(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' list
     *
     * @return Bcdown_Hero[]
     */
    public function getSelfHeroes()
    {
        return $this->get(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_HEROES));
    }

    /**
     * Returns element from '_self_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_Hero
     */
    public function getSelfHeroesAt($offset)
    {
        return $this->get(self::_SELF_HEROES, $offset);
    }

    /**
     * Returns count of '_self_heroes' list
     *
     * @return int
     */
    public function getSelfHeroesCount()
    {
        return $this->count(self::_SELF_HEROES);
    }

    /**
     * Appends value to '_oppo_heroes' list
     *
     * @param Bcdown_Hero $value Value to append
     *
     * @return null
     */
    public function appendOppoHeroes(Bcdown_Hero $value)
    {
        return $this->append(self::_OPPO_HEROES, $value);
    }

    /**
     * Clears '_oppo_heroes' list
     *
     * @return null
     */
    public function clearOppoHeroes()
    {
        return $this->clear(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' list
     *
     * @return Bcdown_Hero[]
     */
    public function getOppoHeroes()
    {
        return $this->get(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_HEROES));
    }

    /**
     * Returns element from '_oppo_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_Hero
     */
    public function getOppoHeroesAt($offset)
    {
        return $this->get(self::_OPPO_HEROES, $offset);
    }

    /**
     * Returns count of '_oppo_heroes' list
     *
     * @return int
     */
    public function getOppoHeroesCount()
    {
        return $this->count(self::_OPPO_HEROES);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Sets value of '_self_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSelfRobot($value)
    {
        return $this->set(self::_SELF_ROBOT, $value);
    }

    /**
     * Returns value of '_self_robot' property
     *
     * @return int
     */
    public function getSelfRobot()
    {
        return $this->get(self::_SELF_ROBOT);
    }
}

/**
 * tbc_check_msg message
 */
class Bcdown_TbcCheckMsg extends \ProtobufMessage
{
    /* Field index constants */
    const _CHECKID = 1;
    const _USERID = 2;
    const _USERNAME = 3;
    const _OPPO_USERID = 4;
    const _OPPO_NAME = 5;
    const _OPPO_ROBOT = 6;
    const _RESULT = 7;
    const _SELF_HEROES = 8;
    const _OPPO_HEROES = 9;
    const _RSEED = 10;
    const _SELF_ROBOT = 11;
    const _SELF_DYNA_START = 12;
    const _SELF_DYNA_END = 13;
    const _OPPO_DYNA_START = 14;
    const _OPPO_DYNA_END = 15;
    const _OPRATIONS = 16;
    const _CLI_BATTLE_TIME = 17;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHECKID => array(
            'name' => '_checkid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERID => array(
            'name' => '_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERNAME => array(
            'name' => '_username',
            'required' => false,
            'type' => 7,
        ),
        self::_OPPO_USERID => array(
            'name' => '_oppo_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_OPPO_NAME => array(
            'name' => '_oppo_name',
            'required' => false,
            'type' => 7,
        ),
        self::_OPPO_ROBOT => array(
            'name' => '_oppo_robot',
            'required' => false,
            'type' => 5,
        ),
        self::_RESULT => array(
            'default' => Bcdown_Result::victory, 
            'name' => '_result',
            'required' => false,
            'type' => 5,
        ),
        self::_SELF_HEROES => array(
            'name' => '_self_heroes',
            'repeated' => true,
            'type' => 'Bcdown_Hero'
        ),
        self::_OPPO_HEROES => array(
            'name' => '_oppo_heroes',
            'repeated' => true,
            'type' => 'Bcdown_Hero'
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_ROBOT => array(
            'name' => '_self_robot',
            'required' => false,
            'type' => 5,
        ),
        self::_SELF_DYNA_START => array(
            'name' => '_self_dyna_start',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_SELF_DYNA_END => array(
            'name' => '_self_dyna_end',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_OPPO_DYNA_START => array(
            'name' => '_oppo_dyna_start',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_OPPO_DYNA_END => array(
            'name' => '_oppo_dyna_end',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_OPRATIONS => array(
            'name' => '_oprations',
            'repeated' => true,
            'type' => 5,
        ),
        self::_CLI_BATTLE_TIME => array(
            'name' => '_cli_battle_time',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHECKID] = null;
        $this->values[self::_USERID] = null;
        $this->values[self::_USERNAME] = null;
        $this->values[self::_OPPO_USERID] = null;
        $this->values[self::_OPPO_NAME] = null;
        $this->values[self::_OPPO_ROBOT] = null;
        $this->values[self::_RESULT] = Bcdown_Result::victory;
        $this->values[self::_SELF_HEROES] = array();
        $this->values[self::_OPPO_HEROES] = array();
        $this->values[self::_RSEED] = null;
        $this->values[self::_SELF_ROBOT] = null;
        $this->values[self::_SELF_DYNA_START] = array();
        $this->values[self::_SELF_DYNA_END] = array();
        $this->values[self::_OPPO_DYNA_START] = array();
        $this->values[self::_OPPO_DYNA_END] = array();
        $this->values[self::_OPRATIONS] = array();
        $this->values[self::_CLI_BATTLE_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_checkid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCheckid($value)
    {
        return $this->set(self::_CHECKID, $value);
    }

    /**
     * Returns value of '_checkid' property
     *
     * @return int
     */
    public function getCheckid()
    {
        return $this->get(self::_CHECKID);
    }

    /**
     * Sets value of '_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserid($value)
    {
        return $this->set(self::_USERID, $value);
    }

    /**
     * Returns value of '_userid' property
     *
     * @return int
     */
    public function getUserid()
    {
        return $this->get(self::_USERID);
    }

    /**
     * Sets value of '_username' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setUsername($value)
    {
        return $this->set(self::_USERNAME, $value);
    }

    /**
     * Returns value of '_username' property
     *
     * @return string
     */
    public function getUsername()
    {
        return $this->get(self::_USERNAME);
    }

    /**
     * Sets value of '_oppo_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoUserid($value)
    {
        return $this->set(self::_OPPO_USERID, $value);
    }

    /**
     * Returns value of '_oppo_userid' property
     *
     * @return int
     */
    public function getOppoUserid()
    {
        return $this->get(self::_OPPO_USERID);
    }

    /**
     * Sets value of '_oppo_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setOppoName($value)
    {
        return $this->set(self::_OPPO_NAME, $value);
    }

    /**
     * Returns value of '_oppo_name' property
     *
     * @return string
     */
    public function getOppoName()
    {
        return $this->get(self::_OPPO_NAME);
    }

    /**
     * Sets value of '_oppo_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoRobot($value)
    {
        return $this->set(self::_OPPO_ROBOT, $value);
    }

    /**
     * Returns value of '_oppo_robot' property
     *
     * @return int
     */
    public function getOppoRobot()
    {
        return $this->get(self::_OPPO_ROBOT);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_self_heroes' list
     *
     * @param Bcdown_Hero $value Value to append
     *
     * @return null
     */
    public function appendSelfHeroes(Bcdown_Hero $value)
    {
        return $this->append(self::_SELF_HEROES, $value);
    }

    /**
     * Clears '_self_heroes' list
     *
     * @return null
     */
    public function clearSelfHeroes()
    {
        return $this->clear(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' list
     *
     * @return Bcdown_Hero[]
     */
    public function getSelfHeroes()
    {
        return $this->get(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_HEROES));
    }

    /**
     * Returns element from '_self_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_Hero
     */
    public function getSelfHeroesAt($offset)
    {
        return $this->get(self::_SELF_HEROES, $offset);
    }

    /**
     * Returns count of '_self_heroes' list
     *
     * @return int
     */
    public function getSelfHeroesCount()
    {
        return $this->count(self::_SELF_HEROES);
    }

    /**
     * Appends value to '_oppo_heroes' list
     *
     * @param Bcdown_Hero $value Value to append
     *
     * @return null
     */
    public function appendOppoHeroes(Bcdown_Hero $value)
    {
        return $this->append(self::_OPPO_HEROES, $value);
    }

    /**
     * Clears '_oppo_heroes' list
     *
     * @return null
     */
    public function clearOppoHeroes()
    {
        return $this->clear(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' list
     *
     * @return Bcdown_Hero[]
     */
    public function getOppoHeroes()
    {
        return $this->get(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_HEROES));
    }

    /**
     * Returns element from '_oppo_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_Hero
     */
    public function getOppoHeroesAt($offset)
    {
        return $this->get(self::_OPPO_HEROES, $offset);
    }

    /**
     * Returns count of '_oppo_heroes' list
     *
     * @return int
     */
    public function getOppoHeroesCount()
    {
        return $this->count(self::_OPPO_HEROES);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Sets value of '_self_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSelfRobot($value)
    {
        return $this->set(self::_SELF_ROBOT, $value);
    }

    /**
     * Returns value of '_self_robot' property
     *
     * @return int
     */
    public function getSelfRobot()
    {
        return $this->get(self::_SELF_ROBOT);
    }

    /**
     * Appends value to '_self_dyna_start' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendSelfDynaStart(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_SELF_DYNA_START, $value);
    }

    /**
     * Clears '_self_dyna_start' list
     *
     * @return null
     */
    public function clearSelfDynaStart()
    {
        return $this->clear(self::_SELF_DYNA_START);
    }

    /**
     * Returns '_self_dyna_start' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getSelfDynaStart()
    {
        return $this->get(self::_SELF_DYNA_START);
    }

    /**
     * Returns '_self_dyna_start' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfDynaStartIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_DYNA_START));
    }

    /**
     * Returns element from '_self_dyna_start' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getSelfDynaStartAt($offset)
    {
        return $this->get(self::_SELF_DYNA_START, $offset);
    }

    /**
     * Returns count of '_self_dyna_start' list
     *
     * @return int
     */
    public function getSelfDynaStartCount()
    {
        return $this->count(self::_SELF_DYNA_START);
    }

    /**
     * Appends value to '_self_dyna_end' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendSelfDynaEnd(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_SELF_DYNA_END, $value);
    }

    /**
     * Clears '_self_dyna_end' list
     *
     * @return null
     */
    public function clearSelfDynaEnd()
    {
        return $this->clear(self::_SELF_DYNA_END);
    }

    /**
     * Returns '_self_dyna_end' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getSelfDynaEnd()
    {
        return $this->get(self::_SELF_DYNA_END);
    }

    /**
     * Returns '_self_dyna_end' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfDynaEndIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_DYNA_END));
    }

    /**
     * Returns element from '_self_dyna_end' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getSelfDynaEndAt($offset)
    {
        return $this->get(self::_SELF_DYNA_END, $offset);
    }

    /**
     * Returns count of '_self_dyna_end' list
     *
     * @return int
     */
    public function getSelfDynaEndCount()
    {
        return $this->count(self::_SELF_DYNA_END);
    }

    /**
     * Appends value to '_oppo_dyna_start' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendOppoDynaStart(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_OPPO_DYNA_START, $value);
    }

    /**
     * Clears '_oppo_dyna_start' list
     *
     * @return null
     */
    public function clearOppoDynaStart()
    {
        return $this->clear(self::_OPPO_DYNA_START);
    }

    /**
     * Returns '_oppo_dyna_start' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getOppoDynaStart()
    {
        return $this->get(self::_OPPO_DYNA_START);
    }

    /**
     * Returns '_oppo_dyna_start' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoDynaStartIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_DYNA_START));
    }

    /**
     * Returns element from '_oppo_dyna_start' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getOppoDynaStartAt($offset)
    {
        return $this->get(self::_OPPO_DYNA_START, $offset);
    }

    /**
     * Returns count of '_oppo_dyna_start' list
     *
     * @return int
     */
    public function getOppoDynaStartCount()
    {
        return $this->count(self::_OPPO_DYNA_START);
    }

    /**
     * Appends value to '_oppo_dyna_end' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendOppoDynaEnd(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_OPPO_DYNA_END, $value);
    }

    /**
     * Clears '_oppo_dyna_end' list
     *
     * @return null
     */
    public function clearOppoDynaEnd()
    {
        return $this->clear(self::_OPPO_DYNA_END);
    }

    /**
     * Returns '_oppo_dyna_end' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getOppoDynaEnd()
    {
        return $this->get(self::_OPPO_DYNA_END);
    }

    /**
     * Returns '_oppo_dyna_end' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoDynaEndIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_DYNA_END));
    }

    /**
     * Returns element from '_oppo_dyna_end' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getOppoDynaEndAt($offset)
    {
        return $this->get(self::_OPPO_DYNA_END, $offset);
    }

    /**
     * Returns count of '_oppo_dyna_end' list
     *
     * @return int
     */
    public function getOppoDynaEndCount()
    {
        return $this->count(self::_OPPO_DYNA_END);
    }

    /**
     * Appends value to '_oprations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOprations($value)
    {
        return $this->append(self::_OPRATIONS, $value);
    }

    /**
     * Clears '_oprations' list
     *
     * @return null
     */
    public function clearOprations()
    {
        return $this->clear(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' list
     *
     * @return int[]
     */
    public function getOprations()
    {
        return $this->get(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' iterator
     *
     * @return ArrayIterator
     */
    public function getOprationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPRATIONS));
    }

    /**
     * Returns element from '_oprations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOprationsAt($offset)
    {
        return $this->get(self::_OPRATIONS, $offset);
    }

    /**
     * Returns count of '_oprations' list
     *
     * @return int
     */
    public function getOprationsCount()
    {
        return $this->count(self::_OPRATIONS);
    }

    /**
     * Sets value of '_cli_battle_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCliBattleTime($value)
    {
        return $this->set(self::_CLI_BATTLE_TIME, $value);
    }

    /**
     * Returns value of '_cli_battle_time' property
     *
     * @return int
     */
    public function getCliBattleTime()
    {
        return $this->get(self::_CLI_BATTLE_TIME);
    }
}

/**
 * oppo_type enum embedded in excav_check_msg message
 */
final class Bcdown_ExcavCheckMsg_OppoType
{
    const monster = 1;
    const player = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'monster' => self::monster,
            'player' => self::player,
        );
    }
}

/**
 * excav_check_msg message
 */
class Bcdown_ExcavCheckMsg extends \ProtobufMessage
{
    /* Field index constants */
    const _CHECKID = 1;
    const _USERID = 2;
    const _OPPO_USERID = 3;
    const _OPPO_TYPE = 4;
    const _RESULT = 5;
    const _SELF_HEROES = 6;
    const _OPPO_HEROES = 7;
    const _RSEED = 8;
    const _SELF_DYNA_START = 9;
    const _SELF_DYNA_END = 10;
    const _OPPO_DYNA_START = 11;
    const _OPPO_DYNA_END = 12;
    const _OPRATIONS = 13;
    const _CLI_BATTLE_TIME = 14;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHECKID => array(
            'name' => '_checkid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERID => array(
            'name' => '_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_OPPO_USERID => array(
            'name' => '_oppo_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_OPPO_TYPE => array(
            'name' => '_oppo_type',
            'required' => false,
            'type' => 5,
        ),
        self::_RESULT => array(
            'default' => Bcdown_Result::victory, 
            'name' => '_result',
            'required' => false,
            'type' => 5,
        ),
        self::_SELF_HEROES => array(
            'name' => '_self_heroes',
            'repeated' => true,
            'type' => 'Bcdown_Hero'
        ),
        self::_OPPO_HEROES => array(
            'name' => '_oppo_heroes',
            'repeated' => true,
            'type' => 'Bcdown_Hero'
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_DYNA_START => array(
            'name' => '_self_dyna_start',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_SELF_DYNA_END => array(
            'name' => '_self_dyna_end',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_OPPO_DYNA_START => array(
            'name' => '_oppo_dyna_start',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_OPPO_DYNA_END => array(
            'name' => '_oppo_dyna_end',
            'repeated' => true,
            'type' => 'Bcdown_HeroDyna'
        ),
        self::_OPRATIONS => array(
            'name' => '_oprations',
            'repeated' => true,
            'type' => 5,
        ),
        self::_CLI_BATTLE_TIME => array(
            'name' => '_cli_battle_time',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHECKID] = null;
        $this->values[self::_USERID] = null;
        $this->values[self::_OPPO_USERID] = null;
        $this->values[self::_OPPO_TYPE] = null;
        $this->values[self::_RESULT] = Bcdown_Result::victory;
        $this->values[self::_SELF_HEROES] = array();
        $this->values[self::_OPPO_HEROES] = array();
        $this->values[self::_RSEED] = null;
        $this->values[self::_SELF_DYNA_START] = array();
        $this->values[self::_SELF_DYNA_END] = array();
        $this->values[self::_OPPO_DYNA_START] = array();
        $this->values[self::_OPPO_DYNA_END] = array();
        $this->values[self::_OPRATIONS] = array();
        $this->values[self::_CLI_BATTLE_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_checkid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCheckid($value)
    {
        return $this->set(self::_CHECKID, $value);
    }

    /**
     * Returns value of '_checkid' property
     *
     * @return int
     */
    public function getCheckid()
    {
        return $this->get(self::_CHECKID);
    }

    /**
     * Sets value of '_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserid($value)
    {
        return $this->set(self::_USERID, $value);
    }

    /**
     * Returns value of '_userid' property
     *
     * @return int
     */
    public function getUserid()
    {
        return $this->get(self::_USERID);
    }

    /**
     * Sets value of '_oppo_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoUserid($value)
    {
        return $this->set(self::_OPPO_USERID, $value);
    }

    /**
     * Returns value of '_oppo_userid' property
     *
     * @return int
     */
    public function getOppoUserid()
    {
        return $this->get(self::_OPPO_USERID);
    }

    /**
     * Sets value of '_oppo_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoType($value)
    {
        return $this->set(self::_OPPO_TYPE, $value);
    }

    /**
     * Returns value of '_oppo_type' property
     *
     * @return int
     */
    public function getOppoType()
    {
        return $this->get(self::_OPPO_TYPE);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_self_heroes' list
     *
     * @param Bcdown_Hero $value Value to append
     *
     * @return null
     */
    public function appendSelfHeroes(Bcdown_Hero $value)
    {
        return $this->append(self::_SELF_HEROES, $value);
    }

    /**
     * Clears '_self_heroes' list
     *
     * @return null
     */
    public function clearSelfHeroes()
    {
        return $this->clear(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' list
     *
     * @return Bcdown_Hero[]
     */
    public function getSelfHeroes()
    {
        return $this->get(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_HEROES));
    }

    /**
     * Returns element from '_self_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_Hero
     */
    public function getSelfHeroesAt($offset)
    {
        return $this->get(self::_SELF_HEROES, $offset);
    }

    /**
     * Returns count of '_self_heroes' list
     *
     * @return int
     */
    public function getSelfHeroesCount()
    {
        return $this->count(self::_SELF_HEROES);
    }

    /**
     * Appends value to '_oppo_heroes' list
     *
     * @param Bcdown_Hero $value Value to append
     *
     * @return null
     */
    public function appendOppoHeroes(Bcdown_Hero $value)
    {
        return $this->append(self::_OPPO_HEROES, $value);
    }

    /**
     * Clears '_oppo_heroes' list
     *
     * @return null
     */
    public function clearOppoHeroes()
    {
        return $this->clear(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' list
     *
     * @return Bcdown_Hero[]
     */
    public function getOppoHeroes()
    {
        return $this->get(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_HEROES));
    }

    /**
     * Returns element from '_oppo_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_Hero
     */
    public function getOppoHeroesAt($offset)
    {
        return $this->get(self::_OPPO_HEROES, $offset);
    }

    /**
     * Returns count of '_oppo_heroes' list
     *
     * @return int
     */
    public function getOppoHeroesCount()
    {
        return $this->count(self::_OPPO_HEROES);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Appends value to '_self_dyna_start' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendSelfDynaStart(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_SELF_DYNA_START, $value);
    }

    /**
     * Clears '_self_dyna_start' list
     *
     * @return null
     */
    public function clearSelfDynaStart()
    {
        return $this->clear(self::_SELF_DYNA_START);
    }

    /**
     * Returns '_self_dyna_start' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getSelfDynaStart()
    {
        return $this->get(self::_SELF_DYNA_START);
    }

    /**
     * Returns '_self_dyna_start' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfDynaStartIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_DYNA_START));
    }

    /**
     * Returns element from '_self_dyna_start' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getSelfDynaStartAt($offset)
    {
        return $this->get(self::_SELF_DYNA_START, $offset);
    }

    /**
     * Returns count of '_self_dyna_start' list
     *
     * @return int
     */
    public function getSelfDynaStartCount()
    {
        return $this->count(self::_SELF_DYNA_START);
    }

    /**
     * Appends value to '_self_dyna_end' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendSelfDynaEnd(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_SELF_DYNA_END, $value);
    }

    /**
     * Clears '_self_dyna_end' list
     *
     * @return null
     */
    public function clearSelfDynaEnd()
    {
        return $this->clear(self::_SELF_DYNA_END);
    }

    /**
     * Returns '_self_dyna_end' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getSelfDynaEnd()
    {
        return $this->get(self::_SELF_DYNA_END);
    }

    /**
     * Returns '_self_dyna_end' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfDynaEndIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_DYNA_END));
    }

    /**
     * Returns element from '_self_dyna_end' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getSelfDynaEndAt($offset)
    {
        return $this->get(self::_SELF_DYNA_END, $offset);
    }

    /**
     * Returns count of '_self_dyna_end' list
     *
     * @return int
     */
    public function getSelfDynaEndCount()
    {
        return $this->count(self::_SELF_DYNA_END);
    }

    /**
     * Appends value to '_oppo_dyna_start' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendOppoDynaStart(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_OPPO_DYNA_START, $value);
    }

    /**
     * Clears '_oppo_dyna_start' list
     *
     * @return null
     */
    public function clearOppoDynaStart()
    {
        return $this->clear(self::_OPPO_DYNA_START);
    }

    /**
     * Returns '_oppo_dyna_start' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getOppoDynaStart()
    {
        return $this->get(self::_OPPO_DYNA_START);
    }

    /**
     * Returns '_oppo_dyna_start' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoDynaStartIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_DYNA_START));
    }

    /**
     * Returns element from '_oppo_dyna_start' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getOppoDynaStartAt($offset)
    {
        return $this->get(self::_OPPO_DYNA_START, $offset);
    }

    /**
     * Returns count of '_oppo_dyna_start' list
     *
     * @return int
     */
    public function getOppoDynaStartCount()
    {
        return $this->count(self::_OPPO_DYNA_START);
    }

    /**
     * Appends value to '_oppo_dyna_end' list
     *
     * @param Bcdown_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendOppoDynaEnd(Bcdown_HeroDyna $value)
    {
        return $this->append(self::_OPPO_DYNA_END, $value);
    }

    /**
     * Clears '_oppo_dyna_end' list
     *
     * @return null
     */
    public function clearOppoDynaEnd()
    {
        return $this->clear(self::_OPPO_DYNA_END);
    }

    /**
     * Returns '_oppo_dyna_end' list
     *
     * @return Bcdown_HeroDyna[]
     */
    public function getOppoDynaEnd()
    {
        return $this->get(self::_OPPO_DYNA_END);
    }

    /**
     * Returns '_oppo_dyna_end' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoDynaEndIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_DYNA_END));
    }

    /**
     * Returns element from '_oppo_dyna_end' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroDyna
     */
    public function getOppoDynaEndAt($offset)
    {
        return $this->get(self::_OPPO_DYNA_END, $offset);
    }

    /**
     * Returns count of '_oppo_dyna_end' list
     *
     * @return int
     */
    public function getOppoDynaEndCount()
    {
        return $this->count(self::_OPPO_DYNA_END);
    }

    /**
     * Appends value to '_oprations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOprations($value)
    {
        return $this->append(self::_OPRATIONS, $value);
    }

    /**
     * Clears '_oprations' list
     *
     * @return null
     */
    public function clearOprations()
    {
        return $this->clear(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' list
     *
     * @return int[]
     */
    public function getOprations()
    {
        return $this->get(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' iterator
     *
     * @return ArrayIterator
     */
    public function getOprationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPRATIONS));
    }

    /**
     * Returns element from '_oprations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOprationsAt($offset)
    {
        return $this->get(self::_OPRATIONS, $offset);
    }

    /**
     * Returns count of '_oprations' list
     *
     * @return int
     */
    public function getOprationsCount()
    {
        return $this->count(self::_OPRATIONS);
    }

    /**
     * Sets value of '_cli_battle_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCliBattleTime($value)
    {
        return $this->set(self::_CLI_BATTLE_TIME, $value);
    }

    /**
     * Returns value of '_cli_battle_time' property
     *
     * @return int
     */
    public function getCliBattleTime()
    {
        return $this->get(self::_CLI_BATTLE_TIME);
    }
}

/**
 * hero_equip message
 */
class Bcdown_HeroEquip extends \ProtobufMessage
{
    /* Field index constants */
    const _INDEX = 1;
    const _ITEM_ID = 2;
    const _EXP = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_INDEX => array(
            'name' => '_index',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_ID => array(
            'name' => '_item_id',
            'required' => true,
            'type' => 5,
        ),
        self::_EXP => array(
            'name' => '_exp',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_INDEX] = null;
        $this->values[self::_ITEM_ID] = null;
        $this->values[self::_EXP] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_index' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIndex($value)
    {
        return $this->set(self::_INDEX, $value);
    }

    /**
     * Returns value of '_index' property
     *
     * @return int
     */
    public function getIndex()
    {
        return $this->get(self::_INDEX);
    }

    /**
     * Sets value of '_item_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemId($value)
    {
        return $this->set(self::_ITEM_ID, $value);
    }

    /**
     * Returns value of '_item_id' property
     *
     * @return int
     */
    public function getItemId()
    {
        return $this->get(self::_ITEM_ID);
    }

    /**
     * Sets value of '_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExp($value)
    {
        return $this->set(self::_EXP, $value);
    }

    /**
     * Returns value of '_exp' property
     *
     * @return int
     */
    public function getExp()
    {
        return $this->get(self::_EXP);
    }
}

/**
 * status enum embedded in hero message
 */
final class Bcdown_Hero_Status
{
    const idle = 0;
    const hire = 1;
    const mining = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'idle' => self::idle,
            'hire' => self::hire,
            'mining' => self::mining,
        );
    }
}

/**
 * hero message
 */
class Bcdown_Hero extends \ProtobufMessage
{
    /* Field index constants */
    const _TID = 1;
    const _RANK = 2;
    const _LEVEL = 3;
    const _STARS = 4;
    const _EXP = 5;
    const _GS = 6;
    const _STATE = 7;
    const _SKILL_LEVELS = 8;
    const _ITEMS = 9;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TID => array(
            'name' => '_tid',
            'required' => true,
            'type' => 5,
        ),
        self::_RANK => array(
            'name' => '_rank',
            'required' => false,
            'type' => 5,
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => true,
            'type' => 5,
        ),
        self::_STARS => array(
            'name' => '_stars',
            'required' => true,
            'type' => 5,
        ),
        self::_EXP => array(
            'name' => '_exp',
            'required' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => true,
            'type' => 5,
        ),
        self::_STATE => array(
            'name' => '_state',
            'required' => true,
            'type' => 5,
        ),
        self::_SKILL_LEVELS => array(
            'name' => '_skill_levels',
            'repeated' => true,
            'type' => 5,
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 'Bcdown_HeroEquip'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TID] = null;
        $this->values[self::_RANK] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_STARS] = null;
        $this->values[self::_EXP] = null;
        $this->values[self::_GS] = null;
        $this->values[self::_STATE] = null;
        $this->values[self::_SKILL_LEVELS] = array();
        $this->values[self::_ITEMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_tid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTid($value)
    {
        return $this->set(self::_TID, $value);
    }

    /**
     * Returns value of '_tid' property
     *
     * @return int
     */
    public function getTid()
    {
        return $this->get(self::_TID);
    }

    /**
     * Sets value of '_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRank($value)
    {
        return $this->set(self::_RANK, $value);
    }

    /**
     * Returns value of '_rank' property
     *
     * @return int
     */
    public function getRank()
    {
        return $this->get(self::_RANK);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_stars' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStars($value)
    {
        return $this->set(self::_STARS, $value);
    }

    /**
     * Returns value of '_stars' property
     *
     * @return int
     */
    public function getStars()
    {
        return $this->get(self::_STARS);
    }

    /**
     * Sets value of '_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExp($value)
    {
        return $this->set(self::_EXP, $value);
    }

    /**
     * Returns value of '_exp' property
     *
     * @return int
     */
    public function getExp()
    {
        return $this->get(self::_EXP);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }

    /**
     * Sets value of '_state' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setState($value)
    {
        return $this->set(self::_STATE, $value);
    }

    /**
     * Returns value of '_state' property
     *
     * @return int
     */
    public function getState()
    {
        return $this->get(self::_STATE);
    }

    /**
     * Appends value to '_skill_levels' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendSkillLevels($value)
    {
        return $this->append(self::_SKILL_LEVELS, $value);
    }

    /**
     * Clears '_skill_levels' list
     *
     * @return null
     */
    public function clearSkillLevels()
    {
        return $this->clear(self::_SKILL_LEVELS);
    }

    /**
     * Returns '_skill_levels' list
     *
     * @return int[]
     */
    public function getSkillLevels()
    {
        return $this->get(self::_SKILL_LEVELS);
    }

    /**
     * Returns '_skill_levels' iterator
     *
     * @return ArrayIterator
     */
    public function getSkillLevelsIterator()
    {
        return new \ArrayIterator($this->get(self::_SKILL_LEVELS));
    }

    /**
     * Returns element from '_skill_levels' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getSkillLevelsAt($offset)
    {
        return $this->get(self::_SKILL_LEVELS, $offset);
    }

    /**
     * Returns count of '_skill_levels' list
     *
     * @return int
     */
    public function getSkillLevelsCount()
    {
        return $this->count(self::_SKILL_LEVELS);
    }

    /**
     * Appends value to '_items' list
     *
     * @param Bcdown_HeroEquip $value Value to append
     *
     * @return null
     */
    public function appendItems(Bcdown_HeroEquip $value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return Bcdown_HeroEquip[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcdown_HeroEquip
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }
}

/**
 * hero_dyna message
 */
class Bcdown_HeroDyna extends \ProtobufMessage
{
    /* Field index constants */
    const _HP_PERC = 1;
    const _MP_PERC = 2;
    const _CUSTOM_DATA = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HP_PERC => array(
            'name' => '_hp_perc',
            'required' => true,
            'type' => 5,
        ),
        self::_MP_PERC => array(
            'name' => '_mp_perc',
            'required' => true,
            'type' => 5,
        ),
        self::_CUSTOM_DATA => array(
            'name' => '_custom_data',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HP_PERC] = null;
        $this->values[self::_MP_PERC] = null;
        $this->values[self::_CUSTOM_DATA] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_hp_perc' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHpPerc($value)
    {
        return $this->set(self::_HP_PERC, $value);
    }

    /**
     * Returns value of '_hp_perc' property
     *
     * @return int
     */
    public function getHpPerc()
    {
        return $this->get(self::_HP_PERC);
    }

    /**
     * Sets value of '_mp_perc' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMpPerc($value)
    {
        return $this->set(self::_MP_PERC, $value);
    }

    /**
     * Returns value of '_mp_perc' property
     *
     * @return int
     */
    public function getMpPerc()
    {
        return $this->get(self::_MP_PERC);
    }

    /**
     * Sets value of '_custom_data' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCustomData($value)
    {
        return $this->set(self::_CUSTOM_DATA, $value);
    }

    /**
     * Returns value of '_custom_data' property
     *
     * @return int
     */
    public function getCustomData()
    {
        return $this->get(self::_CUSTOM_DATA);
    }
}
