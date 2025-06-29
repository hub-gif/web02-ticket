/*
 Navicat Premium Data Transfer

 Source Server         : 本地mysql连接
 Source Server Type    : MySQL
 Source Server Version : 80037
 Source Host           : localhost:3306
 Source Schema         : toudatrain

 Target Server Type    : MySQL
 Target Server Version : 80037
 File Encoding         : 65001

 Date: 29/06/2025 21:31:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `ticket_id` int(0) NOT NULL,
  `order_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `order_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('未支付','已支付','已取消','已完成') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '未支付',
  `total_price` decimal(10, 2) NOT NULL,
  `passenger_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `passenger_id_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `passenger_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `seat_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `payment_time` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_number`(`order_number`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `ticket_id`(`ticket_id`) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for seat_types
-- ----------------------------
DROP TABLE IF EXISTS `seat_types`;
CREATE TABLE `seat_types`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price_multiplier` decimal(3, 2) NOT NULL DEFAULT 1.00,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `type_name`(`type_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of seat_types
-- ----------------------------
INSERT INTO `seat_types` VALUES (1, '二等座', '二等座位', 1.00);
INSERT INTO `seat_types` VALUES (2, '一等座', '一等座位', 1.60);
INSERT INTO `seat_types` VALUES (3, '商务座', '商务座位', 3.00);
INSERT INTO `seat_types` VALUES (4, '无座', '无座位', 0.80);

-- ----------------------------
-- Table structure for stations
-- ----------------------------
DROP TABLE IF EXISTS `stations`;
CREATE TABLE `stations`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `station_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `station_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `station_name`(`station_name`) USING BTREE,
  UNIQUE INDEX `station_code`(`station_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stations
-- ----------------------------
INSERT INTO `stations` VALUES (1, '北京南', '北京', '北京', 'BJP');
INSERT INTO `stations` VALUES (2, '上海虹桥', '上海', '上海', 'SHH');
INSERT INTO `stations` VALUES (3, '广州南', '广州', '广东', 'GZQ');
INSERT INTO `stations` VALUES (4, '深圳北', '深圳', '广东', 'SZX');
INSERT INTO `stations` VALUES (5, '杭州东', '杭州', '浙江', 'HZH');

-- ----------------------------
-- Table structure for tickets
-- ----------------------------
DROP TABLE IF EXISTS `tickets`;
CREATE TABLE `tickets`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `train_id` int(0) NOT NULL,
  `seat_type_id` int(0) NOT NULL,
  `departure_date` date NOT NULL,
  `available_seats` int(0) NOT NULL DEFAULT 0,
  `base_price` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_ticket`(`train_id`, `seat_type_id`, `departure_date`) USING BTREE,
  INDEX `seat_type_id`(`seat_type_id`) USING BTREE,
  CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`seat_type_id`) REFERENCES `seat_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for train_types
-- ----------------------------
DROP TABLE IF EXISTS `train_types`;
CREATE TABLE `train_types`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `speed_level` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `type_name`(`type_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of train_types
-- ----------------------------
INSERT INTO `train_types` VALUES (1, '高铁', '高速动车组列车', 300);
INSERT INTO `train_types` VALUES (2, '动车', '动车组列车', 200);
INSERT INTO `train_types` VALUES (3, '特快', '特快旅客列车', 160);
INSERT INTO `train_types` VALUES (4, '普快', '普通旅客快车', 120);

-- ----------------------------
-- Table structure for trains
-- ----------------------------
DROP TABLE IF EXISTS `trains`;
CREATE TABLE `trains`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `train_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `train_type_id` int(0) NOT NULL,
  `start_station_id` int(0) NOT NULL,
  `end_station_id` int(0) NOT NULL,
  `departure_time` time(0) NOT NULL,
  `arrival_time` time(0) NOT NULL,
  `duration` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `distance` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `train_number`(`train_number`) USING BTREE,
  INDEX `train_type_id`(`train_type_id`) USING BTREE,
  INDEX `start_station_id`(`start_station_id`) USING BTREE,
  INDEX `end_station_id`(`end_station_id`) USING BTREE,
  CONSTRAINT `trains_ibfk_1` FOREIGN KEY (`train_type_id`) REFERENCES `train_types` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `trains_ibfk_2` FOREIGN KEY (`start_station_id`) REFERENCES `stations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `trains_ibfk_3` FOREIGN KEY (`end_station_id`) REFERENCES `stations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `id_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (10, 'user001', '123456', 'salt_001', 'user001@test.com', '13800138001', '用户一', '110101190001010002', NULL, '2025-06-28 22:50:35', '2025-06-28 22:56:05');
INSERT INTO `users` VALUES (11, 'user002', '123456', 'salt_002', 'user002@test.com', '13800138002', '用户二', '110101190001010003', NULL, '2025-06-28 22:50:35', '2025-06-28 22:56:08');
INSERT INTO `users` VALUES (12, 'user003', '123456', 'salt_003', 'user003@test.com', '13800138003', '用户三', '110101190001010004', NULL, '2025-06-28 22:50:35', '2025-06-28 22:56:13');
INSERT INTO `users` VALUES (16, 'user004', '123456', 'salt_004', 'user004@test.com', '13800138004', '赵六', '340000199304040004', 'https://example.com/avatar/4.jpg', '2025-06-28 22:55:02', '2025-06-28 22:56:18');
INSERT INTO `users` VALUES (17, 'user005', '123456', 'salt_005', 'user005@test.com', '13800138005', '孙七', '350000199405050005', NULL, '2025-06-28 22:55:02', '2025-06-28 22:56:22');
INSERT INTO `users` VALUES (18, 'admin001', '123456', 'salt_admin', 'admin@system.com', '13800138000', '系统管理员', '110000190001010000', 'https://example.com/avatar/admin.jpg', '2025-06-28 22:55:02', '2025-06-28 22:56:26');
INSERT INTO `users` VALUES (19, 'student001', '123456', 'salt_stu', 'stu@school.com', '13800138007', '李同学', '410000200509010007', NULL, '2025-06-28 22:55:02', '2025-06-28 22:56:34');
INSERT INTO `users` VALUES (20, 'teacher001', '123456', 'salt_tea', 'tea@school.com', '13800138008', '王老师', '420000198508150008', 'https://example.com/avatar/teacher.jpg', '2025-06-28 22:55:02', '2025-06-28 22:56:43');
INSERT INTO `users` VALUES (21, '12', 'GmDlr5X09Rp9P0uhYKgtpCbIl78fQwcfS8umJ6aqelU=', 'HOY2nULiMNjld2Vsf7TJTw==', '', '', '', '', NULL, '2025-06-29 12:28:49', '2025-06-29 14:35:14');
INSERT INTO `users` VALUES (23, 'ak', 'KsyoQkcDLVael83pwt53f2UH3huSw/NiEgazK4u0EVo=', 'IjCIxsOxMXAYuPNxrI/XhQ==', '9999999@qq.com', '12345678901', NULL, NULL, NULL, '2025-06-29 13:49:48', '2025-06-29 13:49:48');

SET FOREIGN_KEY_CHECKS = 1;
