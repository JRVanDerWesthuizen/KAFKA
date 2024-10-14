import ballerinax/kafka;
import ballerina/log;

// Define the Kafka producer configuration
kafka:ProducerConfiguration producerConfig = {
    bootstrapServers: "localhost:9092"
};

// Define the Kafka producer client
kafka:Producer kafkaProducer = check new(producerConfig);

type DeliveryRequest record {
    string type;
    string pickupLocation;
    string deliveryLocation;
    string timeSlot;
    string customerName;
};

public function main() returns error? {
    // Sample request data
    DeliveryRequest request = {
        type: "standard",
        pickupLocation: "Windhoek",
        deliveryLocation: "Swakopmund",
        timeSlot: "10:00 - 12:00",
        customerName: "John Doe"
    };

    // Serialize the request record to a JSON string
    string message = request.toJsonString();

    // Send the request to the appropriate Kafka topic
    check kafkaProducer->send({
        topic: "standard_delivery_requests",
        value: message
    });

    log:printInfo("Request sent to standard delivery service.");
}
