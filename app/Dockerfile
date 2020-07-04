FROM nginx:stable-alpine

RUN apk update && \
      apk upgrade && \
      apk --no-cache add curl

COPY html /usr/share/nginx/html

EXPOSE 80
