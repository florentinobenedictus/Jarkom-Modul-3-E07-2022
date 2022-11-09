# echo 'nameserver 192.168.122.1' > '/etc/resolv.conf'

apt-get update &
wait
apt-get install lynx -y &
wait
apt-get install speedtest-cli -y &
wait
export PYTHONHTTPSVERIFY=0

echo '#auto eth0
#iface eth0 inet static
#       address 10.25.1.3
#       netmask 255.255.255.0
#       gateway 10.25.1.1

auto eth0
iface eth0 inet dhcp' > '/etc/network/interfaces'

export http_proxy="http://10.25.2.3:5000"

# speedtest --secure