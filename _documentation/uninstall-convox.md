---
title: "Uninstalling Convox"
sort: 40
---
Your rack can be uninstalled using the CLI. AWS credentials are required for this process, so please refer to the guide if you need to generate those. To uninstall type:

    $ convox uninstall

This will remove all of the AWS data and services created by Convox.

    Uninstalling Convox...
    Cleaning up registry...
    Deleted ECS Service: Kernel
    Deleted S3 Bucket: convox-settings-l5u6qcekwsq4
    Deleted ECS TaskDefinition: KernelTasks
    Deleted Access Key: AKIAIEP4FSGRQE5GGRRA
    Deleted Access Key: AKIAIIXP3G3F4TX3KY2A
    Deleted IAM User: convox-KernelUser-OC4CV0Q5NU8B
    Deleted IAM User: convox-RegistryUser-1L99G5CIN2YJ2
    Deleted S3 Bucket: convox-registrybucket-182tj69qj9k8y
    Deleted Routing Table: rtb-6306fe07
    Deleted DynamoDB Table: convox-builds
    Deleted DynamoDB Table: convox-releases
    Deleted AutoScalingGroup: convox-Instances-1496N5UFY25LU
    Deleted Security Group: sg-3be3365c
    Deleted Elastic Load Balancer: convox
    Deleted ECS Cluster: convo-Clust-17YAVSE7MRRKH
    Deleted VPC Subnet: subnet-bece8be7
    Deleted Security Group: sg-3ee33659
    Deleted VPC Subnet: subnet-994567ee
    Deleted VPC Subnet: subnet-9490febf
    Deleted Lambda Function: convox-CustomTopic-484343B6HXL5
    Deleted VPC Internet Gateway: igw-b03f76d5
    Deleted CloudFormation Stack: convox
    Deleted VPC: vpc-fd130e98
    Successfully uninstalled.
