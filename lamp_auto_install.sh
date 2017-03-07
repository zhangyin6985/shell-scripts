#!/bin/bash

# 用yum的方式一键安装lamp环境的脚本
# 仅适用于CentOS 6&7
# Writen by zhangyin
# E-mail:zhangyin6985@gmail.com

if ping -c 1 www.qq.com > /dev/null
then
	echo -e "检查网络连接：\033[32mOK\033[0m"
fi

if [ `getenforce` == "Enforcing" ]
then
	setenforce 0
	echo -e "关闭selinux：\033[32mOK\033[0m"
elif [ `getenforce` == "Permissive" ]
then 
	echo -e "关闭selinux：\033[32mOK\033[0m"
elif [ `getenforce` == "Disabled" ]
then
	echo -e "关闭selinux：\033[32mOK\033[0m"
fi

if iptables -F
then
	echo -e "关闭防火墙：\033[32mOK\033[0m"
	yum install -y net-tools epel-release
fi


function os6(){
echo -e "\033[33m开始安装apache:\033[0m"

yum install -y httpd

sed -i s/#ServerName/ServerName/g /etc/httpd/conf/httpd.conf

if [ `echo $?` == 0 ]
then
	echo -e "\033[33mapache安装完成！\033[0m"
fi

echo -e "\033[33m开始安装mysql:\033[0m"

yum install -y mysql mysql-server mysql-devel

service mysqld start

if [ `echo $?` == 0 ]
then
	echo -e "\033[33mmysql安装完成！\033[0m"
fi

echo -e "\033[33m开始安装PHP以及常用扩展:\033[0m"

yum install -y php php-mysql php-common php-gd php-mbstring php-mcrypt php-devel php-xml

if [ `echo $?` == 0 ]
then
	echo -e "\033[33mPHP以及常用扩展安装完成！\033[0m"
fi

/usr/sbin/httpd -t

if [ `echo $?` == 0 ]
then
    echo -e "\033[33m启动apache……\033[0m"
    service httpd start
fi

echo -e "\033[33m创建测试文件……\033[0m"

echo -e "<?php\nphpinfo();\n?>" > /var/www/html/index.php

echo -e "\033[34m恭喜！lamp安装已经完成，请打开浏览器访问测试页面！\033[0m"

netstat -lnpt
}

function os7(){
echo -e "\033[33m开始安装apache:\033[0m"

yum install -y httpd

sed -i s/#ServerName/ServerName/g /etc/httpd/conf/httpd.conf

if [ `echo $?` == 0 ]
then
        echo -e "\033[33mapache安装完成！\033[0m"
fi

echo -e "\033[33m开始安装mysql:\033[0m"

yum install -y mariadb mariadb-server mariadb-devel

systemctl start mariadb

if [ `echo $?` == 0 ]
then
	echo -e "\033[33mmysql安装完成！\033[0m"
fi

echo -e "\033[33m开始安装PHP以及常用扩展:\033[0m"

yum install -y php php-mysql php-common php-gd php-mbstring php-mcrypt php-devel php-xml

if [ `echo $?` == 0 ]
then
	echo -e "\033[33mPHP以及常用扩展安装完成！\033[0m"
fi

/usr/sbin/httpd -t

if [ `echo $?` == 0 ]
then
    echo -e "\033[33m启动apache……\033[0m"
    systemctl start httpd
fi

echo -e "\033[33m创建测试文件……\033[0m"

echo -e "<?php\nphpinfo();\n?>" > /var/www/html/index.php

echo -e "\033[34m恭喜！lamp安装已经完成，请打开浏览器访问测试页面！\033[0m"

netstat -lnpt
}


echo -e "开始安装lamp……"

if `uname -r|grep -q 2.6.32`
then
        os6;
elif `uname -r|grep -q 3.10.0`
then
        os7;
fi
