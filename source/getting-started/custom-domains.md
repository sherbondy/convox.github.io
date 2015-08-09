---
title: "Custom Domains"
---
Every app with open ports that you deploy to Convox will be assigned a load balancer. Its hostname can be fetched at any time using the `convox info` command:

```shell
$ convox info --app myapp
Name       myapp
Status     running
Release    RDKYJGPGXVZ
Processes  main
Hostname   myapp-62376059.us-east-1.elb.amazonaws.com
Ports      main:5000"
```

To make the app available at a custom domain, create a CNAME record with your DNS provider that points to the Hostname returned by `convox info`.
