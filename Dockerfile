# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx prisma generate
RUN npm run build

# Production stage
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

COPY package*.json ./
RUN npm install --production
COPY --from=builder /app/.next ./.next
COPY schema.prisma ./
RUN npx prisma generate

EXPOSE 3000
CMD npx prisma db push && npm start