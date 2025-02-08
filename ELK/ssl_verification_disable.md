- Modified `/etc/kibana/kibana.yml` to disable settings related to SSL Certificate verification.
```
# This section was automatically generated during setup.
#elasticsearch.hosts: ['https://10.0.0.4:9200']
elasticsearch.hosts: ['https://PUBLIC_IP:9200']
elasticsearch.serviceAccountToken: AAEAAWVsYXN0aWMva2liYW5hL2Vucm9sb..TE3MzgyMTI5NTUxNzM6a3hwX1Nyb2ZTZ3l0c1VOQUJkOGRpUQ
#elasticsearch.ssl.certificateAuthorities: [/var/lib/kibana/ca_1738212955559.crt]
elasticsearch.ssl.verificationMode: none
#xpack.fleet.outputs: [{id: fleet-default-output, name: default, is_default: true, is_default_monitoring: true, type: elasticsearch, hosts: ['https://10.0.0.4:9200'], ca_trusted_fingerprint: b440dff3af6cece05cb049fdaef6574e4f0276ed3261d7f03c5a7fb18b66e63a}]
xpack.fleet.outputs: [{id: fleet-default-output, name: default, is_default: true, is_default_monitoring: true, type: elasticsearch, hosts: ['https://PUBLIC_IP:9200']}]
```
- Restart the `kibana` service after changes.

- Using Fleet Server is giving SSL validation issues, so currently falling back to `Adding Elastic Agents as Standalone installation`.
- Just need to download the `elastic-agent.yml` from the Kibana UI (from appropriate `Agent Policy` dashboard). 
- Add `ssl.verification_mode: none` in `/opt/Elastic/Agent/elastic-agent.yml` file. It should look like this:
```
outputs:
  default:
    type: elasticsearch
    hosts:
      - 'https://PUBLIC_IP:9200'
    api_key: 'J3NjxJQBAiJrcezh3UUN:.....'
    ssl.verification_mode: none
    preset: balanced

```

- Refer to this [link](https://www.elastic.co/guide/en/fleet/current/secure-connections.html) for configuring SSL certificates for self-managed Fleet Servers. 