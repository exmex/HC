#!/bin/sh

declare ROOT=/product/dota/beta/server/htdocs

for ((i = $1; i <= $2; i++));
do
    php $ROOT/test/test_parse_dota_up_msg.php $i >> $ROOT/log/logs/202/${i}.log
	
	php $ROOT/test/test_parse_dota_down_msg.php $i >> $ROOT/log/logs/202/${i}.log
    
    echo "parse ${i} done!"
done
