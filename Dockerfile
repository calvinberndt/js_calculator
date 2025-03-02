# Use the official Nginx image
FROM nginx:alpine

# Copy the static site content to the default Nginx HTML folder
COPY . /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]