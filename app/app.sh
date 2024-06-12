#!/bin/bash

# Change to app folder
cd "/opt/app" || exit

## Print DNS Servers Configuration
echo "======================== Container /etc/resolv.conf ======================"
cat /etc/resolv.conf
echo "======================== Container /etc/resolv.conf ======================"

## Print Network Addresses
echo "======================== Container ip addr ======================"
ip addr
echo "======================== Container ip addr ======================"

## Print Network Routes IPv4
echo "======================== Container ip route ======================"
ip route
echo "======================== Container ip route ======================"

## Print Network Routes IPv6
echo "======================== Container ip -4 route ======================"
ip route
echo "======================== Container ip -6 route ======================"

## Print Network Routes IPv4 (route)
echo "======================== Container route (IPv4) ======================"
route -n4
echo "======================== Container route (IPv4) ======================"

## Print Network Routes IPv6 (route)
echo "======================== Container route (IPv6) ======================"
route -n6
echo "======================== Container route (IPv6) ======================"

## Attempt DNS Resolution to debian.org
echo "======================== Container nslookup to debian.org  ======================"
nslookup debian.org
echo "======================== Container nslookup to debian.org ======================"

## Attempt Traceroute to debian.org
echo "======================== Container IPv4 ICMP Traceroute to debian.org  ======================"
traceroute -I debian.org
echo "======================== Container IPv4 ICMP Traceroute to debian.org ======================"

## Attempt Traceroute to debian.org
echo "======================== Container IPv6 ICMP Traceroute to debian.org  ======================"
traceroute6 -I debian.org
echo "======================== Container IPv6 ICMP Traceroute to debian.org ======================"

## Attempt Traceroute to debian.org
echo "======================== Container IPv4 TCP Traceroute Port 443 to debian.org  ======================"
traceroute -T -p 443 debian.org
echo "======================== Container IPv4 TCP Traceroute Port 443 to debian.org ======================"

## Attempt Traceroute to debian.org
echo "======================== Container IPv6 TCP Traceroute Port 443 to debian.org  ======================"
traceroute6 -T -p 443 debian.org
echo "======================== Container IPv6 TCP Traceroute Port 443 to debian.org ======================"


## Print External IP Address
## Print Network Routes IPv4
echo "======================== Container Public IP Address ======================"
ipv4_address=$(curl -q -4 ifconfig.me)
ipv6_address=$(curl -q -6 ifconfig.me)

echo "Public IPv4 Address: ${ipv4_address}"
echo "Public IPv6 Address: ${ipv6_address}"
echo "======================== Container Public IP Address ======================"


# Infinite loop to Troubleshoot
# Also needed if the Main Script/App doesn't have a looping itself, preventing the Container from Stopping
#if [[ -v ENABLE_INFINITE_LOOP ]]
#then
   if [[ "${ENABLE_INFINITE_LOOP}" == "true" ]]
   then
       echo "Starting Infinite Loop"
       while true
       do
          sleep 5
       done
   fi
#fi
