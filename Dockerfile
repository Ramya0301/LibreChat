# v0.7.5-rc2

# Base node image
FROM node:20-alpine AS node

RUN apk --no-cache add curl

RUN mkdir -p /app && chown node:node /app
WORKDIR /app

USER node

COPY --chown=node:node . .
#COPY --chown=node:node client/public/assets/logo.svg client/public/assets/logo1.svg client/public/assets/apple-touch-icon-180x180.png client/public/assets/favicon-16x16.png client/public/assets/favicon-32x32.png client/public/assets/maskable-icon.png /app/client/public/assets/

RUN \
    # Allow mounting of these files, which have no default
    touch .env ; \
    # Create directories for the volumes to inherit the correct permissions
    mkdir -p /app/client/public/images /app/api/logs ; \
    npm config set fetch-retry-maxtimeout 600000 ; \
    npm config set fetch-retries 5 ; \
    npm config set fetch-retry-mintimeout 15000 ; \
    npm install --no-audit; \
    # React client build
    NODE_OPTIONS="--max-old-space-size=2048" npm run frontend; \
    npm prune --production; \
    npm cache clean --force

RUN mkdir -p /app/client/public/images /app/api/logs

# Node API setup
EXPOSE 3080
ENV HOST=0.0.0.0
CMD ["npm", "run", "backend"]

# Optional: for client with nginx routing
# FROM nginx:stable-alpine AS nginx-client
# WORKDIR /usr/share/nginx/html
# COPY --from=node /app/client/dist /usr/share/nginx/html
# COPY client/nginx.conf /etc/nginx/conf.d/default.conf
# ENTRYPOINT ["nginx", "-g", "daemon off;"]
