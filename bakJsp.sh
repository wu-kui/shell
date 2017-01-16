dbpath=/home/qlm/web/www.qianlima.com/jsp/
bakpath=/home/qlm/bak/bakJspDir

DATE=`date +%y-%m-%d`

savepath=$bakpath/$DATE
mkdir $savepath
cp -r $dbpath $savepath

cd $bakpath
tar -zcvf $DATE.tar.gz  $savepath/jsp  
