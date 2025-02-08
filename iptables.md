You're right! To avoid locking yourself out of SSH, you need to allow port 22 first before applying the blocking rules. Here's the corrected order of commands:

1. Flush Existing Rules (Optional but Recommended)
bash
Copy
Edit
iptables -F
iptables -X
iptables -Z
2. Allow SSH First (Port 22)
This will ensure you don't get disconnected.

bash
Copy
Edit
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
3. Set Default Policies (Drop Everything by Default)
bash
Copy
Edit
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
INPUT DROP: Drop all inbound traffic unless explicitly allowed.
FORWARD DROP: Drop forwarded packets.
OUTPUT ACCEPT: Allow all outgoing connections.
4. Allow Established and Related Connections
bash
Copy
Edit
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
5. Allow DNS (Port 53)
bash
Copy
Edit
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
6. Allow HTTP (Port 80)
bash
Copy
Edit
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
7. Allow Localhost Traffic
bash
Copy
Edit
iptables -A INPUT -i lo -j ACCEPT
Ensures that local services can communicate with each other.
8. Save Rules
On Ubuntu/Debian:

bash
Copy
Edit
netfilter-persistent save
On RHEL/CentOS:

bash
Copy
Edit
service iptables save
9. Verify Rules
bash
Copy
Edit
iptables -L -v -n
This sequence ensures SSH remains open while blocking everything else except for DNS and HTTP. You'll also have unrestricted outbound traffic.







