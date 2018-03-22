

find . -name "*.lua" | while read line; do echo $line |sed 's,[^.]*/,,'; done | sort | uniq | sed 's/\.//' > /tmp/alluniqfile.txt

echo "" > /tmp/deletelist.txt

while read line
do 

num=`find . -name $line | wc -l`
if [ $num != 1  ]; then
   echo "------------------------------------------"
   echo "$line have $num"
   find . -name $line | sed 's/\.\///' > /tmp/ddfile.txt
  # cat /tmp/ddfile.txt
   while read ref 
   do
       kw=${ref/%.lua/}
       #refnum=`find . -name "*.lua" | xargs grep $kw | wc -l`
        pp="\""$kw"\""
#        echo $pp
        refnum=`grep -E "$pp" maingameproject.lua | wc -l`
        echo "$ref  refer $refnum "
	if  [ $refnum == 0 ]; then
           echo $ref >> /tmp/deletelist.txt
        fi
   done < /tmp/ddfile.txt
    
   echo "------------------------------------------"
   echo "+"


fi 

done < /tmp/alluniqfile.txt
