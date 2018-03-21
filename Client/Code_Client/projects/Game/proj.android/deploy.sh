filepostfix=`date +%Y%m%d%H%M%S`
#filepostfix=`date +%Y%m%d`

inputapk=$1
lastestHtml=$2
dirbase1=$3
base_name=$4
svn_vervsion=$5
svn_dir=$6
obbfilename=$7
displayname="$base_name-$filepostfix.apk"
obbdisplayname="main.1.com.ucool.hero.obb"
distfile1="$dirbase1/$displayname"


fileurl=$displayname

echo "<html><head><meta charset=utf-8 /></head><body>" > htmltemplat.txt
#style
echo "<style type=\"text/css\">" >>  htmltemplat.txt 
echo "body { font:normal 36px arial, sans-serif; }" >>  htmltemplat.txt 
echo "body {" >>  htmltemplat.txt 	
echo "list-style: none;" >>  htmltemplat.txt 
echo "margin:0;" >>  htmltemplat.txt 
echo "padding:0;" >>  htmltemplat.txt 
echo "}" >>  htmltemplat.txt 
echo "a {" >>  htmltemplat.txt 
echo "background-color: #4d90fe;" >>  htmltemplat.txt 
echo "padding: 50px;" >>  htmltemplat.txt 
echo "-webkit-border-radius: 5px;" >>  htmltemplat.txt 
echo "-moz-border-radius: 5px;" >>  htmltemplat.txt 
echo "border-radius: 5px;" >>  htmltemplat.txt 
echo "font-weight: bold;" >>  htmltemplat.txt 
echo "text-align: center;" >>  htmltemplat.txt 
echo "text-decoration: none;" >>  htmltemplat.txt 
echo "background-image: -webkit-linear-gradient(top, #4d90fe, #4787ed);" >>  htmltemplat.txt 
echo "background-image: -moz-linear-gradient(top, #4d90fe, #4787ed);" >>  htmltemplat.txt 
echo "background-image: -ms-linear-gradient(top, #4d90fe, #4787ed);" >>  htmltemplat.txt 
echo "background-image: -o-linear-gradient(top, #4d90fe, #4787ed);" >>  htmltemplat.txt 
echo "background-image: linear-gradient(top, #4d90fe, #4787ed);" >>  htmltemplat.txt 
echo "border: 1px solid #3079ed;" >>  htmltemplat.txt 
echo "color: #fff;" >>  htmltemplat.txt 
echo "font-size:1.5em;" >>  htmltemplat.txt 
echo "display:block;" >>  htmltemplat.txt 
echo "margin:50px 20px;" >>  htmltemplat.txt 
echo "}" >>  htmltemplat.txt 
echo "p {" >>  htmltemplat.txt 
echo "text-indent:none;" >>  htmltemplat.txt 
echo "padding:0;" >>  htmltemplat.txt 
echo "margin:0 0 10px 0;" >>  htmltemplat.txt 
echo "}" >>  htmltemplat.txt 
echo "h6 {" >>  htmltemplat.txt 
echo "font-size:.7em;" >>  htmltemplat.txt 
echo "color:#666;" >>  htmltemplat.txt 
echo "font-weight:normal;" >>  htmltemplat.txt 
echo "margin:0 0 5px 0;" >>  htmltemplat.txt 
echo "}" >>  htmltemplat.txt 
echo "ul{margin:20px; display:block;}" >>  htmltemplat.txt 
echo "li{ display:block;}" >>  htmltemplat.txt 
echo ".time {" >>  htmltemplat.txt 
echo "color:#999;" >>  htmltemplat.txt 
echo "padding:0 5px;" >>  htmltemplat.txt 
echo "}" >>  htmltemplat.txt 
echo "</style>" >>  htmltemplat.txt 



echo "<a href=\"$fileurl\">$displayname</a>"  >> htmltemplat.txt
echo "<a href=\"$obbfilename\">$obbfilename</a>"  >> htmltemplat.txt

 
svn log -r $svn_vervsion:1 -l 20 --username builder --password '0wAeiUx929Hv' --non-interactive  $svn_dir > svnlogx1.txt
sed 's/|/@PIPE@/g' svnlogx1.txt | sed -e  's/r\(.*\)@PIPE@\(.*\)@PIPE@\(.*\)@PIPE@.*line/<li><h6><span class="whom">Revision \1 by \2<\/span><span class="time">at \3<\/span><\/h6><p>/g' > svnlogx2.txt
#sed -i 's/$/<br>/g'  svnlogx2.txt
sed -i 's/------------------------------------------------------------------------/<\/p><\/li>/g' svnlogx2.txt
sed -i '1d' svnlogx2.txt
sed -i 's/ (.*) //g' svnlogx2.txt

echo "<ul>" >> htmltemplat.txt
cat svnlogx2.txt >> htmltemplat.txt
echo "</ul>" >> htmltemplat.txt
echo " </body></html>" >> htmltemplat.txt

#r24088 | yanghuafeng | 2012-05-04 09:05:44 -0700 (Fri, 04 May 2012) | 1 line


echo "deploy $displayname"
cat svnlogx2.txt
echo "src: $inputapk"
echo "dest: $distfile1"
curpwd=`pwd`



cat  htmltemplat.txt  > $dirbase1/$lastestHtml

cd $dirbase1
echo "cleaning old apk"
ls -alt | awk '{print $9}' | grep "$base_name.*\.apk" | sed 1,3d | xargs rm -f
cd $curpwd
cp $inputapk $distfile1

#echo "deploy $displayname SUCCESS"


rm -f svnlogx1.txt
rm -f svnlogx2.txt
rm -f htmltemplat.txt


