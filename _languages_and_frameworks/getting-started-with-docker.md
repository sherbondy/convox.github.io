---
title: "Getting started with Docker"
sort: 1
---
Convox provides tools for developing and deploying any dockerized application. This tutorial will walk through the steps required to create a new Docker project and set it up to work with Convox.

## Prerequisites

- [Docker](https://docs.docker.com/installation/)
- [Convox CLI](/docs/getting-started-with-convox/)

## Creating an app

To get started, create a new `Dockerfile` and `docker-compose.yml` in a new directory. We'll call ours `apache-app`.

    $ mkdir apache-app
    $ cd apache-app

Your `Dockerfile` should look like this:

    FROM httpd

And your `docker-compose.yml` should look like this:

    main:
      build: .
      ports:
        - 80:80

Convox uses Docker under the hood for containerization, and these two files contain all the information it needs to build and run your app.

## First boot

You can now boot the app with Convox:

    $ convox start

Apache should now be up and running. Point your browser to http://&lt;docker host IP&gt;


If you're using `docker-machine` and your development VM is called `dev`, you can simply:

    $ open http://$(docker-machine ip dev)

You should see the "It works!" welcome page.

![httpd-welcome-page](/assets/images/docs/getting-started-with-docker/it-works.png)


## Updating our `Dockerfile`

The [docs of the httpd image](https://hub.docker.com/_/httpd/) instruct us to copy a folder
to the location `/usr/local/apache2/htdocs/` to serve our html files.

Let's create the folder

    $ mkdir public-html

And a simple index page:

    $ echo "<h1>Hello from Convox</h1>" > public-html/index.html

Now we can update our `Dockerfile` to:

    FROM httpd
    COPY ./public-html/ /usr/local/apache2/htdocs/

Use ctrl+c to stop convox and restart your app with

    $ convox start

You should now be able to refresh your app and see the new page.


## Sync volumes

Restarting convox every time you make a change can be painful. This is why `docker-compose` and `convox` support the **volumes** directive in the `docker-compose.yml`.

This will keep the container filesystems in sync with your local filesystem. Edit your `docker-compose.yml` to look like this:

    main:
      build: .
      ports:
        - 80:80
      volumes:
        - ./public-html/:/usr/local/apache2/htdocs/

Restart your application with

    $ convox start

Now when you change files in the `./public-html` directory of your local filesystem the changes are automatically synced to your development container.

Let's add some emphasis to our `index.html`:

    <h1>Hello from Convox!</h1>

You can now refresh the page in your browser and should see your new, more emphatic index!


## Deploying to your Convox rack

Now that you have an app working with `convox start` you can deploy it to production. First create an app in your rack:

    $ convox apps create simple-apache
    Creating app simple-apache... OK

Then deploy with:

    $ convox deploy --app simple-apache

You should now be able to visit your web app running on Convox!
