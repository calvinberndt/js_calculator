**Report on Deploying a Dockerized Web Application on AWS EC2**

**Introduction**
This report summarizes the process of deploying a Dockerized web application on an Amazon EC2 instance. The project involved containerizing an existing calculator application built with HTML, CSS, and JavaScript, pushing the image to Docker Hub, and running the container on an AWS EC2 instance. Several technical challenges were addressed, including architecture compatibility, port conflicts, and security group settings.

**Process Overview**

1. **Setting Up the Local Development Environment**
   - Cloned the calculator application source code from the GitHub repository to the local machine:
     ```bash
     git clone <repository-url>
     ```
   - Created a `Dockerfile` in the project root directory with the following content:

     ```dockerfile
     # Use the official Nginx image
     # This is based on the Alpine Linux distribution, which is extremely lightweight (7MB).
     FROM nginx:alpine

     # Copy the static site content to the default Nginx HTML folder
     # This command copies everything (.) in the current directory into the container's web root.
     COPY . /usr/share/nginx/html

     # Expose port 80 for web traffic
     EXPOSE 80

     # Start Nginx when the container runs
     CMD ["nginx", "-g", "daemon off;"]
     ```


   - Built the Docker image locally using:
     ```bash
     docker build -t my-calculator .
     ```
   - Ran the container locally and mapped the ports:
     ```bash
     docker run -d -p 8080:80 my-calculator
     ```
     This command returns a container ID (e.g., ad331729001bf6326ae40e7e0485074aac63aeef523981447c8a82ab21e9bcee)
     
   - Accessed the application locally via http://localhost:8080 to verify functionality
   - Built the Docker image with platform specification for AWS EC2 compatibility:
     ```bash
     docker build --platform linux/amd64 -t calvinberndt/my-calculator:latest .
     ```
   - Tagged and pushed the image to Docker Hub:
     ```bash
     docker push calvinberndt/my-calculator:latest
     ```

2. **Setting Up AWS EC2 Instance**
   - Launched an AWS EC2 instance with an appropriate Amazon Machine Image (AMI) and assigned a public IP
   - Connected to the EC2 instance via SSH using the key file:
     ```bash
     ssh -i "cs_293_class.pem" ubuntu@ec2-3-147-77-201.us-east-2.compute.amazonaws.com
     ```
   - Updated the EC2 instance packages:
     ```bash
     sudo apt update -y
     ```
   - Installed Docker on EC2 (resolved conflicts with containerd.io package):
     ```bash
     sudo apt install docker-ce docker-ce-cli -y
     ```
   - Added current user to the Docker group to avoid using sudo with Docker commands:
     ```bash
     sudo usermod -aG docker $USER
     ```
   - Restarted Docker to apply the user group changes:
     ```bash
     sudo systemctl restart docker
     ```

3. **Preparing and Pushing the Docker Image**
   - **Docker Hub Explanation**: Docker Hub is an online service provided by Docker where images can be stored and shared, similar to GitHub for Docker images
   - On local machine, logged into Docker Hub:
     ```bash
     docker login
     ```
   - Tagged the local image for Docker Hub:
     ```bash
     docker tag my-calculator calvinberndt/my-calculator:latest
     ```
   - Pushed the image to Docker Hub:
     ```bash
     docker push calvinberndt/my-calculator:latest
     ```
   - Rebuilt the image with the correct architecture for EC2:
     ```bash
     docker build --platform linux/amd64 -t calvinberndt/my-calculator:latest .
     docker push calvinberndt/my-calculator:latest
     ```

4. **Pulling and Running the Docker Container on EC2**
   - Logged into Docker Hub from the EC2 instance:
     ```bash
     docker login
     ```
   - Pulled the Docker image from Docker Hub with the correct architecture:
     ```bash
     docker pull --platform linux/amd64 calvinberndt/my-calculator:latest
     ```
   - Ran the Docker container and mapped port 81 (since port 80 was already in use):
     ```bash
     docker run -d -p 81:80 calvinberndt/my-calculator:latest
     ```
   - Added security group rule to allow inbound traffic on port 81
   - Accessed the application via:
     ```
     http://3.147.77.201:81/
     ```

**Challenges and Solutions**

1. **Architecture Mismatch Issue**
   - The local development environment (MacBook Pro's M3) used `arm64`, while the EC2 instance required `amd64`.
   - Solution: Specified the correct platform during the build process using:
     ```bash
     docker build --platform linux/amd64 -t calvinberndt/my-calculator:latest .
     ```

2. **Port Conflict on EC2**
   - Port 80 was already in use, causing Docker to fail when binding the port.
   - Solution: Used an alternative port (81) for the container:
     ```bash
     docker run -d -p 81:80 calvinberndt/my-calculator:latest
     ```

3. **Security Group Configuration**
   - The default security group settings in AWS blocked external access to port 81.
   - Solution: Modified the EC2 security group to allow inbound traffic on port 81.

**Key Learnings**
- **Docker Image Compatibility:** When working across different system architectures, specifying the target platform ensures the image runs correctly on the deployment environment.
- **Port Management in Docker:** Understanding port mapping (`-p host:container`) is critical when running multiple services on a machine.
- **Security Group Configurations in AWS:** Adjusting AWS security groups is essential for allowing external access to hosted applications.
- **End-to-End Deployment Workflow:** Deploying a containerized application involves several steps—building, pushing, pulling, and running the image while ensuring proper networking and security settings.

**Conclusion**
By following these steps, we successfully deployed the calculator application on an AWS EC2 instance using Docker. The process highlighted the importance of architecture compatibility, network configuration, and cloud security settings. This deployment approach provides a scalable and portable solution for hosting web applications in the cloud.

