## Intro

This is an attempt to get a recent version of Postfix running on CentOS or other stable distibutions.

Since current CentOS releases come with somewhat old versions of Postfix but I wanted to use features of newer Postfix versions while staying with CentOS as a base system, I ended up with running a container for Postfix. Alpine contains a reasonably new version of Postfix.

I would have loved to use an official Postfix container, but that doesn't exist. One reason for that might be the fact that Postfix consists of several executables that have to run in parallel, needing an init system that is normally not present in a Docker container. For this container I use chaperone as basic init system. I got the idea from https://github.com/trippd6/postfix .

`/var/spool/postfix` should be mounted to a permanent directory for obvious reasons.

`/mnt/postfix-config` should be mounted to a directory containing:

* `*.cf`: Postfix configuration files that will be copied to `/etc/postfix`.
* `*`: Postfix configuration files that will be processed by `postmap` after being copied.
* `*.sh`: Shell scripts that will be executed, mainly containing `postconf` calls.


## Standard usage

This is available on the Docker Store:

```
docker pull rompe/postfix-alpine
```

In case you want to play a bit more or you happen to be me, there are other options:


## Build

```
git clone https://github.com/rompe/postfix-alpine.git
cd postfix-alpine
docker build . -t rompe/postfix-alpine
```


## Quick test usage

```
mkdir /tmp/postfix-config
mkdir /tmp/postfix-spool
mkdir /tmp/mail

touch /tmp/postfix-config/bla.cf

echo "postconf -e 'mydomain = example.com'" > /tmp/postfix-config/foo.sh
echo "postconf -e 'mydestination = example.com'" > /tmp/postfix-config/bar.sh
echo "root: root" > /tmp/postfix-config/aliases

docker run -p 50025:25 -v /tmp/postfix-config:/mnt/postfix-config:Z -v /tmp/postfix-spool:/var/spool/postfix:Z -v /tmp/mail:/var/spool/mail:Z rompe/postfix-alpine
```

In another terminal:

```
swaks --to root@example.com --server localhost --port 50025
```

## Publish

```
docker login
docker push rompe/postfix-alpine
```
