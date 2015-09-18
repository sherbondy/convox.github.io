---
title: "Developing an Application"
sort: 11
---
## Local development

Local development is hard to get right.
What starts as a simple install script sprawls into its own repository of bash scripts that run to completion on exactly the wrong person's machine.

Convox is the simplest and most intuitive way to leverage Docker for declarative local development.

## Background

Inspired by our work at Heroku and [12 factor app design](http://12factor.net),
we seek a declarative solution that has a clean contract with the underlying operating system.

We found tools like [foreman][foreman] got us close, but all too often subtle differences in
development and production execution environments lead to errors in live systems that were
often hard to reproduce, let alone debug.

Linux containers solve many of these issues, including the [dev/prod parity][dev-prod] problem, by making virtualization cheap and reliable.
Docker is the de-facto open source standard for building and running linux containers:
by giving linux containers an API, Docker gives them a standard.

We believe a development environment should have these properties:

  - *exhaustive*: _anything_ not referenced in the manifest should not be available to a running system.
  - *declarative*: make definitions and references to other definitions. order should be inferred, not encoded.
  - *reproducible*: deterministic builds, common runtimes, and explicit environments make dev/prod parity possible

## The Manifest(s)

The manifest allows you to describe everything you need to run any application
consisting of containerized linux processes and cloud services.

Convox uses three files to build and run your development environment:

  - A `docker-compose.yml` file or a Procfile (referred to as the "manifest")
  - An optional `Dockerfile` to document your build (can be used instead of a manifest)
  - An optional `.env` to contain development secrets

Only one of: `docker-compose.yml`, `Procfile`, or `Dockerfile` is required.
`convox start` will generate a `docker-compose.yml` from a `Dockerfile`.
`convox start` will generate a `docker-compose.yml` AND a `Dockerfile` from a `Procfile`.

You will most likely need to customize these generated files until we add better project detection ([pull requests welcome][rack-github]!).

The `Dockerfile` and `.env` file are there to support information that is referenced in the manifest
and required for a deterministic and declarative way to run your software.
This allows the manifest to act as a single source of truth.

The build instructions, in the `Dockerfile`, define how to create your software from source code.

The environment data, in the `.env`, allows you to configure your development environment.

Before we dive into what these files look like, let's take a look at the Convox commands we'll need to be familiar with.

## Convox commands

### `convox start`

Convox supports a [Docker][docker]-based local development workflow via the `convox start`
[CLI][cli] command.

Like [docker-compose][compose], `convox` is a tool for defining and running
multi-container applications with Docker.
However, `convox start` is only focused on local development and offloads as much work as possible
to Docker itself.

`convox start` builds and runs the processes declared in your application manifest with environment
stored in a `.env` file and interleaves the standard output and standard error of those processes.
It allows Docker to act as build service, runtime, and process manager.

For example:

    $ cd $GOPATH/src/github.com/convox/rack/examples/procfile
    $ convox start
    RUNNING: docker build -t knexsfvjdc /Users/csquared/projects/go/src/github.com/convox/rack/examples/procfile
    Sending build context to Docker daemon 8.192 kB
    Step 0 : FROM ruby:2.2.2
     ---> 9664620d4c2a
    Step 1 : EXPOSE 3000
     ---> Running in d2894bf8d64b

    ...

    RUNNING: docker tag -f ejjcgsgjgh procfile/web
    RUNNING: docker tag -f ejjcgsgjgh procfile/worker
    web    | running: docker run -i --name procfile-web -p 5000:3000 procfile/web sh -c ruby web.rb
    web    | [2015-09-18 06:16:53] INFO  WEBrick 1.3.1
    web    | [2015-09-18 06:16:53] INFO  ruby 2.2.2 (2015-04-13) [x86_64-linux]
    web    | == Sinatra (v1.4.6) has taken the stage on 3000 for development with backup from WEBrick
    web    | [2015-09-18 06:16:53] INFO  WEBrick::HTTPServer#start: pid=7 port=3000
    worker | running: docker run -i --name procfile-worker -p 5100:3000 procfile/worker sh -c ruby worker.rb
    worker | working!
    worker | working!
    worker | working!
    ^C
    $


A `CTRL+C` on the `convox start` process stops everything and exits.

By using Docker, Convox is able to achieve fast setup and teardown, dev/prod parity, and an intuitive developer experience behind a simple command.


### `convox exec <process> <command>`

Convox supports executing a command within the context of one of your local running processes via the `convox exec`[CLI][cli] command.

This allows you to administer your development app via [one-off processes][12fac-oneoff] using the same commands you would pass to `convox run`. For example, you could run database migrations via:

    $ convox exec web rake db:migrate

Depending on your base image's operating system, you can can also start a shell for interactive debugging:

    $ convox exec main bash
    $ convox exec web sh

Or start an interactive session with your favorite REPL:

    $ convox exec web rails console    # rails
    $ convox exec web node             # node.js
    $ convox exec main psql <host>     # SQL session

Your only limit is the software in your manifest!

## The Manifest(s) (continued)

Let's take a look at the manifest, the build instructions, and the environment
and how they interact in the context of the [Convox Sinatra Example](https://github.com/convox-examples/sinatra).

### `docker-compose.yml`

The `docker-compose.yml` looks like this:

    web: &web
      build: .
      command: bin/web
      environment:
        - RACK_ENV=development
        - POSTGRES_URL=postgres://postgres:password@postgres:5432/app
        - REDIS_URL=redis://redis:password@redis:6379/0
      ports:
        - 3000:3000
      volumes:
        - .:/app
      links:
        - postgres
        - redis
    worker:
      <<: *web
      ports: []
    redis:
      image: convox/redis
    postgres:
      image: convox/postgres


The `&web` reference is yaml syntax that allows you to name and copy parameters from one hash to another.
This allows us to assign all the same configuration to `worker` process with the syntax `<<: *web`.
Notice how we have to then clear the port mappings. Why we do this will become clear below.

Each top level key defines the configuration necessary to run a process for your application.
If the parameters look familiar, it is because they are.
Everything [docker compose][compose-conf] supports is also supported here.

This particular manifest describes four processes: `web`, `worker`, `postgres`, and `redis`.
The `postgres` and `redis` processes are both images, which means they are already built.
They are pulled from [Docker Hub][docker-hub] during `convox start` using `docker pull`.

The `web` process has a `build` key.
That instructs `convox start` to build an image using the `Dockerfile` in the specified directory.

The `ports` key is passed to `docker run` and determines port mappings for the host VM.
In this example, the port 5000 of the docker host machine is being mapped to port 3000 in the container.

The `worker` process configuration is copied from web because it is built with the same codebase,
talks to the same database, and otherwise shares everything in common with the `web` process except the command.

And the ports. We've already mapping `3000` on the host container to the exposed `3000` on `web`.
Because we can't have two processes on the same port, this will cause an error starting the `worker`.

The worker doesn't need that port for anything anyways and this becomes explicit in the manifest.

<div class="block-callout block-show-callout type-info">
<h3>Ports</h3>
<p>You can either explicitly map ports from the host operating system via "HOST:CONTAINER" syntax
in the manifest, but that can lead to conflicts.
This is usually only necessary few to one process in your application to explicitly define a port and
that is usually to communicate with an external load balancer..
</p>

<p>
When possible, it is better to avoid picking ports and to use container linking and/or `docker port` to query
exposed port values.
This
allows the image to bind to a known port within a container but still allow
docker to map arbitrary ports to your container.
</p>
</div>

The `volumes` key is passed to `docker run` to mount a volume for read and write access into the running container.
This is useful for mapping in config files that exist in your source repository or for mapping the
source code directories into the docker container so you can do code reloading on change detection.

The `links` key defines dependencies on other processes named in this file.
`convox start` uses [docker container linking][docker-links] to connect processes in development.
In general, it is a good practice to have containers wait for connections they expect to become available.
This way if the main process completes startup before the database, you don't throw an error because the connection is not there.

You can read more about [the docker-compose configuration options][compose-conf] on Docker's website.

### `Dockerfile`

A `Dockerfile` looks like this:

    FROM gliderlabs/alpine:3.2

    RUN apk-install ruby ruby-bundler ruby-io-console ruby-kgio ruby-pg ruby-raindrops ruby-unicorn

    WORKDIR /app

    # cache bundler
    COPY Gemfile /app/Gemfile
    COPY Gemfile.lock /app/Gemfile.lock
    RUN bundle install

    # copy the rest of the app
    COPY . /app

    ENTRYPOINT ["bundle", "exec"]
    CMD ["bin", "web"]

It describes the steps you need to build and run a unix process.

The `FROM` declaration specifies your "base image".
For applications you are developing, it is most common to start with a minimal operating
system or a language-specific image maintained by that language's community.

In Docker, a build takes place in terms of the "build context", which is basically a
snapshot of the directory you're currently in when you run `docker build` or `convox start`.

`COPY` (and `ADD`, not shown here) commands move files from the build context into the
image. `RUN` executes the given command in the context of the image.

`EXPOSE` allows docker to know which tcp or udp ports the application binds to.
If you do not publish the port it is only available via name to a [linked service][docker-links].



`ENTRYPOINT` and `CMD` control the default command that is executed via `docker run`.
You can think of `CMD` as setting a default, whereas `ENTRYPOINT` should do any
necessary runtime configuration. This may include adding config files from a known
location, setting up the environment, or waiting on resources to become available.

It is extremely common for entrypoint scripts to do their work in shell and end with:

    exec "$@"

Both `ENTRYPOINT` and `CMD` can be overridden at runtime. In fact, everything in the
build can be overridden or augmented with information passed to `docker run`.
That's the very reason we need something like `docker-compose.yml`!

To be fair, every deviation from the vanilla `docker run <image>` invocation has the potential
to change behavior.
This is why a `Dockerfile` alone is not enough to describe an application.

For more information on how to write Dockerfiles, see the [Docker user guide][docker-ug] and the [Dockerfile reference][dockerfile-ref].

### `.env`

A `Dockerfile` and `docker-compose.yml` *should* be enough to describe your application.
Where there are no private credentials or all linked services have known,
deterministic credentials, a `Dockerfile` and `docker-compose.yml` are enough.

However, we have found that some credentials are only possible or significantly easier to generate outside of the application.
This can often be the case with cloud resources; there just isn't a simple solution to running large parts of the internet on your laptop.

To support this use-case, we automatically populate `enivronment` variables that are listed in the manifest but not declared to equal anything (no equals sign) with `KEY=VALUE` pairs from your `.env` file.

## Bringing it together

Instead of telling you, let's use convox to show exactly how the `.env` file works.

We can start with a simple `docker-compose.yml` and a minimal linux distribution so we can have the `env` command available.
Since we don't need to install anything on top of the base image, we don't need a `Dockerfile`.

Here's a `docker-compose.yml` that we can use:

    main:
      image: gliderlabs/alpine:3.2
      environment:
        - TEST_ONE
        - TEST_TWO=
        - TEST_THREE=3
      command: env | grep TEST

Now simply running `convox start`:

    RUNNING: docker pull gliderlabs/alpine:3.2
    3.2: Pulling from gliderlabs/alpine
    2cc966a5578a: Already exists
    Digest: sha256:10e5a41452c61b36a936384c6162588142d95299ea8b67fa7e52eef6f934bd88
    Status: Image is up to date for gliderlabs/alpine:3.2
    RUNNING: docker tag -f gliderlabs/alpine:3.2 test-env/main
    main | running: docker run -i --name test-env-main -e TEST_ONE= -e TEST_TWO= -e TEST_THREE=3 test-env/main sh -c env | grep TEST
    main | TEST_TWO=
    main | TEST_THREE=3
    main | TEST_ONE=

Here you can see we build the image, then print out the exact command used to run the container, and then run the command.
Most servers won't exit, but our command does.
Notice we get what we expect: `TEST_THREE` has a value, but `TEST_ONE` and `TEST_TWO` do not.

Now let's create a `.env` file:

    TEST_ONE=1
    TEST_TWO=2
    TEST_THREE=4

What do you think will happen? As stated above, we'll populate variables that are undeclared, ie: have not equals sign.

This is to fit with the expected meaning: `TEST_ONE` is declared to exist, whereas we interpret `TEST_TWO=`
as being declared _and initialized to the empty string_.
It also does not overwrite `TEST_THREE` to follow [docker-compose][compose], though perhaps it should... [let us know what you think][issues-github]!

Sure enough, `convox start | grep TEST` gives us what we expect:

    main | running: docker run -i --name test-env-main -e TEST_ONE=1 -e TEST_TWO= -e TEST_THREE=3 test-env/main sh -c env | grep TEST
    main | TEST_TWO=
    main | TEST_THREE=3
    main | TEST_ONE=1

This is important: it preserves the *declarative* nature of your architecture, but still gives you flexibility.
You can still avoid committing secrets to your repository, which makes for happy security engineers everywhere :).

[cli]: /docs/getting-started-with-convox
[docker]: https://docs.docker.com/installation/
[compose]: https://docs.docker.com/compose/
[foreman]: https://github.com/ddollar/foreman
[docker-run]: https://docs.docker.com/docker/
[docker-hub]: https://hub.docker.com/
[compose-conf]: https://docs.docker.com/compose/yml
[dockerfile-ref]: http://docs.docker.com/reference/builder/
[docker-ug]: https://docs.docker.com/userguide/dockerimages/#building-an-image-from-a-dockerfile
[dev-prod]: http://12factor.net/dev-prod-parity
[12fac-oneoff]: http://12factor.net/admin-processes
[docker-links]: https://docs.docker.com/userguide/dockerlinks/
[rack-github]: https://github.com/convox/rack
[issues-github]: https://github.com/convox/convox.github.io/issues/new
