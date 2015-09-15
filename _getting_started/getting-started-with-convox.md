---
title: "Getting Started with Convox"
sort: 10
---
## What is Convox?

Convox is an open source [Platform as a Service](https://en.wikipedia.org/wiki/Platform_as_a_service) that runs in your own Amazon Web Services (AWS) account.

To start using Convox, you'll need to install the command line interface (CLI) onto your OS X or Linux computer. Then you can use the `convox` CLI to install the PaaS system into your AWS account.

Once that's all set up you can start deploying and managing your apps with Convox, without having to worry about the underlying AWS services.

Follow the step-by-step guide below to get started.


## Install the CLI

##### OSX
    $ curl -Ls https://www.convox.com/downloads/osx/convox.zip > /tmp/convox.zip
    $ unzip /tmp/convox.zip -d /usr/local/bin

##### Linux
    $ curl -Ls https://www.convox.com/downloads/linux/convox.zip > /tmp/convox.zip
    $ unzip /tmp/convox.zip -d /usr/local/bin

## Install Convox in AWS

The `convox install` command will kick off the process of setting up Convox in your AWS account. All of the AWS resources required for creating a powerful app deployment platform will be correctly configured for you.

    $ convox install

<div class="block-callout block-show-callout type-info">
  <h3>Security credentials</h3>
  <p>To install Convox into your AWS account, the Convox CLI needs an <code>AWS Access Key ID</code> and <code>Secret Access Key</code>. We highly recommend following AWS best practices by <a href="/docs/creating-an-iam-user">creating a new IAM user to supply these credentials</a>. Once the install is complete you can safely <a href="/docs/deleting-an-iam-user">delete the user</a>.</p>
</div>

<div class="block-callout block-show-callout type-primary">
  <h3>Rack Region</h3>
  <p>A Rack exists in one AWS region. Since Convox depends on specific AWS services you can't deploy Rack's in all regions. Currently AWS regions that support both <em>Lambda</em> and <em>EC2 Container Service</em> are supported.</p>
  <p>Region can be specified on Rack install using the <code>--region</code> flag.</p>
</div>

The installation process takes about 5 minutes. Feel free to go make a sandwich while you contemplate all of the AWS docs you're not reading and glue code you're not writing.

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

When the load balancer becomes available the installation is complete:

    Logging in...
    Success, try convox apps

You can run `convox apps` to verify that your client is properly communicating with the system.

    $ convox apps
    APP  STATUS

Congratulations! Convox is set up and ready to deploy apps. Try [deploying](/docs/deploying-an-application) one of our sample applications.

<div class="block-callout block-show-callout type-warning">
  <h3>Cost Management</h3>

  <p>The Convox Installer by default provisions an Elastic Load Balancer and 3 t2.small instances, giving you 6GB of memory capacity. This runs the Convox API and Private Registry, and leaves room for 10 512MB containers.</p>

  <p>This configuration costs $85/month according to the <a href="http://calculator.s3.amazonaws.com/index.html">AWS simple cost calculator</a>.</p>

  <p>Each deployed app will provision an additional ELB which starts at $18/month.</p>

  <p>At any time you can <a href="/docs/uninstall-convox">uninstall Convox</a> to delete the resources and stop accruing costs.</p>
</div>
