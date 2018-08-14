-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 14, 2018 at 09:39 PM
-- Server version: 10.1.33-MariaDB
-- PHP Version: 7.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tenant_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `accepted_application`
--

CREATE TABLE `accepted_application` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `application_requirements`
--

CREATE TABLE `application_requirements` (
  `id` int(11) NOT NULL,
  `unit` int(11) NOT NULL,
  `application_fee` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='application prerequisites of a unit ';

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `tenant` int(11) NOT NULL,
  `invoice_number` int(50) NOT NULL,
  `invoice` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leasing_info`
--

CREATE TABLE `leasing_info` (
  `id` int(11) NOT NULL,
  `leasing_type` varchar(50) NOT NULL,
  `security_deposit` decimal(10,2) NOT NULL,
  `rent` decimal(10,2) NOT NULL,
  `utility_charge` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='leasing information of a unit ';

--
-- Dumping data for table `leasing_info`
--

INSERT INTO `leasing_info` (`id`, `leasing_type`, `security_deposit`, `rent`, `utility_charge`) VALUES
(1, 'monthly', '10000.00', '15000.00', '5000.00'),
(2, 'monthly', '10000.00', '15000.00', '5000.00'),
(3, 'monthly', '10000.00', '15000.00', '5000.00'),
(4, 'monthly', '10000.00', '15000.00', '5000.00'),
(5, 'monthly', '10000.00', '15000.00', '5000.00');

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_requests`
--

CREATE TABLE `maintenance_requests` (
  `id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `requester` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `occupant`
--

CREATE TABLE `occupant` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `moved_in` date NOT NULL,
  `lease_period` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payment_log`
--

CREATE TABLE `payment_log` (
  `id` int(11) NOT NULL,
  `invoice_number` int(50) NOT NULL,
  `tenant` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `property`
--

CREATE TABLE `property` (
  `ren_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `units_managed` int(50) NOT NULL,
  `registered_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `manager` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Properties recorded by registered tenants. ';

--
-- Dumping data for table `property`
--

INSERT INTO `property` (`ren_id`, `name`, `address`, `units_managed`, `registered_on`, `manager`) VALUES
(1, 'skylark', 'rongai', 8, '2018-08-10 14:15:42', 4),
(2, 'eddos', 'kitengela\r\n', 2, '2018-08-10 14:16:36', 4),
(3, 'Laiser Courst', 'Embakasi', 5, '2018-08-13 05:26:28', 2),
(4, 'Kikoy House', 'Westlands', 8, '2018-08-13 05:27:36', 2),
(5, 'Meso Flats', 'Riruta, Dagoretti', 20, '2018-08-13 05:28:48', 2),
(6, 'Zuri Apartments', 'Githurai 44', 10, '2018-08-13 05:30:27', 2),
(7, 'Mukami House', 'Ngara', 20, '2018-08-13 05:31:03', 6),
(8, 'Jamir Luxury Apartments', 'South B', 20, '2018-08-13 05:32:00', 6),
(9, 'Kenan Courts', 'Ngong Road', 10, '2018-08-13 05:32:41', 6),
(10, 'Sherehe Flats', 'Kayole', 15, '2018-08-13 05:33:33', 6),
(11, 'Mawingu Hostels', 'Figtree, Ngara', 15, '2018-08-13 05:34:34', 6);

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `unit_id` int(11) NOT NULL,
  `property` int(11) NOT NULL,
  `unit_name` varchar(50) NOT NULL,
  `features` varchar(255) NOT NULL,
  `is_available` char(1) NOT NULL,
  `is_reserved` char(1) DEFAULT NULL,
  `lease_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='units belonging to recorded properties ';

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`unit_id`, `property`, `unit_name`, `features`, `is_available`, `is_reserved`, `lease_id`) VALUES
(3, 1, 'A01', 'studio room \r\n', 'N', 'N', 1),
(4, 1, 'A-02', 'studio room', 'Y', 'N', 1),
(5, 1, 'A-03', 'studio room', 'Y', 'N', 1),
(6, 1, 'A-04', 'studio room', 'N', 'N', 1),
(7, 1, 'A-05', 'studio room', 'N', 'Y', 1),
(9, 1, 'A-06', 'studio room', 'Y', 'Y', 1),
(10, 2, 'E01', '1 bedroom', 'Y', 'Y', 2),
(11, 2, 'E02', '1 bedroom', 'N', 'Y', 2),
(12, 2, 'E03', '2 bedroom Master Ensuite', 'N', 'N', 3),
(13, 3, 'house_1', '2 bedroom Master Ensuite', 'N', 'N', 4),
(14, 3, 'house_2', '3  bedroom Master Ensuite', 'N', 'N', 5),
(15, 3, 'house_3', '3  bedroom Master Ensuite', 'Y', 'Y', 5),
(16, 4, 'Kikoy1', '10*15(150 SF)', 'Y', 'Y', 5),
(17, 4, 'Kikoy2', '10*15(150 SF)', 'Y', 'Y', 5),
(18, 4, 'Kikoy3', '10*15(150 SF)', 'Y', 'Y', 5),
(20, 4, 'Kikoy4', '12*10(120 SF)', 'N', 'N', 5),
(21, 4, 'Kikoy5', '8*6(48 SF)', 'N', 'N', 5),
(22, 4, 'Kikoy6', '10*10 (10 SF)', 'N', 'N', 5),
(23, 11, 'ROOM1', '2-SHARING', 'N', 'N', 5),
(25, 11, 'ROOM2', '2-SHARING', 'N', 'N', 5),
(27, 11, 'ROOM3', '3-SHARING', 'N', 'N', 5),
(28, 11, 'ROOM4', '3-SHARING', 'Y', 'N', 5),
(29, 11, 'ROOM5', '3-SHARING', 'Y', 'N', 5),
(30, 11, 'ROOM6', '3-SHARING', 'Y', 'N', 5),
(31, 8, 'A1', '3BR', 'Y', 'N', 5),
(32, 8, 'B1', '3BR', 'N', 'N', 5),
(33, 8, 'B2', '3BR', 'N', 'N', 5),
(34, 8, 'B3', '2BR', 'N', 'N', 5),
(37, 8, 'B4', '2BR', 'Y', 'Y', 5),
(38, 8, 'B5', '2BR', 'Y', 'Y', 5);

-- --------------------------------------------------------

--
-- Table structure for table `unit_application`
--

CREATE TABLE `unit_application` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `id_proof_document` varchar(50) NOT NULL,
  `id_proof_doc_no` varchar(50) NOT NULL,
  `submit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Applications to rent listed vacant units ';

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `account` enum('T','RM','ADMIN') NOT NULL,
  `first_name` varchar(15) NOT NULL,
  `last_name` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_number` int(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `signup_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='system users ';

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `account`, `first_name`, `last_name`, `email`, `phone_number`, `password`, `signup_date`) VALUES
(1, 'ADMIN', 'Grace', 'Murigi', 'gracemurigi95@gmail.com', 729695435, '$5$rounds=535000$gT87VLewknc3br.E$fzdGRwTQY2LHJhkhP5T0VpzqYKLLhLiTbXpkwt2QKZ4', '2018-07-17 06:24:06'),
(2, 'RM', 'Fridah ', 'Kanini ', 'kaninifridah436@gmail.com', 725410486, '$5$rounds=535000$plOhm2lgdU5HDTYx$smAN2Z1g996s5hTCcM2X3QTYVXJOT5IWFYjMkW9WIa6', '2018-07-17 06:26:07'),
(3, 'T', 'Marie ', 'Chemtai', 'mariechemu@gmail.com', 700123456, '$5$rounds=535000$emrh0TpKv2TIDZwk$GyTKC63jKWn6Ep/85lkvIrjRyL6dsgRBk53kya08Xt/', '2018-08-05 14:04:03'),
(4, 'RM', 'Griffin', 'Mfalme', 'mfalmegriffin@gmail.com', 2147483647, '$5$rounds=535000$NyTi5EzJcioKQv.n$ZFLiHGqh0JbohrTFY8erUby1/68tZUMT5WSYUxGNZc.', '2018-08-10 13:35:51'),
(6, 'RM', 'Joy ', 'Githu ', 'rosegrace68@gmail.com', 700321654, '$5$rounds=535000$guGcz0GPHRPzfS9Q$nDOMbbWSZuy2QXSqk0N9kr33/q09EqYtGQ1AaBY1Mo7', '2018-08-13 05:07:24'),
(7, 'T', 'Isaac ', 'Murray ', 'murray@live.ca', 789254163, '$5$rounds=535000$qhvtUox28vKvodcU$dNbfNsquIDohw1mLsKFAzYY/ldfKZA.AsZqS5w0BeB1', '2018-08-13 05:08:40');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accepted_application`
--
ALTER TABLE `accepted_application`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_appliaction` (`application_id`);

--
-- Indexes for table `application_requirements`
--
ALTER TABLE `application_requirements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_apply_to_unit` (`unit`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`invoice_number`),
  ADD KEY `fk_billtothistenant` (`tenant`);

--
-- Indexes for table `leasing_info`
--
ALTER TABLE `leasing_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_requester` (`requester`);

--
-- Indexes for table `occupant`
--
ALTER TABLE `occupant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rented_unit` (`unit_id`),
  ADD KEY `fk_occupant` (`user_id`);

--
-- Indexes for table `payment_log`
--
ALTER TABLE `payment_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_payer` (`tenant`),
  ADD KEY `fk_invoice` (`invoice_number`);

--
-- Indexes for table `property`
--
ALTER TABLE `property`
  ADD PRIMARY KEY (`ren_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `fk_manager` (`manager`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`unit_id`),
  ADD UNIQUE KEY `unit_name` (`unit_name`),
  ADD KEY `fk_lease_details` (`lease_id`),
  ADD KEY `fk_property_details` (`property`);

--
-- Indexes for table `unit_application`
--
ALTER TABLE `unit_application`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_applied_unit` (`unit_id`),
  ADD KEY `fk_applicant` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accepted_application`
--
ALTER TABLE `accepted_application`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `application_requirements`
--
ALTER TABLE `application_requirements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leasing_info`
--
ALTER TABLE `leasing_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `occupant`
--
ALTER TABLE `occupant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_log`
--
ALTER TABLE `payment_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `property`
--
ALTER TABLE `property`
  MODIFY `ren_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `unit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `unit_application`
--
ALTER TABLE `unit_application`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accepted_application`
--
ALTER TABLE `accepted_application`
  ADD CONSTRAINT `fk_appliaction` FOREIGN KEY (`application_id`) REFERENCES `unit_application` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `application_requirements`
--
ALTER TABLE `application_requirements`
  ADD CONSTRAINT `fk_apply_to_unit` FOREIGN KEY (`unit`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE;

--
-- Constraints for table `invoice`
--
ALTER TABLE `invoice`
  ADD CONSTRAINT `fk_billtothistenant` FOREIGN KEY (`tenant`) REFERENCES `occupant` (`id`);

--
-- Constraints for table `maintenance_requests`
--
ALTER TABLE `maintenance_requests`
  ADD CONSTRAINT `fk_requester` FOREIGN KEY (`requester`) REFERENCES `occupant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `occupant`
--
ALTER TABLE `occupant`
  ADD CONSTRAINT `fk_occupant` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rented_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE;

--
-- Constraints for table `payment_log`
--
ALTER TABLE `payment_log`
  ADD CONSTRAINT `fk_invoice` FOREIGN KEY (`invoice_number`) REFERENCES `invoice` (`invoice_number`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_payer` FOREIGN KEY (`tenant`) REFERENCES `occupant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `property`
--
ALTER TABLE `property`
  ADD CONSTRAINT `fk_manager` FOREIGN KEY (`manager`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `fk_lease_details` FOREIGN KEY (`lease_id`) REFERENCES `leasing_info` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_property_details` FOREIGN KEY (`property`) REFERENCES `property` (`ren_id`) ON DELETE CASCADE;

--
-- Constraints for table `unit_application`
--
ALTER TABLE `unit_application`
  ADD CONSTRAINT `fk_applicant` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_applied_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
