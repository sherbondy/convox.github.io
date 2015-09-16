---
title: "One-off Runs"
sort: 15
---

It's possible to run one-off commands against your Convox apps using the `convox run` CLI command. These can be useful for administrative tasks like database migrations as well as degugging and inspection.

Since a Convox app can be composed of many different process types, you must specify the type in which you want to run the command as the first argument. The second argument is the command to be run. For example, if you have an app with a web and a worker process like this

    $ convox ps
    ID            NAME    RELEASE      CPU    MEM     STARTED      COMMAND
    551967b75abd  web     RHQZEJZFCSD  0.39%  21.04%  2 hours ago  rails server -b 0.0.0.0
    f5ec95c38f58  worker  RHQZEJZFCSD  0.00%  30.35%  2 hours ago  sidekiq 

you can run a command in a container based off of the web image by issuing the following command:

    $ convox run web ls
    Dockerfile    README.rdoc  bin     config.ru   lib     test
    Gemfile       Rakefile     blah    db          log     vendor
    Gemfile.lock  app    config  docker-compose.yml  public

By default this will start an interactive session that runs until the command on Convox exits. Since the session is interactive, you can do things more interesting than `ls`, for example:

    $ convox run web bash
    root@3e4160f0c4d0:/app#

Now you're in a bash shell on the container. When you're done type "exit" or hit ctrl+D:

    root@3e4160f0c4d0:/app# exit
    $

## Detached runs

In some cases you might not want an interactive session. You might just want to fire off a command and check on the results later. In those cases you can use the `--detach` option:

    $ convox run web bin/long_task --detach
    Running `bin/long_task` on web... OK
