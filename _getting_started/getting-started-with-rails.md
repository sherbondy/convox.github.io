---
title: "Getting started with Rails"
sort: 50
---
Convox provides tools for developing and deploying Rails applications. This tutorial will walk through the steps required to create a new Rails project and set it up to work with Convox.

### Prerequisites

- [Docker](https://docs.docker.com/installation/)
- [Convox CLI](/docs/getting-started-with-convox/)

### Creating an app

To get started, create a new rails app. We'll call ours "simple-rails".

    $ rails new simple-rails

### First boot

Change directories into the generated app and boot it with Convox:

    $ cd simple-rails
    $ convox start

Your app should now be up and running. Point your browser to http://&lt;docker host IP&gt;:5000. You should see the Rails welcome page.

![rails-welcome-page](/assets/images/docs/getting-started-with-rails/rails_welcome.png)

List the files in your app directory, and you'll notice 2 new ones, `Dockerfile` and `docker-compose.yml`. Convox uses Docker under the hood for containerization, and these two files contain all the information it needs to build and run your app. When these files don't already exist `convox start` makes some educated guesses and creates the best config files for you that it can. While this is nice, these files are meant as a starting point and can be completely customized. It's important to understand how they work, so let's do a walkthrough.

### Dockerfile


First, let's take a look at the `Dockerfile`:

    FROM rails
    
    WORKDIR /app
    
    COPY Gemfile /app/Gemfile
    COPY Gemfile.lock /app/Gemfile.lock
    RUN bundle install
    
    COPY . /app
    
    CMD ["rails", "server", "-b", "0.0.0.0"]

Blah blah blah. Maybe copy some stuff from the blog post here.

### Adding a Postgres database

Now we'll move onto the docker-compose.yml file and start customizing it to meet our needs. First, let's change the default process name from main to web. Your file should look like this: 

    web:
      build: .
      ports:
        - 5000:3000

Now we'll add a database process using the offical Postgres image from Docker Hub:

    web:
      build: .
      ports:
        - 5000:3000
    db:
      image: postgres

Great! Now we have a database, but the web process doesn't know how to connect to it. We'll tell it how using a link and an environment variable. Update your docker-compose.yml to look like this:

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

Now we just need to make a couple of changes. First, delete the database config file. App config should be done with environment variables instead.

    $ rm config/database.yml

Now edit the Gemfile. Replace this line:

    gem 'sqlite3'

with:

    gem 'pg'

and bundle again:

    $ bundle install

Now start convox:

    $ convox start

Let's generate a scaffold. We'll need to run this with `convox exec` since DATABASE_URL is set on the container, but not in our local environment.

    $ convox exec web rails g scaffold book title:string author:string started_on:date finished_on:date

Run the migration:

    $ convox exec web rake db:migrate

### Deploying to your Convox rack

Create an app.

    $ convox apps create simple-rails
    Creating app simple-rails... OK

Create a database.

    $ convox services create simple-rails-postgres postgres
    Creating service simple-rails-postgres (postgres)... OK, simple-rails-postgres

Fetch the URL and set an environment variable.

    $ convox services info simple-rails-postgres
    Name    simple-rails-postgres
    Status  running
    URL     postgres://postgres:B!*Ke&i^6(k?9Px=GOMm@simple-rails-postgres.cbm068zjzjcr.us-east-1.rds.amazonaws.com:5432/app

    $ convox env set 'DATABASE_URL=postgres://postgres:B!*Ke&i^6(k?9Px=GOMm@simple-rails-postgres.cbm068zjzjcr.us-east-1.rds.amazonaws.com:5432/app'

Configure for production. First put shared config in a new `common-services.yml` file:

    web:
      build: .
      ports:
        - 5000:3000

Put development-specific config in `docker-compose.yml`:

    web:
      extends:
        file: common-services.yml
        service: web
      links:
        - db
      environment:
        - DATABASE_URL=postgres://postgres:@db:5432
      volumes:
        - .:/app
    db:
      image: postgres

Put production-specific config in `docker-compose.yml`:

    web:
      extends:
        file: common-services.yml
        service: web 
