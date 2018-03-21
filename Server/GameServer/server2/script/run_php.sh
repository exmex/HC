#!/bin/bash

declare LABEL=$1
declare TYPE=$2

#hero
declare GAME=$3

if [ "" == "$GAME" ]; then
    GAME='hero';
fi;

declare PROJECT_PATH="/product/${GAME}/${LABEL}/${TYPE}"
echo "Run /usr/bin/php -f ${PROJECT_PATH}/htdocs/script/updateMemcache.php"
res=`/usr/bin/php -f ${PROJECT_PATH}/htdocs/script/updateMemcache.php`

if [ $? != 0 ] || [ ${#res} -gt 0 ]; then
    #//error
    echo "Run Error: ${res}."
    exit 1;
fi
echo "Run Success!"

exit 0
