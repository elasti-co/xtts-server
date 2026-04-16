FROM python:3.11-slim

LABEL description="XTTS API Server (CPU mode)"
LABEL org.opencontainers.image.source="https://github.com/elasti-co/xtts-server"

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ffmpeg curl git build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    torch torchaudio --index-url https://download.pytorch.org/whl/cpu

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt && rm /tmp/requirements.txt

COPY . /app
RUN pip install --no-cache-dir /app

RUN mkdir -p /app/speakers /app/models /app/output

WORKDIR /app

EXPOSE 8020

ENV COQUI_TOS_AGREED=1

CMD ["python3", "-m", "xtts_api_server", \
    "--listen", \
    "-p", "8020", \
    "-t", "http://localhost:8020", \
    "-sf", "/app/speakers", \
    "-o", "/app/output", \
    "-mf", "/app/models"]
