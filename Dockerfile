# Use a Node.js base image that supports bun installation
FROM node:18-alpine as builder

# Install bun
RUN npm install -g bun

# Set the working directory
WORKDIR /app

# Copy package and lock files
COPY package.json bun.lockb ./

# Install dependencies using bun
RUN bun install

# Copy the rest of the application
COPY . .

# Build the application
RUN bun run build

# Create a release image
FROM node:18-alpine

# Install bun
RUN npm install -g bun

# Set the working directory
WORKDIR /app

# Copy built files and package.json from builder
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/

# Configure to use STDIO
ENV NODE_ENV=production
ENV MCP_TRANSPORT=stdio

# Run the server with STDIO transport
CMD ["node", "/app/dist/index.js"]
