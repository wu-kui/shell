
#!/bin/bash
#
# author: wukui
# 批量修改服务器密码

# 配置文件中每个IP占一行
host=/root/host.txt
# 密码的前部分字符
qz=qlm

for i in `cat $host`
do
    hz=`openssl rand -base64 64 | tail -c 10 | head -c 8`
    password=$qz$hz
    echo $i $password >> cp.log
    ssh $i "echo $password | passwd --stdin root"
done
