FROM alpine:3.19 as builder

WORKDIR /edudocs/deployment

COPY mkdocs /edudocs/deployment

RUN mkdir -p ~/.config/rclone /edudocs/deployment/docs; \
    echo -e "[allas]\ntype = swift\nenv_auth = true" > ~/.config/rclone/rclone.conf; \
    apk add --update rclone \
    python3; \
    python3 -m venv /edudocs; \
    source /edudocs/bin/activate; \
    pip install --upgrade pip; \
    pip install mkdocs mkdocs-material; \
    rclone sync allas:css-edu-tutorials /edudocs/deployment/docs; \
    find /edudocs/deployment/docs -name "*.md" -exec sed -i 's/\..*kuvat\//https:\/\/a3s.fi\/imgs\//g' {} \;; \
    mkdocs build -f /edudocs/deployment/mkdocs.yml

FROM nginx
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
    chown nginx.root /var/cache/nginx /var/run /var/log/nginx && \
    # users are not allowed to listen on privileged ports
    sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf && \
    sed -i.bak 's/server_name\(.*\)localhost;/add_header Access-Control-Allow-Origin https:\/\/a3s.fi always;/' /etc/nginx/conf.d/default.conf && \
    # add a rule to accept fonts from a different domain.
#    echo "\
#server {\
#    listen 8081;\
#    location ~* \.(?:woff|woff2|ttf)$ {\
#        add_header Access-Control-Allow-Origin "https://a3s.fi";\
#    }\
#}" > /etc/nginx/conf.d/font_rule.conf && \

    # Make /etc/nginx/html/ available to use
    mkdir -p /etc/nginx/html/ && chmod 777 /etc/nginx/html/ && \
    # comment user directive as master process is run as user in OpenShift anyhow
    sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

COPY --from=builder /edudocs/deployment/site /usr/share/nginx/html
EXPOSE 8081
