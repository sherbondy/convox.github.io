---
title: "Rack Update Process"
sort: 10
---

The Convox CLI enables you to update your Convox rack by using the `convox rack update` command. This document covers the basics of how that process works and provides some tips on how to structure your apps to avoid downtime.

When you run `convox rack update`, the CLI will check for the latest published rack version. If your version is behind, it will initiate an update. You can check your version using the `convox -v` command.

When it's determined that your rack should be updated the update process:

Downloads a new CloudFormation json file from S3
Initiates an update on your convox CloudFormation stack using the new template

## API Downtime

None if Cluster EC2 instances aren't rolled
Some if they are rolled since there is only one api instance

## App Downtime

Can be avoided by running at least 2 instances of critical processes

## Required Releases

Explain how required releases work and why they're necessary.
(Don't say anything about edge releases yet because non-employees don't have access to information about them yet).
