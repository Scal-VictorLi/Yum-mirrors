#!/bin/bash
#Script name:rsync_yumrepo.sh
source /etc/profile >/dev/null 2>&1
source /etc/bashrc >/dev/null 2>&1
source /root/.bash_profile >/dev/null 2>&1
source /root/.bashrc >/dev/null 2>&1
RsyncBin="/usr/bin/rsync"
RsyncPerm='-avrt --delete --no-iconv --bwlimit=1000'
Centos_base='/data/yum_repo/mirrors/centos'
epel='/data/yum_repo/mirrors/epel'
LogFile='/data/yum_repo/rsync_yum_log'
Date=`date +%Y-%m-%d`
#check
function check {
if [ $? -eq 0 ];then
    echo -e "\033[1;32mRsync is success!\033[0m" >>$LogFile/$Date.log
else
    echo -e "\033[1;31mRsync is fail!\033[0m" >>$LogFile/$Date.log
fi
}
if [ ! -d "$LogFile" ];then
    mkdir $LogFile
fi
#rsync centos 6.7 base
echo 'Now start to rsync centos 6.7 base!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm --exclude-from=/data/yum_repo/rsync_yum_shell/exclude.list rsync://mirrors.ustc.edu.cn/centos/6.7/ $Centos_base/6.7/ >>$LogFile/$Date.log
check
echo 'Now start to rsync centos 7.0 base!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm --exclude=isos/ rsync://mirrors.ustc.edu.cn/centos/7/ $Centos_base/7/ >>$LogFile/$Date.log
check
#rsync centos epel 6Server
echo 'Now start to rsync epel 6Server!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm --exclude=i386/ --exclude=SRPMS/ --exclude=ppc64/ rsync://mirrors.ustc.edu.cn/epel/6Server/ $epel/6Server/ >>$LogFile/$Date.log
check
echo 'Now start to rsync epel 7!' >>$LogFile/$Date.log
$RsyncBin $RsyncPerm --exclude=x86_64/debug/ --exclude=ppc64le/ --exclude=SRPMS/ --exclude=ppc64/ rsync://mirrors.ustc.edu.cn/epel/7/ $epel/7/ >>$LogFile/$Date.log
check
