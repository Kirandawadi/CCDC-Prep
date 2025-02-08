### Minute 0 Tasks
- Get install commands ready to be pasted
- Share exact commands with team members for setting up the Elastic Agent on all the machines 
- Create Agent Policy (LinuxPolicy & WindowsPolicy)
```
Shall we add /tmp also to FIM while monitoring ?
```
- Go to `Add Agent` and copy `elastic-agent.yml`
- Remember to add `ssl.verification_mode: none`
- Share the `elastic-agent.yml` to all with `scp` / `host with http.server`
- Select which integrations you want to apply \[ FIM in Linux  / Windows in Windows ] . `EDR` won't work without Fleer Server.
- Verify the logs are coming from the machines
- Setup important Dashboards for their monitoring  (example: FIM Dashboard / Windows Dashboard)
- Turn on the Detection Rules according to how much RAM is available.