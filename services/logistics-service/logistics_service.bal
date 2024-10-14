import ballerina/http;
import ballerina/log;
import ballerinax/kafka;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/sql;

// Configurable parameters for the database connection
configurable string dbHost = "mysql";
configurable int dbPort = 3307;
configurable string dbUser = "root";
configurable string dbPassword = "Uejaa@31";
configurable string dbName = "logistics";

// Kafka configurable parameters
configurable string groupId = "logistics-consumers";
configurable string logisticsTopic = "logistics";
configurable string standardDeliveryTopic = "standard_delivery";
configurable string expressDeliveryTopic = "express_delivery";
configurable string internationalDeliveryTopic = "international_delivery";
configurable decimal pollingInterval = 1;
configurable string kafkaEndpoint = kafka:DEFAULT_URL;

// Define records for customers, shipments, and logistics requests
type Customer record {|
    int id;
    string firstName;
    string lastName;
    string contactNumber;
|};

type Shipment record {|
    int id;
    string shipmentType;
    string pickupLocation;
    string deliveryLocation;
    int customerId;
|};

type LogisticsRequest readonly & record {|
    string deliveryType; // e.g., "STANDARD", "EXPRESS", "INTERNATIONAL"
    string details; // Additional details about the delivery
|};

// Configure Kafka consumer settings
final kafka:ConsumerConfiguration consumerConfigs = {
    groupId: groupId,
    topics: [logisticsTopic],
    offsetReset: kafka:OFFSET_RESET_EARLIEST,
    pollingInterval
};

// Create a Kafka listener for logistics requests
service on new kafka:Listener(kafkaEndpoint, consumerConfigs) {
    private final kafka:Producer logisticsProducer;

    // Initialize the producer
    function init() returns error? {
        self.logisticsProducer = check new (kafkaEndpoint);
    }

    // Handle incoming logistics requests
    remote function onConsumerRecord(LogisticsRequest[] requests) returns error? {
        // Process each logistics request based on delivery type
        foreach LogisticsRequest request in requests {
            if request.deliveryType == "STANDARD" {
                check sendToStandardDelivery(self.logisticsProducer, request);
            } else if request.deliveryType == "EXPRESS" {
                check sendToExpressDelivery(self.logisticsProducer, request);
            } else if request.deliveryType == "INTERNATIONAL" {
                check sendToInternationalDelivery(self.logisticsProducer, request);
            }
        }
    }
}

// HTTP service for database interactions
service /logistics on new http:Listener(8080) {
    private final mysql:Client db;

    // Initialize the MySQL client
    function init() returns error? {
        self.db = check new (dbHost, dbUser, dbPassword, dbName, dbPort);
    }

    // Endpoint to retrieve all customers
    resource function get customers() returns Customer[]|error {
        stream<Customer, sql:Error?> customerStream = self.db->query(SELECT * FROM customers);
        return from Customer customer in customerStream select customer;
    }

    // Endpoint to retrieve a single customer by ID
    resource function get customers/[int id]() returns Customer|http:NotFound|error {
        Customer|sql:Error result = self.db->queryRow(SELECT * FROM customers WHERE id = ${id});
        if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            return result;
        }
    }

    // Endpoint to add a new customer
    resource function post customer(@http:Payload Customer customer) returns Customer|error {
        _ = check self.db->execute(`
            INSERT INTO customers (first_name, last_name, contact_number)
            VALUES (${customer.firstName}, ${customer.lastName}, ${customer.contactNumber});`);
        return customer;
    }

    // Endpoint to retrieve all shipments
    resource function get shipments() returns Shipment[]|error {
        stream<Shipment, sql:Error?> shipmentStream = self.db->query(SELECT * FROM shipments);
        return from Shipment shipment in shipmentStream select shipment;
    }

    // Endpoint to retrieve a single shipment by ID
    resource function get shipments/[int id]() returns Shipment|http:NotFound|error {
        Shipment|sql:Error result = self.db->queryRow(SELECT * FROM shipments WHERE id = ${id});
        if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            return result;
        }
    }

    // Endpoint to add a new shipment
    resource function post shipment(@http:Payload Shipment shipment) returns Shipment|error {
        _ = check self.db->execute(`
            INSERT INTO shipments (shipment_type, pickup_location, delivery_location, customer_id)
            VALUES (${shipment.shipmentType}, ${shipment.pickupLocation}, ${shipment.deliveryLocation}, ${shipment.customerId});`);
        return shipment;
    }
}

// Function to send a message to the standard delivery topic
function sendToStandardDelivery(kafka:Producer producer, LogisticsRequest request) returns error? {
    check producer->send({
        topic: standardDeliveryTopic,
        value: request
    });
    log:printInfo("Sent to standard delivery: " + request.details);
}

// Function to send a message to the express delivery topic
function sendToExpressDelivery(kafka:Producer producer, LogisticsRequest request) returns error? {
    check producer->send({
        topic: expressDeliveryTopic,
        value: request
    });
    log:printInfo("Sent to express delivery: " + request.details);
}

// Function to send a message to the international delivery topic
function sendToInternationalDelivery(kafka:Producer producer, LogisticsRequest request) returns error? {
    check producer->send({
        topic: internationalDeliveryTopic,
        value: request
    });
    log:printInfo("Sent to international delivery: " + request.details);
}