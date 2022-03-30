# Simple SSH Server over Ubuntu 🛳️ ⛅

This Dockerfile can spawn an SSH server inside Ubuntu (ubuntu20.04 by default).

Use it as follows:

```sh
docker build -t ubuntu-sshd . --build-arg PASSWORD=<some-password>
...

docker run --net=host -t --rm ubuntu-sshd:latest
```

Then to connect to it (if you've launched it locally), `ssh localhost -p 2022`
