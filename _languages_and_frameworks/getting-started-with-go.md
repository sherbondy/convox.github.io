---
title: "Getting started with Go"
sort: 10
---

Convox provides tools for developing and deploying any dockerized application. This tutorial will walk through the steps required to create a new Go project and set it up to work with Convox.

## Prerequisites

- [Docker](https://docs.docker.com/installation/)
- [Convox CLI](/docs/getting-started-with-convox/)

## Creating an app

To get started, create a new `Dockerfile` and `docker-compose.yml` in a new directory. We'll call ours `go-app`.

    $ mkdir go-app
    $ cd go-app

At Convox, we're huge fans of the [Alpine Linux distros from Glider Labs](https://hub.docker.com/r/gliderlabs/alpine/).
They allow us to produce small images, pairing perfectly with Go's static binaries.

However, for this example we're going to use the [official golang image](https://hub.docker.com/_/golang/)
 from Docker Hub.

Create a `Dockerfile` that looks like this:

    FROM golang:1.4

    ENV PORT 5000

    WORKDIR /go/src/app
    COPY . /go/src/app
    RUN go-wrapper download
    RUN go-wrapper install

And a `docker-compose.yml` that looks like this:

    main:
      build: .
      ports:
        - 80:5000
      command: go-wrapper run

Convox uses Docker under the hood for containerization,
and these two files contain all the information it needs to build and run your app.

## Simple Go Server

Now we need an application server. Let's start with something simple in `main.go`:

    package main

    import (
      "fmt"
      "html"
      "log"
      "net/http"
      "os"
    )

    func main() {
      // read config from environment
      port := os.Getenv("PORT")

      // start server
      http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "<h1>Hello, %q</h1>", html.EscapeString(r.URL.Path))
      })
      log.Println("listening=" + port)
      log.Fatal(http.ListenAndServe(":"+port, nil))
    }

For your convenience, the following files can also be checked out from [Github](https://github.com/convox-examples/go-app).

## First boot

You can now boot the app with Convox:

    $ convox start

The server should now be up and running. Point your browser to http://&lt;docker host IP&gt;

If you're using `docker-machine` and your development VM is called `dev`, you can simply:

    $ open http://$(docker-machine ip dev)

You should see our application server: any path you visit at this host will get echo'ed back.

![go-welcome-page](/assets/images/docs/getting-started-with-go/hello.png)


## Let's get minimal

There are many ways to build your Go apps with Docker.
The easiest way to compare them is by the size of the image created.
The default golang image includes not just the Go runtime, but an entire linux distro:

    $ docker build -t go-app .
    $ docker images | grep go-app
    go-app                latest              df6880858cf5        5 hours ago         670.5 MB
    go-app/main           latest              df6880858cf5        5 hours ago         670.5 MB

On the other end of the spectrum,
see [Nick Guthier's post](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/)
for shipping nothing but a static go binary on top of the 0-byte "`scratch`" image.
This method, while a bit more manual (managing ssl certs)
and complex (requires compiling the go app as a separate step from building your image),
can yield images smaller than 50MB!

Here's a middle of the road approach.
We start with a minimal linux runtime and still do the go compilation as part of our build.

Edit your `Dockerfile` to contain:

    FROM gliderlabs/alpine:3.2

    RUN apk-install docker git

    RUN apk-install go
    ENV GOPATH /go
    ENV PATH $GOPATH/bin:$PATH

    RUN go get github.com/ddollar/init

    WORKDIR /go/src/github.com/usr/app
    COPY . /go/src/github.com/usr/app
    RUN go get .

    ENV PORT 5000
    ENTRYPOINT ["/go/bin/init"]
    CMD ["app"]

This will get you Alpine Linux 3.2 and Go 1.4. Edit your `docker-compose.yml` to look like this:

    main:
      build: .
      ports:
        - 80:5000
      command: app

As you can see, we haven't crossed the sub-100MB threshold, but we're almost 4 times smaller!

    $ docker build -t go-app .
    $ docker images | grep go-app
    go-app/main           latest              2cc80122624f        22 seconds ago       174.5 MB
    go-app                latest              2cc80122624f        22 seconds ago       174.5 MB

This minimal version of the app is available as a branch of the example project on [Github](https://github.com/convox-examples/go-app/tree/minimal).

## Deploying to your Convox rack

Now that you have an app working with `convox start` you can deploy it to production. First create an app in your rack:

    $ convox apps create go-app
    Creating app go-app... OK

Then deploy with:

    $ convox deploy

You should now be able to visit your web app running on Convox!
