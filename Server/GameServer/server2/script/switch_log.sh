#!/bin/bash

path='/data/GameServer/log/logs/';

if [ -d $path ]; then
	yesterday=`date -d yesterday '+%Y-%m-%d'`;
	cp $path'/action.log' $path'/action_'$yesterday'.log';
	echo '' > $path'/action.log';
fi
