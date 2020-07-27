FROM nginx:stable-alpine

RUN apk update && \
      apk upgrade && \
      apk --no-cache add curl # support container health checks

COPY src/public/html /usr/share/nginx/html/
COPY src/scripts/update-index.sh /docker-entrypoint.d/

