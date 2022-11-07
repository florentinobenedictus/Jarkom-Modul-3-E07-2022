echo '# What servers should the DHCP relay forward requests to?
SERVERS="10.25.2.4"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""' > '/etc/default/isc-dhcp-relay'

# echo '
# net.ipv4.ip_forward=1
# ' >> '/etc/sysctl.conf'

service isc-dhcp-relay restart
service isc-dhcp-relay restart
