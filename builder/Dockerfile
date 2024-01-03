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
    find /edudocs/deployment/docs -name "*.md" -exec sed -i 's/\..*kuvat\//https:\/\/a3s.fi\/cssedu-images\//g' {} \; \
    mkdocs build

FROM nginx
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
    chown nginx.root /var/cache/nginx /var/run /var/log/nginx && \
    # users are not allowed to listen on privileged ports
    sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf && \
    # Make /etc/nginx/html/ available to use
    mkdir -p /etc/nginx/html/ && chmod 777 /etc/nginx/html/ && \
    # comment user directive as master process is run as user in OpenShift anyhow
    sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

COPY --from=builder /edudocs/deployment/site /usr/share/nginx/html
EXPOSE 8081
