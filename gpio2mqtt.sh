#!/bin/sh
cd `dirname "$0"`
! [ -f "relay.sh" ] && echo "Can't find relay.sh script" && exit 1
! [ -f mqtt.conf ] && echo "Fail to find mqtt.conf file" && exit 2
. ./mqtt.conf
mqtt="mosquitto_sub -v -h $host -p $port"
[ -n "$user$pass" ] && mqtt="$mqtt -u $user -P $pass"
[ -n "$topicpref" ] && mqtt="$mqtt -t $topicpref" || mqtt="$mqtt -t /gpio2mqtt"

echo 
echo `date "+%F %T"`" Start gpio2mqtt script..."
echo

$mqtt | while read -r line; do
    rn=`echo "$line" | sed 's/^.*relay//;s/ .*//'`
    val=`echo "$line" | cut -d " " -f 2`
    echo `date "+%F %T"`" MQTT: RELAY$rn -> $val"
    if [ -n "$rn" ] && [ -n "$val" ]; then
        ./relay.sh "$rn" "$val"
    else
        echo `date "+%F %T"`" ERROR: Can't get relay number or action"
    fi
done
 
