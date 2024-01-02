FROM alpine:3.19 as builder

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
    rm /edudocs/deployment/docs/*; \
    rclone sync allas:cssedu /edudocs/deployment/docs; \
    mv -f /edudocs/deployment/docs/mkdocs.yml /edudocs/deployment/; \
    mkdocs build


FROM nginx
RUN sed -i s/80\;/8080\;/g /etc/nginx/conf.d/default.conf
COPY --from=builder /edudocs/deployment/site /usr/share/nginx/html
EXPOSE 8080
