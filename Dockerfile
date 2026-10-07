FROM node:22-bookworm-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    pkg-config \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHON=/usr/bin/python3
ENV npm_config_python=/usr/bin/python3

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build

ENV XHS_MCP_HEADLESS=true
ENV XHS_MCP_DATA_DIR=/data
ENV XHS_MCP_KEEP_OPEN=false
ENV XHS_MCP_REQUEST_INTERVAL=3000

EXPOSE 18060

CMD ["sh", "-c", "node dist/index.js --http --port ${PORT:-18060}"]
