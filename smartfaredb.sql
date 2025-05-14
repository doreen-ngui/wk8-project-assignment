CREATE DATABASE smartfaredb;

USE smartfaredb;

-- Owners table 
CREATE TABLE Owners (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Drivers table
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    contact_info VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Conductors table
CREATE TABLE Conductors (
    conductor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicles table
CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    capacity INT NOT NULL,
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES Owners(owner_id)
);

-- Trips table
CREATE TABLE Trips (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT,
    driver_id INT,
    conductor_id INT,
    route VARCHAR(100) NOT NULL,
    trip_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trip_end TIMESTAMP,
    passenger_count INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (conductor_id) REFERENCES Conductors(conductor_id)
);

-- Fare collection table
CREATE TABLE FareCollection (
    collection_id INT PRIMARY KEY AUTO_INCREMENT,
    trip_id INT,
    amount_collected DECIMAL(10,2) NOT NULL,
    expected_amount DECIMAL(10,2) NOT NULL,
    discrepancy DECIMAL(10,2) GENERATED ALWAYS AS (expected_amount - amount_collected),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);

-- Financial report table
CREATE TABLE FinancialReports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT,
    total_revenue DECIMAL(10,2),
    total_discrepancy DECIMAL(10,2),
    report_date DATETIME DEFAULT  CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


-- DATA ENTRIES

-- -- Owners table records 
INSERT INTO Owners (name, contact_info) VALUES
('John Mwangi', '+254712345678'),
('Alice Njoroge', '+254723456789');

-- Drivers table records
INSERT INTO Drivers (name, license_number, contact_info) VALUES
('Samuel Kamau', 'DL123456', '+254734567890'),
('Kevin Otieno', 'DL789012', '+254745678901'),
('Peter Mwangi', 'DL345678', '+254756789012'); 

-- conductors table records
INSERT INTO Conductors (name, contact_info) VALUES
('David Otieno', '+254756789012'),
('Eric Wanjiru', '+254767890123'),
('James Karanja', '+254778901234'); 

-- trips table records
INSERT INTO Trips (trip_id, vehicle_id, driver_id, conductor_id, route, trip_start, trip_end, passenger_count) VALUES
(1, 1, 1, 1, 'Nairobi - Thika', '2025-05-14 06:30:00', '2025-05-14 07:45:00', 13),
(2, 2, 2, 2, 'Nairobi - Kitengela', '2025-05-14 08:00:00', '2025-05-14 09:30:00', 24),
(3, 3, 3, 3, 'Nairobi - Umoja', '2025-05-14 10:00:00', '2025-05-14 11:20:00', 17);

-- farecollection table records
INSERT INTO FareCollection (trip_id, amount_collected, expected_amount) VALUES
(1, 1300.00, 1400.00), -- Nairobi-Thika (13 passengers × 100-150)
(2, 3000.00, 3600.00), -- Nairobi-Kitengela (24 passengers × 100-150)
(3, 2550.00, 2700.00); -- Nairobi-Umoja (17 passengers × 100-150)

-- vehicle table records
INSERT INTO Vehicles (plate_number, capacity, owner_id) VALUES
('KDA 123A', 14, 1),
('KBB 456B', 25, 2),
('KCC 789C', 18, 1); 

-- financialreports table records
INSERT INTO FinancialReports (vehicle_id, total_revenue, total_discrepancy, report_date) VALUES
(1, 1300.00, 100.00, '2025-05-14'),
(2, 3000.00, 600.00, '2025-05-14'),
(3, 2550.00, 150.00, '2025-05-14');
