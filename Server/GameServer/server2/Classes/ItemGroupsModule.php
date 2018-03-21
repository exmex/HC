<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");

class ItemGroupsModule
{
	/*
	 * 随机获取指定道具组中的道具
	 *
	 */
	public static function getRandomItem($groupId)
	{
		$DataModule = DataModule::getInstance();
		$items = $DataModule->lookupDataTable(ITEM_GROUPS_LUA_KEY, $groupId, array());
		$item = $items[array_rand($items)];
		return $item;
	}
}