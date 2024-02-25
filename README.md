# Welcome to cri-bench
This docker image runs a script with a slew of tests to benchmark a system, from within Docker.

# How to use
The benchmark can be simply run with (hint: replace "docker" with "podman" on CentOS);
```
docker run benjaminpieplow/cri-bench:cpu-latest
```

## Customization
The `sysbench` test lengths can be customized by appending the desired seconds, by default they will run 60s each, this command shortens it to 10;
```
docker run benjaminpieplow/cri-bench:cpu-latest 10
```

To run the container interactively (notably - to allow you to easily break off a test);
```
docker run -it benjaminpieplow/cri-bench:cpu-latest 10
```
