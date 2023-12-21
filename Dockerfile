FROM libpod/alpine

RUN apk add s3fs-fuse \
    ca-certificates \
    bash \
    git \
    openssh \
    python3 \
    python3-dev \
    py3-pip \
    build-base && \
    pip install --upgrade pip; \
    pip install mkdocs; \
    mkdocs new cssedu; \
    cd cssedu; \
    echo "# Hello world" > ./docs/index.md; \
    pwd; \
    whoami; \
    mkdocs serve --dev-addr localhost:80

CMD ["cat", "/dev/null"]
