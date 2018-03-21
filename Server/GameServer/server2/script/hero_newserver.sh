#!/bin/bash

#//run at eweb59

if [ "$*" == "" ]
then
    echo "Usage: $0 timezone servername"
    echo "EXAMPLE:"
    echo -e "\t$0 1 Ospheim\n"
    exit 11
fi

timeZone=1 #//$1
serverName=$2
scriptType=$3
product=$4
openServer=$5

echo "Start add new hero alpha server, timeZone: ${timeZone}, serverName: ${serverName}, script: ${scriptType}, product: ${product}."
echo "host name = "`hostname`;

#//get production, set db
if [ "alpha" == "${product}" ]; then
    dbHost='heromysqlmasterdev';
    dbUser='hero';
    dbPwd='herodevel2014';
    dbName='hero_devel';

    #//which web to run script once
    allowWeb='chero_devel.digisocial.com';
elif [ "production" == "${product}" ]; then
    dbHost='heromysqlmaster';
    dbUser='hero';
    dbPwd='hero3n#4g7&ks';
    dbName='hero';

    #//which web to run script once
    allowWeb='chero_web1.digisocial.com';
else
    echo "You can only set alpha/latest/beta/production for product varialbe. Can't be [${product}].";
    exit 1;
fi

echo "Target DB host: ${dbHost}, DB name: ${dbName}";

if [ "HeroServer" == "${serverName}" ]; then
    echo "The serverName is default(HeroServer), please set one in 'Run Customised Plan', and also need set timezone.";
    exit 1;
fi

#//update db, only run on eweb59(run once)
if [ "${scriptType}" == "updateDB" ] ; then
    #//insert mysql
    echo "Run ${scriptType} script";
    
    if [ "${allowWeb}" != `hostname` ]; then
        echo "host name = "`hostname`;
        echo "Only ${allowWeb} can run this script."
        exit 1;
    fi
    
    #// -- if serve name exists
    serverSql="select server_id from server_list where server_name='${serverName}';"
    selectResult=`mysql -h $dbHost -u $dbUser -p${dbPwd} -D $dbName -e "${serverSql}" --skip-column-names`
    echo "Has Server By Name: ${selectResult}"
    
    if [ -n "${selectResult}" ]; then
        echo "Server Name[${serverName}] is exists.";
        exit 1;
    fi

    if [ "1" == "${openServer}" ]; then
        openServer=1;
        serverSql="insert into server_list(server_name,server_state,server_start_date) values ('${serverName}','${openServer}',unix_timestamp());"
    else
        openServer=1;
        #//24小时后开服
        serverSql="insert into server_list(server_name,server_state,server_start_date) values ('${serverName}','${openServer}',unix_timestamp(date(now()) + INTERVAL 24 HOUR));"
    fi
    
    echo "SQL: ${serverSql}"
    
    res=`mysql -h $dbHost -u $dbUser -p${dbPwd} -D $dbName -e "${serverSql};"`
    echo "Sql Insert Finish."
    
    #//check if insert success
    serverSql="select server_id from server_list where server_name='${serverName}' limit 1;"
    echo "Sql: ${serverSql}"
    selectResult=`mysql -h $dbHost -u $dbUser -p${dbPwd} -D $dbName -e "${serverSql}" --skip-column-names`
    echo "New Server Id: ${selectResult}"
    
    if [ -z "${selectResult}" ]; then
        echo "Get server id error, Sql insert failed.";
        exit 1;
    fi
    echo "Run Success!"
    exit 0;
fi


#//Run Robot script
if [ "${scriptType}" == "initRobot" ]; then
    echo "Run ${scriptType} script";
    if [ "${allowWeb}" != `hostname` ]; then
        echo "host name = "`hostname`;
        echo "Only ${allowWeb} can run this script."
        exit 1;
    fi

    serverSql="select server_id from server_list where server_name='${serverName}';"
    echo "Sql: ${serverSql}"
    selectResult=`mysql -h $dbHost -u $dbUser -p${dbPwd} -D $dbName -e "${serverSql}" --skip-column-names`
    echo "Sql Result: ${selectResult}"

    if [ -z "${selectResult}" ]; then
        echo "Get server_id error.";
        exit 1;
    fi

    SERVERID=${selectResult}
    echo "server_id: ${SERVERID}"

    echo "Run /usr/bin/php -f /product/hero/${product}/server/htdocs/script/initServerRobot.php ${SERVERID}"
    res=`/usr/bin/php -f /product/hero/${product}/server/htdocs/script/initServerRobot.php ${SERVERID}`
    if [ $? != 0 ] || [ ${#res} -gt 0 ]; then
        #//error
        echo "Run Error: ${res}."
        exit 1;
    fi
    echo "Run Success!"
    exit 0;
fi

#//Run Arena script
if [ "${scriptType}" == "updateMemcache" ]; then
    echo "Run ${scriptType} script";
    if [ "${allowWeb}" != `hostname` ]; then
        echo "host name = "`hostname`;
        echo "Only ${allowWeb} can run this script."
        exit 1;
    fi

    echo "Run /usr/bin/php -f /product/hero/${product}/server/htdocs/script/updateMemcache.php"
    res=`/usr/bin/php -f /product/hero/${product}/server/htdocs/script/updateMemcache.php`
    if [ $? != 0 ] || [ ${#res} -gt 0 ]; then
        #//error
        echo "Run Error: ${res}."
        exit 1;
    fi
    echo "Run Success!"
    exit 0;
fi

exit $?;
