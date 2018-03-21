<?php
require_once("config.php");
require_once($GLOBALS ['GAME_ROOT'] . 'WorldSvc.php');
require_once($GLOBALS ['GAME_ROOT'] . "Log/Logger.php");

class CMemcache
{
    private static $instance;

    private static $_cache = null;
    private static $useMemcached = true;
	public static $memcache_write_time=0;
	public static $memcache_read_time =0;
    static function &getInstance()
    {
        if (!isset (self::$instance)) {
            self::$instance = new CMemcache ();
        }

        return self::$instance;
    }

    function CMemcache()
    {
    }

    private static function getServers()
    {
        eval (MEMCACHE_INFO);
        $serverArr = array();
        $serverCount = count($MEMCACHE_INFO);
        for ($idx = 0; $idx < $serverCount; $idx++) {
            $host = $MEMCACHE_INFO [$idx] ["HOST"];
            $port = $MEMCACHE_INFO [$idx] ["PORT"];
            $serverArr[] = array($host, $port, 0);
        }
        return $serverArr;
    }

    private static function getMemCache()
    {
        if (self::$_cache !== null) {
            return self::$_cache;
        } else {
            $serverArr = self::getServers();
            if (count($serverArr) <= 0) {
                return null;
            }

            if (!class_exists("Memcached")) {
                self::$useMemcached = false;
                Logger::getLogger()->error("don't have Memcached support");
            }

            if (self::$useMemcached) {
                self::$_cache = new Memcached('heroPersistent');
                self::$_cache->setOption(Memcached::OPT_NO_BLOCK, true);
                self::$_cache->setOption(Memcached::OPT_TCP_NODELAY, true);
                self::$_cache->setOption(Memcached::OPT_CONNECT_TIMEOUT, 500);
                self::$_cache->setOption(Memcached::OPT_RETRY_TIMEOUT, 300);
                self::$_cache->setOption(Memcached::OPT_BINARY_PROTOCOL, true);
                self::$_cache->setOption(Memcached::OPT_LIBKETAMA_COMPATIBLE, true);
          
                $curServersNum = count(self::$_cache->getServerList());
                //Logger::getLogger()->debug("cur Server Num = " . $curServersNum);
                if ($curServersNum <= 0) {
                    self::$_cache->addServers($serverArr);
                    //$curServersNum = count(self::$_cache->getServerList());
                    //Logger::getLogger()->debug("new Server Num = " . $curServersNum);
                }
            } else {
                self::$_cache = new Memcache;
                foreach ($serverArr as $server) {
                    self::$_cache->addServer($server[0], $server[1]);
                }
            }

            return self::$_cache;
        }
    }

    private static function getMemcacheKey($key)
    {
        $domain_name = WorldSvc::getInstance()->domain_name;
        return $domain_name . "_" . $key;
    }

    private static function connect($key = null)
    {
        if (WorldSvc::getInstance()->isLocal()) {
            return null;
        }

        return self::getMemCache();
    }

    private static function close($mem)
    {
        // $mem->close();
    }

    public static function closeReally()
    {
        self::close(self::$_cache);
        self::$_cache = null;
    }

    /**
     * @return boolean
     */
    public function getVersion()
    {
        $ret = false;
        $mem = self::connect();
        if ($mem) {
            $ret = $mem->getVersion();
            $this->close($mem);
        }
        return $ret;
    }

    /**
     * 根据key获取数据
     *
     * @param  $key
     * @return boolean
     */
    public function getData($key)
    {
        if (WorldSvc::getInstance()->isLocal()) {
            return false;
        }

        $ret = false;
        $mem = self::connect($key);
        if ($mem) {
            $ret = self::getDataByConnection($mem, $key);
            $this->close($mem);
        }
        return $ret;
    }

    /**
     * 根据key获取数据
     *
     * @param  $key
     * @return boolean
     */
    public function getDataArr($keyArr)
    {
        if (WorldSvc::getInstance()->isLocal()) {
            return false;
        }

        $ret = false;
        $mem = self::connect();
        if ($mem) {
            $ret = self::getMutilByConnection($mem, $keyArr);
            $this->close($mem);
        }
        return $ret;
    }

    /**
     * 提供一个key,保存数据
     *
     * @param $key    长度不能超过250个字节
     * @param $data   不能超过1M
     * @param $expire 过期时间
     * @return boolean
     */
    public function setData($key, $data, $expire = 0)
    {
        $ret = false;
        $mem = self::connect($key);
        if ($mem) {
            $ret = self::setDataByConnection($mem, $key, $data, $expire);
            $this->close($mem);
        }
        return $ret;
    }
    
    
    public function setDataMulti($data,$expire = 0)
    {
    	$ret = false;
    	$mem = self::connect(null);
    	if ($mem) {
    		$ret = self::setDataMultiByConnection($mem, $data, $expire);
    		$this->close($mem);
    	}
    	return $ret;
    }

    /**
     * 提供一个key,保存数据
     *
     * @param  $key 长度不能超过250个字节
     * @param  $data 不能超过1M
     * @return boolean
     */
    public function replaceData($key, $data, $expire = 10)
    {
        $ret = false;
        $mem = self::connect($key);
        if ($mem) {
            $ret = self::replaceDataByConnection($mem, $key, $data, false, $expire);
            $this->close($mem);
        }
        return $ret;
    }

    /**
     * 根据一个key,删除数据
     *
     * @param  $key
     */
    public function deleteData($key)
    {
        $mem = self::connect($key);
        if ($mem) {
            self::deleteDataByConnection($mem, $key);
            $this->close($mem);
        }
    }

    public function increment($key, $value)
    {
        $ret = false;
        $mem = self::connect($key);
        if ($mem) {
            $memKey = self::getMemcacheKey($key);
            $ret = $mem->increment($memKey, $value);
            $this->close($mem);
        }
        return $ret;
    }

    public function decrement($key, $value)
    {
        $ret = false;
        $mem = self::connect($key);
        if ($mem) {
            $memKey = self::getMemcacheKey($key);
            $ret = $mem->decrement($memKey, $value);
            $this->close($mem);
        }
        return $ret;
    }

    /**
     * 提供一个key,保存数据
     *
     * @param  $mem memcache连接
     * @param  $key 长度不能超过250个字节
     * @param  $obj 不能超过1
     * @param  $expire 过期时间
     * @return boolean
     */
    public static function setDataByConnection($mem, $key, $obj, $expire = 0)
    {
        if ($mem) {
            $memKey = self::getMemcacheKey($key);
            
            $start_time = microtime(TRUE);
            $ret = self::$useMemcached ? $mem->set($memKey, $obj, $expire) : $mem->set($memKey, $obj, false, $expire);
            self::$memcache_write_time += microtime(TRUE) - $start_time;
            
            if ($ret === false) {
                Logger::getLogger()->error("CMemcache::setDataByConnection - Failed to save data({$memKey}) at the memcache server : "
                    . strval(self::$useMemcached)
                    . " ERRORCODE = " . $mem->getResultCode());
                return false;
            }
            return true;
        }
        Logger::getLogger()->error("CMemcache::setDataByConnection - connection is Invalid.");
        return false;
    }
    
    
    public static function setDataMultiByConnection($mem, $data, $expire = 0)
    {
    	if(self::$useMemcached )
    	{
	    	if ($mem) {
	    		$memdata = array();
	    		foreach($data as $k=>$v)
	    		{
	    			$memdata[self::getMemcacheKey($k)] = $v;
	    		}
	    		$start_time = microtime(TRUE);
	    		$ret =  $mem->setMulti($memdata, $expire);
	    		self::$memcache_write_time += microtime(TRUE) - $start_time;
	    		
	    		if($ret === false) {
	    			Logger::getLogger()->error("CMemcache::setDataMultiByConnection - Failed to save data({$memKey}) at the memcache server : "
	    			. strval(self::$useMemcached)
	    			. " ERRORCODE = " . $mem->getResultCode());
	    			return false;
	    		}
	    		return true;
	    	}
    	}
    	
    	
    	
    	Logger::getLogger()->error("CMemcache::setDataMultiByConnection - connection is Invalid.");
    	return false;
    }
    

    /**
     * 根据key获取数据
     *
     * @param  $mem memcache连接
     * @param  $key 长度不能超过250个字节
     * @return boolean
     */
    public static function getDataByConnection($mem, $key)
    {
        if ($mem) {
            $memKey = self::getMemcacheKey($key);
            $start_time = microtime(TRUE);
            $ret = $mem->get($memKey);
            self::$memcache_read_time += microtime(TRUE) - $start_time;
            
            if ($ret === false) {
                return false;
            }
            return $ret;
        }
        Logger::getLogger()->error("CMemcache::getDataByConnection - connection is Invalid.");
        return false;
    }

    /**
     * 根据key获取数据
     *
     * @param  $mem memcached连接
     * @param  $key 长度不能超过250个字节
     * @return boolean
     */
    public static function getMutilByConnection($mem, $keyArr)
    {
        if (self::$useMemcached && $mem) {
        	
            $uniqueIDs = array();
            $results = array();
            foreach ($keyArr as $id) {
                $uniqueIDs[$id] = self::getMemcacheKey($id);
                $results[$id] = false;
            }
            $cache = self::getMemCache();
            
            $start_time = microtime(TRUE);
            $values = $cache->getMulti(array_values($uniqueIDs));
            self::$memcache_read_time += microtime(TRUE) - $start_time;
            
            foreach ($uniqueIDs as $id => $uniqueID) {
                if (!isset($values[$uniqueID])) {
                    continue;
                }
                $results[$id] = $values[$uniqueID];
            }
          
            return $results;
        }
        Logger::getLogger()->error("CMemcache::getMutilByConnection - connection is Invalid.");
        return false;
    }

    /**
     * 提供一个key,保存数据
     *
     * @param  $mem memcache连接
     * @param  $key 长度不能超过250个字节
     * @param  $data 不能超过1M
     * @return boolean
     */
    public function replaceDataByConnection($mem, $key, $data, $expire = 0)
    {
        if ($mem) {
            $memKey = self::getMemcacheKey($key);
            $start_time = microtime(TRUE);
            $ret = self::$useMemcached ? $mem->replace($memKey, $data, $expire) : $mem->replace($memKey, $data, false, $expire);
            self::$memcache_write_time += microtime(TRUE) - $start_time;
            
            if ($ret === false) {
                Logger::getLogger()->error("CMemcache::replaceDataByConnection - Failed to replace data({$key}) at the memcache server");
                return false;
            }
            return true;
        }
        Logger::getLogger()->error("CMemcache::replaceDataByConnection - connection is Invalid.");
        return false;
    }

    /**
     * 根据一个key,删除数据
     *
     * @param  $key
     */
    public static function deleteDataByConnection($mem, $key)
    {
        if ($mem) {
            $memKey = self::getMemcacheKey($key);
            $start_time = microtime(TRUE);
            $mem->delete($memKey);
            self::$memcache_write_time += microtime(TRUE) - $start_time;
        } else {
            Logger::getLogger()->error("CMemcache::deleteDataByConnection - connection is Invalid.");
        }
    }
}
