---
title: "Deploying an Application"
sort: 20
group: "Getting Started"
---
Applications can be deployed to Convox via the `convox deploy` [CLI](https://github.com/convox/cli) command.

## Deploying an example app

To quickly see Convox deployment in action, you can clone one of our [example apps](https://github.com/convox-examples).

    $ git clone git@github.com:convox-examples/sinatra.git

Change into the sinatra directory and deploy the application.

    $ cd sinatra
    $ convox apps create
    $ convox deploy

## Deploying your own app

Deploying your app on Convox is easy. To deploy, simply run:

    $ cd ~/myapp
    $ convox apps create myapp
    $ convox deploy --app myapp

<div class="block-callout block-show-callout type-info">
  <h3>App Names</h3>
  <p>Passing an app name with <code>--app</code> is optional. If you do not provide one, the name of your current directory will be used as the app name.</p>

  <p>App names can be made up of alphanumeric characters and dashes.</p>
</div>

When you create a new app, Convox provisions all of the AWS infrastructure required to support your app. This will take a few minutes.

The first deployment can also be a little slow as all of the Docker images are built. Subsequent deploys of the same app will be significantly faster since they will take advantage of Docker layer caching.

The Convox CLI will print live updates as the deployment proceeds:

    $ convox deploy --app myapp
    Uploading... OK
    RUNNING: docker build -t xmjsczmcug /tmp/repo044075326/clone
    Sending build context to Docker daemon 92.16 kB
    Sending build context to Docker daemon
    Step 0 : FROM ruby:2.2.2
    2.2.2: Pulling from ruby
    ...

when the build finishes the release ID will be shown.

    Releasing... OK, RANLOWQFMRF

If necessary, the CLI will also wait for the app's load balancer to become available.

    Waiting for app...

When the load balancer becomes available the deploy is finished. Any processes with open ports will be listed.

    main: http://myapp-62376059.us-east-1.elb.amazonaws.com:5000
