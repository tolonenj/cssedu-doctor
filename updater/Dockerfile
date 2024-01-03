FROM cssedu-generator:latest as builder

WORKDIR /edudocs

RUN source /edudocs/bin/activate; \
    cd /edudocs/deployment; \
    rclone sync allas:cssedu /edudocs/deployment/docs; \
    mv -f /edudocs/deployment/docs/mkdocs.yml /edudocs/deployment/; \
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
