echo 'nameserver 192.168.122.1' > '/etc/resolv.conf'

apt-get update &
wait
apt-get install squid -y &
wait

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

echo '
include /etc/squid/acl.conf
http_access allow AVAILABLE_WORKING

#http_access deny !Safe_Ports
#http_access deny CONNECT !SSL_Ports

http_port 5000
visible_hostname Berlint

acl WHITELIST dstdomain "/etc/squid/restrict-sites.acl"
http_access allow WHITELIST
http_access deny all
http_access deny CONNECT all
' > '/etc/squid/squid.conf'

echo 'acl AVAILABLE_WORKING time MTWHF 00:00-07:59
acl AVAILABLE_WORKING time MTWHF 17:01-23:59
acl AVAILABLE_WORKING time SA 00:00-23:59

acl SSL_Ports port 443
acl Safe_Ports port 80 # http
acl Safe_Ports port 443 # https
acl CONNECT method CONNECT
' > '/etc/squid/acl.conf'

echo 'loid-work.com
franky-work.com' > '/etc/squid/restrict-sites.acl'

service squid status
service squid start
service squid stop
service squid start