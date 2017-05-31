#!/bin/bash

#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl


# install squid3
apt-get -y install squid3
cat > /etc/squid3/squid.conf <<-END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8080
http_port 3128
http_port 90
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname Proxy.HostingTermurah.net
END
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget "http://script.hostingtermurah.net/repo/webmin_1.801_all.deb"
dpkg --install webmin_1.801_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.801_all.deb
service webmin restart
service vnstat restart
apt-get -y --force-yes -f install libxml-parser-perl

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*filter
:FORWARD ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -s 192.168.100.0/255.255.255.0 -j ACCEPT
-A FORWARD -s 10.1.0.0/255.255.255.0 -j ACCEPT
-A FORWARD -j REJECT --reject-with icmp-port-unreachable
-A OUTPUT -d 23.66.241.170 -j DROP
-A OUTPUT -d 23.66.255.37 -j DROP
-A OUTPUT -d 23.66.255.232 -j DROP
-A OUTPUT -d 23.66.240.200 -j DROP
-A OUTPUT -d 128.199.213.5 -j DROP
-A OUTPUT -d 128.199.149.194 -j DROP
-A OUTPUT -d 128.199.196.170 -j DROP
COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o venet0 -j SNAT --to-source xxxxxxxxx
COMMIT
END
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules

# download script
cd /usr/bin
wget -O menu.tar.gz "https://raw.githubusercontent.com/aliya02/scrirptphp/master/menu.tar.gz"
tar -xvf menu.tar.gz
rm -f menu.tar.gz

chmod +x /usr/bin/speedtest
chmod +x /usr/bin/bench-network
chmod +x /usr/bin/ps-mem.py

chmod +x /usr/bin/disable-user-expire
chmod +x /usr/bin/delete-user-expire
chmod +x /usr/bin/dropmon
chmod +x /usr/bin/rubah-tanggal
chmod +x /usr/bin/rubah-port
chmod +x /usr/bin/banned-user
chmod +x /usr/bin/unbanned-user
chmod +x /usr/bin/menu
chmod +x /usr/bin/next
chmod +x /usr/bin/user-active-list
chmod +x /usr/bin/user-add
chmod +x /usr/bin/user-add-pptp
chmod +x /usr/bin/user-del
chmod +x /usr/bin/user-expire
chmod +x /usr/bin/user-expire-list
chmod +x /usr/bin/user-gen
chmod +x /usr/bin/user-limit
chmod +x /usr/bin/user-list
sed -i 's/auth.log/secure/g' /usr/bin/user-login
chmod +x /usr/bin/user-login
chmod +x /usr/bin/user-pass
chmod +x /usr/bin/user-renew
chmod +x /usr/bin/user-trial
screen -AmdS limit /root/limit.sh
screen -AmdS ban /root/ban.sh
clear
cd

# cron
cd
sed -i '$ i\screen -AmdS limit /root/limit.sh' /etc/rc.local
sed -i '$ i\screen -AmdS ban /root/ban.sh' /etc/rc.local
sed -i '$ i\screen -AmdS limit /root/limit.sh' /etc/rc.d/rc.local
sed -i '$ i\screen -AmdS ban /root/ban.sh' /etc/rc.d/rc.local
echo "0 0 * * * root /usr/bin/user-expire" > /etc/cron.d/user-expire
echo "0 0 * * * root /usr/bin/user-expire-pptp" > /etc/cron.d/user-expire-ppt

# finalisasi
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php5-fpm start
service vnstat restart
service openvpn restart
service snmpd restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
service pptpd restart

#clearing history
history -c

# info
clear
echo "script.hostingtermurah.net | www.hostingtermurah.net| 089-5030-48170 (SMS Only) | VPS & Hosting Termurah" | tee log-install.txt
echo "===============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:85/client.tar)"  | tee -a log-install.txt
echo "OpenSSH  : 22, 143"  | tee -a log-install.txt
echo "Dropbear : 109, 110, 443"  | tee -a log-install.txt
echo "Squid3   : 80, 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "nginx    : 85"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Tools"  | tee -a log-install.txt
echo "-----"  | tee -a log-install.txt
echo "axel"  | tee -a log-install.txt
echo "bmon"  | tee -a log-install.txt
echo "htop"  | tee -a log-install.txt
echo "iftop"  | tee -a log-install.txt
echo "mtr"  | tee -a log-install.txt
echo "nethogs"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "Penjelasan di Group"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "vnstat   : http://$MYIP:85/vnstat/"  | tee -a log-install.txt
echo "MRTG     : http://$MYIP:85/mrtg/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Installasi --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "SILAHKAN REBOOT VPS ANDA !"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==============================================="  | tee -a log-install.txt
echo "Script Created By www.HostingTermurah.net"  | tee -a log-install.txt
echo "Terimakasih telah berlangganan di www.HostingTermurah.net"  | tee -a log-install.txt
