---
title: "Updating Convox"
sort: 70
group: "Documentation"
---
Convox is frequently releasing new versions of the [kernel](https://github.com/convox/kernel) and [cli](https://github.com/convox/cli) with features and bugfixes. To get the latest versions do:

`$ convox update && convox system update`


## 1. Check Versions

    $ convox --version
    client: 20150723050710
    server: 20150723050744 (demo.convox.io)

    $ curl http://convox.s3.amazonaws.com/release/latest/version
    20150727173559

The convox server is on version `20150723050744`, a release made on July 23rd. There is a newer version `20150727173559`, a release made on July 27th.


## 2. Update CLI

    $ convox update
    Updating: OK, 20150727173556

## 3. Update Server

    $ convox system update
    Name       convox
    Status     updating
    Version    20150727173559
    Count      3
    Type       t2.small
