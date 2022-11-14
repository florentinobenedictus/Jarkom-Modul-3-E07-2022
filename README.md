# Jarkom-Modul-3-E07-2022
| Nama                        | NRP        |
|:---------------------------:|:----------:|
| Arya Nur Razzaq             | 5025201102 |
| Florentino Benedictus       | 5025201222 |
| Muhammad Zufarrifqi Prakoso | 5025201276 |

#### [Script](script)
#### [Resources](resources)

## Soal 1
Loid bersama Franky berencana membuat peta tersebut dengan kriteria WISE sebagai DNS Server, Westalis sebagai DHCP Server, Berlint sebagai Proxy Server 
### Jawaban
1. Buat topologi dengan ostania sebagai router 
![Screenshot (797)](https://user-images.githubusercontent.com/103361498/201553744-039c8ba7-28b1-4a49-b3e7-fc310cbb7e45.png)
2. Lakukan konfigurasi network dengan feature ```Edit network configuration``` untuk tiap router dan network dengan ketentuan sebagai berikut :
- Ostania
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.25.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.25.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.25.3.1
	netmask 255.255.255.0
```
- Wise
```
auto eth0
iface eth0 inet static
	address 10.25.2.2
	netmask 255.255.255.0
	gateway 10.25.2.1
```
- Berlint
```
auto eth0
iface eth0 inet static
	address 10.25.2.3
	netmask 255.255.255.0
	gateway 10.25.2.1
```
- Westalis
```
auto eth0
iface eth0 inet static
	address 10.25.2.4
	netmask 255.255.255.0
	gateway 10.25.2.1
```
- SSS, Garden, Eden, NewstonCastle, KemonoPark
```
auto eth0
iface eth0 inet dhcp
```
3. Lakukan `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.25.0.0/16` pada router
4. Lakukan `echo nameserver 192.168.122.1 > /etc/resolv.conf` pada node selain router
5. Lakukan `apt-get update` kemudian lakukan `apt-get install bind 9-y` pada WISE
6. lakukan `apt-get update` kemudian lakukan `apt-get install isc-dhcp-server -y` pada Westalis kemudian lakukan konfigurasi pada `INTERFACES` pada `/etc/default/isc-dhcp-server` dengan menambahkan `eth0`
7. lakukan `apt-get update` kemudian lakukan `apt-get install squid -y` pada Berlint

## Soal 2
Ostania sebagai DHCP Relay
### Jawaban
1. Lakukan command `apt-get update` kemudian `apt-get install isc-dhcp-relay -y` pada Ostania
2. Lakukan konfigurasi pada `/etc/default/isc-dhcp-relay` :
```
# What servers should the DHCP relay forward requests to?
SERVERS="10.25.`2.4"
# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3"
# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""
```
3. Lakukan `service isc-dhcp-relay restart`

## Soal 3
Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.50 - [prefix IP].1.88 dan [prefix IP].1.120 - [prefix IP].1.155 (3)

### Jawaban
1. Lakukan konfigurasi file `/etc/dhcp/dhcpd.conf`pada Westalis dengan melakukan :
```
subnet 10.25.2.0 netmask 255.255.255.0 {
} #kalo gk ada ini service restart error
subnet 10.25.1.0 netmask 255.255.255.0 {
    range 10.25.1.50 10.25.1.88;
    range 10.25.1.120 10.25.1.155;
    option routers 10.25.1.1;
    option broadcast-address 10.25.1.255;
    option domain-name-servers 10.25.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
```
2. Lalu lakukan `service isc-dhcp-server restart`

## Soal 4
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.10 - [prefix IP].3.30 dan [prefix IP].3.60 - [prefix IP].3.85


