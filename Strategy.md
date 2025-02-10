# Defense Strategy

### 1. Prevent (Proactive Defense)

#### **System Hardening**
- Follow the provided **playbook** for system-specific hardening.
- Run **hardening scripts** to apply security baselines.
- Use `linpeas.sh` to check for security misconfigurations and privilege escalation vectors.
- Disable unnecessary services:
  ```sh
  systemctl disable --now <service>
  chkconfig <service> off  # For older systems
  ```
- Restrict SSH access:
  - Change to key-based authentication (`PermitRootLogin no`, `PasswordAuthentication no`).
  - Limit SSH access to trusted IPs in `/etc/ssh/sshd_config`.
- Restrict sudo & admin privileges:
  ```sh
  sudo -l  # Check current sudo access
  visudo   # Edit and restrict sudo privileges
  ```
- Remove default users and keys:
  ```sh
  userdel -r <user>
  cat /etc/passwd | grep bash  # Check for unnecessary accounts
  ```
- Deploy AppArmor/SELinux:
  ```sh
  aa-enforce <profile>
  setenforce 1
  ```
- Check if the `/etc/apt/sources` are looking good or not. They might be malicious as well.
#### **Firewall & Network Security**
- Set up **firewall rules** using `iptables` or `ufw`:
  ```sh
  iptables -A INPUT -p tcp --dport 22 -s <trusted-IP> -j ACCEPT
  iptables -A INPUT -p tcp --dport 22 -j DROP
  ```
- Block repeated SSH login attempts using **fail2ban**:
  ```sh
  apt install fail2ban
  systemctl enable --now fail2ban
  ```
- Monitor network activity for unexpected connections:
  ```sh
  ss -tulnp  # Show listening ports and processes
  netstat -antp  # Alternative command
  ```

### 2. Monitor (Detection & Alerting)

#### **Log Collection & SIEM**
- Install and configure **ELK stack** to collect logs from all systems.
- Forward logs to an external server to prevent tampering.
- Use **auditd** for critical file monitoring:
  ```sh
  auditctl -w /etc/shadow -p wa -k shadow_change
  ```

#### **Active Monitoring**
- Run monitoring scripts and send anomalies to **Discord** alerts.
- Enable logging for sudo & executed commands:
  ```sh
  echo "Defaults logfile='/var/log/sudo.log'" >> /etc/sudoers
  ```
- Check system logs for unauthorized actions:
  ```sh
  journalctl -xe
  cat /var/log/auth.log | grep "Failed password"
  ```
- Detect new services or ports:
  ```sh
  systemctl list-units --type=service | grep enabled
  lsof -i -P -n | grep LISTEN
  ```
- Identify reverse shells:
  ```sh
  ps aux | grep nc  # Detect netcat shells
  ```

### 3. Cure (Incident Response)

#### **Investigate and Mitigate Attacks**
- Analyze logs for **unauthorized changes**:
  ```sh
  grep "useradd" /var/log/auth.log  # Check if new users were added
  ```
- Immediately remove new unauthorized users:
  ```sh
  userdel -r <suspicious-user>
  ```
- Identify and delete malicious services:
  ```sh
  systemctl list-units --type=service | grep enabled
  systemctl disable --now <suspicious-service>
  ```
- Scan for persistence mechanisms:
  ```sh
  crontab -l  # List user cron jobs
  find /etc/cron* -type f  # System-wide cron jobs
  ```
- Check for unauthorized SSH keys:
  ```sh
  cat ~/.ssh/authorized_keys
  ```
- Investigate newly opened ports:
  ```sh
  ss -tulnp | grep LISTEN
  ```
- Check system logs for privilege escalation attempts:
  ```sh
  grep "sudo" /var/log/auth.log
  ```

### 4. Real-World Attack Scenarios & Mitigations

| Attack Type | Mitigation Strategy |
|------------|--------------------|
| **Web Shell via Apache/Nginx Uploads** | Restrict writable directories (`chmod -R 755 /var/www/html`), disable PHP execution in `/uploads/` |
| **Brute-force SSH (Hydra, Patator)** | Block repeated login attempts with `fail2ban`, limit SSH rate in `iptables` |
| **Privilege Escalation via SUID Binaries** | Find all SUID binaries (`find / -perm -4000 2>/dev/null`), remove unnecessary ones |

---

This plan ensures a **high cost-to-benefit ratio** while maximizing defense effectiveness during CCDC.

- Don't forget to check ~/.bash_history (Sometimes the commands they used to make machine vulnerable is exposed).