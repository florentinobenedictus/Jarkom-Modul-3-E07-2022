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
