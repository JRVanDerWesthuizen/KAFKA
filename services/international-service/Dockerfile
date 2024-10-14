# File: C:\Users\tengo\.ballerina\KAFKA\services\international-service\Dockerfile

# Use the official Ballerina image
FROM ballerina/ballerina:latest

# Set the working directory
WORKDIR /home/ballerina/src

# Copy the source code into the container
COPY ./international_service.bal /home/ballerina/src/international_service.bal

# Build the Ballerina service
RUN bal build international-service/international_service.bal

# Expose the port that the service listens on
EXPOSE 8083

# Command to run the Ballerina service
CMD ["ballerina", "run", "international/international_service.balx"]
