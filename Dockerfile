FROM nginx

RUN echo "<!DOCTYPE html><html><head><title>My Web App</title></head><body><h1>Hello from my web app!</h1></body></html>" > /usr/share/nginx/html/index.html
EXPOSE 80