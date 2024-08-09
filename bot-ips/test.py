# find out the bot ips, from a log file containing all hits, bot ips are not among whitelisted cidrs and ips, and is considereed bot
# if there are more than 6 hits per minute from a that ip

import json
from datetime import datetime
from ipaddress import ip_network, ip_address
from collections import defaultdict

def is_ip_whitelisted(ip, given_whitelisted_cidrs, given_whitelisted_ips):
    ip_obj = ip_address(ip)
    if ip in given_whitelisted_ips:
        return True
    return any(ip_obj in ip_network(cidr) for cidr in given_whitelisted_cidrs)

def find_is_bot_ip(log_file_path, given_whitelisted_cidrs, given_whitelisted_ips):
    ip_hits = defaultdict(lambda: defaultdict(int))
    is_bot_ip = set()
    
    with open(log_file_path, 'r') as log_file:
        for line in log_file:
            entry = json.loads(line)
            ip = entry['remote_addr']
            log_time = datetime.strptime(entry['created_at'], '%Y-%m-%dT%H:%M:%S%z')
            log_minute = log_time.replace(second=0)
            
            # Filtering out all header’s(HTTP/1.1) IPS
            if "HTTP/1.1" not in entry['request']:
                continue
            
            # Comparing all of them with whitelisted, google bots I need to filter out the remaining ips

            if is_ip_whitelisted(ip, given_whitelisted_cidrs, given_whitelisted_ips):
                continue
            
            ip_hits[ip][log_minute] += 1             # Counting up the hits 

            
            if ip_hits[ip][log_minute] > 6:                # Calculating the number of hits if >6 then bot IP

                is_bot_ip.add(ip)
    
    return is_bot_ip

log_file_path = '/Users/priyankasharma/Downloads/logfile.log'
given_whitelisted_cidrs = ['49.206.54.0/24'] 
given_whitelisted_ips =  ['192.186.1.1', '43.23.11.23', '34.56.1.1' ]

is_bot_ip = find_is_bot_ip(log_file_path, given_whitelisted_cidrs, given_whitelisted_ips)

print("Bot IPs:")
for ip in is_bot_ip:
    print(ip)
