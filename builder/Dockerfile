FROM alpine:3.19 as builder

ENV basedir=edudocs

RUN apk add --update rclone \
    python3; \
    python3 -m venv $basedir; \
    cd $basedir; \
    source .bin/activate; \
    pip install --upgrade pip; \
    pip install mkdocs; \
    mkdocs new deployment; \
    cd deployment; \
    rm ./docs/*

COPY mkdocs.yml /$basedir/deployment

RUN rclone sync ./docs/ allas:cssedu; \
    mkdocs build

FROM nginx
COPY --from=builder /$basedir/deployment/site /usr/share/nginx/html
EXPOSE 80
