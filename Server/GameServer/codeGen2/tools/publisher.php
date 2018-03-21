<?php

define('PATH_SOURCE', "./src/");
define('PATH_DESTINATION', "./dest/");

$update_files = array();

// 复制文件
function copyFile($node) {
	global $update_files;
	
	$attrs = $node->attributes();
	
	$url = (String)$attrs["url"];
	$md5 = (String)$attrs["md5"];		
			
	$src = PATH_SOURCE.$url;
	
	// 文件存在
	if (!file_exists($src)) {
		return false;
	}

	// 创建目录
	$dir = substr($url, 0, strrpos($url, '/') + 1);
	
	$root = PATH_DESTINATION.$dir;
	if (!is_dir($root)) {
		if (!mkdir($root, 0777, true)) {
			return false;
		}
	}

	// 产生MD5
	$new_md5 = md5_file($src);
	if ($new_md5 == false) {
		return false;
	}
	
	$ret = false;
	
	// 扩展名
	$ext = strrchr($src, '.');
	
	$url = $dir.$md5.$ext;
	
	if ($md5 !== $new_md5) {		
		// 目标目录
		$dest = $root.$new_md5.$ext;
	
		// 复制
		copy($src, $dest);
		
		$md5 = $new_md5;
		$url = $dir.$md5.$ext;
		
		$update_files[$md5] = $url;
		
		$ret = true;
	}
					
	if ($node->attributes()->url) {
		$node->attributes()->url = $url;
	} else {
		$node->addAttribute("url", $url);
	}
	if ($node->attributes()->md5) {
		$node->attributes()->md5 = $md5;
	} else {
		$node->addAttribute("md5", $md5);
	}
	
	return $ret;
}

// 校验发布结果
function check() {	
	global $update_files;
	
	$ret = 0;
	
	foreach ($update_files as $key => $value) {
		$url = PATH_DESTINATION.$value;
		if (file_exists($url)) {
			// 校验MD5
			$new_md5 = md5_file($url);
			if ($key !== $new_md5) {
				echo $url.": MD5 incompatible!\n";
				$ret++;
			}
		} else {
			echo $url.": Can not find file!\n";
			$ret++;
		}
	}
		
	return $ret;
}

// 更新源数据
function update($src) {
	$xml = simplexml_load_file($src);
	if ($xml == null) {
		echo("read file failed: ".$src."\n");
		return false;
	}
	
	foreach ($xml->children() as $node){
		if($node->getName() == "PNGLoader") {
			foreach ($node->children() as $urls) {			
				$attrs = $urls->attributes();
				
				$url = PATH_SOURCE.(String)$attrs["url"];
				$md5 = (String)$attrs["md5"];
				if (file_exists($url)) {
					// 产生MD5
					$new_md5 = md5_file($url);
					if (($new_md5 == false) || ($md5 === $new_md5)) {
						continue;
					}
					// 更新MD5
					if ($urls->attributes()->md5) {
						$urls->attributes()->md5 = $new_md5;
					} else {
						$urls->addAttribute("md5", $new_md5);
					}
				}
			}
		} else {
			$attrs = $node->attributes();

			$url = PATH_SOURCE.(String)$attrs["url"];
			$md5 = (String)$attrs["md5"];
			// 文件存在
			if (file_exists($url)) {
				// 产生MD5
				$new_md5 = md5_file($url);
				if (($new_md5 == false) || ($md5 === $new_md5)) {
					continue;
				}
				// 更新MD5
				if ($node->attributes()->md5) {
					$node->attributes()->md5 = $new_md5;
				} else {
					$node->addAttribute("md5", $new_md5);
				}
			}
		}
	}
	
	$xml->asXML($src);
	
	return true;
}

// 执行发布
function execute($src) {	
	$xml = simplexml_load_file($src);
	if ($xml == null) {
		echo("read file failed: ".$src."\n");
		return false;
	}
	
	foreach ($xml->children() as $node){
		if($node->getName() == "PNGLoader") {
			foreach ($node->children() as $urls) {
				copyFile($urls);
			}
		} else {
			copyFile($node);
		}
	}
	
	$xml->asXML(PATH_DESTINATION."xml/data.xml");
	
	return true;
}

echo "please wait...\n";
// 执行发布
execute(PATH_SOURCE."xml/data.xml");
// 校验
$err = check();
if ($err === 0) {
	// 更新源数据
	update(PATH_SOURCE."xml/data.xml");
	// 打印更新文件个数
	echo count($update_files)." files updated!\n";
} else {
	// 打印错误个数
	echo $err." errors occurred!\n";
}
echo "DONE";
?>