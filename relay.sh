#/bin/sh
# Simple script for rule low-level triggered relay modules with gpio by Evgeniy Shumilov <evgeniy.shumilov@gmail.com>
# Reuqired builded WiringPi

# Relay port to gpio connection
rports='
1:8
2:10
3:11
4:13
'

if [ -z "$1" ]; then
    echo "Usage: $0 <port> [0/1/t]"
    exit 1
else
    gpio=`echo "$rports" | sed '/^'"$1"':/!d;s/^[0-9]*://'`
fi

[ -z "$gpio" ] && echo "Can't find gpio for port $1" && exit 2

stat=`gpio -1 read $gpio`
if [ -n "$2" ]; then
    case $2 in
        1|on)
            gpio -1 write $gpio 0
            echo "Status: 1"
        ;;
        0|off)
            gpio -1 write $gpio 1
            echo "Status: 0"
        ;;
        t) #toggle
        case $stat in
            0)
                gpio -1 write $gpio 1
                echo "Status: 0"
            ;;
            1)
                gpio -1 write $gpio 0
                echo "Status: 1"
            ;;
        esac
        ;;
    esac
else
    case $stat in
        1)
            echo "Status: 0"
        ;;
        0)
            echo "Status: 1"
        ;;
    esac
fi
gpio -1 mode $gpio out

