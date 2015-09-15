---
title: "Getting started with Rails"
sort: 50
---
Convox provides tools for developing and deploying Rails applications. This tutorial will walk through the steps required to create a new Rails project and set it up to work with Convox.

## Prerequisites

- [Docker](https://docs.docker.com/installation/)
- [Convox CLI](/docs/getting-started-with-convox/)

## Creating an app

To get started, create a new rails app. We'll call ours **simple-rails**.

    $ rails new simple-rails

## First boot

Change directories into the generated app and boot it with Convox:

    $ cd simple-rails
    $ convox start

Your app should now be up and running. Point your browser to http://&lt;docker host IP&gt;:5000. You should see the Rails welcome page.

![rails-welcome-page](/assets/images/docs/getting-started-with-rails/rails_welcome.png)

List the files in your app directory, and you'll notice 2 new ones, `Dockerfile` and `docker-compose.yml`. Convox uses Docker under the hood for containerization, and these two files contain all the information it needs to build and run your app.

When these files don't already exist `convox start` makes some educated guesses and creates the best config files for you that it can. While this is nice, these files are meant as a starting point and can be completely customized. Let's edit `docker-compose.yml` to boot a Postgres container to be used in development mode.

## Adding a Postgres process

To use a Postgres container in development we need to describe it and link it to **web**, which we'll rename from **main**. Edit your `docker-compose.yml` to look like this:

    web:
      build: .
      ports:
        - 5000:3000
      links:
        - db
      environment:
        - DATABASE_URL=postgres://postgres:@db:5432
    db:
      image: postgres

The links item does a few things, but most importantly it adds a "db" entry to the `/etc/hosts` file on the web container, pointing to the IP address of the db container.

The environment item creates an environment variable, DATABASE_URL which stores a URL to the database. The default postgres image boots a database with a user called "postgres" with no password, running on port 5432. With this information, your rails app should be able to connect to the database.

Now we need to make a couple of changes to the app itself. First, delete the database config file so that DATABASE_URL will be used.

    $ rm config/database.yml

Now edit the `Gemfile`. Replace this line:

    gem 'sqlite3'

with:

    gem 'pg'

and run bundler:

    $ bundle install

## Sync volumes

Now we're ready to start editing the rails app, but first we should add a **volumes** directive to `docker-compose.yml`. This will keep the container filesystems in sync with your local filesystem. Edit your `docker-compose.yml` to look like this:

    web:
      build: .
      ports:
        - 5000:3000
      links:
        - db
      environment:
        - DATABASE_URL=postgres://postgres:@db:5432
      volumes:
        - .:/app
    db:
      image: postgres

## Add some functionality

Let's generate a scaffold so we can see Rails working. We'll make a trivial app to record books reading or read. Run the command with `convox exec` since DATABASE_URL is set on the container, but not in our local environment.

    $ convox exec web rails g scaffold book title:string author:string started_on:date finished_on:date

Run the migration:

    $ convox exec web rake db:migrate

Now you should be able to navigate to http://&lt;docker host ip&gt;:5000/books and see a listing of books. You should be able to enter a book and save the record in your containerized database.

## Deploying to your Convox rack

Now that you have an app working with `convox start` you can deploy it to production. First create an app in your rack:

    $ convox apps create simple-rails
    Creating app simple-rails... OK

Deployed apps should use hosted databases, not containers, so provision a Postgres database for your app to use:

    $ convox services create simple-rails-postgres postgres
    Creating service simple-rails-postgres (postgres)... OK, simple-rails-postgres

Fetch the URL and set an environment variable.

    $ convox services info simple-rails-postgres
    Name    simple-rails-postgres
    Status  running
    URL     postgres://postgres:KEDS6tKPZb1iffVB8IXi@postgres1.cbm068zjzjcr.us-east-1.rds.amazonaws.com:5432/app 

Attach the database to your app using the 

    $ convox env set DATABASE_URL=postgres://postgres:KEDS6tKPZb1iffVB8IXi@postgres1.cbm068zjzjcr.us-east-1.rds.amazonaws.com:5432/app 

Now we're ready to deploy the app:

    $ convox deploy

When the deployment finishes the URL of the app will be returned:

    Waiting for app... OK
    web: http://simple-rails-764877228.us-east-1.elb.amazonaws.com:5000 

Scale down the db process since we're using a hosted database:

    $ convox scale simple-rails-postgres --count 0

To finish up, run the database migrations on your production database:

    $ convox run web rake db:migrate

You should now be able to visit `/books` and see your web app running on Convox!
