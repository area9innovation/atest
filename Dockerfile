FROM nginx:1.22.0-alpine
COPY target/<artifact_link> /usr/share/nginx/html/
