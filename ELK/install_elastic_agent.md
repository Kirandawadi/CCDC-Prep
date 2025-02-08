In order to collect logs and metrics from the individual machines, `Elastic Agent` need to be setup on each machine and be configured to send logs to the ELK server.
### Important!!!
> Please ensure that outbound traffic on port 9200 is allowed to the IP address of the ELASTIC_SERVER

Here are the steps to configure an `Elastic Agent` on your host:
## Step 1: Install the Agent Service
### For Linux
```shell
$ curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.17.1-linux-x86_64.tar.gz
$ tar xzvf elastic-agent-8.17.1-linux-x86_64.tar.gz
$ cd elastic-agent-8.17.1-linux-x86_64
$ sudo ./elastic-agent install
```
After install, you will be asked for prompt:
```
$ sudo ./elastic-agent install
Elastic Agent will be installed at /opt/Elastic/Agent and will run as a service. Do you want to continue? [Y/n]:Y
Do you want to enroll this Agent into Fleet? [Y/n]:n
```
### For Windows
```powershell
> $ProgressPreference = 'SilentlyContinue' 
> Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.17.1-windows-x86_64.zip -OutFile elastic-agent-8.17.1-windows-x86_64.zip
> Expand-Archive elastic-agent-8.17.1-windows-x86_64.zip -DestinationPath .
> cd elastic-agent-8.17.1-windows-x86_64 
> .\elastic-agent.exe install
```
After install, you will be asked for prompt. Select Y for install and n for not to enroll.
```powershell
> .\elastic-agent.exe install
Elastic Agent will be installed at C:\Program Files\Elastic\Agent and will run as a service. Do you want to continue? [Y/n]:Y
Do you want to enroll this Agent into Fleet? [Y/n]:n
[  ==] Service Started  [5s] Elastic Agent successfully installed, starting enrollment.
[  ==] Done  [5s]
Elastic Agent has been successfully installed.
```

## Step 2: Copy the configuration file
I'll be providing over the `elastic-agent.yml` file that you need to copy over to their appropriate location.
### For Linux
- First pull the config file from the location below.
```shell
curl -O http://ELASTIC_SERVER:8000/linux/elastic-agent.yml
```
Note: We will know the `ELASTIC_SERVER` IP on competition day only.
- Copy the file to `/opt/Elastic/Agent`  
### For Windows
- First pull the config file from the location below.
```powershell
Invoke-WebRequest -Uri "http://ELASTIC_SERVER:8000/windows/elastic-agent.yml" -OutFile ".\elastic-agent.yml"
```
Note: We will know the `ELASTIC_SERVER` IP on competition day only.
- Copy the file to `C:\Program Files\Elastic\Agent`

### Step 3: Restart the service

### For Linux
```bash
sudo systemctl restart elastic-agent.service
```

### For Windows
- Go to `Task Manager` and restart the `Elastic Agent` service.
![](../attachments/Pasted%20image%2020250207205327.png)