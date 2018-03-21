<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerMail {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $sid;
	private /*string*/ $user_id;
	private /*int*/ $type;
	private /*string*/ $title;
	private /*string*/ $from;
	private /*string*/ $content;
	private /*int*/ $mail_cfg_id;
	private /*string*/ $mail_params;
	private /*int*/ $mail_time;
	private /*int*/ $expire_time;
	private /*int*/ $money;
	private /*int*/ $diamonds;
	private /*string*/ $items;
	private /*string*/ $points;
	private /*int*/ $status;
	private /*int*/ $template;
	private /*int*/ $server_id;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $sid_status_field = false;
	private $user_id_status_field = false;
	private $type_status_field = false;
	private $title_status_field = false;
	private $from_status_field = false;
	private $content_status_field = false;
	private $mail_cfg_id_status_field = false;
	private $mail_params_status_field = false;
	private $mail_time_status_field = false;
	private $expire_time_status_field = false;
	private $money_status_field = false;
	private $diamonds_status_field = false;
	private $items_status_field = false;
	private $points_status_field = false;
	private $status_status_field = false;
	private $template_status_field = false;
	private $server_id_status_field = false;


	public static function  loadedTable( $fields=NULL,$condition=NULL)
	{
		$result = array();
		
		$p = "*";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
		if (empty($condition))
		{
			$sql = "SELECT {$p} FROM `player_mail`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_mail` WHERE ".SQLUtil::parseCondition($condition);
		}			
		
		$qr = MySQL::getInstance()->RunQuery($sql);
		if(empty($qr)){
			return $result;
		}
		$ar = MySQL::getInstance()->FetchAllRows($qr);
		
		if (empty($ar) || count($ar) == 0)
		{
			return $result;
		}
		
		foreach($ar as $row)
		{
			$tb = new SysPlayerMail();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['sid'])) $tb->sid = $row['sid'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['type'])) $tb->type = intval($row['type']);
			if (isset($row['title'])) $tb->title = $row['title'];
			if (isset($row['from'])) $tb->from = $row['from'];
			if (isset($row['content'])) $tb->content = $row['content'];
			if (isset($row['mail_cfg_id'])) $tb->mail_cfg_id = intval($row['mail_cfg_id']);
			if (isset($row['mail_params'])) $tb->mail_params = $row['mail_params'];
			if (isset($row['mail_time'])) $tb->mail_time = intval($row['mail_time']);
			if (isset($row['expire_time'])) $tb->expire_time = intval($row['expire_time']);
			if (isset($row['money'])) $tb->money = intval($row['money']);
			if (isset($row['diamonds'])) $tb->diamonds = intval($row['diamonds']);
			if (isset($row['items'])) $tb->items = $row['items'];
			if (isset($row['points'])) $tb->points = $row['points'];
			if (isset($row['status'])) $tb->status = intval($row['status']);
			if (isset($row['template'])) $tb->template = intval($row['template']);
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_mail` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_mail` (`id`,`sid`,`user_id`,`type`,`title`,`from`,`content`,`mail_cfg_id`,`mail_params`,`mail_time`,`expire_time`,`money`,`diamonds`,`items`,`points`,`status`,`template`,`server_id`) VALUES ";
			$result[1] = array('id'=>1,'sid'=>1,'user_id'=>1,'type'=>1,'title'=>1,'from'=>1,'content'=>1,'mail_cfg_id'=>1,'mail_params'=>1,'mail_time'=>1,'expire_time'=>1,'money'=>1,'diamonds'=>1,'items'=>1,'points'=>1,'status'=>1,'template'=>1,'server_id'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`id` = '{$this->id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `player_mail` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['sid'])) $this->sid = $ar['sid'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['type'])) $this->type = intval($ar['type']);
		if (isset($ar['title'])) $this->title = $ar['title'];
		if (isset($ar['from'])) $this->from = $ar['from'];
		if (isset($ar['content'])) $this->content = $ar['content'];
		if (isset($ar['mail_cfg_id'])) $this->mail_cfg_id = intval($ar['mail_cfg_id']);
		if (isset($ar['mail_params'])) $this->mail_params = $ar['mail_params'];
		if (isset($ar['mail_time'])) $this->mail_time = intval($ar['mail_time']);
		if (isset($ar['expire_time'])) $this->expire_time = intval($ar['expire_time']);
		if (isset($ar['money'])) $this->money = intval($ar['money']);
		if (isset($ar['diamonds'])) $this->diamonds = intval($ar['diamonds']);
		if (isset($ar['items'])) $this->items = $ar['items'];
		if (isset($ar['points'])) $this->points = $ar['points'];
		if (isset($ar['status'])) $this->status = intval($ar['status']);
		if (isset($ar['template'])) $this->template = intval($ar['template']);
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`id` = '{$this->id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `player_mail` WHERE {$where}";
	
				if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
	
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		return $ar;
	}
	
	
	
	public function loadedExistFields()
	{
		$emptyCondition = true;
    	$emptyFields = true;
    	$fields = array();
    	$condition = array();
    	
    	if (!isset($this->id)){
    		$emptyFields = false;
    		$fields[] = 'id';
    	}else{
    		$emptyCondition = false; 
    		$condition['id']=$this->id;
    	}
    	if (!isset($this->sid)){
    		$emptyFields = false;
    		$fields[] = 'sid';
    	}else{
    		$emptyCondition = false; 
    		$condition['sid']=$this->sid;
    	}
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->type)){
    		$emptyFields = false;
    		$fields[] = 'type';
    	}else{
    		$emptyCondition = false; 
    		$condition['type']=$this->type;
    	}
    	if (!isset($this->title)){
    		$emptyFields = false;
    		$fields[] = 'title';
    	}else{
    		$emptyCondition = false; 
    		$condition['title']=$this->title;
    	}
    	if (!isset($this->from)){
    		$emptyFields = false;
    		$fields[] = 'from';
    	}else{
    		$emptyCondition = false; 
    		$condition['from']=$this->from;
    	}
    	if (!isset($this->content)){
    		$emptyFields = false;
    		$fields[] = 'content';
    	}else{
    		$emptyCondition = false; 
    		$condition['content']=$this->content;
    	}
    	if (!isset($this->mail_cfg_id)){
    		$emptyFields = false;
    		$fields[] = 'mail_cfg_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['mail_cfg_id']=$this->mail_cfg_id;
    	}
    	if (!isset($this->mail_params)){
    		$emptyFields = false;
    		$fields[] = 'mail_params';
    	}else{
    		$emptyCondition = false; 
    		$condition['mail_params']=$this->mail_params;
    	}
    	if (!isset($this->mail_time)){
    		$emptyFields = false;
    		$fields[] = 'mail_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['mail_time']=$this->mail_time;
    	}
    	if (!isset($this->expire_time)){
    		$emptyFields = false;
    		$fields[] = 'expire_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['expire_time']=$this->expire_time;
    	}
    	if (!isset($this->money)){
    		$emptyFields = false;
    		$fields[] = 'money';
    	}else{
    		$emptyCondition = false; 
    		$condition['money']=$this->money;
    	}
    	if (!isset($this->diamonds)){
    		$emptyFields = false;
    		$fields[] = 'diamonds';
    	}else{
    		$emptyCondition = false; 
    		$condition['diamonds']=$this->diamonds;
    	}
    	if (!isset($this->items)){
    		$emptyFields = false;
    		$fields[] = 'items';
    	}else{
    		$emptyCondition = false; 
    		$condition['items']=$this->items;
    	}
    	if (!isset($this->points)){
    		$emptyFields = false;
    		$fields[] = 'points';
    	}else{
    		$emptyCondition = false; 
    		$condition['points']=$this->points;
    	}
    	if (!isset($this->status)){
    		$emptyFields = false;
    		$fields[] = 'status';
    	}else{
    		$emptyCondition = false; 
    		$condition['status']=$this->status;
    	}
    	if (!isset($this->template)){
    		$emptyFields = false;
    		$fields[] = 'template';
    	}else{
    		$emptyCondition = false; 
    		$condition['template']=$this->template;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}

    	
		if ($emptyFields)
    	{
    		unset($fields);
    	}
    	
    	if ($emptyCondition)
    	{
    		unset($condition); 
    	}
    	
    	return $this->loaded($fields,$condition);    	
	}
	
	public function  inOrUp()
	{
		$sql = $this->getInSQL();
		if (empty($sql))
		{
			return false;
		}		
		$sql .= " ON DUPLICATE KEY UPDATE ";		
		$sql .= $this->getUpFields();		
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		if (!$qr)
		{
			return false;
		}
				
		if (empty($this->id))
		{
			$this->id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`id`='{$this->id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		$sql = $this->getUpSQL($uc);
		
		if(empty($sql)){
			return true;
		}
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}

		$qr = MySQL::getInstance()->RunQuery($sql);
		
		$this->clean();
				
		return (boolean)$qr;
	}
	
	public static function sql_delete($condition=NULL)
	{
		if (empty($condition))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_mail` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_mail` WHERE `id`='{$this->id}'";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'id'){
 				$values .= "'{$this->id}',";
 			}else if($f == 'sid'){
 				$values .= "'{$this->sid}',";
 			}else if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'type'){
 				$values .= "'{$this->type}',";
 			}else if($f == 'title'){
 				$values .= "'{$this->title}',";
 			}else if($f == 'from'){
 				$values .= "'{$this->from}',";
 			}else if($f == 'content'){
 				$values .= "'{$this->content}',";
 			}else if($f == 'mail_cfg_id'){
 				$values .= "'{$this->mail_cfg_id}',";
 			}else if($f == 'mail_params'){
 				$values .= "'{$this->mail_params}',";
 			}else if($f == 'mail_time'){
 				$values .= "'{$this->mail_time}',";
 			}else if($f == 'expire_time'){
 				$values .= "'{$this->expire_time}',";
 			}else if($f == 'money'){
 				$values .= "'{$this->money}',";
 			}else if($f == 'diamonds'){
 				$values .= "'{$this->diamonds}',";
 			}else if($f == 'items'){
 				$values .= "'{$this->items}',";
 			}else if($f == 'points'){
 				$values .= "'{$this->points}',";
 			}else if($f == 'status'){
 				$values .= "'{$this->status}',";
 			}else if($f == 'template'){
 				$values .= "'{$this->template}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}		
		}
		$values .= ")";
		
		return str_replace(",)",")",$values);		
	}
	
	private function  getInSQL()
	{
		if (!$this->this_table_status_field)
		{
			return;
		}		
		
		$fields = "(";
		$values = " VALUES(";

		if (isset($this->id))
		{
			$fields .= "`id`,";
			$values .= "'{$this->id}',";
		}
		if (isset($this->sid))
		{
			$fields .= "`sid`,";
			$values .= "'{$this->sid}',";
		}
		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->type))
		{
			$fields .= "`type`,";
			$values .= "'{$this->type}',";
		}
		if (isset($this->title))
		{
			$fields .= "`title`,";
			$values .= "'{$this->title}',";
		}
		if (isset($this->from))
		{
			$fields .= "`from`,";
			$values .= "'{$this->from}',";
		}
		if (isset($this->content))
		{
			$fields .= "`content`,";
			$values .= "'{$this->content}',";
		}
		if (isset($this->mail_cfg_id))
		{
			$fields .= "`mail_cfg_id`,";
			$values .= "'{$this->mail_cfg_id}',";
		}
		if (isset($this->mail_params))
		{
			$fields .= "`mail_params`,";
			$values .= "'{$this->mail_params}',";
		}
		if (isset($this->mail_time))
		{
			$fields .= "`mail_time`,";
			$values .= "'{$this->mail_time}',";
		}
		if (isset($this->expire_time))
		{
			$fields .= "`expire_time`,";
			$values .= "'{$this->expire_time}',";
		}
		if (isset($this->money))
		{
			$fields .= "`money`,";
			$values .= "'{$this->money}',";
		}
		if (isset($this->diamonds))
		{
			$fields .= "`diamonds`,";
			$values .= "'{$this->diamonds}',";
		}
		if (isset($this->items))
		{
			$fields .= "`items`,";
			$values .= "'{$this->items}',";
		}
		if (isset($this->points))
		{
			$fields .= "`points`,";
			$values .= "'{$this->points}',";
		}
		if (isset($this->status))
		{
			$fields .= "`status`,";
			$values .= "'{$this->status}',";
		}
		if (isset($this->template))
		{
			$fields .= "`template`,";
			$values .= "'{$this->template}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_mail` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->sid_status_field)
		{			
			if (!isset($this->sid))
			{
				$update .= ("`sid`=null,");
			}
			else
			{
				$update .= ("`sid`='{$this->sid}',");
			}
		}
		if ($this->user_id_status_field)
		{			
			if (!isset($this->user_id))
			{
				$update .= ("`user_id`=null,");
			}
			else
			{
				$update .= ("`user_id`='{$this->user_id}',");
			}
		}
		if ($this->type_status_field)
		{			
			if (!isset($this->type))
			{
				$update .= ("`type`=null,");
			}
			else
			{
				$update .= ("`type`='{$this->type}',");
			}
		}
		if ($this->title_status_field)
		{			
			if (!isset($this->title))
			{
				$update .= ("`title`=null,");
			}
			else
			{
				$update .= ("`title`='{$this->title}',");
			}
		}
		if ($this->from_status_field)
		{			
			if (!isset($this->from))
			{
				$update .= ("`from`=null,");
			}
			else
			{
				$update .= ("`from`='{$this->from}',");
			}
		}
		if ($this->content_status_field)
		{			
			if (!isset($this->content))
			{
				$update .= ("`content`=null,");
			}
			else
			{
				$update .= ("`content`='{$this->content}',");
			}
		}
		if ($this->mail_cfg_id_status_field)
		{			
			if (!isset($this->mail_cfg_id))
			{
				$update .= ("`mail_cfg_id`=null,");
			}
			else
			{
				$update .= ("`mail_cfg_id`='{$this->mail_cfg_id}',");
			}
		}
		if ($this->mail_params_status_field)
		{			
			if (!isset($this->mail_params))
			{
				$update .= ("`mail_params`=null,");
			}
			else
			{
				$update .= ("`mail_params`='{$this->mail_params}',");
			}
		}
		if ($this->mail_time_status_field)
		{			
			if (!isset($this->mail_time))
			{
				$update .= ("`mail_time`=null,");
			}
			else
			{
				$update .= ("`mail_time`='{$this->mail_time}',");
			}
		}
		if ($this->expire_time_status_field)
		{			
			if (!isset($this->expire_time))
			{
				$update .= ("`expire_time`=null,");
			}
			else
			{
				$update .= ("`expire_time`='{$this->expire_time}',");
			}
		}
		if ($this->money_status_field)
		{			
			if (!isset($this->money))
			{
				$update .= ("`money`=null,");
			}
			else
			{
				$update .= ("`money`='{$this->money}',");
			}
		}
		if ($this->diamonds_status_field)
		{			
			if (!isset($this->diamonds))
			{
				$update .= ("`diamonds`=null,");
			}
			else
			{
				$update .= ("`diamonds`='{$this->diamonds}',");
			}
		}
		if ($this->items_status_field)
		{			
			if (!isset($this->items))
			{
				$update .= ("`items`=null,");
			}
			else
			{
				$update .= ("`items`='{$this->items}',");
			}
		}
		if ($this->points_status_field)
		{			
			if (!isset($this->points))
			{
				$update .= ("`points`=null,");
			}
			else
			{
				$update .= ("`points`='{$this->points}',");
			}
		}
		if ($this->status_status_field)
		{			
			if (!isset($this->status))
			{
				$update .= ("`status`=null,");
			}
			else
			{
				$update .= ("`status`='{$this->status}',");
			}
		}
		if ($this->template_status_field)
		{			
			if (!isset($this->template))
			{
				$update .= ("`template`=null,");
			}
			else
			{
				$update .= ("`template`='{$this->template}',");
			}
		}
		if ($this->server_id_status_field)
		{			
			if (!isset($this->server_id))
			{
				$update .= ("`server_id`=null,");
			}
			else
			{
				$update .= ("`server_id`='{$this->server_id}',");
			}
		}

			
		if (empty($update) || strlen($update) < 1)
		{
			return;
		}
		
		$i = strrpos($update,",");
		if (!is_bool($i))
		{
			$update = substr($update,0,$i);
		}		
		
		return $update;
	}
	
	private function  getUpSQL($condition)
	{
		if (!$this->this_table_status_field)
		{
			return null;
		}
		
		$update = $this->getUpFields();
		
		if (empty($update))
		{
			return;
		}
		
		$sql = "UPDATE `player_mail` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`id`='{$this->id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `player_mail` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`id`='{$this->id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `player_mail` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->sid_status_field = false;
		$this->user_id_status_field = false;
		$this->type_status_field = false;
		$this->title_status_field = false;
		$this->from_status_field = false;
		$this->content_status_field = false;
		$this->mail_cfg_id_status_field = false;
		$this->mail_params_status_field = false;
		$this->mail_time_status_field = false;
		$this->expire_time_status_field = false;
		$this->money_status_field = false;
		$this->diamonds_status_field = false;
		$this->items_status_field = false;
		$this->points_status_field = false;
		$this->status_status_field = false;
		$this->template_status_field = false;
		$this->server_id_status_field = false;

	}
	
	public function /*string*/ getId()
	{
		return $this->id;
	}
	
	public function /*void*/ setId(/*string*/ $id)
	{
		$this->id = SQLUtil::toSafeSQLString($id);
		$this->id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIdNull()
	{
		$this->id = null;
		$this->id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSid()
	{
		return $this->sid;
	}
	
	public function /*void*/ setSid(/*string*/ $sid)
	{
		$this->sid = SQLUtil::toSafeSQLString($sid);
		$this->sid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSidNull()
	{
		$this->sid = null;
		$this->sid_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getUserId()
	{
		return $this->user_id;
	}
	
	public function /*void*/ setUserId(/*string*/ $user_id)
	{
		$this->user_id = SQLUtil::toSafeSQLString($user_id);
		$this->user_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserIdNull()
	{
		$this->user_id = null;
		$this->user_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getType()
	{
		return $this->type;
	}
	
	public function /*void*/ setType(/*int*/ $type)
	{
		$this->type = intval($type);
		$this->type_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTypeNull()
	{
		$this->type = null;
		$this->type_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getTitle()
	{
		return $this->title;
	}
	
	public function /*void*/ setTitle(/*string*/ $title)
	{
		$this->title = SQLUtil::toSafeSQLString($title);
		$this->title_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTitleNull()
	{
		$this->title = null;
		$this->title_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getFrom()
	{
		return $this->from;
	}
	
	public function /*void*/ setFrom(/*string*/ $from)
	{
		$this->from = SQLUtil::toSafeSQLString($from);
		$this->from_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFromNull()
	{
		$this->from = null;
		$this->from_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getContent()
	{
		return $this->content;
	}
	
	public function /*void*/ setContent(/*string*/ $content)
	{
		$this->content = SQLUtil::toSafeSQLString($content);
		$this->content_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setContentNull()
	{
		$this->content = null;
		$this->content_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getMailCfgId()
	{
		return $this->mail_cfg_id;
	}
	
	public function /*void*/ setMailCfgId(/*int*/ $mail_cfg_id)
	{
		$this->mail_cfg_id = intval($mail_cfg_id);
		$this->mail_cfg_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMailCfgIdNull()
	{
		$this->mail_cfg_id = null;
		$this->mail_cfg_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getMailParams()
	{
		return $this->mail_params;
	}
	
	public function /*void*/ setMailParams(/*string*/ $mail_params)
	{
		$this->mail_params = SQLUtil::toSafeSQLString($mail_params);
		$this->mail_params_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMailParamsNull()
	{
		$this->mail_params = null;
		$this->mail_params_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getMailTime()
	{
		return $this->mail_time;
	}
	
	public function /*void*/ setMailTime(/*int*/ $mail_time)
	{
		$this->mail_time = intval($mail_time);
		$this->mail_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMailTimeNull()
	{
		$this->mail_time = null;
		$this->mail_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getExpireTime()
	{
		return $this->expire_time;
	}
	
	public function /*void*/ setExpireTime(/*int*/ $expire_time)
	{
		$this->expire_time = intval($expire_time);
		$this->expire_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExpireTimeNull()
	{
		$this->expire_time = null;
		$this->expire_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getMoney()
	{
		return $this->money;
	}
	
	public function /*void*/ setMoney(/*int*/ $money)
	{
		$this->money = intval($money);
		$this->money_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMoneyNull()
	{
		$this->money = null;
		$this->money_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDiamonds()
	{
		return $this->diamonds;
	}
	
	public function /*void*/ setDiamonds(/*int*/ $diamonds)
	{
		$this->diamonds = intval($diamonds);
		$this->diamonds_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDiamondsNull()
	{
		$this->diamonds = null;
		$this->diamonds_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getItems()
	{
		return $this->items;
	}
	
	public function /*void*/ setItems(/*string*/ $items)
	{
		$this->items = SQLUtil::toSafeSQLString($items);
		$this->items_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setItemsNull()
	{
		$this->items = null;
		$this->items_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPoints()
	{
		return $this->points;
	}
	
	public function /*void*/ setPoints(/*string*/ $points)
	{
		$this->points = SQLUtil::toSafeSQLString($points);
		$this->points_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPointsNull()
	{
		$this->points = null;
		$this->points_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStatus()
	{
		return $this->status;
	}
	
	public function /*void*/ setStatus(/*int*/ $status)
	{
		$this->status = intval($status);
		$this->status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStatusNull()
	{
		$this->status = null;
		$this->status_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTemplate()
	{
		return $this->template;
	}
	
	public function /*void*/ setTemplate(/*int*/ $template)
	{
		$this->template = intval($template);
		$this->template_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTemplateNull()
	{
		$this->template = null;
		$this->template_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getServerId()
	{
		return $this->server_id;
	}
	
	public function /*void*/ setServerId(/*int*/ $server_id)
	{
		$this->server_id = intval($server_id);
		$this->server_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerIdNull()
	{
		$this->server_id = null;
		$this->server_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("sid={$this->sid},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("type={$this->type},");
		$dbg .= ("title={$this->title},");
		$dbg .= ("from={$this->from},");
		$dbg .= ("content={$this->content},");
		$dbg .= ("mail_cfg_id={$this->mail_cfg_id},");
		$dbg .= ("mail_params={$this->mail_params},");
		$dbg .= ("mail_time={$this->mail_time},");
		$dbg .= ("expire_time={$this->expire_time},");
		$dbg .= ("money={$this->money},");
		$dbg .= ("diamonds={$this->diamonds},");
		$dbg .= ("items={$this->items},");
		$dbg .= ("points={$this->points},");
		$dbg .= ("status={$this->status},");
		$dbg .= ("template={$this->template},");
		$dbg .= ("server_id={$this->server_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
