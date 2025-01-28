### Security Onion Installation in AWS

This documentation provides a concise guide for installing Security Onion on an AWS EC2 instance using its AMI image.

---

### 1. Launch an EC2 Instance

- Open the AWS Management Console and navigate to **EC2**.
- Click **Launch Instance**.
- Under **Community AMIs**, search for and select the **Security Onion AMI**.

![](./attachments/Pasted%20image%2020250126230202.png)

![](./attachments/Pasted%20image%2020250126230303.png)

### 2. Instance Configuration

- Use the default configuration settings (e.g., instance type, storage).
- Proceed to launch the instance.
- Generate or use an existing SSH key pair to access the instance.
### 3. Access the Instance
Using the generated SSH key pair, log in to the instance:
```
ssh onion@<INSTANCE_IP> -i <YOUR_KEY_PAIR.pem>
```

### 4. Standalone Installation

- Choose the **STANDALONE** installation option during the setup process.

![](./attachments/Pasted%20image%2020250126230535.png)

![](./attachments/Pasted%20image%2020250126230624.png)
- **Note**: The standalone setup requires two network interfaces (NICs).

![](attachments/Pasted%20image%2020250127143856.png)

### 5. Add a Second Network Interface

- Navigate to **Network Interfaces** in the AWS Console.
- Create a new network interface and remember to attach it to your running instance.

![](attachments/Pasted%20image%2020250127144212.png)
- The second network interface is necessary for Security Onion to monitor traffic effectively.

Log in back to the instance using SSH. Follow on-screen prompts during the standalone installation to complete the configuration.

### 6. Accessing the SecurityOnion Dashboard
- Access the Management Interface using the IP address assigned while configuring the instance.
![](attachments/Pasted%20image%2020250128012616.png)
- You can also access Kibana from the SO Dashboard. Look at the pre-configured dashboard below.
![](attachments/Pasted%20image%2020250128012637.png)
- Through `Discover` tab, it provides visibility to the collected logs.
![](attachments/Pasted%20image%2020250128013218.png)
