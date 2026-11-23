# Base image: official Node.js on a small Alpine Linux
FROM node:22-alpine

# Working directory inside the container
WORKDIR /app

# Copy the application code
COPY package.json ./
COPY src ./src

# The app listens on this port (documentation only; use -p to publish it)
EXPOSE 80

# Run as the unprivileged "node" user instead of root
USER node

# Command executed when the container starts
CMD ["node", "src/server.js"]
