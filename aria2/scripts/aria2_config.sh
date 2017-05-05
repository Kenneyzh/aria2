#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
#eval `dbus export aria2`
version=`$KSROOT/aria2/aria2c --version|grep "aria2 version"|cut -d" " -f3`
dirpath=`df -h|grep sd|awk -F" " '{print $6"/\("$4"\)"}'`
if [ -z $dirpath ];then
	dirpath="未挂载磁盘"
fi
dbus set aria2_version=$version
dbus set aria2_dir_str=$dirpath
if [ "`dbus get aria2_enable`" == "1" ] && [ ! -z "`dbus get aria2_dir_str|grep mnt`" ];then
	dbus set aria2_version="<font color=green>服务已开启</font>  ($version)"
	sh $KSROOT/aria2/aria2_run.sh restart
else
	dbus set aria2_version="<font color=red>服务未开启</font>  ($version)"
	dbus set aria2_enable=0
	sh $KSROOT/aria2/aria2_run.sh stop
fi
http_response '设置已保存！切勿重复提交！页面将在3秒后刷新'