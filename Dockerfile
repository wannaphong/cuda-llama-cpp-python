FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04
WORKDIR /
EXPOSE 80/tcp
EXPOSE 8000/tcp

# Setup dependencies
RUN apt update && \
    apt install -y python3 python3-venv python3-pip python3-uvicorn

RUN python3 -m venv venv && \
    /venv/bin/pip install llama-cpp-python --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu121 && \
    /venv/bin/pip install anyio fastapi starlette sse_starlette starlette_context pydantic pydantic_settings

# Setup nginx reverse proxy
RUN apt install -y nginx
COPY default /etc/nginx/sites-available/

# Setup environment
ENV TZ="UTC"

# Modified host code
ADD host /host

# Setup entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
