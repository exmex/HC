<?php
/**
 * @author LiangZhixian
 */

require_once 'ItemRule.php';
require_once 'config.php';


    //先从配置文件初始化 文件路径     
   $rule_src = ITEM_RULE_SRC;    
   $rule_dest = ITEM_RULE_DEST;
    
    
    //如果运行参数带有路径 那么直接取运行参数 
    if ($argc > 1 )
    {
    	$rule_src = $argv[1];    	
    }
    if ($argc > 2 )
    {
    	$rule_dest = $argv[2];
    }    
    
    echo "SRC->".$rule_src."\n";
    echo "DST->".$rule_dest."\n";
           
   /* if (!isset($rule_src) || !isset($rule_dest))
    {
    	echo "Usage: codeGen.php <rule source file> <rule dest file>\n";
    	return;
    }*/

 	$itemrule = new ItemRule();
 
 	$itemrule->loadItemRuleSrc($rule_src,$rule_dest);  

 	if (RESET_RULE){
 		$itemrule->resetRule(); 	
 	}
 
 	$itemrule->parse();
    
 	echo "run codeGen finished!\n";

?>
