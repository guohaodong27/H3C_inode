Xvfb :0 -screen 0 1360x720x24 -listen tcp -ac +extension GLX +extension RENDER > /iNode/xvfb.log 2>&1 &\
x11vnc -forever -shared -noipv6 -passwd wenzhu27 > /iNode/x11vnc.log 2>&1 &\
# 启动服务
# start service
echo -n "Starting AuthenMngService: "
IfExist=`ps awx -o command|awk -F/ '{print $NF}'|grep -x AuthenMngService`
    if [ "$IfExist" != "" ]
    then
        echo "AuthenMngService already running"
    else
        nohup "/iNode/iNodeClient/AuthenMngService" > /dev/null 2>&1 &
        echo OK
    fi

IfExist=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeMon`
    if [ "$IfExist" = "" ]
    then
        sleep 5
        nohup "/iNode/iNodeClient/iNodeMon" > /dev/null 2>&1 &
        echo "iNodeMon is started"
    fi

    touch /var/lock/subsys/iNodeAuthService
    touch /var/run/AuthenMngService.pid
getPid=`ps |grep AuthenMng|awk '{print $1}'`
# 每秒尝试执行一次，总共50次
for i in `seq 50`
do
        IfExistUI=`pidof iNodeClient`
        curPid=`pidof AuthenMngService`
        echo "$i curPid = $curPid; getPid = $getPid " > "/iNode/iNodeClient/getAuthPid.txt"
        if [ "$curPid" != "" -a "$IfExistUI" = "" ]
        then
        DISPLAY=:0.0 nohup "/iNode/iNodeClient/.iNode/iNodeClient" &
                break
        else
                sleep 1
        fi
done
