# filepath: /my-calculator-fork/my-calculator-fork/Dockerfile
# Use the official Nginx image
# This is based on the Alpine Linux distribution, which is extremely lightweight (7MB).
FROM nginx:alpine

# Copy the static site content to the default Nginx HTML folder
# This command copies everything (.) in the src directory into the container's web root.
COPY src/ /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]