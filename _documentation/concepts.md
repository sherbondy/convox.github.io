---
title: "Concepts"
sort: 10
group: "Documentation"
---
### Apps

An App is a collection of Processes that share a common Environment.

An App is created from a single source repository.

### Processes

A Process is the smallest individual unit of execution. An App is composed of one or more Processes defined by a `docker-compose.yml` file.
A Process maps to a single Docker image and an Environment inherited from the App – plus any linked Services.

A Process can be connected to other Processes or external services using a Link.

### Ports

A Port allows a Process to accept traffic from the Internet.

A Process can optionally define one or more Ports.

### Builds

A Build represents a collection Docker images, one for each Process, that is created from the source repository for an App.

### Releases

Every time a Build is created or the Environment changes a new Release will be created. A Release can be Deployed to become the live version of the application.

### Deployment

Deploying sets a Release to be the new live version of the app.

### Environment

The Environment is a collection of key/value pairs for an App that will be set as environment variables during runtime.

Use Environment variables for application-level configuration.

### Services

A service is a resource, either hosted by a third party or defined by a Docker image, that can be shared across apps and clusters. Ex: Postgres, Redis.

### Links

Links expose Process and Service interfaces to each other within the app. For example, a worker process might be linked to a Redis service from which it fetches jobs.
