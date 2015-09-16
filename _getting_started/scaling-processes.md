---
title: "Scaling Processes"
sort: 40
---
### Scaling process concurrency

You can scale the number of application processes using the `convox scale` command. For example, to scale the "web" process up, use the following command:

    $ convox scale web --count 2
    PROCESS  COUNT  MEM
    postgres 1      256
    redis    1      256
    web      2      256
    worker   1      256

    $ convox scale postgres --count 0
    PROCESS  COUNT  MEM
    postgres 0      256
    redis    1      256
    web      2      256
    worker   1      256

This schedules a second web process to run. Updating the application configuration and starting the second process may take a few seconds.You can verify the running formation using the `convox ps` command. For example:

    $ convox ps
    ID            PROCESS   RELEASE      MEM    COMMAND
    12f1f51366ea  postgres  RGJAINPIBLP  256    /docker-entrypoint.sh postgres
    9798529ca0ff  redis     RGJAINPIBLP  256    /docker-entrypoint.sh redis-server /tmp/redis.conf
    33c691d273cc  web       RGJAINPIBLP  256    sh -c bin/web
    bc15af240d69  web       RGJAINPIBLP  256    sh -c bin/web
    f850e426dfe5  worker    RGJAINPIBLP  256    sh -c bin/worker

### Scaling process memory

You can also scale the memory available to a process using the `convox scale` command. For example, to double the memory of the web process, use the following command:

    $ convox scale web --memory 512
    PROCESS  COUNT  MEM
    postgres 1      256
    redis    1      256
    web      2      512
    worker   1      256

This schedules two new web processes to come up with 512 MB of memory, then stops the 256 MB web processes.

### Capacity

Your dedicated Convox Rack is a set of instances, each with a fixed amount of memory (i.e. 2.0 GB on a t2.small). It is possible to ask for a process count and memory that exceed this capacity. If you do this the `scale` configuration will change, but the actual set of running processes will not:

    $ convox scale web --count 4 --memory 4096
    PROCESS  COUNT  MEM
    redis    0      256
    web      4      4096
    worker   1      256
    postgres 0      256

    $ convox ps
    ID            PROCESS  RELEASE      MEM    COMMAND
    f850e426dfe5  worker   RGJAINPIBLP  256    sh -c bin/worker
    2dc18eaee697  web      RGJAINPIBLP  512    sh -c bin/web
    6829d5c734e9  web      RGJAINPIBLP  512    sh -c bin/web

The container service keeps the last configuration running until the new configuration successfully starts.

To increase your Convox Rack capacity, see the `convox system scale` command or contact support@convox.com
