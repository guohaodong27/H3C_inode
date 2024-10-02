#!/bin/bash

# define the PID file
PID_FILE="./pid.log"

stop_services(){
        echo "stopping services"

        if [ ! -f $PID_FILE ];then
                echo "Can't find pid.log file in $PID_FILE"
                exit 1
        fi

        while IFS=: read -r service pid;do
                echo "stopping $service PID:$pid"
                kill -9 $pid
                if [ $? -eq 0 ];then
                        echo "$service stopped"
                else
                        kill -9 `pidof $service`
                        if [ $? -eq 0 ];then
                                echo "$service stopped"
                        else
                                echo "$service stopped failed"
                        fi
                fi
        done < $PID_FILE
}


stop_services
echo "Starting"

 > $PID_FILE

# start Xvfb
Xvfb :0 -screen 0 1360x720x24 -listen tcp -ac +extension GLX +extension RENDER > /iNode/xvfb.log 2>&1 &\
XVFB=$!
echo "Xvfb : $XVFB"

# start vnc service

x11vnc -forever -shared -noipv6 -passwd wenzhu27 > /iNode/x11vnc.log 2>&1 &\
X11VNC=$!
echo "x11vnc : $X11VNC"


# start inode services , create some necessary files

IfExist=`ps awx -o command|awk -F/ '{print $NF}'|grep -x AuthenMngService`
    if [ "$IfExist" != "" ]
    then
        echo "AuthenMngService already running"
    else
        "/iNode/iNodeClient/AuthenMngService" > /dev/null 2>&1 &
        AMS=`pidof AuthenMngService`
        echo "AuthenMngService : $AMS"
    fi


IfExist=`ps awx -o command|awk -F/ '{print $NF}'|grep -x iNodeMon`
    if [ "$IfExist" = "" ]
    then
        sleep 5
        "/iNode/iNodeClient/iNodeMon" > /dev/null 2>&1 &
        INM=`pidof iNodeMon`
        echo "iNodeMon : $INM"
    fi

    touch /var/lock/subsys/iNodeAuthService
    touch /var/run/AuthenMngService.pid

getPid=`ps |grep AuthenMng|awk '{print $1}'`

sleep 5

for i in `seq 50`
do
        IfExistUI=`pidof iNodeClient`
        curPid=`pidof AuthenMngService`
        echo "$i curPid = $curPid; getPid = $getPid " > "/iNode/iNodeClient/getAuthPid.txt"
        if [ "$curPid" != "" -a "$IfExistUI" = "" ]
        then
                DISPLAY=:0.0 "/iNode/iNodeClient/.iNode/iNodeClient" &
                INC=`pidof iNodeClient`
                echo "iNodeClient : $INC"
                break
        else
                sleep 1
        fi
done
echo "iNodeClient : $INC" >> $PID_FILE
echo "iNodeMon : $INM" >> $PID_FILE
echo "AuthenMngService : $AMS" >> $PID_FILE
echo "x11vnc : $X11VNC" >> $PID_FILE
echo "Xvfb : $XVFB" >> $PID_FILE
tail -f /dev/null