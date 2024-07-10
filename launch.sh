#!/bin/bash
docker build -t protobuf_bug .
[[ $1 == --interactive ]] && \
    exec docker run -it -v .:/root/bug_report -w /root/bug_report protobuf_bug
exec docker run -v .:/root/bug_report -w /root/bug_report protobuf_bug ./reproduce.sh
