iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.25.0.0/16

apt-get update &
wait
apt-get install isc-dhcp-relay -y

echo "bash ./script2.sh !!!"