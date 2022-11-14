﻿# Jarkom-Modul-3-E07-2022
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
1. Lakukan konfigurasi file `/etc/dhcp/dhcpd.conf`pada Westalis dengan menambahkan :
```
subnet 10.25.2.0 netmask 255.255.255.0 {
} #kalau tidak ada ini service restart error
subnet 10.25.1.0 netmask 255.255.255.0 {
    range 10.25.1.50 10.25.1.88;
    range 10.25.1.120 10.25.1.155;
    option routers 10.25.1.1;
    option broadcast-address 10.25.1.255;
    option domain-name-servers 10.25.2.2;
    default-lease-time 360;
    max-lease-time 7200;
}
```
2. Lalu lakukan `service isc-dhcp-server restart`

## Soal 4
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.10 - [prefix IP].3.30 dan [prefix IP].3.60 - [prefix IP].3.85
### Jawaban
1. Lakukan konfigurasi file `/etc/dhcp/dhcpd.conf`pada Westalis dengan menambahkan :
```
subnet 10.25.3.0 netmask 255.255.255.0 {
    range 10.25.3.10 10.25.3.30;
    range 10.25.3.60 10.25.3.85;
    option routers 10.25.3.1;
    option broadcast-address 10.25.3.255;
    option domain-name-servers 10.25.2.2; 
    default-lease-time 360; 
    max-lease-time 7200; 
}
```
2. Lalu lakukan `service isc-dhcp-server restart`

## Soal 5
Client mendapatkan DNS dari WISE dan client dapat terhubung dengan internet melalui DNS tersebut.
### Jawaban
1. Lakukan konfigurasi pada `etc/bind/named.conf.options` dengan menambahkan :
```
forwarders {
                192.168.122.1;
        };
	allow-query{any;};
```
dan comment bagian 
```
// dnssec-validation auto;
```
2. Lakukan `service bind9 restart`
3. Edit file `/etc/dhcp/dhcpd.conf` pada Westalis dengan menambahkan `option domain-name-servers "IP WISE"` pada `subnet 10.25.2.0` dan `subnet 10.25.3.0`
## Soal 6
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 5 menit sedangkan pada client yang melalui Switch3 selama 10 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit. (6)
### Jawaban
1. Lakukan konfigurasi pada `/etc/dhcp/dhcpd.conf`pada Westalis yang dimana default-lease time dan max lease timenya diganti menjadi sebagai berikut
```bash
subnet 10.25.2.0 netmask 255.255.255.0 {
} #kalau tidak ada ini service restart error
#untuk switch 1
subnet 10.25.1.0 netmask 255.255.255.0 {
    range 10.25.1.50 10.25.1.88;
    range 10.25.1.120 10.25.1.155;
    option routers 10.25.1.1;
    option broadcast-address 10.25.1.255;
    option domain-name-servers 10.25.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
#dan untuk switch 3
subnet 10.25.3.0 netmask 255.255.255.0 {
    range 10.25.3.10 10.25.3.30;
    range 10.25.3.60 10.25.3.85;
    option routers 10.25.3.1;
    option broadcast-address 10.25.3.255;
    option domain-name-servers 10.25.2.2; 
    default-lease-time 600; 
    max-lease-time 6900; 
}
```
2. Lalu lakukan service isc-dhcp-server restart
## Soal 7
## Soal Proxy

## 8.1
Client hanya dapat mengakses internet diluar (selain) hari & jam kerja (senin-jumat 08.00 - 17.00) dan hari libur (dapat mengakses 24 jam penuh)\
###  Jawaban
1. Lakukan `apt-get update` dan `apt-get install squid -y`
2. Lakukan `mv /etc/squid/squid.conf /etc/squid/squid.conf.bak`
3. Buat konfigurasi acl untuk waktu yang bisa diakses di '/etc/squid/squid.conf' menjadi sebagai berikut
```
acl WEEKDAY_WORK time MTWHF 08:00-17:00
acl WEEKDAY_NWORK time MTWHF 00:00-07:59
acl WEEKDAY_NWORK time MTWHF 17:01-23:59
acl WEEKEND time SA 00:00-23:59
``` 
3. lalu memnbuat konfigurasi untuk http_accessnya menjadi berikut
```
http_access allow WEEKDAY_NWORK
http_access allow WEEKEND
http_access deny all
```
4. Lakukan `service squid restart`
5. Lakukan `export http_proxy="http://10.25.2.3:5000"` di node SSS
6. Test menggunakan lynx ke domain apapun
### Hasil



## 8.2
Adapun pada hari dan jam kerja sesuai nomor (1), client hanya dapat mengakses domain loid-work.com dan franky-work.com (IP tujuan domain dibebaskan)
### Jawaban
1. Buat konfigurasi di `/etc/squid/restrict-sites.acl` dengan menambahkan loid-work.com dan franky-work.com 
2. di  '/etc/squid/squid.conf' ditambahkan acl `acl WHITELIST dstdomain "/etc/squid/restrict-sites.acl"` agar dapat mengakses domain tersebut
3. agar domain tersebut bisa dipakai saat jam kerja ditambahkan juga http_access menjadi seperti berikut
```
http_access allow WHITELIST WEEKDAY_WORK
http_access deny WHITELIST WEEKDAY_NWORK
http_access deny WHITELIST WEEKEND
```
4. Lakukan `service squid restart`
5. Lakukan `export http_proxy="http://10.25.2.3:5000"` lagi di node SSS
## 8.3
## 8.4
## 8.5

## Kendala
- bisa mendeny http tetapi tidak bisa mengatur https agar tidak bisa diakses
