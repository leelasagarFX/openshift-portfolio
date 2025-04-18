# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app
COPY client ./client
COPY client/package*.json ./client/
RUN cd client && npm install && npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=builder /app/client/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
