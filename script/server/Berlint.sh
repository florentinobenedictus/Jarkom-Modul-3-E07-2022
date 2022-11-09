echo 'nameserver 192.168.122.1' > '/etc/resolv.conf'

apt-get update &
wait
apt-get install squid -y &
wait

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

echo '
#include /etc/squid/acl.conf
#include /etc/squid/acl-bandwidth.conf

acl WEEKDAY_WORK time MTWHF 08:00-17:00
acl WEEKDAY_NWORK time MTWHF 00:00-07:59
acl WEEKDAY_NWORK time MTWHF 17:01-23:59
acl WEEKEND time SA 00:00-23:59

#acl SSL_Ports port 443
#acl Safe_Ports port 80 # http
#acl Safe_Ports port 443 # https
#acl CONNECT method CONNECT

delay_pools 1 #
delay_class 1 2
# delay_class 2 2

delay_access 1 allow WEEKEND
delay_parameters 1 none 16000/16000
delay_access 1 deny all

# delay_access 2 WEEKDAY_NWORK
# delay_parameters 2 none 16000/16000
# delay_access 2 deny all


#http_access deny !Safe_Ports
#http_access deny CONNECT !SSL_Ports

http_port 5000
visible_hostname Berlint

acl WHITELIST dstdomain "/etc/squid/restrict-sites.acl"
http_access allow WHITELIST WEEKDAY_WORK
http_access deny WHITELIST WEEKDAY_NWORK
http_access deny WHITELIST WEEKEND
http_access allow WEEKDAY_NWORK
http_access allow WEEKEND
http_access deny all

#http_access deny CONNECT all
' > '/etc/squid/squid.conf'

echo '
' > '/etc/squid/acl.conf'

echo 'loid-work.com
franky-work.com' > '/etc/squid/restrict-sites.acl'

echo '
' > '/etc/squid/acl-bandwidth.conf'

service squid status
service squid start
service squid stop
service squid start