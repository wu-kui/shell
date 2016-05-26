#!/bin/bash
#
#
tjz=$1
# 判断是否需要输出帮助信息
if [ "$1" == "help" ]
then
        echo "./tjipfws.sh help  获取访问帮助"
        echo "./tjipfws.sh 监听套接字(117.79.92.70:80) 指定套接字查看链接数"
        exit
fi

# 判断输入的套接字格式是否合法，空就默认打印80端口的连接,不合法退出脚本。
if [ "$tjz" == "" ]
then
                # 没的指定套接字执行这里
                ss -tna |egrep '[[:alpha:]-]+[[:digit:]\.:]+.:\b80\b'|grep ESTAB | grep -v grep |awk -F':' '{a[$8]++}END{for(i in a){printf "访问IP: %-17s访问次数: %-10s\n",i,a[i]}}' | sort -n  -r -k4 > tjipfws.temp 
elif ! echo $tjz |egrep '^([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5]):[0-9]{1,5}$'
then
        if [ ! $1 == '' ]
        then
                echo "输入格式错误,格式应为一个IP地址冒号端口的格式"
                exit 1
        fi
else
                # 指定了套接字执行这里
                ss -tna |grep $1 |grep ESTAB | grep -v grep |awk -F':' '{a[$8]++}END{for(i in a){printf "访问IP: %-17s访问次数: %-10s\n",i,a[i]}}' | sort -n  -r -k4 > tjipfws.temp
fi


# 统计总链接数
a=0
for i in `cat tjipfws.temp |cut -d: -f3`
do
        a=$(( $a + $i ))
done
echo "总链接数: $a"

# 判断是否指定的显示行数,如未指定默认输出前10行。
if [ ! "$2" == '' ]
then
        head -n $2 tjipfws.temp
else
        head -n 10 tjipfws.temp
fi

# 删除临时文件
rm -f tjipfws.temp
