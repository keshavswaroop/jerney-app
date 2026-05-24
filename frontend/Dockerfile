FROM node:lts-bookworm-slim AS builder
WORKDIR /app
COPY package.json ./
RUN npm install 
COPY . .
RUN npm run build

FROM nginx:latest AS prod
RUN rm -rf /etc/nginx/conf.d/default.conf /usr/share/nginx/html/*

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built frontend from build stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Security: run nginx as non-root
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]