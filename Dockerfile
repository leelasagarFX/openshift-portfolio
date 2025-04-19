# Stage 1: Build React app
FROM node:18-alpine AS builder

WORKDIR /app

COPY client/package*.json ./client/
COPY client/ ./client/

RUN cd client && npm install && npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom NGINX config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy React build
COPY --from=builder /app/client/build /usr/share/nginx/html

# 🔧 Create and set permissions for cache dirs (OpenShift safe)
RUN mkdir -p /var/cache/nginx/client_temp \
    && chmod -R 777 /var/cache/nginx

# Run with OpenShift-safe UID
USER 1001

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
