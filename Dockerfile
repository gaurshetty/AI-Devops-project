
# Lightweight Node.js Alpine image
FROM node:26-alpine

# Set working directory
WORKDIR /app

# Copy package files first for better Docker layer caching
COPY package.json package-lock.json ./

# Install only production dependencies
RUN npm ci --omit=dev && npm cache clean --force

# Copy application source code
COPY --chown=node:node . .

# Run as non-root user
USER node

# Expose application port
EXPOSE 3000

# Start application
CMD ["node", "index.js"]
