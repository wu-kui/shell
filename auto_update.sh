#!/bin/bash
value=190
while true
do
    wwip=`curl http://members.3322.org/dyndns/getip`
    xzip=`mysql -uroot -h10.10.10.10 -P3306 -ppassword -e 'select ip from rawdatas._ip_priv_ WHERE id=2394;' | egrep '(\<[1-9]{1,2}\>|(\<1[0-9]{1,2}\>)|(\<2[01][0-9]\>)|(22[0-3]))\.([0-2]?[0-9]{1,2}\.){2}[0-2]?[0-9]{1,2}'`
    if [ $wwip != $xzip ]
    then
        mysql -uroot -h10.10.10.10 -P3306 -ppassword -e "UPDATE rawdatas._ip_priv_ SET ip='$wwip' WHERE id=2394;"
    fi
    sleep $value
done
