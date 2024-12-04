FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04
WORKDIR /
EXPOSE 80/tcp
EXPOSE 8000/tcp

# Setup dependencies
RUN apt update && \
    apt install -y python3 python3-venv python3-pip python3-uvicorn

RUN python3 -m venv venv && \
    CMAKE_ARGS="-DLLAMA_CUDA=on" /venv/bin/pip install llama-cpp-python anyio fastapi starlette sse_starlette starlette_context pydantic pydantic_settings
