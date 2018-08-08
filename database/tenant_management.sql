-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 09, 2018 at 12:22 AM
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
  `move_in_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `application_requirements`
--

CREATE TABLE `application_requirements` (
  `id` int(11) NOT NULL,
  `unit` int(11) NOT NULL,
  `application_fee` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `leasing_info`
--

CREATE TABLE `leasing_info` (
  `id` int(11) NOT NULL,
  `leasing_type` varchar(50) NOT NULL,
  `application_fee` decimal(10,2) NOT NULL,
  `security_deposit` decimal(10,2) NOT NULL,
  `rent` decimal(10,2) NOT NULL,
  `utility_charge` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='this describes the leasing deatils of a unit ';

-- --------------------------------------------------------

--
-- Table structure for table `maintenace_requests`
--

CREATE TABLE `maintenace_requests` (
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
  `renter_id` int(11) NOT NULL,
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
  `paid_by` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `received_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `property`
--

CREATE TABLE `property` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `units_managed` int(50) NOT NULL,
  `registered_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `manager` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `renters`
--

CREATE TABLE `renters` (
  `renter_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `id_proof_document` varchar(50) NOT NULL,
  `id_proof_doc_no` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `renter_application`
--

CREATE TABLE `renter_application` (
  `id` int(11) NOT NULL,
  `renter_id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `submit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tenant_manager`
--

CREATE TABLE `tenant_manager` (
  `mgr_id` int(11) NOT NULL,
  `work_email` varchar(50) NOT NULL,
  `work_phone` varchar(20) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `unit_id` int(11) NOT NULL,
  `property` int(11) NOT NULL,
  `unit_name` varchar(50) NOT NULL,
  `purpose` varchar(50) NOT NULL,
  `features` varchar(255) NOT NULL,
  `is_available` char(1) NOT NULL,
  `is_reserved` char(1) DEFAULT NULL,
  `lease_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `account` enum('T','RM') NOT NULL,
  `first_name` varchar(15) NOT NULL,
  `last_name` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_number` int(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `signup_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `account`, `first_name`, `last_name`, `email`, `phone_number`, `password`, `signup_date`) VALUES
(1, 'T', 'Grace', 'Murigi', 'gracemurigi95@gmail.com', 729695435, '$5$rounds=535000$gT87VLewknc3br.E$fzdGRwTQY2LHJhkhP5T0VpzqYKLLhLiTbXpkwt2QKZ4', '2018-07-17 06:24:06'),
(2, 'RM', 'Fridah ', 'Kanini ', 'kaninifridah436@gmail.com', 725410486, '$5$rounds=535000$plOhm2lgdU5HDTYx$smAN2Z1g996s5hTCcM2X3QTYVXJOT5IWFYjMkW9WIa6', '2018-07-17 06:26:07'),
(3, 'T', 'Marie ', 'Chemtai', 'mariechemu@gmail.com', 700123456, '$5$rounds=535000$emrh0TpKv2TIDZwk$GyTKC63jKWn6Ep/85lkvIrjRyL6dsgRBk53kya08Xt/', '2018-08-05 14:04:03');

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
-- Indexes for table `leasing_info`
--
ALTER TABLE `leasing_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `maintenace_requests`
--
ALTER TABLE `maintenace_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_requester` (`requester`);

--
-- Indexes for table `occupant`
--
ALTER TABLE `occupant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_occupant` (`renter_id`),
  ADD KEY `fk_rented_unit` (`unit_id`);

--
-- Indexes for table `payment_log`
--
ALTER TABLE `payment_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_payer` (`paid_by`),
  ADD KEY `fk_receiver` (`received_by`);

--
-- Indexes for table `property`
--
ALTER TABLE `property`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `renters`
--
ALTER TABLE `renters`
  ADD PRIMARY KEY (`renter_id`),
  ADD KEY `details_FK` (`user_id`);

--
-- Indexes for table `renter_application`
--
ALTER TABLE `renter_application`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_applicant` (`renter_id`),
  ADD KEY `fk_applied_unit` (`unit_id`);

--
-- Indexes for table `tenant_manager`
--
ALTER TABLE `tenant_manager`
  ADD PRIMARY KEY (`mgr_id`),
  ADD KEY `user_id_FK` (`user_id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`unit_id`),
  ADD UNIQUE KEY `unit_name` (`unit_name`),
  ADD KEY `fk_unit_building` (`property`),
  ADD KEY `fk_lease_details` (`lease_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenace_requests`
--
ALTER TABLE `maintenace_requests`
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
-- AUTO_INCREMENT for table `renters`
--
ALTER TABLE `renters`
  MODIFY `renter_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `renter_application`
--
ALTER TABLE `renter_application`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tenant_manager`
--
ALTER TABLE `tenant_manager`
  MODIFY `mgr_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `unit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accepted_application`
--
ALTER TABLE `accepted_application`
  ADD CONSTRAINT `fk_appliaction` FOREIGN KEY (`application_id`) REFERENCES `renter_application` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `application_requirements`
--
ALTER TABLE `application_requirements`
  ADD CONSTRAINT `fk_apply_to_unit` FOREIGN KEY (`unit`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE;

--
-- Constraints for table `maintenace_requests`
--
ALTER TABLE `maintenace_requests`
  ADD CONSTRAINT `fk_requester` FOREIGN KEY (`requester`) REFERENCES `occupant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `occupant`
--
ALTER TABLE `occupant`
  ADD CONSTRAINT `fk_occupant` FOREIGN KEY (`renter_id`) REFERENCES `renters` (`renter_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rented_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE;

--
-- Constraints for table `payment_log`
--
ALTER TABLE `payment_log`
  ADD CONSTRAINT `fk_payer` FOREIGN KEY (`paid_by`) REFERENCES `occupant` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_receiver` FOREIGN KEY (`received_by`) REFERENCES `tenant_manager` (`mgr_id`) ON DELETE CASCADE;

--
-- Constraints for table `renters`
--
ALTER TABLE `renters`
  ADD CONSTRAINT `details_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `renter_application`
--
ALTER TABLE `renter_application`
  ADD CONSTRAINT `fk_applicant` FOREIGN KEY (`renter_id`) REFERENCES `renters` (`renter_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_applied_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`) ON DELETE CASCADE;

--
-- Constraints for table `tenant_manager`
--
ALTER TABLE `tenant_manager`
  ADD CONSTRAINT `user_id_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `fk_lease_details` FOREIGN KEY (`lease_id`) REFERENCES `leasing_info` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_unit_building` FOREIGN KEY (`property`) REFERENCES `property` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
