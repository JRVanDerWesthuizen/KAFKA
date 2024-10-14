# File: C:\Users\tengo\.ballerina\KAFKA\services\logistics-service\Dockerfile

# Use the official Ballerina image
FROM ballerina/ballerina:latest

# Set the working directory
WORKDIR /home/ballerina/src

# Copy the source code into the container
COPY ./logistics_service.bal /home/ballerina/src/logistics_service.bal

# Build the Ballerina service
RUN bal build logistics_service.bal 

# Expose the port that the service listens on
EXPOSE 8080

# Command to run the Ballerina service
CMD ["bal", "run", "logistics_service.balx"]  # Ensure the correct .balx file path
