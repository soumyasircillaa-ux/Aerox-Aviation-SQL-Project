/*
Project Title : Design RDBMS for Aerox
----------------------------------------------------------------------------------------------------------
Objective :
1. Design RDBMS for Aerox and understand the trend analysis 
2. Understand operational performance of Aerox
----------------------------------------------------------------------------------------------------------
Schema Design
1. Passengers
	-passenger_id (primary key)
	-passenger_fullname
	-passenger_mobileno
	-passenger_email
	-passenger_passport_no

2. Bookings
	-booking_id (primary key)
	-booking_date
	-booking_class
	-booking_status
    -seat_availability
    -seat_no
	-passenger_id (foreign key)
	
3.Routes
	-route_id (primary key)
    -route_source
	-route_destination
	-route_start_time
	-route_end_time
    -route_status
	-route_distance_km
    -booking_id (fk)
    -passenger_id (fk)
    
4. AirFlight
	-airflight_id (primary key)
	-airflight_model
	-airflight_capacity
	-airflight_status (active, maintanence, retired)
    -booking_id
	-route_id (fk)
	-passenger_id (fk)
    
5.Airport
	-airport_code (Primary key) 
	-airport_name
	-airport_city
	-airport_country
	-airport_type
     -booking_id (fk)
    -airflight_id (fk)
    
6. Crew Members
	-crew_id (Primary key)
	-crew_fullname
	-crew_phone
	-crew_email
    -crew_designation
    -route_id (fk)
    -airflight_id (fk)
    -airport_id (fk)
	
7. Services
	-ticket_id (primary key)
	-maintenance_status (scheduled, in-progress, completed, pending)
	-security_status (cleared, under check, restricted) default under check
	-service type(inflight, ground, premium,)
	-service name (inflight meal, WIFI, extra baggage, entertainment)
    -passenger_id (fk)
	-booking_id (fk)
    -route_id (fk)
    -airflight_id (fk)
    
    8. Transactions
	-transaction_id (primary key)
	-transaction_status
	-transaction_method
	-transaction_date
	-transaction_amount
	-booking_id (foreign key)
	-ticket_id (fk)
	-passenger_id (fk)

9.Revenue
	-revenue_id (primary key)
    -revenue_amount
	-ticket_id (foreign key)
	-booking_id (foreign key)
	-transaction_id (fk)
	
10. Reviews
	-passenger_feedback
	-passenger_rating
    -crew_feedback
    -crew_rating
    -booking_feedback
	-passenger_id (foreign key)
	-booking_id (fk)
    -crew_id (fk)
    */
    
create database if not exists Aerox;

use Aerox;

-- ---------------------------------------------------------------------------------
-- Create Passengers Table 
-- ----------------------------------------------------------------------------------
create table passengers (
passenger_id int primary key unique not null,
passenger_fullname varchar(30) not null,
passenger_mobileno bigint not null,
passenger_email varchar (30) not null,
passenger_passport_no varchar (20) not null);

-- -------------------------------------------------------------------------------------
-- Create Bookings Table 
-- -------------------------------------------------------------------------------------------
create table bookings(
booking_id int primary key unique not null,
booking_date datetime not null,
booking_class enum ("First Class", "Economy", "Business", "Cargo") not null,
seat_available int not null,
seat_no int not null,
booking_status enum ("Confirm", "Pendiing", "Canceled") not null,
passenger_id int not null,
foreign key (passenger_id) references passengers (passenger_id));

-- ---------------------------------------------------------------------------------------------------
-- Create Routes Table 
-- -----------------------------------------------------------------------------------------------------
create table routes(
route_id varchar(20) primary key unique not null,
route_source varchar (20) not null,
route_destination varchar (20) not null,
route_start_time datetime not null,
route_end_time datetime not null,
route_status enum ("Active", "Inactive", "Scheduled", "Delayed", "Completed") not null,
route_distance_km int not null,
passenger_id int not null,
foreign key (passenger_id) references passengers (passenger_id),
booking_id int not null,
foreign key (booking_id) references bookings (booking_id));

-- -------------------------------------------------------------------------------------------------------
-- create table airflights
-- -------------------------------------------------------------------------------------------------------

create table airflights(
airflight_id varchar(20) primary key unique not null,
airflight_model varchar(20) not null,
airflight_capacity int not null,
airflight_status enum ("Active", "Maintanence", "Retired") not null,
passenger_id int not null,
foreign key (passenger_id) references passengers (passenger_id),
booking_id int not null,
foreign key (booking_id) references bookings (booking_id),
route_id varchar(20) not null,
foreign key (route_id) references routes (route_id));

-- ---------------------------------------------------------------------------------------------------
-- Create table Airports
-- ----------------------------------------------------------------------------------------------------
create table airports(
airport_code varchar (20) primary key unique not null,
airport_name varchar (20) not null,
airport_city varchar(20) not null,
airport_country varchar(20) not null,
airport_type enum ("International", "Domestic") not null,
booking_id int not null,
foreign key (booking_id) references bookings (booking_id),
airflight_id varchar (20) not null,
foreign key (airflight_id) references airflights (airflight_id));

-- --------------------------------------------------------------------------------------------------------
-- Create table crew_info
-- --------------------------------------------------------------------------------------------------------

create table crew_info(
crew_id int primary key unique not null,
crew_fullname varchar(50) not null,
crew_mobilno bigint not null,
crew_email varchar(50),
crew_designation varchar (20) not null,
route_id varchar(20) not null,
foreign key (route_id) references routes (route_id),
airflight_id varchar (20) not null,
foreign key (airflight_id) references airflights (airflight_id),
airport_code varchar (20) not null,
foreign key (airport_code) references airports (airport_code));

-- --------------------------------------------------------------------------------------------------------
-- create table services 
-- -----------------------------------------------------------------------------------------------------------

create table services(
ticket_id varchar (20) primary key unique not null,
maintenance_status enum ("scheduled", "In-Progress", "Complete", "Pending") not null,
security_status enum ("Cleared", "Under check", "Restricted") default "Under check",
service_type enum ("Inflight", "Ground", "Premium") not null,
service_name enum ("Inflight meal", "WIFI", "Extra baggege", "Entertainment")not null,
passenger_id int not null,
foreign key (passenger_id) references passengers (passenger_id),
booking_id int not null,
foreign key (booking_id) references bookings (booking_id),
route_id varchar(20) not null,
foreign key (route_id) references routes (route_id),
airflight_id varchar (20) not null,
foreign key (airflight_id) references airflights (airflight_id));

-- -----------------------------------------------------------------------------------------------
-- create table transactions
-- ---------------------------------------------------------------------------------------------------

create table transactions(
transaction_id bigint primary key unique not null,
transaction_amount decimal(10,2) not null,
transaction_method enum ("UPI", "Net Banking", "Wallet", "Cards") not null,
transaction_date datetime not null,
transaction_status enum ("Complete", "Pending", "Failed", "Canceled", "Refunded", "Processing")not null,
booking_id int not null,
foreign key (booking_id) references bookings (booking_id),
ticket_id varchar(20) not null,
foreign key (ticket_id) references services (ticket_id),
passenger_id int not null,
foreign key (passenger_id) references passengers (passenger_id));

-- -------------------------------------------------------------------------------------------------------
-- create table revenue
-- ------------------------------------------------------------------------------------------------------

create table revenue(
revenue_id int primary key unique not null,
revenue_amount decimal(10,2) not null,
ticket_id varchar (20) not null,
foreign key (ticket_id) references services (ticket_id),
booking_id int not null,
foreign key (booking_id) references bookings (booking_id),
transaction_id bigint not null,
foreign key (transaction_id) references transactions (transaction_id));


-- --------------------------------------------------------------------------------------------------
-- create table reviews 
-- ---------------------------------------------------------------------------------------------------

create table reviews(
passenger_feedback varchar(200),
passenger_rating int check (passenger_rating between 1 and 5),
crew_feedback varchar(200),
crew_rating int check (crew_rating between 1 and 5),
booking_feedback varchar (200),
passenger_id int not null,
foreign key (passenger_id) references passengers (passenger_id),
booking_id int not null,
foreign key (booking_id) references bookings (booking_id),
crew_id int not null,
foreign key (crew_id) references crew_info (crew_id));


-- --------------------------------------------------------------------------------------------------------
-- insert values into passengers
-- -------------------------------------------------------------------------------------------------------
INSERT INTO Passengers (passenger_id, passenger_fullname, passenger_mobileno, passenger_email, passenger_passport_no) VALUES
(1, 'John Smith', 1234567890, 'john.smith@gmail.com', 'P12345678'),
(2, 'Emma Johnson', 1234567891, 'emma.j@yahoo.com', 'E87654321'),
(3, 'Michael Brown', 1234567892, 'michael.brown@hotmail.com', 'M11223344'),
(4, 'Sophia Williams', 1234567893, 'sophia.w@outlook.com', 'S99887766'),
(5, 'James Jones', 1234567894, 'james.jones@gmail.com', 'J55667788'),
(6, 'Olivia Garcia', 1234567895, 'olivia.garcia@yahoo.com', 'O44332211'),
(7, 'David Martinez', 1234567896, 'david.martinez@gmail.com', 'D66778899'),
(8, 'Isabella Rodriguez', 1234567897, 'isabella.r@hotmail.com', 'I12398765'),
(9, 'Daniel Davis', 1234567898, 'daniel.davis@outlook.com', 'D99882233'),
(10, 'Mia Lopez', 1234567899, 'mia.lopez@gmail.com', 'M44556677'),
(11, 'Matthew Wilson', 1234567800, 'matthew.w@yahoo.com', 'M11229988'),
(12, 'Charlotte Anderson', 1234567801, 'charlotte.a@gmail.com', 'C77665544'),
(13, 'Andrew Thomas', 1234567802, 'andrew.t@hotmail.com', 'A33447799'),
(14, 'Amelia Taylor', 1234567803, 'amelia.taylor@outlook.com', 'A99883322'),
(15, 'Christopher Moore', 1234567804, 'chris.moore@gmail.com', 'C55667700'),
(16, 'Evelyn Jackson', 1234567805, 'evelyn.j@yahoo.com', 'E11224455'),
(17, 'Joshua White', 1234567806, 'josh.white@gmail.com', 'J77889900'),
(18, 'Abigail Harris', 1234567807, 'abigail.h@hotmail.com', 'A44339988'),
(19, 'Nicholas Martin', 1234567808, 'nick.martin@outlook.com', 'N66772211'),
(20, 'Emily Thompson', 1234567809, 'emily.t@gmail.com', 'E99887711'),
(21, 'Ryan Martinez', 1234567810, 'ryan.martinez@yahoo.com', 'R11223355'),
(22, 'Madison Robinson', 1234567811, 'madison.r@hotmail.com', 'M77664433'),
(23, 'Jacob Clark', 1234567812, 'jacob.clark@gmail.com', 'J55661122'),
(24, 'Elizabeth Lewis', 1234567813, 'elizabeth.l@outlook.com', 'E33447799'),
(25, 'William Walker', 1234567814, 'will.walker@gmail.com', 'W99880011'),
(26, 'Sofia Hall', 1234567815, 'sofia.hall@yahoo.com', 'S44556688'),
(27, 'Ethan Allen', 1234567816, 'ethan.allen@hotmail.com', 'E66778822'),
(28, 'Ava Young', 1234567817, 'ava.young@gmail.com', 'A77889933'),
(29, 'Alexander King', 1234567818, 'alex.king@outlook.com', 'A99001122'),
(30, 'Grace Wright', 1234567819, 'grace.wright@gmail.com', 'G11227799'),
(31, 'Benjamin Scott', 1234567820, 'ben.scott@yahoo.com', 'B44559988'),
(32, 'Victoria Green', 1234567821, 'victoria.g@hotmail.com', 'V66778844'),
(33, 'Lucas Baker', 1234567822, 'lucas.baker@gmail.com', 'L99887755'),
(34, 'Hannah Adams', 1234567823, 'hannah.adams@outlook.com', 'H12345678'),
(35, 'Henry Nelson', 1234567824, 'henry.nelson@gmail.com', 'H87654321'),
(36, 'Lily Carter', 1234567825, 'lily.carter@yahoo.com', 'L11223344'),
(37, 'Samuel Mitchell', 1234567826, 'sam.mitchell@hotmail.com', 'S99887766'),
(38, 'Zoey Perez', 1234567827, 'zoey.perez@gmail.com', 'Z55667788'),
(39, 'Nathan Roberts', 1234567828, 'nathan.r@outlook.com', 'N44332211'),
(40, 'Lillian Turner', 1234567829, 'lillian.t@gmail.com', 'L66778899'),
(41, 'Dylan Phillips', 1234567830, 'dylan.p@yahoo.com', 'D12398765'),
(42, 'Addison Campbell', 1234567831, 'addison.c@hotmail.com', 'A99882233'),
(43, 'Gabriel Parker', 1234567832, 'gabriel.p@gmail.com', 'G44556677'),
(44, 'Eleanor Evans', 1234567833, 'eleanor.e@outlook.com', 'E11229988'),
(45, 'Caleb Edwards', 1234567834, 'caleb.e@gmail.com', 'C77665544'),
(46, 'Nora Collins', 1234567835, 'nora.collins@yahoo.com', 'N33447799'),
(47, 'Isaac Stewart', 1234567836, 'isaac.s@hotmail.com', 'I99883322'),
(48, 'Scarlett Sanchez', 1234567837, 'scarlett.s@gmail.com', 'S55667700'),
(49, 'Owen Morris', 1234567838, 'owen.morris@outlook.com', 'O11224455'),
(50, 'Brooklyn Rogers', 1234567839, 'brooklyn.r@gmail.com', 'B77889900');


-- ------------------------------------------------------------------------------------
-- insert values into bookings
-- ----------------------------------------------------------------------------------------

INSERT INTO bookings (booking_id, booking_date, booking_class, seat_available, seat_no, booking_status, passenger_id) VALUES
(100, '2025-04-01 08:30:00', 'Economy', 150, 12, 'Confirm', 1),
(101, '2025-04-01 10:15:00', 'Business', 40, 5, 'Confirm', 2),
(102, '2025-04-02 14:00:00', 'First Class', 10, 2, 'Pendiing', 3),
(103, '2025-04-02 18:45:00', 'Cargo', 200, 59, 'Confirm', 4),
(104, '2025-04-03 06:20:00', 'Economy', 150, 88, 'Canceled', 5),
(105, '2025-04-03 21:10:00', 'Business', 40, 7, 'Confirm', 6),
(106, '2025-04-04 09:00:00', 'First Class', 10, 1, 'Pendiing', 7),
(107, '2025-04-04 12:30:00', 'Economy', 149, 33, 'Confirm', 8),
(108, '2025-04-05 16:00:00', 'Cargo', 200, 55, 'Confirm', 9),
(109, '2025-04-05 20:00:00', 'Business', 39, 3, 'Canceled', 10),
(110, '2025-04-06 07:00:00', 'Economy', 148, 45, 'Confirm', 11),
(111, '2025-04-06 13:30:00', 'First Class', 9, 4, 'Confirm', 12),
(112, '2025-04-07 11:00:00', 'Business', 38, 8, 'Pendiing', 13),
(113, '2025-04-07 22:15:00', 'Cargo', 199, 4, 'Confirm', 14),
(114, '2025-04-08 05:45:00', 'Economy', 147, 56, 'Canceled', 15),
(115, '2025-04-08 17:30:00', 'Business', 37, 2, 'Confirm', 16),
(116, '2025-04-09 08:00:00', 'First Class', 8, 6, 'Confirm', 17),
(117, '2025-04-09 19:20:00', 'Economy', 146, 77, 'Pendiing', 18),
(118, '2025-04-10 10:00:00', 'Cargo', 198, 2, 'Confirm', 19),
(119, '2025-04-10 23:00:00', 'Business', 36, 10, 'Canceled', 20),
(120, '2025-04-11 06:30:00', 'Economy', 145, 22, 'Confirm', 21),
(121, '2025-04-11 15:00:00', 'First Class', 7, 1, 'Confirm', 22),
(122, '2025-04-12 12:00:00', 'Business', 35, 9, 'Pendiing', 23),
(123, '2025-04-12 20:30:00', 'Cargo', 197, 25, 'Confirm', 24),
(124, '2025-04-13 07:15:00', 'Economy', 144, 99, 'Confirm', 25),
(125, '2025-04-13 18:45:00', 'Business', 34, 11, 'Canceled', 26),
(126, '2025-04-14 09:00:00', 'First Class', 6, 3, 'Confirm', 27),
(127, '2025-04-14 21:30:00', 'Economy', 143, 67, 'Pendiing', 28),
(128, '2025-04-15 11:00:00', 'Cargo', 196, 9, 'Confirm', 29),
(129, '2025-04-15 16:00:00', 'Business', 33, 4, 'Confirm', 30),
(130, '2025-04-16 08:30:00', 'Economy', 142, 15, 'Canceled', 31),
(131, '2025-04-16 13:00:00', 'First Class', 5, 7, 'Confirm', 32),
(132, '2025-04-17 10:30:00', 'Business', 32, 6, 'Pendiing', 33),
(133, '2025-04-17 22:00:00', 'Cargo', 195, 12, 'Confirm', 34),
(134, '2025-04-18 06:00:00', 'Economy', 141, 42, 'Confirm', 35),
(135, '2025-04-18 19:00:00', 'Business', 31, 12, 'Confirm', 36),
(136, '2025-04-19 07:30:00', 'First Class', 4, 5, 'Canceled', 37),
(137, '2025-04-19 14:30:00', 'Economy', 140, 89, 'Pendiing', 38),
(138, '2025-04-20 09:45:00', 'Cargo', 194, 41, 'Confirm', 39),
(139, '2025-04-20 18:00:00', 'Business', 30, 13, 'Confirm', 40),
(140, '2025-04-21 08:00:00', 'Economy', 139, 28, 'Confirm', 41),
(141, '2025-04-21 16:30:00', 'First Class', 3, 6, 'Pendiing', 42),
(142, '2025-04-22 11:15:00', 'Business', 29, 14, 'Canceled', 43),
(143, '2025-04-22 20:00:00', 'Cargo', 193, 87, 'Confirm', 44),
(144, '2025-04-23 05:30:00', 'Economy', 138, 55, 'Confirm', 45),
(145, '2025-04-23 17:00:00', 'Business', 28, 15, 'Confirm', 46),
(146, '2025-04-24 10:00:00', 'First Class', 2, 8, 'Pendiing', 47),
(147, '2025-04-24 21:00:00', 'Economy', 137, 73, 'Canceled', 48),
(148, '2025-04-25 12:00:00', 'Cargo', 192, 58, 'Confirm', 49),
(149, '2025-04-25 19:30:00', 'Business', 27, 9, 'Confirm', 50);

-- --------------------------------------------------------------------------------------------
-- insert values into routes
-- ----------------------------------------------------------------------------------------------
 
INSERT INTO routes (route_id, route_source, route_destination, route_start_time, route_end_time, route_status, route_distance_km, passenger_id, booking_id) VALUES
('R101', 'New York', 'Los Angeles', '2025-04-01 08:00:00', '2025-04-01 14:30:00', 'Active', 4500, 1, 100),
('R102', 'Chicago', 'Miami', '2025-04-01 10:00:00', '2025-04-01 15:45:00', 'Completed', 2100, 2, 101),
('R103', 'San Francisco', 'Seattle', '2025-04-02 07:30:00', '2025-04-02 09:45:00', 'Scheduled', 1300, 3, 102),
('R104', 'Boston', 'Washington DC', '2025-04-02 13:00:00', '2025-04-02 16:30:00', 'Active', 700, 4, 103),
('R105', 'Dallas', 'Houston', '2025-04-03 09:00:00', '2025-04-03 11:00:00', 'Completed', 400, 5, 104),
('R106', 'Phoenix', 'Denver', '2025-04-03 14:15:00', '2025-04-03 18:30:00', 'Delayed', 1200, 6, 105),
('R107', 'Philadelphia', 'Atlanta', '2025-04-04 08:45:00', '2025-04-04 13:15:00', 'Active', 1100, 7, 106),
('R108', 'San Diego', 'Las Vegas', '2025-04-04 16:00:00', '2025-04-04 18:30:00', 'Scheduled', 500, 8, 107),
('R109', 'Portland', 'San Francisco', '2025-04-05 06:00:00', '2025-04-05 08:30:00', 'Completed', 900, 9, 108),
('R110', 'Detroit', 'Chicago', '2025-04-05 11:30:00', '2025-04-05 13:45:00', 'Inactive', 450, 10, 109),
('R111', 'Minneapolis', 'St. Louis', '2025-04-06 07:00:00', '2025-04-06 11:00:00', 'Active', 900, 11, 110),
('R112', 'Orlando', 'Miami', '2025-04-06 14:00:00', '2025-04-06 16:30:00', 'Completed', 380, 12, 111),
('R113', 'Charlotte', 'Nashville', '2025-04-07 09:30:00', '2025-04-07 12:15:00', 'Scheduled', 650, 13, 112),
('R114', 'Salt Lake City', 'Boise', '2025-04-07 15:00:00', '2025-04-07 17:45:00', 'Delayed', 550, 14, 113),
('R115', 'Kansas City', 'Oklahoma City', '2025-04-08 08:00:00', '2025-04-08 10:30:00', 'Active', 500, 15, 114),
('R116', 'Columbus', 'Indianapolis', '2025-04-08 12:00:00', '2025-04-08 14:15:00', 'Completed', 280, 16, 115),
('R117', 'Austin', 'San Antonio', '2025-04-09 07:15:00', '2025-04-09 08:45:00', 'Active', 130, 17, 116),
('R118', 'Milwaukee', 'Chicago', '2025-04-09 17:00:00', '2025-04-09 18:30:00', 'Inactive', 150, 18, 117),
('R119', 'Jacksonville', 'Tampa', '2025-04-10 10:30:00', '2025-04-10 13:00:00', 'Scheduled', 340, 19, 118),
('R120', 'Memphis', 'Birmingham', '2025-04-10 19:00:00', '2025-04-10 21:15:00', 'Completed', 370, 20, 119),
('R121', 'New Orleans', 'Houston', '2025-04-11 06:30:00', '2025-04-11 11:00:00', 'Active', 560, 21, 120),
('R122', 'Louisville', 'Cincinnati', '2025-04-11 13:45:00', '2025-04-11 15:30:00', 'Delayed', 160, 22, 121),
('R123', 'Richmond', 'Washington DC', '2025-04-12 08:00:00', '2025-04-12 10:15:00', 'Completed', 170, 23, 122),
('R124', 'Buffalo', 'Pittsburgh', '2025-04-12 14:30:00', '2025-04-12 17:45:00', 'Active', 350, 24, 123),
('R125', 'Raleigh', 'Charlotte', '2025-04-13 09:00:00', '2025-04-13 11:15:00', 'Scheduled', 280, 25, 124),
('R126', 'Tulsa', 'Oklahoma City', '2025-04-13 16:00:00', '2025-04-13 17:45:00', 'Completed', 180, 26, 125),
('R127', 'Albuquerque', 'Phoenix', '2025-04-14 07:30:00', '2025-04-14 11:00:00', 'Active', 600, 27, 126),
('R128', 'Fresno', 'Sacramento', '2025-04-14 12:15:00', '2025-04-14 14:30:00', 'Inactive', 250, 28, 127),
('R129', 'Bridgeport', 'New York', '2025-04-15 08:00:00', '2025-04-15 10:15:00', 'Delayed', 120, 29, 128),
('R130', 'Hartford', 'Boston', '2025-04-15 15:30:00', '2025-04-15 17:00:00', 'Completed', 250, 30, 129),
('R131', 'Omaha', 'Kansas City', '2025-04-16 06:45:00', '2025-04-16 09:00:00', 'Active', 320, 31, 130),
('R132', 'Rochester', 'Syracuse', '2025-04-16 11:00:00', '2025-04-16 12:30:00', 'Scheduled', 150, 32, 131),
('R133', 'Tucson', 'Phoenix', '2025-04-17 09:15:00', '2025-04-17 10:45:00', 'Completed', 180, 33, 132),
('R134', 'Dayton', 'Columbus', '2025-04-17 13:30:00', '2025-04-17 15:00:00', 'Active', 120, 34, 133),
('R135', 'Colorado Springs', 'Denver', '2025-04-18 07:00:00', '2025-04-18 08:30:00', 'Delayed', 110, 35, 134),
('R136', 'Baton Rouge', 'New Orleans', '2025-04-18 16:30:00', '2025-04-18 18:15:00', 'Completed', 130, 36, 135),
('R137', 'Wichita', 'Tulsa', '2025-04-19 08:00:00', '2025-04-19 10:30:00', 'Active', 300, 37, 136),
('R138', 'Little Rock', 'Memphis', '2025-04-19 14:00:00', '2025-04-19 16:15:00', 'Scheduled', 280, 38, 137),
('R139', 'Knoxville', 'Nashville', '2025-04-20 09:00:00', '2025-04-20 11:30:00', 'Inactive', 290, 39, 138),
('R140', 'El Paso', 'Albuquerque', '2025-04-20 15:15:00', '2025-04-20 18:00:00', 'Completed', 400, 40, 139),
('R141', 'Spokane', 'Seattle', '2025-04-21 06:00:00', '2025-04-21 08:00:00', 'Active', 450, 41, 140),
('R142', 'Des Moines', 'Omaha', '2025-04-21 10:00:00', '2025-04-21 12:15:00', 'Delayed', 300, 42, 141),
('R143', 'Madison', 'Milwaukee', '2025-04-22 07:30:00', '2025-04-22 08:45:00', 'Completed', 130, 43, 142),
('R144', 'Manchester', 'Boston', '2025-04-22 12:00:00', '2025-04-22 13:30:00', 'Scheduled', 100, 44, 143),
('R145', 'Cleveland', 'Columbus', '2025-04-23 08:45:00', '2025-04-23 10:15:00', 'Active', 230, 45, 144),
('R146', 'Providence', 'Hartford', '2025-04-23 14:30:00', '2025-04-23 16:00:00', 'Completed', 150, 46, 145),
('R147', 'Toledo', 'Detroit', '2025-04-24 07:00:00', '2025-04-24 08:30:00', 'Inactive', 120, 47, 146),
('R148', 'Bakersfield', 'Fresno', '2025-04-24 11:00:00', '2025-04-24 12:30:00', 'Active', 110, 48, 147),
('R149', 'Worcester', 'Boston', '2025-04-25 09:00:00', '2025-04-25 10:15:00', 'Delayed', 80, 49, 148),
('R150', 'Aurora', 'Denver', '2025-04-25 16:30:00', '2025-04-25 17:45:00', 'Completed', 30, 50, 149);


-- --------------------------------------------------------------------------------------------------------------
-- insert values into airflights 
-- ------------------------------------------------------------------------------------------------------------------

INSERT INTO airflights (airflight_id, airflight_model, airflight_capacity, airflight_status, passenger_id, booking_id, route_id) VALUES
('AF101', 'Boeing 737', 180, 'Active', 1, 100, 'R101'),
('AF102', 'Airbus A320', 150, 'Active', 2, 101, 'R102'),
('AF103', 'Boeing 777', 300, 'Maintanence', 3, 102, 'R103'),
('AF104', 'Airbus A380', 500, 'Active', 4, 103, 'R104'),
('AF105', 'Boeing 787', 240, 'Active', 5, 104, 'R105'),
('AF106', 'Embraer E175', 76, 'Retired', 6, 105, 'R106'),
('AF107', 'Boeing 757', 200, 'Active', 7, 106, 'R107'),
('AF108', 'Airbus A330', 250, 'Maintanence', 8, 107, 'R108'),
('AF109', 'Bombardier CRJ900', 90, 'Active', 9, 108, 'R109'),
('AF110', 'Boeing 767', 220, 'Active', 10, 109, 'R110'),
('AF111', 'Airbus A319', 130, 'Active', 11, 110, 'R111'),
('AF112', 'Boeing 737 MAX', 190, 'Maintanence', 12, 111, 'R112'),
('AF113', 'Airbus A321', 185, 'Active', 13, 112, 'R113'),
('AF114', 'Boeing 717', 110, 'Retired', 14, 113, 'R114'),
('AF115', 'Embraer E190', 100, 'Active', 15, 114, 'R115'),
('AF116', 'Airbus A350', 350, 'Active', 16, 115, 'R116'),
('AF117', 'Boeing 747', 400, 'Maintanence', 17, 116, 'R117'),
('AF118', 'Bombardier Q400', 78, 'Active', 18, 117, 'R118'),
('AF119', 'Airbus A220', 120, 'Active', 19, 118, 'R119'),
('AF120', 'Boeing 727', 150, 'Retired', 20, 119, 'R120'),
('AF121', 'Embraer E195', 124, 'Active', 21, 120, 'R121'),
('AF122', 'Boeing 737-800', 170, 'Active', 22, 121, 'R122'),
('AF123', 'Airbus A318', 100, 'Maintanence', 23, 122, 'R123'),
('AF124', 'Boeing 757-300', 280, 'Active', 24, 123, 'R124'),
('AF125', 'Bombardier CRJ700', 70, 'Active', 25, 124, 'R125'),
('AF126', 'Airbus A340', 300, 'Retired', 26, 125, 'R126'),
('AF127', 'Boeing 767-400', 245, 'Active', 27, 126, 'R127'),
('AF128', 'Embraer E170', 78, 'Active', 28, 127, 'R128'),
('AF129', 'Airbus A380-800', 520, 'Maintanence', 29, 128, 'R129'),
('AF130', 'Boeing 777-300', 365, 'Active', 30, 129, 'R130'),
('AF131', 'Bombardier CRJ1000', 100, 'Active', 31, 130, 'R131'),
('AF132', 'Airbus A320neo', 165, 'Active', 32, 131, 'R132'),
('AF133', 'Boeing 787-9', 290, 'Maintanence', 33, 132, 'R133'),
('AF134', 'Embraer E175-E2', 88, 'Active', 34, 133, 'R134'),
('AF135', 'Airbus A330-300', 290, 'Retired', 35, 134, 'R135'),
('AF136', 'Boeing 737-900', 180, 'Active', 36, 135, 'R136'),
('AF137', 'Bombardier Q300', 50, 'Active', 37, 136, 'R137'),
('AF138', 'Airbus A319neo', 140, 'Maintanence', 38, 137, 'R138'),
('AF139', 'Boeing 717-200', 115, 'Active', 39, 138, 'R139'),
('AF140', 'Embraer E190-E2', 114, 'Active', 40, 139, 'R140'),
('AF141', 'Airbus A321neo', 195, 'Active', 41, 140, 'R141'),
('AF142', 'Boeing 787-10', 330, 'Maintanence', 42, 141, 'R142'),
('AF143', 'Bombardier CRJ550', 65, 'Active', 43, 142, 'R143'),
('AF144', 'Airbus A350-1000', 370, 'Active', 44, 143, 'R144'),
('AF145', 'Boeing 737-700', 140, 'Retired', 45, 144, 'R145'),
('AF146', 'Embraer E195-E2', 146, 'Active', 46, 145, 'R146'),
('AF147', 'Airbus A330-900', 310, 'Active', 47, 146, 'R147'),
('AF148', 'Boeing 777X', 425, 'Maintanence', 48, 147, 'R148'),
('AF149', 'Bombardier Global 07', 19, 'Active', 49, 148, 'R149'),
('AF150', 'Airbus A220-300', 135, 'Active', 50, 149, 'R150');


-- -------------------------------------------------------------------------------------------------------------
-- insert values into airports
-- -------------------------------------------------------------------------------------------------------------------

INSERT INTO airports (airport_code, airport_name, airport_city, airport_country, airport_type, booking_id, airflight_id) VALUES
('JFK', 'John F Kennedy', 'New York', 'USA', 'International', 100, 'AF101'),
('LAX', 'Los Angeles Intl', 'Los Angeles', 'USA', 'International', 101, 'AF102'),
('ORD', "O'Hare Intl", 'Chicago', 'USA', 'International', 102, 'AF103'),
('MIA', 'Miami Intl', 'Miami', 'USA', 'International', 103, 'AF104'),
('DFW', 'Dallas Fort Worth', 'Dallas', 'USA', 'International', 104, 'AF105'),
('DEN', 'Denver Intl', 'Denver', 'USA', 'International', 105, 'AF106'),
('SFO', 'San Francisco Intl', 'San Francisco', 'USA', 'International', 106, 'AF107'),
('SEA', 'Seattle Tacoma', 'Seattle', 'USA', 'International', 107, 'AF108'),
('ATL', 'Hartsfield Jackson', 'Atlanta', 'USA', 'International', 108, 'AF109'),
('BOS', 'Logan Intl', 'Boston', 'USA', 'International', 109, 'AF110'),
('LAS', 'McCarran Intl', 'Las Vegas', 'USA', 'International', 110, 'AF111'),
('PHX', 'Sky Harbor Intl', 'Phoenix', 'USA', 'International', 111, 'AF112'),
('IAH', 'George Bush Intl', 'Houston', 'USA', 'International', 112, 'AF113'),
('MSP', 'Minneapolis Saint', 'Minneapolis', 'USA', 'International', 113, 'AF114'),
('DTW', 'Detroit Metro', 'Detroit', 'USA', 'International', 114, 'AF115'),
('EWR', 'Newark Liberty', 'Newark', 'USA', 'International', 115, 'AF116'),
('CLT', 'Charlotte Douglas', 'Charlotte', 'USA', 'International', 116, 'AF117'),
('PHL', 'Philadelphia Intl', 'Philadelphia', 'USA', 'International', 117, 'AF118'),
('SAN', 'San Diego Intl', 'San Diego', 'USA', 'International', 118, 'AF119'),
('PDX', 'Portland Intl', 'Portland', 'USA', 'Domestic', 119, 'AF120'),
('BWI', 'Baltimore Washington', 'Baltimore', 'USA', 'Domestic', 120, 'AF121'),
('SLC', 'Salt Lake City Intl', 'Salt Lake City', 'USA', 'Domestic', 121, 'AF122'),
('AUS', 'Austin Bergstrom', 'Austin', 'USA', 'Domestic', 122, 'AF123'),
('SAT', 'San Antonio Intl', 'San Antonio', 'USA', 'Domestic', 123, 'AF124'),
('STL', 'Lambert St Louis', 'St Louis', 'USA', 'Domestic', 124, 'AF125'),
('RDU', 'Raleigh Durham Intl', 'Raleigh', 'USA', 'Domestic', 125, 'AF126'),
('CMH', 'John Glenn Intl', 'Columbus', 'USA', 'Domestic', 126, 'AF127'),
('IND', 'Indianapolis Intl', 'Indianapolis', 'USA', 'Domestic', 127, 'AF128'),
('MCI', 'Kansas City Intl', 'Kansas City', 'USA', 'Domestic', 128, 'AF129'),
('CVG', 'Cincinnati Northern', 'Cincinnati', 'USA', 'Domestic', 129, 'AF130'),
('MKE', 'General Mitchell', 'Milwaukee', 'USA', 'Domestic', 130, 'AF131'),
('JAX', 'Jacksonville Intl', 'Jacksonville', 'USA', 'Domestic', 131, 'AF132'),
('MEM', 'Memphis Intl', 'Memphis', 'USA', 'Domestic', 132, 'AF133'),
('OKC', 'Will Rogers World', 'Oklahoma City', 'USA', 'Domestic', 133, 'AF134'),
('TUL', 'Tulsa Intl', 'Tulsa', 'USA', 'Domestic', 134, 'AF135'),
('ABQ', 'Albuquerque Sunport', 'Albuquerque', 'USA', 'Domestic', 135, 'AF136'),
('SJC', 'Norman Y Mineta', 'San Jose', 'USA', 'Domestic', 136, 'AF137'),
('SNA', 'John Wayne', 'Santa Ana', 'USA', 'Domestic', 137, 'AF138'),
('OAK', 'Oakland Intl', 'Oakland', 'USA', 'Domestic', 138, 'AF139'),
('SMF', 'Sacramento Intl', 'Sacramento', 'USA', 'Domestic', 139, 'AF140'),
('BDL', 'Bradley Intl', 'Hartford', 'USA', 'Domestic', 140, 'AF141'),
('PIT', 'Pittsburgh Intl', 'Pittsburgh', 'USA', 'Domestic', 141, 'AF142'),
('RIC', 'Richmond Intl', 'Richmond', 'USA', 'Domestic', 142, 'AF143'),
('ORF', 'Norfolk Intl', 'Norfolk', 'USA', 'Domestic', 143, 'AF144'),
('MSY', 'Louis Armstrong', 'New Orleans', 'USA', 'International', 144, 'AF145'),
('BNA', 'Nashville Intl', 'Nashville', 'USA', 'Domestic', 145, 'AF146'),
('CLE', 'Cleveland Hopkins', 'Cleveland', 'USA', 'Domestic', 146, 'AF147'),
('PBI', 'Palm Beach Intl', 'West Palm Beach', 'USA', 'Domestic', 147, 'AF148'),
('RSW', 'Southwest Florida', 'Fort Myers', 'USA', 'Domestic', 148, 'AF149'),
('ANC', 'Ted Stevens', 'Anchorage', 'USA', 'International', 149, 'AF150');

-- ----------------------------------------------------------------------------------
-- insert values into crew_info 
-- --------------------------------------------------------------------------------------------------

INSERT INTO crew_info (crew_id, crew_fullname, crew_mobilno, crew_email, crew_designation, route_id, airflight_id, airport_code) VALUES
(201, 'John Smith', 1234567890, 'john.smith@airline.com', 'Captain', 'R101', 'AF101', 'JFK'),
(202, 'Emily Johnson', 1234567891, 'emily.johnson@airline.com', 'First Officer', 'R102', 'AF102', 'LAX'),
(203, 'Michael Williams', 1234567892, 'michael.williams@airline.com', 'Flight Attendant', 'R103', 'AF103', 'ORD'),
(204, 'Sarah Brown', 1234567893, 'sarah.brown@airline.com', 'Purser', 'R104', 'AF104', 'MIA'),
(205, 'David Jones', 1234567894, 'david.jones@airline.com', 'Captain', 'R105', 'AF105', 'DFW'),
(206, 'Lisa Garcia', 1234567895, 'lisa.garcia@airline.com', 'First Officer', 'R106', 'AF106', 'DEN'),
(207, 'James Miller', 1234567896, 'james.miller@airline.com', 'Flight Engineer', 'R107', 'AF107', 'SFO'),
(208, 'Patricia Davis', 1234567897, 'patricia.davis@airline.com', 'Purser', 'R108', 'AF108', 'SEA'),
(209, 'Robert Rodriguez', 1234567898, 'robert.rodriguez@airline.com', 'Captain', 'R109', 'AF109', 'ATL'),
(210, 'Jennifer Martinez', 1234567899, 'jennifer.martinez@airline.com', 'First Officer', 'R110', 'AF110', 'BOS'),
(211, 'Thomas Wilson', 1234567890, 'thomas.wilson@airline.com', 'Flight Attendant', 'R111', 'AF111', 'LAS'),
(212, 'Linda Anderson', 1234567891, 'linda.anderson@airline.com', 'Purser', 'R112', 'AF112', 'PHX'),
(213, 'Charles Taylor', 1234567892, 'charles.taylor@airline.com', 'Captain', 'R113', 'AF113', 'IAH'),
(214, 'Barbara Thomas', 1234567893, 'barbara.thomas@airline.com', 'First Officer', 'R114', 'AF114', 'MSP'),
(215, 'Christopher Moore', 1234567894, 'christopher.moore@airline.com', 'Flight Engineer', 'R115', 'AF115', 'DTW'),
(216, 'Jessica Jackson', 1234567895, 'jessica.jackson@airline.com', 'Purser', 'R116', 'AF116', 'EWR'),
(217, 'Daniel White', 1234567896, 'daniel.white@airline.com', 'Captain', 'R117', 'AF117', 'CLT'),
(218, 'Karen Harris', 1234567897, 'karen.harris@airline.com', 'First Officer', 'R118', 'AF118', 'PHL'),
(219, 'Matthew Martin', 1234567898, 'matthew.martin@airline.com', 'Flight Attendant', 'R119', 'AF119', 'SAN'),
(220, 'Nancy Thompson', 1234567899, 'nancy.thompson@airline.com', 'Purser', 'R120', 'AF120', 'PDX'),
(221, 'Anthony Garcia', 1234567890, 'anthony.garcia@airline.com', 'Captain', 'R121', 'AF121', 'BWI'),
(222, 'Betty Martinez', 1234567891, 'betty.martinez@airline.com', 'First Officer', 'R122', 'AF122', 'SLC'),
(223, 'Donald Robinson', 1234567892, 'donald.robinson@airline.com', 'Flight Engineer', 'R123', 'AF123', 'AUS'),
(224, 'Dorothy Clark', 1234567893, 'dorothy.clark@airline.com', 'Purser', 'R124', 'AF124', 'SAT'),
(225, 'Paul Rodriguez', 1234567894, 'paul.rodriguez@airline.com', 'Captain', 'R125', 'AF125', 'STL'),
(226, 'Helen Lewis', 1234567895, 'helen.lewis@airline.com', 'First Officer', 'R126', 'AF126', 'RDU'),
(227, 'Mark Lee', 1234567896, 'mark.lee@airline.com', 'Flight Attendant', 'R127', 'AF127', 'CMH'),
(228, 'Sandra Walker', 1234567897, 'sandra.walker@airline.com', 'Purser', 'R128', 'AF128', 'IND'),
(229, 'Steven Hall', 1234567898, 'steven.hall@airline.com', 'Captain', 'R129', 'AF129', 'MCI'),
(230, 'Donna Allen', 1234567899, 'donna.allen@airline.com', 'First Officer', 'R130', 'AF130', 'CVG'),
(231, 'Andrew Young', 1234567890, 'andrew.young@airline.com', 'Flight Engineer', 'R131', 'AF131', 'MKE'),
(232, 'Michelle King', 1234567891, 'michelle.king@airline.com', 'Purser', 'R132', 'AF132', 'JAX'),
(233, 'Brian Wright', 1234567892, 'brian.wright@airline.com', 'Captain', 'R133', 'AF133', 'MEM'),
(234, 'Laura Scott', 1234567893, 'laura.scott@airline.com', 'First Officer', 'R134', 'AF134', 'OKC'),
(235, 'Kevin Green', 1234567894, 'kevin.green@airline.com', 'Flight Attendant', 'R135', 'AF135', 'TUL'),
(236, 'Sarah Adams', 1234567895, 'sarah.adams@airline.com', 'Purser', 'R136', 'AF136', 'ABQ'),
(237, 'Jason Baker', 1234567896, 'jason.baker@airline.com', 'Captain', 'R137', 'AF137', 'SJC'),
(238, 'Kimberly Nelson', 1234567897, 'kimberly.nelson@airline.com', 'First Officer', 'R138', 'AF138', 'SNA'),
(239, 'Eric Carter', 1234567898, 'eric.carter@airline.com', 'Flight Engineer', 'R139', 'AF139', 'OAK'),
(240, 'Maria Mitchell', 1234567899, 'maria.mitchell@airline.com', 'Purser', 'R140', 'AF140', 'SMF'),
(241, 'William Perez', 1234567890, 'william.perez@airline.com', 'Captain', 'R141', 'AF141', 'BDL'),
(242, 'Deborah Roberts', 1234567891, 'deborah.roberts@airline.com', 'First Officer', 'R142', 'AF142', 'PIT'),
(243, 'Richard Turner', 1234567892, 'richard.turner@airline.com', 'Flight Attendant', 'R143', 'AF143', 'RIC'),
(244, 'Susan Phillips', 1234567893, 'susan.phillips@airline.com', 'Purser', 'R144', 'AF144', 'ORF'),
(245, 'Joseph Campbell', 1234567894, 'joseph.campbell@airline.com', 'Captain', 'R145', 'AF145', 'MSY'),
(246, 'Margaret Parker', 1234567895, 'margaret.parker@airline.com', 'First Officer', 'R146', 'AF146', 'BNA'),
(247, 'Thomas Evans', 1234567896, 'thomas.evans@airline.com', 'Flight Engineer', 'R147', 'AF147', 'CLE'),
(248, 'Betty Edwards', 1234567897, 'betty.edwards@airline.com', 'Purser', 'R148', 'AF148', 'PBI'),
(249, 'Jeffrey Collins', 1234567898, 'jeffrey.collins@airline.com', 'Captain', 'R149', 'AF149', 'RSW'),
(250, 'Dorothy Stewart', 1234567899, 'dorothy.stewart@airline.com', 'First Officer', 'R150', 'AF150', 'ANC');


-- -------------------------------------------------------------------------------------------------------------------------------
-- insert into services 
-- -------------------------------------------------------------------------------------------------------------------------------

INSERT INTO services (ticket_id, maintenance_status, security_status, service_type, service_name, passenger_id, booking_id, route_id, airflight_id) VALUES
('TKT1001', 'Complete', 'Cleared', 'Inflight', 'Inflight meal', 1, 100, 'R101', 'AF101'),
('TKT1002', 'Scheduled', 'Under check', 'Ground', 'Extra baggege', 2, 101, 'R102', 'AF102'),
('TKT1003', 'In-Progress', 'Cleared', 'Premium', 'WIFI', 3, 102, 'R103', 'AF103'),
('TKT1004', 'Complete', 'Restricted', 'Inflight', 'Entertainment', 4, 103, 'R104', 'AF104'),
('TKT1005', 'Pending', 'Cleared', 'Ground', 'Extra baggege', 5, 104, 'R105', 'AF105'),
('TKT1006', 'Scheduled', 'Under check', 'Inflight', 'Inflight meal', 6, 105, 'R106', 'AF106'),
('TKT1007', 'Complete', 'Cleared', 'Premium', 'WIFI', 7, 106, 'R107', 'AF107'),
('TKT1008', 'In-Progress', 'Cleared', 'Ground', 'Extra baggege', 8, 107, 'R108', 'AF108'),
('TKT1009', 'Pending', 'Under check', 'Inflight', 'Entertainment', 9, 108, 'R109', 'AF109'),
('TKT1010', 'Complete', 'Cleared', 'Inflight', 'Inflight meal', 10, 109, 'R110', 'AF110'),
('TKT1011', 'Scheduled', 'Restricted', 'Premium', 'WIFI', 11, 110, 'R111', 'AF111'),
('TKT1012', 'In-Progress', 'Cleared', 'Ground', 'Extra baggege', 12, 111, 'R112', 'AF112'),
('TKT1013', 'Complete', 'Under check', 'Inflight', 'Entertainment', 13, 112, 'R113', 'AF113'),
('TKT1014', 'Pending', 'Cleared', 'Inflight', 'Inflight meal', 14, 113, 'R114', 'AF114'),
('TKT1015', 'Scheduled', 'Cleared', 'Ground', 'Extra baggege', 15, 114, 'R115', 'AF115'),
('TKT1016', 'Complete', 'Under check', 'Premium', 'WIFI', 16, 115, 'R116', 'AF116'),
('TKT1017', 'In-Progress', 'Cleared', 'Inflight', 'Entertainment', 17, 116, 'R117', 'AF117'),
('TKT1018', 'Pending', 'Restricted', 'Ground', 'Extra baggege', 18, 117, 'R118', 'AF118'),
('TKT1019', 'Complete', 'Cleared', 'Premium', 'WIFI', 19, 118, 'R119', 'AF119'),
('TKT1020', 'Scheduled', 'Under check', 'Inflight', 'Inflight meal', 20, 119, 'R120', 'AF120'),
('TKT1021', 'In-Progress', 'Cleared', 'Ground', 'Extra baggege', 21, 120, 'R121', 'AF121'),
('TKT1022', 'Complete', 'Cleared', 'Inflight', 'Entertainment', 22, 121, 'R122', 'AF122'),
('TKT1023', 'Pending', 'Under check', 'Premium', 'WIFI', 23, 122, 'R123', 'AF123'),
('TKT1024', 'Scheduled', 'Cleared', 'Ground', 'Extra baggege', 24, 123, 'R124', 'AF124'),
('TKT1025', 'Complete', 'Restricted', 'Inflight', 'Inflight meal', 25, 124, 'R125', 'AF125'),
('TKT1026', 'In-Progress', 'Cleared', 'Premium', 'WIFI', 26, 125, 'R126', 'AF126'),
('TKT1027', 'Pending', 'Under check', 'Inflight', 'Entertainment', 27, 126, 'R127', 'AF127'),
('TKT1028', 'Complete', 'Cleared', 'Ground', 'Extra baggege', 28, 127, 'R128', 'AF128'),
('TKT1029', 'Scheduled', 'Cleared', 'Inflight', 'Inflight meal', 29, 128, 'R129', 'AF129'),
('TKT1030', 'In-Progress', 'Under check', 'Premium', 'WIFI', 30, 129, 'R130', 'AF130'),
('TKT1031', 'Complete', 'Restricted', 'Ground', 'Extra baggege', 31, 130, 'R131', 'AF131'),
('TKT1032', 'Pending', 'Cleared', 'Inflight', 'Entertainment', 32, 131, 'R132', 'AF132'),
('TKT1033', 'Scheduled', 'Under check', 'Premium', 'WIFI', 33, 132, 'R133', 'AF133'),
('TKT1034', 'Complete', 'Cleared', 'Ground', 'Extra baggege', 34, 133, 'R134', 'AF134'),
('TKT1035', 'In-Progress', 'Cleared', 'Inflight', 'Inflight meal', 35, 134, 'R135', 'AF135'),
('TKT1036', 'Pending', 'Under check', 'Premium', 'WIFI', 36, 135, 'R136', 'AF136'),
('TKT1037', 'Complete', 'Cleared', 'Ground', 'Extra baggege', 37, 136, 'R137', 'AF137'),
('TKT1038', 'Scheduled', 'Restricted', 'Inflight', 'Entertainment', 38, 137, 'R138', 'AF138'),
('TKT1039', 'In-Progress', 'Cleared', 'Premium', 'WIFI', 39, 138, 'R139', 'AF139'),
('TKT1040', 'Complete', 'Under check', 'Ground', 'Extra baggege', 40, 139, 'R140', 'AF140'),
('TKT1041', 'Pending', 'Cleared', 'Inflight', 'Inflight meal', 41, 140, 'R141', 'AF141'),
('TKT1042', 'Scheduled', 'Cleared', 'Premium', 'WIFI', 42, 141, 'R142', 'AF142'),
('TKT1043', 'Complete', 'Under check', 'Ground', 'Extra baggege', 43, 142, 'R143', 'AF143'),
('TKT1044', 'In-Progress', 'Restricted', 'Inflight', 'Entertainment', 44, 143, 'R144', 'AF144'),
('TKT1045', 'Pending', 'Cleared', 'Premium', 'WIFI', 45, 144, 'R145', 'AF145'),
('TKT1046', 'Complete', 'Under check', 'Ground', 'Extra baggege', 46, 145, 'R146', 'AF146'),
('TKT1047', 'Scheduled', 'Cleared', 'Inflight', 'Inflight meal', 47, 146, 'R147', 'AF147'),
('TKT1048', 'In-Progress', 'Cleared', 'Premium', 'WIFI', 48, 147, 'R148', 'AF148'),
('TKT1049', 'Complete', 'Under check', 'Ground', 'Extra baggege', 49, 148, 'R149', 'AF149'),
('TKT1050', 'Pending', 'Cleared', 'Inflight', 'Entertainment', 50, 149, 'R150', 'AF150');

-- ----------------------------------------------------------------------------------------------------------------------
-- insert values into transactions
-- --------------------------------------------------------------------------------------------------------------------------

INSERT INTO transactions (transaction_id, transaction_amount, transaction_method, transaction_date, transaction_status, booking_id, ticket_id, passenger_id) VALUES
(500001, 250.00, 'Cards', '2025-04-01 08:35:00', 'Complete', 100, 'TKT1001', 1),
(500002, 180.50, 'UPI', '2025-04-01 10:20:00', 'Complete', 101, 'TKT1002', 2),
(500003, 320.00, 'Net Banking', '2025-04-02 14:10:00', 'Pending', 102, 'TKT1003', 3),
(500004, 450.75, 'Wallet', '2025-04-02 18:50:00', 'Complete', 103, 'TKT1004', 4),
(500005, 120.00, 'Cards', '2025-04-03 06:25:00', 'Failed', 104, 'TKT1005', 5),
(500006, 300.00, 'UPI', '2025-04-03 21:15:00', 'Complete', 105, 'TKT1006', 6),
(500007, 275.50, 'Net Banking', '2025-04-04 09:10:00', 'Processing', 106, 'TKT1007', 7),
(500008, 190.00, 'Cards', '2025-04-04 12:35:00', 'Complete', 107, 'TKT1008', 8),
(500009, 420.00, 'Wallet', '2025-04-05 16:10:00', 'Refunded', 108, 'TKT1009', 9),
(500010, 150.00, 'UPI', '2025-04-05 20:05:00', 'Complete', 109, 'TKT1010', 10),
(500011, 350.00, 'Cards', '2025-04-06 07:10:00', 'Pending', 110, 'TKT1011', 11),
(500012, 210.00, 'Net Banking', '2025-04-06 13:35:00', 'Complete', 111, 'TKT1012', 12),
(500013, 480.00, 'Wallet', '2025-04-07 11:10:00', 'Complete', 112, 'TKT1013', 13),
(500014, 165.00, 'UPI', '2025-04-07 22:20:00', 'Processing', 113, 'TKT1014', 14),
(500015, 295.00, 'Cards', '2025-04-08 05:50:00', 'Canceled', 114, 'TKT1015', 15),
(500016, 330.00, 'Net Banking', '2025-04-08 17:35:00', 'Complete', 115, 'TKT1016', 16),
(500017, 185.00, 'Wallet', '2025-04-09 08:10:00', 'Complete', 116, 'TKT1017', 17),
(500018, 410.00, 'UPI', '2025-04-09 19:25:00', 'Failed', 117, 'TKT1018', 18),
(500019, 225.00, 'Cards', '2025-04-10 10:10:00', 'Complete', 118, 'TKT1019', 19),
(500020, 340.00, 'Net Banking', '2025-04-10 23:05:00', 'Pending', 119, 'TKT1020', 20),
(500021, 155.00, 'Wallet', '2025-04-11 06:35:00', 'Complete', 120, 'TKT1021', 21),
(500022, 270.00, 'UPI', '2025-04-11 15:10:00', 'Complete', 121, 'TKT1022', 22),
(500023, 390.00, 'Cards', '2025-04-12 12:10:00', 'Refunded', 122, 'TKT1023', 23),
(500024, 140.00, 'Net Banking', '2025-04-12 20:35:00', 'Complete', 123, 'TKT1024', 24),
(500025, 310.00, 'Wallet', '2025-04-13 07:20:00', 'Processing', 124, 'TKT1025', 25),
(500026, 200.00, 'UPI', '2025-04-13 18:50:00', 'Complete', 125, 'TKT1026', 26),
(500027, 460.00, 'Cards', '2025-04-14 09:10:00', 'Complete', 126, 'TKT1027', 27),
(500028, 175.00, 'Net Banking', '2025-04-14 21:35:00', 'Pending', 127, 'TKT1028', 28),
(500029, 285.00, 'Wallet', '2025-04-15 11:10:00', 'Complete', 128, 'TKT1029', 29),
(500030, 365.00, 'UPI', '2025-04-15 16:10:00', 'Failed', 129, 'TKT1030', 30),
(500031, 130.00, 'Cards', '2025-04-16 08:35:00', 'Complete', 130, 'TKT1031', 31),
(500032, 245.00, 'Net Banking', '2025-04-16 13:10:00', 'Complete', 131, 'TKT1032', 32),
(500033, 380.00, 'Wallet', '2025-04-17 10:40:00', 'Canceled', 132, 'TKT1033', 33),
(500034, 160.00, 'UPI', '2025-04-17 22:10:00', 'Complete', 133, 'TKT1034', 34),
(500035, 290.00, 'Cards', '2025-04-18 06:10:00', 'Processing', 134, 'TKT1035', 35),
(500036, 355.00, 'Net Banking', '2025-04-18 19:10:00', 'Complete', 135, 'TKT1036', 36),
(500037, 195.00, 'Wallet', '2025-04-19 07:35:00', 'Complete', 136, 'TKT1037', 37),
(500038, 430.00, 'UPI', '2025-04-19 14:35:00', 'Refunded', 137, 'TKT1038', 38),
(500039, 260.00, 'Cards', '2025-04-20 09:50:00', 'Complete', 138, 'TKT1039', 39),
(500040, 315.00, 'Net Banking', '2025-04-20 18:10:00', 'Pending', 139, 'TKT1040', 40),
(500041, 145.00, 'Wallet', '2025-04-21 08:10:00', 'Complete', 140, 'TKT1041', 41),
(500042, 235.00, 'UPI', '2025-04-21 16:35:00', 'Complete', 141, 'TKT1042', 42),
(500043, 370.00, 'Cards', '2025-04-22 11:20:00', 'Failed', 142, 'TKT1043', 43),
(500044, 205.00, 'Net Banking', '2025-04-22 20:10:00', 'Complete', 143, 'TKT1044', 44),
(500045, 325.00, 'Wallet', '2025-04-23 05:35:00', 'Processing', 144, 'TKT1045', 45),
(500046, 280.00, 'UPI', '2025-04-23 17:10:00', 'Complete', 145, 'TKT1046', 46),
(500047, 395.00, 'Cards', '2025-04-24 10:10:00', 'Complete', 146, 'TKT1047', 47),
(500048, 135.00, 'Net Banking', '2025-04-24 21:10:00', 'Pending', 147, 'TKT1048', 48),
(500049, 305.00, 'Wallet', '2025-04-25 12:10:00', 'Complete', 148, 'TKT1049', 49),
(500050, 220.00, 'UPI', '2025-04-25 19:35:00', 'Complete', 149, 'TKT1050', 50);


-- ---------------------------------------------------------------------------------------------------------------
-- insert values into revenue
-- --------------------------------------------------------------------------------------------------------------=--

INSERT INTO revenue (revenue_id, revenue_amount, ticket_id, booking_id, transaction_id) VALUES
(301, 250.00, 'TKT1001', 100, 500001),
(302, 180.50, 'TKT1002', 101, 500002),
(303, 320.00, 'TKT1003', 102, 500003),
(304, 450.75, 'TKT1004', 103, 500004),
(305, 120.00, 'TKT1005', 104, 500005),
(306, 300.00, 'TKT1006', 105, 500006),
(307, 275.50, 'TKT1007', 106, 500007),
(308, 190.00, 'TKT1008', 107, 500008),
(309, 420.00, 'TKT1009', 108, 500009),
(310, 150.00, 'TKT1010', 109, 500010),
(311, 350.00, 'TKT1011', 110, 500011),
(312, 210.00, 'TKT1012', 111, 500012),
(313, 480.00, 'TKT1013', 112, 500013),
(314, 165.00, 'TKT1014', 113, 500014),
(315, 295.00, 'TKT1015', 114, 500015),
(316, 330.00, 'TKT1016', 115, 500016),
(317, 185.00, 'TKT1017', 116, 500017),
(318, 410.00, 'TKT1018', 117, 500018),
(319, 225.00, 'TKT1019', 118, 500019),
(320, 340.00, 'TKT1020', 119, 500020),
(321, 155.00, 'TKT1021', 120, 500021),
(322, 270.00, 'TKT1022', 121, 500022),
(323, 390.00, 'TKT1023', 122, 500023),
(324, 140.00, 'TKT1024', 123, 500024),
(325, 310.00, 'TKT1025', 124, 500025),
(326, 200.00, 'TKT1026', 125, 500026),
(327, 460.00, 'TKT1027', 126, 500027),
(328, 175.00, 'TKT1028', 127, 500028),
(329, 285.00, 'TKT1029', 128, 500029),
(330, 365.00, 'TKT1030', 129, 500030),
(331, 130.00, 'TKT1031', 130, 500031),
(332, 245.00, 'TKT1032', 131, 500032),
(333, 380.00, 'TKT1033', 132, 500033),
(334, 160.00, 'TKT1034', 133, 500034),
(335, 290.00, 'TKT1035', 134, 500035),
(336, 355.00, 'TKT1036', 135, 500036),
(337, 195.00, 'TKT1037', 136, 500037),
(338, 430.00, 'TKT1038', 137, 500038),
(339, 260.00, 'TKT1039', 138, 500039),
(340, 315.00, 'TKT1040', 139, 500040),
(341, 145.00, 'TKT1041', 140, 500041),
(342, 235.00, 'TKT1042', 141, 500042),
(343, 370.00, 'TKT1043', 142, 500043),
(344, 205.00, 'TKT1044', 143, 500044),
(345, 325.00, 'TKT1045', 144, 500045),
(346, 280.00, 'TKT1046', 145, 500046),
(347, 395.00, 'TKT1047', 146, 500047),
(348, 135.00, 'TKT1048', 147, 500048),
(349, 305.00, 'TKT1049', 148, 500049),
(350, 220.00, 'TKT1050', 149, 500050);

-- ---------------------------------------------------------------------------------------------------
-- insert values into reviews
-- -------------------------------------------------------------------------------------------------------------------

INSERT INTO reviews (passenger_feedback, passenger_rating, crew_feedback, crew_rating, booking_feedback, passenger_id, booking_id, crew_id) VALUES
('Excellent flight experience', 5, 'Very professional crew', 5, 'Smooth booking process', 1, 100, 201),
('Good journey but delayed', 4, 'Helpful staff', 4, 'Easy online booking', 2, 101, 202),
('Average experience', 3, 'Crew was okay', 3, 'Booking was fine', 3, 102, 203),
('Great service', 5, 'Friendly and attentive', 5, 'Seamless booking', 4, 103, 204),
('Flight was delayed', 2, 'Crew apologized', 3, 'Had issues with payment', 2, 104, 205),
('Wonderful trip', 5, 'Excellent crew', 5, 'Very efficient booking', 6, 105, 206),
('Comfortable seats', 4, 'Good service', 4, 'Booking was quick', 7, 106, 207),
('Poor food quality', 2, 'Crew was rude', 2, 'Confusing booking system', 8, 107, 208),
('Amazing experience', 5, 'Best crew ever', 5, 'Very smooth process', 9, 108, 209),
('Good value for money', 4, 'Professional staff', 4, 'Booking confirmed instantly', 10, 109, 210),
('Flight was bumpy', 3, 'Crew handled well', 4, 'No issues with booking', 11, 110, 211),
('Excellent entertainment', 5, 'Very helpful crew', 5, 'Easy and fast', 12, 111, 212),
('Delayed takeoff', 2, 'Crew kept us informed', 3, 'Booking was straightforward', 13, 112, 213),
('Great legroom', 4, 'Friendly staff', 5, 'Smooth process', 14, 113, 214),
('Lost my luggage', 1, 'Crew helped track it', 3, 'Booking was easy', 15, 114, 215),
('Perfect flight', 5, 'Exceptional service', 5, 'Flawless booking', 16, 115, 216),
('Good but crowded', 3, 'Crew was efficient', 4, 'No complaints', 17, 116, 217),
('Excellent cleanliness', 5, 'Very polite crew', 5, 'Quick confirmation', 18, 117, 218),
('Flight was overbooked', 2, 'Crew managed well', 3, 'Booking had glitch', 19, 118, 219),
('Amazing views', 5, 'Courteous staff', 5, 'Very user-friendly', 20, 119, 220),
('Good experience', 4, 'Helpful crew', 4, 'Smooth transaction', 21, 120, 221),
('Average service', 3, 'Crew was neutral', 3, 'Booking was okay', 22, 121, 222),
('Exceptional comfort', 5, 'World-class crew', 5, 'Perfect booking portal', 23, 122, 223),
('Flight delayed again', 2, 'Poor communication', 2, 'Booking confirmation late', 24, 123, 224),
('Great value', 4, 'Friendly crew', 4, 'Easy to use', 25, 124, 225),
('Excellent overall', 5, 'Very professional', 5, 'No issues at all', 26, 125, 226),
('Seats too tight', 2, 'Crew was nice', 3, 'Booking was fine', 27, 126, 227),
('Wonderful journey', 5, 'Outstanding crew', 5, 'Very efficient', 28, 127, 228),
('Good but pricey', 3, 'Good service', 4, 'Booking was smooth', 29, 128, 229),
('Flight was cancelled', 1, 'Crew rebooked us', 3, 'Refund process slow', 30, 129, 230),
('Great experience', 5, 'Excellent crew', 5, 'Flawless booking', 31, 130, 231),
('Good food', 4, 'Attentive staff', 4, 'Quick and easy', 32, 131, 232),
('Average journey', 3, 'Crew was okay', 3, 'Booking had minor issue', 33, 132, 233),
('Very comfortable', 5, 'Friendly and helpful', 5, 'Smooth process', 34, 133, 234),
('Flight was noisy', 2, 'Crew apologized', 3, 'Booking was fine', 35, 134, 235),
('Excellent service', 5, 'Best crew ever', 5, 'Very user-friendly', 36, 135, 236),
('Good experience', 4, 'Professional staff', 4, 'Easy booking', 37, 136, 237),
('Delayed and crowded', 2, 'Crew tried their best', 3, 'Booking was okay', 38, 137, 238),
('Amazing trip', 5, 'Exceptional crew', 5, 'Seamless experience', 39, 138, 239),
('Good but expensive', 3, 'Good service', 4, 'Booking was easy', 40, 139, 240),
('Perfect in every way', 5, 'Fantastic crew', 5, 'Very efficient', 41, 140, 241),
('Satisfactory journey', 4, 'Polite staff', 4, 'No complaints', 42, 141, 242),
('Flight was okay', 3, 'Crew was average', 3, 'Booking took time', 43, 142, 243),
('Excellent experience', 5, 'Very helpful crew', 5, 'Smooth and fast', 44, 143, 244),
('Good value trip', 4, 'Friendly staff', 4, 'Easy to navigate', 45, 144, 245),
('Flight was late', 2, 'Crew was courteous', 3, 'Booking confirmed late', 46, 145, 246),
('Wonderful service', 5, 'Outstanding crew', 5, 'Perfect booking', 47, 146, 247),
('Good but cramped', 3, 'Good crew', 4, 'Booking was fine', 48, 147, 248),
('Excellent overall', 5, 'Best experience', 5, 'Very smooth', 49, 148, 249),
('Great flight', 4, 'Professional crew', 4, 'Easy booking process', 50, 149, 250);

select * from crew_info;
select * from services;

-- 10 BUSINESS QUESTIONS

-- Q1- Total Number of Flights we have with use?
select count(*) as total_flights
from airflights;

-- Q2 - What is the Total Revenue Generation?
select sum(revenue_amount) as total_revenue 
from revenue;

-- Q3 - What will be the average capacity of flights?
select avg(airflight_capacity) as avg_capacity
from airflights;

-- Q4 - What will be the top 5 flighst that gives more revenue?
select a.airflight_id, a.airflight_model,
sum(r.revenue_amount) as Top_5_revenueGeneration
from revenue r 
join airflights a
on r.booking_id = a.booking_id
group by a.airflight_id , a.airflight_model
order by Top_5_revenueGeneration desc
limit 5;

-- Q5 - What will be the Revenue per Booking?
select booking_id,
sum(revenue_amount)
from revenue
group by booking_id;

-- Q6 - Is Aerox generating more revenue through Economy, Business Class, Cargo?
select b.booking_class,
sum(r.revenue_amount) as total_revenue
from revenue r
join bookings b
on r.booking_id = b.booking_id
where booking_class in ('Business','Cargo','Economy')
group by booking_class
order by total_revenue desc;

-- Q7 - What will be the CSAT Scorerating given by passenger?
select sum(case
when passenger_rating >= 4 then 1 else 0 end) *100 /
count(*) as CSAT_score
from reviews;

-- Q8 - What will be the trend with respect to Booking?
select day(booking_date), count(booking_date) as total_bookings
from bookings 
group by day(booking_date);

-- Q9 - What are the different services our company is offering?
select distinct(service_name) from services;

-- Q10 - How many flights are under Maintenance?
select a.airflight_id , a.airflight_model , s.maintenance_status 
from services s 
join airflights a
on s.airflight_id = a.airflight_id
where maintenance_status = 'In-Progress';