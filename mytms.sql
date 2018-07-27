-- phpMyAdmin SQL Dump
-- version 4.8.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 22, 2018 at 01:59 PM
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
-- Database: `mytms`
--

-- --------------------------------------------------------

--
-- Table structure for table `rental_properties`
--

CREATE TABLE `rental_properties` (
  `prop_id` int(11) NOT NULL,
  `property_name` varchar(20) NOT NULL,
  `address` varchar(50) NOT NULL,
  `purpose` varchar(20) NOT NULL,
  `units` int(10) NOT NULL,
  `mgr_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tenant`
--

CREATE TABLE `tenant` (
  `ten_id` int(11) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_number` int(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `signup_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tenant`
--

INSERT INTO `tenant` (`ten_id`, `first_name`, `last_name`, `email`, `phone_number`, `password`, `signup_date`) VALUES
(1, 'Fridah ', 'Kanini ', 'kaninifridah436@gmail.com', 725410486, '$5$rounds=535000$4/lgF9GFe6eABih2$/9VkE8mVqKciBr5R4vOS7fDIYRK8kek8.t8M7iWQZQ1', '2018-07-22 08:41:31');

-- --------------------------------------------------------

--
-- Table structure for table `tenant_manager`
--

CREATE TABLE `tenant_manager` (
  `mgr_id` int(11) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone_number` int(20) NOT NULL,
  `company` varchar(50) DEFAULT NULL,
  `password` varchar(100) NOT NULL,
  `signup_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tenant_manager`
--

INSERT INTO `tenant_manager` (`mgr_id`, `first_name`, `last_name`, `email`, `phone_number`, `company`, `password`, `signup_date`) VALUES
(1, 'Grace', 'Murigi', 'gracemurigi95@gmail.com', 729695435, 'Kenli Agencies', '$5$rounds=535000$KtjppZcwEdlb9PWk$CNLT7djK5CDcZz94Ms3R3ZMiVLWdXVhWc5sZ/9sCnB9', '2018-07-22 08:36:20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rental_properties`
--
ALTER TABLE `rental_properties`
  ADD PRIMARY KEY (`prop_id`),
  ADD KEY `mgr_FK` (`mgr_id`);

--
-- Indexes for table `tenant`
--
ALTER TABLE `tenant`
  ADD PRIMARY KEY (`ten_id`);

--
-- Indexes for table `tenant_manager`
--
ALTER TABLE `tenant_manager`
  ADD PRIMARY KEY (`mgr_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rental_properties`
--
ALTER TABLE `rental_properties`
  MODIFY `prop_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tenant`
--
ALTER TABLE `tenant`
  MODIFY `ten_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tenant_manager`
--
ALTER TABLE `tenant_manager`
  MODIFY `mgr_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rental_properties`
--
ALTER TABLE `rental_properties`
  ADD CONSTRAINT `mgr_FK` FOREIGN KEY (`mgr_id`) REFERENCES `tenant_manager` (`mgr_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
