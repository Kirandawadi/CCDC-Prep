
# Hardening Linux Box with `iptables`

This guide demonstrates how to harden your Linux box using `iptables`, ensuring that only SSH (port 22), DNS (port 53), and HTTP (port 80) are accessible from the outside while allowing all outgoing connections.

## 1. Flush Existing Rules

```bash
iptables -F
```

## 2. Allow SSH First (Port 22)

Allow SSH access before applying the blocking rules to avoid getting disconnected.

```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

## 3. Set Default Policies (Drop Everything by Default)

Set the default policies to drop inbound and forwarded traffic, while allowing outbound traffic.

```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
```

- `INPUT DROP`: Drop all inbound traffic unless explicitly allowed.
- `FORWARD DROP`: Drop forwarded packets.
- `OUTPUT ACCEPT`: Allow all outgoing connections.

## 4. Allow Established and Related Connections

This allows responses to outbound connections and keeps established connections working.

```bash
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

## 5. Allow DNS (Port 53)

Allow DNS traffic (both UDP and TCP).

```bash
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
```

## 6. Allow HTTP (Port 80)

Allow HTTP traffic on port 80.

```bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

## 7. Allow Localhost Traffic

Allow traffic on the loopback interface to ensure local services can communicate.

```bash
iptables -A INPUT -i lo -j ACCEPT
```

## 8. Save Rules

On Ubuntu/Debian:

```bash
netfilter-persistent save
```

On RHEL/CentOS:

```bash
service iptables save
```

## 9. Verify Rules

To verify your active rules:

```bash
iptables -L -v -n
```

---

This setup ensures:
- Only SSH (22), DNS (53), and HTTP (80) are accessible from the outside.
- All outbound traffic is allowed.
- Responses to outbound connections are permitted.
