import ballerina/log;
import ballerinax/kafka;

// Configurable parameters
configurable string groupId = "standard-consumers";
configurable string standardDeliveryTopic = "standard_delivery";
configurable decimal pollingInterval = 1;
configurable string kafkaEndpoint = kafka:DEFAULT_URL;

// Define a record for the standard delivery request
type DeliveryRequest readonly & record {
    string details; // Additional details about the delivery
};

// Configure Kafka consumer settings
final kafka:ConsumerConfiguration consumerConfigs = {
    groupId: groupId,
    topics: [standardDeliveryTopic],
    offsetReset: kafka:OFFSET_RESET_EARLIEST,
    pollingInterval
};

// Create a Kafka listener for standard delivery requests
service on new kafka:Listener(kafkaEndpoint, consumerConfigs) {
    // Handle incoming standard delivery requests
    remote function onConsumerRecord(DeliveryRequest[] requests) returns error? {
        foreach var request in requests {
            log:printInfo("Processing standard delivery request: " + request.details);
            // Process the request here
        }
    }
}