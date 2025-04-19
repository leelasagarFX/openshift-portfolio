# Use the official NGINX image
FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom NGINX config
# Use custom config to avoid permission errors
COPY nginx.conf /etc/nginx/nginx.conf


# Copy React build files to NGINX's HTML directory
COPY client/build/ /usr/share/nginx/html/

# Expose the port NGINX is listening on
EXPOSE 8080

# Use non-root user (OpenShift friendly)
USER 1001
