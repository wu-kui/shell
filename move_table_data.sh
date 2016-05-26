#!/bin/bash
#
# author: wukui
#
mysqldump -uroot -ppassword tablename > /tmp/tablename.sql
mysql -uroot -h192.168.20.145 -P3306 -ppassword << EOF > /dev/null
use tj
source /tmp/tablename.sql

EOF
