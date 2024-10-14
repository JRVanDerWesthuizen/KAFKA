CREATE DATABASE logistics;
USE logistics;

CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  contact_number VARCHAR(20)
);

CREATE TABLE shipments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  shipment_type VARCHAR(20),
  pickup_location VARCHAR(100),
  delivery_location VARCHAR(100),
  customer_id INT,
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);
