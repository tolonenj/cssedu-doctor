FROM alpine:3.19 as builder



RUN apk add --update rclone \
    python3; \
    python3 -m venv edudocs; \
    cd edudocs; \
    source ./bin/activate; \
    pip install --upgrade pip; \
    pip install mkdocs; \
    mkdocs new deployment; \
    cd deployment; \
    rm ./docs/*

COPY mkdocs.yml /edudocs/deployment
COPY rclone.conf /root/.config/rclone/rclone.conf

RUN env; \
    cat /root/.config/rclone/rclone.conf

RUN rclone sync ./docs/ allas:cssedu; \
    mkdocs build


FROM nginx
COPY --from=builder /edudocs/deployment/site /usr/share/nginx/html
EXPOSE 80
