---
title: "Troubleshooting Install"
sort: 50
group: "Documentation"
---
## Problem: `convox install` failed

**Solution: Try `convox uninstall && convox install` again and look at the AWS [Cloudformation Management Console](https://console.aws.amazon.com/cloudformation/home?region=us-east-1) and look for CREATE_FAILED errors on the "Events" tab**

If you see Events with a Status Reason like:

* VPC vpc-e77b6682 has no internet gateway
* route table rtb-1337db77 and network gateway igw-5c1d6639 belong to different networks

these are transient errors in AWS and CloudFormation. Generally a `convox uninstall && convox install` will work on a second try.
