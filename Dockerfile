FROM python:3.13.0a2-alpine3.19

RUN apk add s3fs-fuse; \
    pip install --upgrade pip; \
    pip install mkdocs; \
    mkdocs new cssedu; \
    cd cssedu; \
    mkdocs serve --dev-addr localhost:80

CMD ["cat", "/dev/null"]
