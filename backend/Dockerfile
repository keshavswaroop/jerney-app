FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json ./
RUN npm install


FROM node:18-alpine AS final
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY src/ ./src/

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 5000

CMD ["node","src/index.js"]