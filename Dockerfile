# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: Production
FROM node:18-alpine AS runner
WORKDIR /app
# Only copy the production dependencies and built files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./
EXPOSE 3000
CMD ["npm", "start"]