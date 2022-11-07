echo 'nameserver 192.168.122.1' > '/etc/resolv.conf'

apt-get update &
wait
apt-get install isc-dhcp-server -y &
wait

echo 'INTERFACES="eth0"' > '/etc/default/isc-dhcp-server'

echo 'subnet 10.25.2.0 netmask 255.255.255.0 {
} #kalo gk ada ini error

subnet 10.25.1.0 netmask 255.255.255.0 {
    range 10.25.1.50 10.25.1.88;
    range 10.25.1.120 10.25.1.155;
    option routers 10.25.1.1;
    option broadcast-address 10.25.1.255;

    option domain-name-servers 10.25.2.2;

    default-lease-time 300;
    max-lease-time 6900;
}

subnet 10.25.3.0 netmask 255.255.255.0 {
    range 10.25.3.10 10.25.3.30;
    range 10.25.3.60 10.25.3.85;
    option routers 10.25.3.1;
    option broadcast-address 10.25.3.255;

    option domain-name-servers 10.25.2.2; 

    default-lease-time 600; 
    max-lease-time 6900; 
}' > '/etc/dhcp/dhcpd.conf'

service isc-dhcp-server restart
service isc-dhcp-server restart
