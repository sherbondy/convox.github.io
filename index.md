---
title: "Getting Started with Convox"
sort: 10
group: "Getting Started"
---
## What is Convox?

Convox is an open source [Platform as a Service](https://en.wikipedia.org/wiki/Platform_as_a_service) that runs in your own Amazon Web Services (AWS) account. Instead of signing up for a multi-tenant PaaS like Heroku, you can have your own. This gives you privacy and control over your platform and avoids the substantial markup on AWS prices that other platforms charge.

To start using Convox, you'll need to install the command line interface (CLI) onto your OS X or Linux computer. Then you can use the `convox` CLI to install the PaaS system into your AWS account.

Once that's all set up you can start deploying and managing your apps with Convox, without having to worry about the underlying AWS services.

Follow the step-by-step guide below to get started.


## Install the CLI

##### OSX
```shell
$ curl -Ls https://www.convox.com/downloads/osx/convox.zip > /tmp/convox.zip
$ unzip /tmp/convox.zip -d /usr/local/bin
```

##### Linux
```shell
$ curl -Ls https://www.convox.com/downloads/linux/convox.zip > /tmp/convox.zip
$ unzip /tmp/convox.zip -d /usr/local/bin
```



## Install Convox in AWS

The `convox install` command will kick off the process of setting up Convox in your AWS account. All of the AWS resources required for creating a powerful app deployment platform will be correctly configured for you.

```shell
$ convox install
```

<div class="block-callout block-show-callout type-info">
### Security credentials
To install Convox into your AWS account, the Convox CLI needs an `AWS Access Key ID` and `Secret Access Key`. We highly recommend following AWS best practices by [creating a new IAM user to supply these credentials](/getting-started/creating-an-iam-user-and-credentials). Once the install is complete you can safely [delete the user](/getting-started/deleting-an-iam-user).
</div>

The installation process takes about 5 minutes. Go make a sandwich while you contemplate all of the AWS docs you're not reading and glue code you're not writing.

```shell
Installing Convox...
Created IAM User: convox-RegistryUser-1L99G5CIN2YJ2
Created ECS Cluster: convo-Clust-17YAVSE7MRRKH
Created IAM User: convox-KernelUser-OC4CV0Q5NU8B
Created Access Key: AKIAIIXP3G3F4TX3KY2A
Created Access Key: AKIAIEP4FSGRQE5GGRRA
Created S3 Bucket: convox-registrybucket-182tj69qj9k8y
Created S3 Bucket: convox-settings-l5u6qcekwsq4
Created VPC Internet Gateway: igw-b03f76d5
Created VPC: vpc-fd130e98
Created Lambda Function: convox-CustomTopic-484343B6HXL5
Created Routing Table: rtb-6306fe07
Created DynamoDB Table: convox-releases
Created DynamoDB Table: convox-builds
Created Security Group: sg-3be3365c
Created Security Group: sg-3ee33659
Created VPC Subnet: subnet-994567ee
Created VPC Subnet: subnet-bece8be7
Created VPC Subnet: subnet-9490febf
Created Elastic Load Balancer: convox
Created ECS TaskDefinition: KernelTasks
Created ECS Service: Kernel
Created AutoScalingGroup: convox-Instances-1496N5UFY25LU
Created CloudFormation Stack: convox
Waiting for load balancer...
```

When the load balancer becomes available the installation is complete:

```shell
Logging in...
Success, try convox apps
```

You can run `convox apps` to verify that your client is properly communicating with the system.

```shell
$ convox apps
APP  STATUS
```

Congratulations! Convox is set up and ready to deploy apps. Try [deploying](/getting-started/deploying-an-application) one of our sample applications.

<div class="block-callout block-show-callout type-warning">
### Cost Management

The Convox Installer by default provisions an Elastic Load Balancer and 3 t2.small instances, giving you 6GB of memory capacity. This runs the Convox API and Private Registry, and leaves room for 10 512MB containers.

This configuration costs $85/month according to the [AWS simple cost calculator](http://calculator.s3.amazonaws.com/index.html).

Each deployed app will provision an additional ELB which starts at $18/month.

At any time you can [uninstall Convox](/getting-started/uninstall-convox) to delete the resources and stop accruing costs.
</div>
