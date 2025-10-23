# Frontend Dockerfile (Vite + React)
# Multi-stage: build with Node, serve with Nginx

FROM node:20-alpine AS build
WORKDIR /app

# Install dependencies first (leverages Docker layer caching)
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci

# Copy source
COPY frontend/ ./

# Provide API base URL at build time (optional)
ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

# Build the production assets
RUN npm run build

FROM nginx:alpine AS runtime

# Copy custom Nginx config if present
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built assets
COPY --from=build /app/dist/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

