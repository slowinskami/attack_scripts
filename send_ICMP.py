#! /usr/bin/env python

from scapy.all import *
import sys

srp1(Ether() / IP( src=sys.argv[1] , dst="192.168.200.1") / ICMP() , iface='wlan0')
