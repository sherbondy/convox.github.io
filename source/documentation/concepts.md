---
title: "Concepts"
---
## Rack

A Convox Rack is an [App](#section-apps) deployment platform that runs in your AWS account. A rack has a set amount of memory and CPU resources that can be shared by the [Processes](#section-processes) of one or many Apps.

## Apps

An App is a collection of [Processes](#section-processes) that share a common [Environment](#section-environment).

An App is created from a single source repository.

## Processes

A Process is the smallest individual unit of execution. An [App](#section-apps) is composed of one or more Processes defined by a `docker-compose.yml` file.

A Process maps to a single Docker image and an [Environment](#section-environment) inherited from the [App](#section-apps) – plus any linked [Services](doc:services).

A Process can be connected to other Processes or external services using a [Link](#section-links).

## Ports

A Port allows a [Process](#section-processes) to accept traffic from the Internet.

A [Process](#section-processes) can optionally define one or more Ports.

## Builds

A Build represents a collection Docker images, one for each [Process](#section-processes), that is created from the source repository for an [App](#section-apps).

## Releases

Every time a [Build](#section-builds) is created or the [Environment](#section-environment) changes a new Release will be created. A Release can be [Deployed](#section-deployment) to become the live version of the application.

## Deployment

Deploying sets a [Release](#section-releases) to be the new live version of the app.

## Environment

The Environment is a collection of key/value pairs for an [App](#section-apps) that will be set as environment variables during runtime.

Use Environment variables for application-level configuration.

## Services

A service is a resource, either hosted by a third party or defined by a Docker image, that can be shared across apps and clusters. Ex: Postgres, Redis.

## Links

Links expose [Process](#section-processes) and [Service](#section-services) interfaces to each other within the app. For example, a worker process might be linked to a Redis service from which it fetches jobs.
