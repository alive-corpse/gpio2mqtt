# GPIO2MQTT
This is just simple script that allow you to rule your low-level triggered relay module with gpio of Raspberry Pi, Banana Pi, Orange Pi or some other Pi board. It does not send back to mqtt server status if relay state will changed by some other reasons (for example other script that working with gpio). 

## Requirements
You need at least pgrep and builded wiringPi library or analog for your *Pi.
#### Raspberry Pi:
```
sudo apt-get install wiringpi
```
#### Orange Pi:
http://www.orangepi.org/Docs/WiringPi.html
#### Banana Pi:
http://wiki.lemaker.org/BananaPro/Pi:GPIO_library

## Installing
At first you should checkout repository to the /opt/gpio2mqtt folder:
```
[ -d /opt ] || sudo mkdir -p /opt # if not exists
cd /opt
sudo git clone https://github.com/alive-corpse/gpio2mqtt.git
```
At second you should copy gpio2mqtt.conf_example to gpio2mqtt.conf and change values for your mqtt connection. If your mqtt connection haven't user and password - just leave variables empty.

At third probably you'll want to change pin numbers connection list in the beginning of file relay.sh. Default pinout for my BPi R1 is below:
```
                +3.3v  1 2  +5v
                  SDA  3 4  +5v -> RELAY MODULE POWER
                  SCK  5 6  GND -> RELAY MODULE GND
                  PWM  7 8  UART3_TX -> RELAY CH1
                  GND  9 10 UART3_RX -> RELAY CH2
 RELAY CH3 <- UART2_RX 11 12 GPIO_PH2
 RELAY CH3 <- UART2_TX 13 14 GND
  ....................................               
                   GND 25 26 SPIO_CS1
   
```

|  Pin type | Pi pin | Relay module pin |
|---------- | -------|------------------|
| +5v       | 4      | +5v              |
| GND       | 5      |GND               |
| U2_TX     | 8      | Ch1              |
| U2_RX     | 10     | Ch2              |
| U3_RX     | 11     | Ch3              |
| U3_TX     | 13     | Ch4              |

**Notice:** For your particular board pinout can differ. Check it in documentation.

Then if you're using old sysvinit:
```
sudo ln -s /opt/gpio2mqtt/gpio2mqtt-init /etc/init.d/gpio2mqtt
sudo ln -s /etc/init.d/gpio2mqtt /etc/rc2.d/S06gpio2mqtt
sudo ln -s /etc/init.d/gpio2mqtt /etc/rc3.d/S06gpio2mqtt
sudo ln -s /etc/init.d/gpio2mqtt /etc/rc4.d/S06gpio2mqtt
sudo ln -s /etc/init.d/gpio2mqtt /etc/rc5.d/S06gpio2mqtt
sudo /etc/init.d/gpio2mqtt start
# Also you can check status if you want: /etc/init.d/gpio2mqtt status
```
In case of you're using new systemd:
```
cd /etc/systemd/system
ln -s /opt/gpio2mqtt/gpio2mqtt.service
systemctl daemon-reload
systemctl enable gpio2mqtt
systemctl start gpio2mqtt
# Status checking: systemctl status gpio2mqtt 
```

## Appending
Also you obliviously can use script "relay.sh" for any your purposes.
