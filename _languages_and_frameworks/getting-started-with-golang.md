---
title: "Getting started with Golang"
sort: 10
---

Convox provides tools for developing and deploying any dockerized application. This tutorial will walk through the steps required to create a new Go project and set it up to work with Convox.

### Prerequisites

- [Docker](https://docs.docker.com/installation/)
- [Convox CLI](/docs/getting-started-with-convox/)

### Creating an app

To get started, create a new `Dockerfile` and `docker-compose.yml` in a new directory. We'll call ours `go-app`.

    $ mkdir go-app
    $ cd go-app

At Convox, we're huge fans of the [Alpine Linux distros from Glider Labs](https://hub.docker.com/r/gliderlabs/alpine/).
They allow us to produce small images, pairing perfectly with Go's static binaries.

However, for this example we're going to use the [official golang image](https://hub.docker.com/_/golang/)
 from docker hub.

Create a `Dockerfile` that looks like this:

    FROM golang:onbuild
    ENV PORT 3000

And a `docker-compose.yml` that looks like this:

    main:
      build: .
      ports:
        - 5000:3000

Convox uses Docker under the hood for containerization,
and these two files contain all the information it needs to build and run your app.


### Simple Go Server

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

### First boot

You can now boot the app with Convox:

    $ convox start

The server should now be up and running. Point your browser to http://&lt;docker host IP&gt;:5000.

If you're using `docker-machine` and your development VM is called `dev`, you can simply:

    $ open http://$(docker-machine ip dev):5000

You should see our application server: any path you visit at this host will get echo'ed back.

![golang-welcome-page](/assets/images/docs/getting-started-with-golang/hello.png)


### Going Further

There are many ways to build your Golang apps with Docker:

- [The Convox Kernel](https://github.com/convox/kernel)
  is a great example of using Alpine linux as the base distro and
  using the `rerun` utility to avoid rebuilding the docker image in development mode
- [Nick Guthier's post](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/)
  shows us just how minimal one can get with static binaries and Go


### Deploying to your Convox rack

Now that you have an app working with `convox start` you can deploy it to production. First create an app in your rack:

    $ convox apps create go-app
    Creating app go-app... OK

Then deploy with:

    $ convox deploy

You should now be able to visit your web app running on Convox!
