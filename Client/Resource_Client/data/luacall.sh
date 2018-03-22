
compile()
{
 while read line
 do
       luac $line 
     if [ $? -ne 0 ]
     then
      echo "------------------"
     fi
 done
}

find . -name "*.lua" | compile
