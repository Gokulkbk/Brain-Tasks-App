# Dockerfile
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy pre-built React app (static files)
COPY dist ./dist

# Install a simple static file server
RUN npm install -g serve

# The React app should be served on port 3000
EXPOSE 3000

# Start the app
CMD ["serve", "-s", "dist", "-l", "3000"]
