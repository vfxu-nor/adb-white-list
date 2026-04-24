#!/system/bin/sh

WHITELIST_URL="https://raw.githubusercontent.com/vfxu-nor/adb-white-list/refs/heads/main/allowed.txt"

curl -s -L $WHITELIST_URL -o /data/local/tmp/whitelist.txt || wget -q $WHITELIST_URL -O /data/local/tmp/whitelist.txt

iptables -F INPUT
iptables -A INPUT -i lo -j ACCEPT

while read -r ip; do
    [ -z "$ip" ] && continue
    iptables -A INPUT -p tcp -s "$ip" --dport 5555 -j ACCEPT
    iptables -A INPUT -p tcp -s "$ip" --dport 5511 -j ACCEPT
done < /data/local/tmp/whitelist.txt

iptables -A INPUT -p tcp --dport 5555 -j DROP
iptables -A INPUT -p tcp --dport 5511 -j DROP

pkill -f "dd if=/dev/zero"
echo "Device Secured and Ready."
