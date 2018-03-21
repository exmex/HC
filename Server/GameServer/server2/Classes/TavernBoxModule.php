<?php
/**
 * User: Ray ray@raymix.net
 * Date: 14-6-12
 * Time: 上午11:31
 */

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerTbc.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemGroupsModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

class TavernBoxModule
{
	private static $myBasePower = 0;
	private static $myPower = 0;

	/**
	 * 开启箱子，返回箱子中的道具列表
	 *
	 * @param $boxId 箱子ID int
	 * @param $param 附加参数 int
	 * <p>远征箱子，为1时为第一次通关奖励 </p>
	 * @return 返回结果集Array
	 * @author Ray ray@raymix.net
	 *
	 */
	public static function openChestBox($boxId,$param = 0)
	{
		//TODO:读取远征规则表，生成Stages
		$boxs = DataModule::getInstance()->lookupDataTable(TAVERN_BOX_TYPE_LUA_KEY,$boxId, array());
		if(!isset($boxs[$param]))
		{
			$param = 0;
		}
		$box = $boxs[$param];
		if(isset($box))
		{
			$items = ItemGroupsModule::getRandomItem(intval($box["Chest Group ID"]));
		}
		return $items;
	}

}
 