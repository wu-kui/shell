#!/bin/bash
echo -e '输入\033[36m  http   \033[0m查看http打开文件描述符数量'
echo -e '输入\033[36m  java   \033[0m查看java打开文件描述符数量'
echo -e '输入\033[36m  all    \033[0m查看当前所有打开文件数量'
echo -e '输入\033[36m  mysql  \033[0m查看msyql打开的文件数'
echo -e '输入\033[36m  tcp    \033[0m查看tcp链接数量'
echo -e '输入\033[36m  pom    \033[0m查看每个进程打开的文件数'
echo -e '输入\033[36m  tomcat \033[0m查看tomcat打开文件数量'
echo -e '输入\033[31m  exit   \033[0m退出'
echo "         "
read -p "请输入： " input
if [ $input == 'http' ]
then
	proc_num=`lsof -c httpd | wc -l`
	echo "http打开的文件描述符数是： $proc_num"
elif [ $input == 'java' ]
then
	proc_num=`lsof -c java| wc -l`
	echo "java进程打开的文件描述符数量： $proc_num"
elif [ $input == 'mysql' ]
then
	proc_num=`lsof -c mysql | wc -l`
	echo "mysql进程打开的文件描述符数量： $proc_num"
elif [ $input == 'all' ]
then
	proc_num=`lsof | wc -l`
	echo "系统当前所有打开的文件描述符是： $proc_num"
elif [ $input == 'tcp' ]
then
	proc_num=` netstat -anl | grep tcp | wc -l`
	echo "当前tcp连接数是： $proc_num"
elif [ $input == 'tomcat' ]
then
	tomcatnum=` ps -ef | grep tomcat | grep -v 'grep' | awk '{print $2}'`
	for i in $tomcatnum
	do
		echo "tomcat 进程 ID: $i"
		tomcatopenfile=`lsof -p $i | wc -l`
		echo -e "打开的文件数量是： $tomcatopenfile"
	done
elif [ $input == 'exit' ]
then
	exit 0
else
	echo "请输入(http | java | mysql | mysql | all )"
fi 
