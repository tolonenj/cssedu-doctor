FROM alpine:3.19 as builder


WORKDIR /edudocs/deployment

RUN apk add --update rclone \
    python3; \
    python3 -m venv edudocs; \
    cd edudocs; \
    source ./bin/activate; \
    pip install --upgrade pip; \
    pip install mkdocs; \
    mkdocs new deployment; \
    cd deployment; \
    rm ./docs/*; \
    mkdir -p ~/.config/rclone; \
    echo -e "[allas]\ntype = swift\nenv_auth = true" > ~/.config/rclone/rclone.conf; \
    rclone sync /edudocs/deployment/docs/ allas:cssedu; \
    mkdocs build
    

#COPY mkdocs.yml /edudocs/deployment
#COPY rclone.conf /root/.config/rclone/rclone.conf



FROM nginx
COPY --from=builder /edudocs/deployment/site /usr/share/nginx/html
EXPOSE 80
