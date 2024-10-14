# File: C:\Users\tengo\.ballerina\KAFKA\services\logistics-service\Dockerfile

# Use the official Ballerina image
FROM ballerina/ballerina:latest

# Set the working directory
WORKDIR /home/ballerina/src

# Copy the source code into the container
COPY ./express_service.bal /home/ballerina/src/express_service.bal

# Build the Ballerina service
RUN bal build express-service/express_service.bal

# Expose the port that the service listens on
EXPOSE 8080

# Command to run the Ballerina service
CMD ["ballerina", "run", "logistics/logistics_service.balx"]
