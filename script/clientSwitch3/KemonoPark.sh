# echo 'nameserver 192.168.122.1' > '/etc/resolv.conf'

echo '#auto eth0
#iface eth0 inet static
#       address 10.25.3.4
#       netmask 255.255.255.0
#       gateway 10.25.3.1

auto eth0
iface eth0 inet dhcp' > '/etc/network/interfaces'