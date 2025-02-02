
## Elasticsearch Installation

> Machine's IP: 10.0.0.4

- Import Elasticsearch public GPG key and add the Elastic package source list in order to install Elasticsearch.
```bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch |sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
```
- Next, add the Elastic source list to the `sources.list.d` directory, where APT will search for new sources:
```bash
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
sudo apt update
```
- Install Elasticsearch
```bash
sudo apt install elasticsearch
```
- This generates password for the elastic built-in superuser. Make sure to note it.
- Start the Elasticsearch service with `systemctl`
```
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
```
- Test whether the Elasticsearch service is responding properly or not.
```bash
dawadi@ubuntuMachine:~$ curl -X GET http://localhost:9200
curl: (52) Empty reply from server
```
- We received empty reply from the server because we are using HTTP instead of HTTPS.
```bash
dawadi@ubuntuMachine:~$ curl -X GET https://localhost:9200
curl: (60) SSL certificate problem: self-signed certificate in certificate chain
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```
- We'll skip the certificate check and then provide it with authentication details for `elastic` user.
```bash
dawadi@ubuntuMachine:~$ curl -X GET -k https://elastic:<PASSWORD>@localhost:9200
{
  "name" : "ubuntuMachine",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "cHwoig-tSCORzBMPNo022A",
  "version" : {
    "number" : "8.17.1",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "d4b391d925c31d262eb767b8b2db8f398103f909",
    "build_date" : "2025-01-10T10:08:26.972230187Z",
    "build_snapshot" : false,
    "lucene_version" : "9.12.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```
## Kibana Installation

- Install Kibana
```bash
sudo apt install kibana
```
- Enable the service and start it.
```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```
- Generate an enrollment token for Kibana instance by using `elasticsearch-create-enrollment-token` method.
```bash
dawadi@ubuntuMachine:~$ sudo /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
eyJ2ZXIiOiI4........xYnVUa1AxZyJ9
```
- Setup Kibana to use this enrollment token.
```
dawadi@ubuntuMachine:~$ sudo /usr/share/kibana/bin/kibana-setup 
Native global console methods have been overridden in production environment.
? Enter enrollment token: eyJ2ZXIiOiI4........xYnVUa1AxZyJ9

✔ Kibana configured successfully.

To start Kibana run:
  bin/kibana

```
- Then restart the kibana service to apply changes.
```
sudo systemctl restart kibana
```
- Kibana runs on port 5601. We can check the status using `ss -tupln` because it takes some time for the service to be fully up.
```
dawadi@ubuntuMachine:~$ ss -tupln
Netid             State              Recv-Q              Send-Q                                Local Address:Port                           Peer Address:Port             Process             
udp               UNCONN             0                   0                                     127.0.0.53%lo:53                                  0.0.0.0:*                                    
udp               UNCONN             0                   0                                     10.0.0.4%eth0:68                                  0.0.0.0:*                                    
udp               UNCONN             0                   0                                         127.0.0.1:323                                 0.0.0.0:*                                    
udp               UNCONN             0                   0                                             [::1]:323                                    [::]:*                                    
tcp               LISTEN             0                   128                                         0.0.0.0:22                                  0.0.0.0:*                                    
tcp               LISTEN             0                   511                                       127.0.0.1:5601                                0.0.0.0:*                                    
tcp               LISTEN             0                   4096                                  127.0.0.53%lo:53                                  0.0.0.0:*                                    
tcp               LISTEN             0                   4096                                          [::1]:9300                                   [::]:*                                    
tcp               LISTEN             0                   4096                             [::ffff:127.0.0.1]:9300                                      *:*                                    
tcp               LISTEN             0                   4096                                              *:9200                                      *:*                                    
tcp               LISTEN             0                   128                                            [::]:22                                     [::]:*                                    

```

## Setup Kibana behind Nginx
- Install nginx using `sudo apt install nginx`
- We are trying to put the Kibana service (running on port 5601) behind a nginx web server. Lets edit `/etc/nginx/sites-enabled/default` file and use `proxy_pass` feature.

```nginx
        server_name _;
        
        location / {
                proxy_pass http://127.0.0.1:5601
        }
```
- Restart `nginx` service with `sudo systemctl restart nginx`
- Now you can access Kibana dashboard on port 80 of the server.
![](attachments/Pasted%20image%2020250129232845.png)
- Login with user `elastic` and the password that was generated in the beginning.

## Basic Setup Workflow
- - First, create an **Agent Policy**, which defines the configurations that will be applied to the hosts assigned to it.
- - Add as many **integrations** as needed within the Agent Policy.
- Finally, enroll **agents** into the Agent Policy to start monitoring them.

## Setting up Fleet Server

> Machine's IP: 10.0.0.6

- Add `Fleet Server` integration to Kibana dashboard. Fleet Server is a component of the Elastic Stack used to centrally manage Elastic Agents.
![](attachments/Pasted%20image%2020250129234250.png)
- I went with default settings.
![](attachments/Pasted%20image%2020250129234626.png)

- Click on `Add Agent` and `Enroll in Fleet`. Add your Fleet Server's IP address with port `8220`. You can use Fleet Server's Public IP Address as well.
![](attachments/Pasted%20image%2020250130141855.png)
- We are using separate machine in order to install `Fleet Server Agent`.  Install it using the following commands:
```
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.17.1-linux-x86_64.tar.gz 
tar xzvf elastic-agent-8.17.1-linux-x86_64.tar.gz 
cd elastic-agent-8.17.1-linux-x86_64
```
- Run this command in order to install Fleet Server Agent with proper configuration. I have added `--fleet-server-es-ca=/usr/local/etc/ssl/certs/elastic/http_ca.crt --insecure` because we are using self-signed certificates.
```
sudo ./elastic-agent install \ 
--fleet-server-es=https://10.0.0.4:9200 \ 
--fleet-server-service-token=<TOKEN> \ 
--fleet-server-policy=ff12d36f-c348-479b-b82c-8b18dbffd786 \ 
--fleet-server-es-ca-trusted fingerprint=b440dff3af6cece05cb049fdaef6574e4f0276ed3261d7f03c5a7fb18b66e63a \ 
--fleet-server-port=8220 \
--fleet-server-es-ca=/usr/local/etc/ssl/certs/elastic/http_ca.crt --insecure
```
- `/usr/local/etc/ssl/certs/elastic/http_ca.crt` is not present by default. I copied the same certificate from Elastic machine from `/etc/elasticsearch/certs/http_ca.crt`.
![](attachments/Pasted%20image%2020250130141952.png)
- Finally it is successfully installed and you can verify this from UI as well.
![](attachments/Pasted%20image%2020250130142048.png)

## Adding agents 

> Windows Agent IP: 10.0.0.5 
- Now we will install `elastic-agent` on those machines which we want to monitor. These agents will forward their system logs (and configured logs) to Elasticsearch.
![](attachments/Pasted%20image%2020250130143330.png)

```powershell
$ProgressPreference = 'SilentlyContinue' 
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.17.1-windows-x86_64.zip -OutFile elastic-agent-8.17.1-windows-x86_64.zip 
Expand-Archive .\elastic-agent-8.17.1-windows-x86_64.zip -DestinationPath . 
cd elastic-agent-8.17.1-windows-x86_64 
.\elastic-agent.exe install --url=https://20.115.80.200:8220 --enrollment-token=SEFkYnVKUUJ3RVZCdmxFcGpDcHE6UkhHbk1EWmVRc2FJQjBLelVsb3AxUQ==
```
- The elastic agent is successfully installed on this windows machine.
![](attachments/Pasted%20image%2020250130144500.png)
![](attachments/Pasted%20image%2020250130144633.png)
- Lets verify this from Kibana's `Discover` tab.
![](attachments/Pasted%20image%2020250130155431.png)
## Enable Endpoint Security
- `Elastic Defend` is an integration available that has a wide range of security capabilities.
![](attachments/Pasted%20image%2020250130150314.png)
![](attachments/Pasted%20image%2020250130150534.png)
- Lets add this integration to our already existing hosts. There are 2 of them currently: one is the Windows server that we installed it on and another is the Fleet-Server machine itself (Linux).
![](attachments/Pasted%20image%2020250130150759.png)

![](attachments/Pasted%20image%2020250130150827.png)
- Oops we received an error.

![](attachments/Pasted%20image%2020250130150957.png)
- Use this command to generate encryption keys.
```
root@elastic:~# /usr/share/kibana/bin/kibana-encryption-keys generate
```
- This will generate three settings that we need to paste at the end of `/etc/kibana.kibana.yml` file.
```
Settings:
xpack.encryptedSavedObjects.encryptionKey: af6e821ff234ad2ff2c1b3c809b548bd
xpack.reporting.encryptionKey: 11b3f337563635cfa5401b51729af1e9
xpack.security.encryptionKey: 209d18e6c7cceb1fe5ce6bee2ab31ee6
```
- Let's restart the kibana service with `systemctl restart kibana` .
- With this, you should be able to save and deploy changes.

## Enable Detection Rules
![](attachments/Pasted%20image%2020250130152420.png)
- Lets enable all the detection rules.
![](attachments/Pasted%20image%2020250130152453.png)
- It has a wide range of detection rules for different sources. We are particularly interested in Linux and Windows sources.

## Triggering a sample detection rule
Let's add a new user in `fleet-server` host. 
```
sudo useradd -m -s /bin/bash username
```
- We can see the alert `Linux User Account Creation` being fired. 
![](attachments/Pasted%20image%2020250130153846.png)
- Everything is working as expected.

## Summary
I found ELK Stack along with Fleet Server and Elastic Agents much powerful that I thought. With the options of enabling `Endpoint Security` and `Detection Rules` , it will be perfect for systems monitoring and security visibility.

## References
DigitalOcean: https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-22-04
Ippsec: https://www.youtube.com/watch?v=Ts-ofIVRMo4