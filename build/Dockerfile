FROM nginx:stable-alpine

RUN apk update && \
      apk upgrade && \
      apk --no-cache add curl # support container health checks

COPY src/public/html /usr/share/nginx/html/
COPY update-index.sh /docker-entrypoint.d/

ENV NGINX_PORT 8080

EXPOSE 8080

USER nginx

CMD ["nginx", "-g", "daemon off;"]

