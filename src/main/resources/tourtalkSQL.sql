-- 회원 관련 테이블
-- 1. 회원 기본 정보
CREATE TABLE `member` (
  `mno` INT NOT NULL AUTO_INCREMENT,
  `id` VARCHAR(20) NOT NULL,
  `password` VARCHAR(1000) NOT NULL,
  `nickname` VARCHAR(50) NULL,
  -- 사용자, 큐레이터, 관리자
  `role` ENUM('user', 'curator', 'admin') NOT NULL DEFAULT 'user',
  -- 정상 활동, 일시 정지, 승인 대기, 탈퇴 처리
  `status` ENUM('active', 'suspended', 'pending', 'deleted') NOT NULL DEFAULT 'active',
  `points` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`mno`),
  UNIQUE KEY (`id`)
);

-- 2. 회원 상세 정보
CREATE TABLE `member_details` (
  `mno` INT NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(13) NOT NULL,
  -- 비공개, 남자, 여자
  `gender` ENUM('unknown', 'man', 'woman') NOT NULL DEFAULT 'unknown',
  `address` VARCHAR(200) NULL,
  `postal_code` VARCHAR(20) NULL,
  `birth_date` DATE NULL,
  `profile_img_path` VARCHAR(255) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` DATETIME NULL,
  PRIMARY KEY (`mno`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`)
);

-- 3. 큐레이터 정보 (테이블명 수정: Untitled -> curator)
CREATE TABLE `curator` (
  `mno` INT NOT NULL,
  `curator_no` VARCHAR(50) NULL,
  `curator_img` VARCHAR(255) NOT NULL,
  `ad_grade` VARCHAR(255) NULL,
  `approved_at` DATETIME NULL,
  PRIMARY KEY (`mno`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`)
);

-- 게시판 관련 테이블
-- 4. 게시판 카테고리
CREATE TABLE `board_categories` (
  `category_id` INT NOT NULL,
  `main_category` VARCHAR(50) NOT NULL,
  `sub_category` VARCHAR(50) NULL,
  PRIMARY KEY (`category_id`)
);

-- 5. 게시글
CREATE TABLE `board` (
  `post_id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NOT NULL,
  `writer_id` INT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `content` TEXT NOT NULL,
  -- 공개, 비공개, 삭제됨
  `status` ENUM('active', 'inactive', 'deleted') NOT NULL DEFAULT 'active',
  `view_count` INT NOT NULL DEFAULT 0,
  `comment_count` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`post_id`),
  FOREIGN KEY (`category_id`) REFERENCES `board_categories` (`category_id`),
  FOREIGN KEY (`writer_id`) REFERENCES `member` (`mno`)
);

-- 6. 게시글 상세 정보
CREATE TABLE `board_details` (
  `post_id` INT NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL,
  `deleted_at` DATETIME NULL,
  `file_path` VARCHAR(255) NULL,
  PRIMARY KEY (`post_id`),
  FOREIGN KEY (`post_id`) REFERENCES `board` (`post_id`)
);

-- 7. 댓글
CREATE TABLE `comments` (
  `comment_id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `writer_id` INT NOT NULL,
  `content` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL,
  -- 공개, 비밀댓글, 삭제됨
  `status` ENUM('active', 'inactive', 'deleted') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`comment_id`),
  FOREIGN KEY (`post_id`) REFERENCES `board` (`post_id`),
  FOREIGN KEY (`writer_id`) REFERENCES `member` (`mno`)
);

-- 8. 게시글 좋아요
CREATE TABLE `post_likes` (
  `post_id` INT NOT NULL,
  `mno` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`, `mno`),
  FOREIGN KEY (`post_id`) REFERENCES `board` (`post_id`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`)
);

-- 9. 평점
CREATE TABLE `rating` (
  `rating_id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `mno` INT NOT NULL,
  -- 상품, 큐레이터, 관광지
  `target_type` ENUM('product', 'curator', 'attraction') NOT NULL,
  `target_id` INT NOT NULL,
  `rating_value` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL,
  -- 공개, 배공개, 삭제됨
  `status` ENUM('active', 'inactive', 'deleted') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`rating_id`),
  FOREIGN KEY (`post_id`) REFERENCES `board` (`post_id`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`)
);

-- 채팅 관련 테이블
-- 10. 채팅방
CREATE TABLE `chat_rooms` (
  `room_id` INT NOT NULL AUTO_INCREMENT,
  `room_name` VARCHAR(30) NOT NULL,
  -- 비공개, 그룹, 공개
  `room_type` ENUM('private', 'group', 'public') NOT NULL,
  `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mno` INT NOT NULL,
  PRIMARY KEY (`room_id`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`)
);

-- 11. 사용자 채팅방
CREATE TABLE `user_rooms` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `room_id` INT NOT NULL,
  `mno` INT NOT NULL,
  `joined_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `role` ENUM('member', 'manager') NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`room_id`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`)
);

-- 12. 메시지
CREATE TABLE `messages` (
  `message_id` INT NOT NULL AUTO_INCREMENT,
  `mno` INT NOT NULL,
  `room_id` INT NOT NULL,
  `content` VARCHAR(300) NOT NULL,
  `message_type` VARCHAR(20) NULL,
  `created_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`),
  FOREIGN KEY (`room_id`) REFERENCES `chat_rooms` (`room_id`)
);

-- 여행 그룹 관련 테이블
-- 13. 여행 그룹
CREATE TABLE `travel_group` (
  `group_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `info` VARCHAR(255) NULL,
  `leader_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_public` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`group_id`),
  FOREIGN KEY (`leader_id`) REFERENCES `member` (`mno`)
);

-- 14. 그룹 멤버
CREATE TABLE `group_member` (
  `group_id` INT NOT NULL AUTO_INCREMENT,
  `member_id` INT NOT NULL,
  `joined_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `role` ENUM('member', 'manager') NOT NULL DEFAULT 'member',
  PRIMARY KEY (`group_id`, `member_id`),
  FOREIGN KEY (`group_id`) REFERENCES `travel_group` (`group_id`),
  FOREIGN KEY (`member_id`) REFERENCES `member` (`mno`)
);

-- 15. 그룹 여행 계획
CREATE TABLE `group_trip_plan` (
  `plan_id` INT NOT NULL AUTO_INCREMENT,
  `group_id` INT NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `start_date` DATETIME NULL,
  `end_date` DATETIME NULL,
  `info` VARCHAR(255) NULL,
  PRIMARY KEY (`plan_id`),
  FOREIGN KEY (`group_id`) REFERENCES `travel_group` (`group_id`)
);

-- 관광지 관련 테이블
-- 16. 시도
CREATE TABLE `sidos` (
  `no` INT NOT NULL AUTO_INCREMENT,
  `sido_code` INT NULL,
  `sido_name` VARCHAR(20) NULL,
  PRIMARY KEY (`no`)
);

-- 17. 구군
CREATE TABLE `guguns` (
  `key` INT NOT NULL AUTO_INCREMENT,
  `sido_code` VARCHAR(255) NULL,
  `gugun_code` INT NULL,
  `gugun_name` VARCHAR(20) NULL,
  PRIMARY KEY (`key`)
);

-- 18. 콘텐츠 타입
CREATE TABLE `contenttypes` (
  `content_type_id` INT NOT NULL,
  `content_type_name` VARCHAR(45) NULL,
  PRIMARY KEY (`content_type_id`)
);

-- 19. 관광지
CREATE TABLE `attractions` (
  `no` INT NOT NULL AUTO_INCREMENT,
  `content_id` INT NULL,
  `title` VARCHAR(500) NULL,
  `content_type_id` INT NOT NULL,
  `area_code` INT NOT NULL,
  `si_gun_gu_code` INT NOT NULL,
  `first_image1` VARCHAR(100) NULL,
  `first_image2` VARCHAR(100) NULL,
  `map_level` INT NULL,
  `latitude` DECIMAL(20,17) NULL,
  `longitude` DECIMAL(20,17) NULL,
  `tel` VARCHAR(20) NULL,
  `addr1` VARCHAR(100) NULL,
  `addr2` VARCHAR(100) NULL,
  `homepage` VARCHAR(1000) NULL,
  `overview` VARCHAR(10000) NULL,
  `view_cnt` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`no`),
  FOREIGN KEY (`content_type_id`) REFERENCES `contenttypes` (`content_type_id`),
  FOREIGN KEY (`area_code`) REFERENCES `sidos` (`no`),
  FOREIGN KEY (`si_gun_gu_code`) REFERENCES `guguns` (`key`)
);

-- 투어 상품 관련 테이블
-- 20. 투어 상품
CREATE TABLE `tour_product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `mno` INT NOT NULL,
  `location_name` INT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `max_participants` INT NOT NULL,
  `min_participants` INT NOT NULL DEFAULT 1,
  -- 전체 비용, 1인당 비용
  `price_type` ENUM('total', 'per_person') NOT NULL,
  `price` INT NOT NULL,
  `start_date` DATE NOT NULL,
  -- 비공개, 모집 중, 모집 완료, 취소됨
  `status` ENUM('draft', 'open', 'closed', 'cancelled') NULL DEFAULT 'draft',
  `thumbnail_img` VARCHAR(255) NULL,
  `tags` VARCHAR(255) NULL,
  `meeting_place` VARCHAR(255) NULL,
  `meeting_time` TIME NOT NULL,
  `duration` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`product_id`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`),
  FOREIGN KEY (`location_name`) REFERENCES `attractions` (`no`)
);

-- 21. 투어 예약
CREATE TABLE `tour_booking` (
  `booking_id` INT NOT NULL AUTO_INCREMENT,
  `mno` INT NOT NULL,
  `product_id` INT NOT NULL,
  `reserved_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `participant_count` INT NOT NULL,
  `total_price` INT NOT NULL,
  `payment_method` VARCHAR(50) NOT NULL,
  -- 미결제, 결제완료, 환불
  `payment_status` ENUM('unpaid', 'paid', 'refunded') NULL DEFAULT 'unpaid',
  -- 정상 예약, 취소됨, 투어 완료
  `status` ENUM('reserved', 'cancelled', 'completed') NOT NULL DEFAULT 'reserved',
  `cancelled_at` DATETIME NULL,
  PRIMARY KEY (`booking_id`),
  FOREIGN KEY (`mno`) REFERENCES `member` (`mno`),
  FOREIGN KEY (`product_id`) REFERENCES `tour_product` (`product_id`)
);

-- 사용자 등록 hotplace 테이블 (신규 추가)
-- 22. 사용자 등록 hotplace 테이블
CREATE TABLE `hotplaces` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(50) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `latitude` DECIMAL(20,17) NOT NULL,
  `longitude` DECIMAL(20,17) NOT NULL,
  `rating` INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  `content_type_id` INT NOT NULL,
  `description` TEXT NULL,
  `review` TEXT NULL,
  `recommendation_reason` TEXT NULL,
  `view_count` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`content_type_id`) REFERENCES `contenttypes` (`content_type_id`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_created_at` (`created_at`),
  INDEX `idx_rating` (`rating`)
);

-- 23. hotplace 이미지 테이블
CREATE TABLE `hotplace_images` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `hotplace_id` BIGINT NOT NULL,
  `image_url` VARCHAR(500) NOT NULL,
  `image_order` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`hotplace_id`) REFERENCES `hotplaces` (`id`) ON DELETE CASCADE,
  INDEX `idx_hotplace_id` (`hotplace_id`)
);