FROM alpine:3.19

WORKDIR /edudocs

RUN mkdir -p ~/.config/rclone; \
    echo -e "[allas]\ntype = swift\nenv_auth = true" > ~/.config/rclone/rclone.conf; \
    apk add --update rclone \
    python3; \
    python3 -m venv /edudocs; \
    source /edudocs/bin/activate; \
    pip install --upgrade pip; \
    pip install mkdocs; \
    mkdocs new deployment; \
    cd /edudocs/deployment; \
    rm /edudocs/deployment/docs/*
