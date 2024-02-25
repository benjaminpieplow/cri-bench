# Author: Benjamin Rohner

FROM ubuntu:latest

LABEL version "0.1"
LABEL description "Geekbench as Docker Image"

# Parameters to make updating this easier
ARG sysbench_version="1.0.20+ds-2"
ARG geekbench_version="6.2.2"

# Create folders
RUN mkdir -p /cri-bench/geekbench6 /tmp/geekbench

# Import script and make it usable
ADD ./src/* /cri-bench
RUN ["chmod", "+x", "/cri-bench/cri-bench.sh"]

# Install sysbench
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y sysbench=${sysbench_version}

# Install geekbench 6
ADD https://cdn.geekbench.com/Geekbench-${geekbench_version}-Linux.tar.gz /tmp
RUN tar -xzf /tmp/Geekbench-${geekbench_version}-Linux.tar.gz -C /tmp/geekbench
RUN mv /tmp/geekbench/Geekbench-${geekbench_version}-Linux/* /cri-bench/geekbench6
RUN rm -rf /tmp

# Run the script
ENTRYPOINT [ "/cri-bench/cri-bench.sh" ]