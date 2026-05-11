# Use the official Flutter image
FROM ghcr.io/cirruslabs/flutter:latest

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the code
COPY . .

# Build the web app
RUN flutter build web

# Use nginx to serve the web app
FROM nginx:alpine

# Copy built web app to nginx
COPY --from=0 /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
 