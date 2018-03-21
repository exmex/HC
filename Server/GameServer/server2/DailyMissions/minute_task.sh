#!/bin/sh

declare ROOT=/mnt/data

curDate=$(date +%Y%m%d)
logFileName="${ROOT}/GameServerUp/Log/logs/minute_${curDate}.log"
#//get production, set db
if [ "alpha" == "$1" ]; then
    dbHost='heromysqlmasterdev';
    dbUser='hero';
    dbPwd='herodevel2014';
    dbName='hero_devel';
elif [ "beta" == "$1" ]; then
    dbHost='192.168.1.202';
    dbUser='frpggame';
    dbPwd='RcDiccltweeilLVYFcLv';
    dbName='dota';
elif [ "production" == "$1" ]; then
    dbHost='localhost';
    dbUser='root';
    dbPwd='';
    dbName='dota';
else
    echo "You can only set alpha/latest/beta/production for product varialbe. Can't be [$1]." >> $logFileName 2>&1
    exit 1;
fi

serverSql="select server_id from server_list;"
serverIdResult=`mysql --host=${dbHost} --user=${dbUser} --password=${dbPwd} --database=${dbName} --execute="${serverSql}" --skip-column-names`

for serverId in ${serverIdResult}
do
    php $ROOT/GameServerUp/DailyMissions/minute_server_task.php ${serverId} >> $logFileName 2>&1 &
    echo `date +'%x %X'` "minute_server_task server ${serverId} done" >> $logFileName 2>&1
done

timezoneSql="select id from time_zone_list ORDER BY id;"
timeZoneList=`mysql --host=${dbHost} --user=${dbUser} --password=${dbPwd} --database=${dbName} --execute="${timezoneSql}" --skip-column-names`

for timeId in ${timeZoneList}
do
    php $ROOT/GameServerUp/DailyMissions/minute_time_zone_task.php $timeId >> $logFileName 2>&1 &
    echo `date +'%x %X'` "minute_time_zone_task time zone $timeId done" >> $logFileName 2>&1
done

php $ROOT/GameServerUp/DailyMissions/minute_task.php $1 >> $logFileName 2>&1 &
echo `date +'%x %X'` "minute_task done" >> $logFileName 2>&1

echo `date +'%x %X'` "all done" >> $logFileName 2>&1
