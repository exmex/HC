<?php
/**
 * Auto generated from bcup.proto at 2014-09-10 01:47:47
 *
 * bcup package
 */

/**
 * battlecheck_reply message
 */
class Bcup_BattlecheckReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'repeated' => true,
            'type' => 'Bcup_CheckResult'
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
        $this->values[self::_RESULT] = array();
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
     * Appends value to '_result' list
     *
     * @param Bcup_CheckResult $value Value to append
     *
     * @return null
     */
    public function appendResult(Bcup_CheckResult $value)
    {
        return $this->append(self::_RESULT, $value);
    }

    /**
     * Clears '_result' list
     *
     * @return null
     */
    public function clearResult()
    {
        return $this->clear(self::_RESULT);
    }

    /**
     * Returns '_result' list
     *
     * @return Bcup_CheckResult[]
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Returns '_result' iterator
     *
     * @return ArrayIterator
     */
    public function getResultIterator()
    {
        return new \ArrayIterator($this->get(self::_RESULT));
    }

    /**
     * Returns element from '_result' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Bcup_CheckResult
     */
    public function getResultAt($offset)
    {
        return $this->get(self::_RESULT, $offset);
    }

    /**
     * Returns count of '_result' list
     *
     * @return int
     */
    public function getResultCount()
    {
        return $this->count(self::_RESULT);
    }
}

/**
 * result enum embedded in check_result message
 */
final class Bcup_CheckResult_Result
{
    const honest = 1;
    const cheat = 2;
    const victory = 3;
    const defeat = 4;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'honest' => self::honest,
            'cheat' => self::cheat,
            'victory' => self::victory,
            'defeat' => self::defeat,
        );
    }
}

/**
 * check_result message
 */
class Bcup_CheckResult extends \ProtobufMessage
{
    /* Field index constants */
    const _CHECKID = 1;
    const _USERID = 2;
    const _RESULT = 3;
    const _IS_PLUGIN = 4;

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
        self::_RESULT => array(
            'default' => Bcup_CheckResult_Result::honest, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_IS_PLUGIN => array(
            'name' => '_is_plugin',
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
        $this->values[self::_CHECKID] = null;
        $this->values[self::_USERID] = null;
        $this->values[self::_RESULT] = null;
        $this->values[self::_IS_PLUGIN] = null;
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
     * Sets value of '_is_plugin' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsPlugin($value)
    {
        return $this->set(self::_IS_PLUGIN, $value);
    }

    /**
     * Returns value of '_is_plugin' property
     *
     * @return int
     */
    public function getIsPlugin()
    {
        return $this->get(self::_IS_PLUGIN);
    }
}
