FROM node:22.19.0-alpine AS base
WORKDIR /usr/src/wpp-server
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json ./
RUN apk update && \
    apk add --no-cache \
    gcc \
    g++ \
    make \
    libc6-compat \
    && rm -rf /var/cache/apk/*
RUN npm install --omit=dev --legacy-peer-deps && \
    npm cache clean --force

FROM base AS build
WORKDIR /usr/src/wpp-server
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json ./
RUN npm install --legacy-peer-deps && \
    npm install sharp@0.33.2 --ignore-engines --legacy-peer-deps && \
    npm cache clean --force
COPY . .
RUN npm run build

FROM base
WORKDIR /usr/src/wpp-server/
RUN apk add --no-cache \
    chromium \
    && rm -rf /var/cache/apk/*
COPY . .
COPY --from=build /usr/src/wpp-server/ /usr/src/wpp-server/
EXPOSE 21465
ENTRYPOINT ["node", "dist/server.js"]
