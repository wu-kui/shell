#!/bin/bash
#
# 2016-04-19
# author: wukui
# 配置区
# 
# curl超时时间,单位为秒
timeout=2
# tomcat的家目录
tomcat_home=/usr/local/tomcat
# 检测间隔的秒数
Interval_time=20
# 检测的URL
url='http://192.168.1.254:8080/TomcatJVM.jsp'
# 程序日志文件
log=/root/check_crm.log

# 访问tomcat的URL,如果访问成功返回0
curl_jsp () {
    /usr/bin/curl -s -m $timeout -I "$url"| grep 'HTTP/1.1 200 OK' > /dev/null 2>&1
    if [ $? = 0 ] 
    then
        return 0
    else
        return 1
    fi
}

# 检查tomcat进程是否存在,如果不存在返回0,否则返回tomcat的进程号
chk_tomcat () {
    tpid=`ps aux |grep ${tomcat_home}/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar | grep -v grep |awk '{print $2}'`
    if [ -z "$tpid" ]
    then
        date=`date +%F_%T`
        echo "$date tomcat_disappear" >> $log
        return 0
    else
        date=`date +%F_%T`
        echo "$date tomcat Zombie" >> $log
        return 1
    fi
}

# 启动tomcat
start_tomcat () {
    ${tomcat_home}/bin/startup.sh > /dev/null 2>&1
    date=`date +%F_%T`
    echo "$date start" >> $log
    sleep 60
}

# 杀死tomcat
kill_tomcat () {
    kill -9 $tpid > /dev/null 2>&1
    date=`date +%F_%T`
    echo "$date kill" >> $log
}

while true 
do
    curl_jsp
    if [ $? == 0 ]
    then
        sleep $Interval_time
    else
        chk_tomcat
        if [ $? == 0 ]
        then
            start_tomcat
            sleep 60
            continue
        elif [ $? == 1 ]
        then
            kill_tomcat
            sleep 5
            start_tomcat
            sleep 60
        fi
    fi
done
