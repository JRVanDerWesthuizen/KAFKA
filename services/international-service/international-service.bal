import ballerina/log;
import ballerinax/kafka;

// Configurable parameters
configurable string groupId = "international-consumers";
configurable string internationalDeliveryTopic = "international_delivery";
configurable decimal pollingInterval = 1;
configurable string kafkaEndpoint = kafka:DEFAULT_URL;

// Define a record for the international delivery request
type DeliveryRequest readonly & record {
    string details; // Additional details about the delivery
};

// Configure Kafka consumer settings
final kafka:ConsumerConfiguration consumerConfigs = {
    groupId: groupId,
    topics: [internationalDeliveryTopic],
    offsetReset: kafka:OFFSET_RESET_EARLIEST,
    pollingInterval
};

// Create a Kafka listener for international delivery requests
service on new kafka:Listener(kafkaEndpoint, consumerConfigs) {
    // Handle incoming international delivery requests
    remote function onConsumerRecord(DeliveryRequest[] requests) returns error? {
        foreach var request in requests {
            log:printInfo("Processing international delivery request: " + request.details);
            // Process the request here
        }
    }
}