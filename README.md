This is an attempt to get a recent version of Postfix running on CentOS.

Since current CentOS releases come with somewhat old versions of Postfix but I wanted to use features of newer Postfix versions while staying with CentOS as a base system, I ended up with running a contaienr that for Postfix. Alpine contains a reasonably new version of Postfix.

I would have loved to use an official Postfix container, but that doesn't exist. One reason for that might be the fact that Postfix consists of several executables that have to run in parallel, needing an init system that is normally not present in a Docker container. For this container I use chaperone as basic init system. I got the idea from https://github.com/trippd6/postfix .

`/var/spool/postfix` should be mounted to a permanent directory for obvious reasons.

`/mnt/postfix-config` should be mounted to a directory containing:

* `*.cf`: Postfix configuration files that will be copied to `/etc/postfix`.
* `*` Postfix configuration files that will be processed by `postmap` after being copied.
* `*.sh`: Shell scripts that will be executed, mainly containing `postconf` calls.
