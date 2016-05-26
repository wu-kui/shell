#!/bin/bash
#
#
#
dbname=root
dbpass=password
mysql -u$dbname -p$dbpass -e "show processlist;" | awk '{print $3}' | awk -F':' '{a[$1]++}END{for( i in a){printf "IP: %-15s    NUM: %-10s\n",i,a[i]}}' | sort -t: -n -r -k3 > ddc.tmp
num=0
for i in `awk '{print $4}' ddc.tmp`
do
        num=$(( $num + $i ))
done
echo -e "\033[32m链接总数为: \033[0m\033[35m${num}\033[0m"
cat ddc.tmp
rm -f ddc.tmp
