# Stage 1: Build React app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy only what's needed for install and build
COPY client/package*.json ./client/
COPY client/ ./client/

# Install and build
RUN cd client && npm install && npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom NGINX config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy React build output
COPY --from=builder /app/client/build /usr/share/nginx/html

# OpenShift requires non-root user
USER 1001

# Expose port (note: OpenShift routes can map this)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
