FROM image-registry.apps.2.rahti.csc.fi/cssedu/cssedu@sha256:1f90c1f75a4092868957c0f4cf491ef441344bdc8e372d0bec9c6203fb7c2217 AS builder

RUN python3 -m venv cssedu-docs; \
    cd cssedu-docs; \
    source ./bin/activate; \
    pip install --upgrade pip; \
    pip install mkdocs; \
    mkdocs build; \
    pwd

CMD ["cat", "/dev/null"]
