import ballerina/kafka;
import ballerina/log;

// Define the Kafka consumer configuration
kafka:ConsumerConfiguration consumerConfig = {
    groupId: "standard-delivery-group",
    topics: ["standard_delivery_requests"],
    bootstrapServers: "localhost:9092"
};

// Define the Kafka consumer client
kafka:Consumer kafkaConsumer = check new(consumerConfig);

public function main() returns error? {
    log:printInfo("Listening for standard delivery requests...");

    // Poll the Kafka topic for messages
    while (true) {
        kafka:ConsumerRecord[] records = check kafkaConsumer->poll(1000);
        foreach var record in records {
            log:printInfo("Received request: " + record.value);
            // Process the delivery request (e.g., send confirmation)
            processDeliveryRequest(record.value.toJson());
        }
    }
}

// Function to process the delivery request
function processDeliveryRequest(json request) {
    log:printInfo("Processing delivery: " + request.toString());
    // Send confirmation, update database, etc.
}
