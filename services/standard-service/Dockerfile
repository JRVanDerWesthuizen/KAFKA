# File: C:\Users\tengo\.ballerina\KAFKA\services\standard-service\Dockerfile

# Use the official Ballerina image
FROM ballerina/ballerina:latest

# Set the working directory
WORKDIR /home/ballerina/src

# Copy the source code into the container
COPY ./standard_service.bal /home/ballerina/src/standard_service.bal

# Build the Ballerina service
RUN bal build standard_service.bal  

# Expose the port that the service listens on
EXPOSE 8081

# Command to run the Ballerina service
CMD ["bal", "run", "standard_service.balx"]
