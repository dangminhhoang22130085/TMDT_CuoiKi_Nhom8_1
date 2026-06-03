-- ============================================
-- Gia Su Online - Database Schema
-- ============================================

SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS giasutot;
CREATE DATABASE giasutot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE giasutot;

-- ============================================
-- Bảng account - Tài khoản đăng nhập
-- role: 1=Student/PhuHuynh, 2=Tutor, 3=Admin
-- ============================================
DROP TABLE IF EXISTS interest;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS lesson;
DROP TABLE IF EXISTS registered_subjects;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS tutor;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS account;

CREATE TABLE account (
    id CHAR(20) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role INT DEFAULT 1 CHECK (role IN (1, 2, 3)),
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    reset_token VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng student - Phụ huynh / Học sinh
-- ============================================
CREATE TABLE student (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    birth DATE NULL,
    description TEXT NULL,
    avatar VARCHAR(255) DEFAULT 'default-avatar.png',
    account_id CHAR(20),
    FOREIGN KEY (account_id) REFERENCES account(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng subject - Môn học
-- ============================================
CREATE TABLE subject (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    level VARCHAR(50) NOT NULL,
    description TEXT,
    fee DECIMAL(12) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng tutor - Gia sư
-- ============================================
CREATE TABLE tutor (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    birth DATE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    specialization VARCHAR(255) NOT NULL,
    description TEXT,
    id_card_number BIGINT(12) NOT NULL,
    bank_account_number BIGINT(15) NOT NULL,
    bank_name VARCHAR(255) NOT NULL,
    avatar VARCHAR(255) DEFAULT 'default-avatar.png',
    account_id CHAR(20),
    evaluate INT DEFAULT 0 CHECK (evaluate BETWEEN 0 AND 5),
    verified TINYINT(1) DEFAULT 0,
    FOREIGN KEY (account_id) REFERENCES account(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng course - Khóa học
-- ============================================
CREATE TABLE course (
    id CHAR(20) PRIMARY KEY,
    subject_id CHAR(20),
    tutor_id CHAR(20),
    time DATETIME NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    FOREIGN KEY (subject_id) REFERENCES subject(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng registered_subjects - Đăng ký khóa học
-- ============================================
CREATE TABLE registered_subjects (
    course_id CHAR(20),
    student_id CHAR(20),
    registration_date DATE NOT NULL,
    number_of_lessons INT NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending_approval', 'pending_payment', 'registered', 'completed', 'cancelled', 'trial')),
    PRIMARY KEY (course_id, student_id),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng lesson - Buổi học
-- ============================================
CREATE TABLE lesson (
    course_id CHAR(20),
    student_id CHAR(20),
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'absent', 'scheduled')),
    time DATETIME NOT NULL,
    PRIMARY KEY (course_id, student_id, time),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng booking - Đặt lịch
-- ============================================
CREATE TABLE booking (
    id CHAR(20) PRIMARY KEY,
    course_id CHAR(20),
    tutor_id CHAR(20),
    student_id CHAR(20),
    booking_time DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending','confirmed','cancelled')),
    note TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng payment - Thanh toán
-- ============================================
CREATE TABLE payment (
    id CHAR(20) PRIMARY KEY,
    course_id CHAR(20) NOT NULL,
    tutor_id CHAR(20) NOT NULL,
    student_id CHAR(20) NOT NULL,
    amount DECIMAL(12) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'bank_transfer',
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'pending', 'failed')),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng notifications - Thông báo
-- ============================================
CREATE TABLE notifications (
    id CHAR(36) PRIMARY KEY,
    account_id CHAR(20) NOT NULL,
    title VARCHAR(255),
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_read TINYINT(1) DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'sent' CHECK (status IN ('sent', 'pending', 'failed')),
    FOREIGN KEY (account_id) REFERENCES account(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng review - Đánh giá gia sư
-- ============================================
CREATE TABLE review (
    id CHAR(20) PRIMARY KEY,
    tutor_id CHAR(20) NOT NULL,
    student_id CHAR(20) NOT NULL,
    course_id CHAR(20),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tutor_id) REFERENCES tutor(id),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (course_id) REFERENCES course(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng interest - Quan tâm (yêu thích gia sư)
-- ============================================
CREATE TABLE interest (
    id_st CHAR(20) NOT NULL,
    id_tt CHAR(20) NOT NULL,
    PRIMARY KEY (id_st, id_tt),
    FOREIGN KEY (id_st) REFERENCES student(id),
    FOREIGN KEY (id_tt) REFERENCES tutor(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- DỮ LIỆU MẪU
-- ============================================

-- Accounts (password = '123456' cho tất cả)
INSERT INTO account (id, email, password, role, status) VALUES
('acc001', 'phuhuynh1@gmail.com', '123456', 1, 'active'),
('acc002', 'phuhuynh2@gmail.com', '123456', 1, 'active'),
('acc003', 'phuhuynh3@gmail.com', '123456', 1, 'active'),
('acc004', 'giasu1@gmail.com', '123456', 2, 'active'),
('acc005', 'giasu2@gmail.com', '123456', 2, 'active'),
('acc006', 'giasu3@gmail.com', '123456', 2, 'active'),
('acc007', 'giasu4@gmail.com', '123456', 2, 'active'),
('acc008', 'giasu5@gmail.com', '123456', 2, 'active'),
('acc009', 'admin@gmail.com', '123456', 3, 'active'),
('acc010', 'phuhuynh4@gmail.com', '123456', 1, 'active'),
('acc011', 'giasu6@gmail.com', '123456', 2, 'inactive'),
('acc012', 'phuhuynh5@gmail.com', '123456', 1, 'active');

-- Students / Phụ huynh
INSERT INTO student (id, name, phone, address, birth, description, account_id) VALUES
('st001', 'Nguyễn Văn Nghĩa', '0901111001', 'Quận 1, TP.HCM', '2005-01-15', 'Cần tìm gia sư Toán cho con lớp 10', 'acc001'),
('st002', 'Lê Thị Liên', '0901111002', 'Quận 3, TP.HCM', '2006-03-20', 'Muốn con học thêm Tiếng Anh giao tiếp', 'acc002'),
('st003', 'Trần Văn Nhỏ', '0901111003', 'Quận 7, TP.HCM', '2004-07-10', 'Tìm gia sư Hóa học cho con', 'acc003'),
('st004', 'Phạm Thị Dung', '0901111004', 'Quận Bình Thạnh, TP.HCM', '2005-11-25', 'Cần gia sư dạy kèm tại nhà', 'acc010'),
('st005', 'Hoàng Minh Tuấn', '0901111005', 'Quận 5, TP.HCM', '2007-02-14', 'Muốn học thêm Vật lý', 'acc012');

-- Tutors / Gia sư
INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, account_id, evaluate, verified) VALUES
('tut001', 'Nguyễn Tuấn Cảnh', 'giasu1@gmail.com', '1990-01-15', '0901000001', 'Quận 1, TP.HCM', 'Toán', 'Thạc sĩ Toán học, 10 năm kinh nghiệm dạy Toán lớp 10-12. Nhiều học sinh đạt giải HSG cấp thành phố.', 123456789012, 123456789012345, 'BIDV', 'acc004', 5, 1),
('tut002', 'Trần Thị Mai', 'giasu2@gmail.com', '1988-05-12', '0901000002', 'Quận 3, TP.HCM', 'Tiếng Anh', 'IELTS 8.0, chuyên luyện giao tiếp và luyện thi IELTS. Từng du học tại Úc.', 123456789013, 123456789012346, 'Sacombank', 'acc005', 4, 1),
('tut003', 'Lê Hoàng Minh', 'giasu3@gmail.com', '1992-07-07', '0901000003', 'Quận 7, TP.HCM', 'Hóa học', 'Giáo viên trường chuyên, 8 năm kinh nghiệm. Phương pháp dạy trực quan, dễ hiểu.', 123456789014, 123456789012347, 'Techcombank', 'acc006', 4, 1),
('tut004', 'Phạm Minh Hương', 'giasu4@gmail.com', '1991-09-20', '0901000004', 'Quận Bình Thạnh, TP.HCM', 'Vật lý', 'Tiến sĩ Vật lý, giảng viên đại học. Dạy nhiệt tình, tận tâm.', 123456789015, 123456789012348, 'MB Bank', 'acc007', 5, 1),
('tut005', 'Nguyễn Thu Hà', 'giasu5@gmail.com', '1993-03-08', '0901000005', 'Quận 5, TP.HCM', 'Ngữ văn', 'Cử nhân Sư phạm Ngữ văn, 6 năm kinh nghiệm. Giúp học sinh yêu thích môn Văn.', 123456789016, 123456789012349, 'TPBank', 'acc008', 3, 1),
('tut006', 'Đỗ Văn Thành', 'giasu6@gmail.com', '1995-11-11', '0901000006', 'Quận Tân Bình, TP.HCM', 'Toán', 'Sinh viên năm cuối ĐH Bách Khoa. Dạy Toán cấp 2 và 3.', 123456789017, 123456789012350, 'Agribank', 'acc011', 0, 0);

-- Subjects / Môn học
INSERT INTO subject (id, name, level, description, fee, status) VALUES
('sub001', 'Toán', 'Lớp 10', 'Toán nâng cao lớp 10 - Đại số và Hình học', 2000000, 'active'),
('sub002', 'Tiếng Anh', 'Giao tiếp', 'Tiếng Anh giao tiếp cơ bản đến nâng cao', 1800000, 'active'),
('sub003', 'Hóa học', 'Lớp 10', 'Hóa học cơ bản và nâng cao lớp 10', 1900000, 'active'),
('sub004', 'Vật lý', 'Lớp 12', 'Vật lý ôn thi THPT Quốc gia', 2200000, 'active'),
('sub005', 'Ngữ văn', 'Lớp 11', 'Ngữ văn nâng cao lớp 11', 1700000, 'active'),
('sub006', 'Toán', 'Lớp 6', 'Toán cơ bản lớp 6', 1500000, 'active'),
('sub007', 'Tiếng Anh', 'IELTS', 'Luyện thi IELTS từ 5.0 đến 7.0', 2500000, 'active'),
('sub008', 'Hóa học', 'Lớp 12', 'Hóa học ôn thi THPT Quốc gia', 2100000, 'active'),
('sub009', 'Toán', 'Lớp 5', 'Toán nâng cao lớp 5 - Bồi dưỡng HSG', 1600000, 'active'),
('sub010', 'Vật lý', 'Lớp 11', 'Vật lý nâng cao lớp 11', 2000000, 'active');

-- Courses / Khóa học
INSERT INTO course (id, subject_id, tutor_id, time) VALUES
('course001', 'sub001', 'tut001', '2025-05-01 08:00:00'),
('course002', 'sub002', 'tut002', '2025-05-02 09:00:00'),
('course003', 'sub003', 'tut003', '2025-05-03 10:00:00'),
('course004', 'sub004', 'tut004', '2025-06-01 08:00:00'),
('course005', 'sub005', 'tut005', '2025-06-15 09:00:00'),
('course006', 'sub006', 'tut001', '2025-07-01 14:00:00'),
('course007', 'sub007', 'tut002', '2025-07-01 10:00:00'),
('course008', 'sub008', 'tut003', '2025-07-15 08:00:00'),
('course009', 'sub009', 'tut001', '2025-08-01 08:00:00'),
('course010', 'sub010', 'tut004', '2025-08-01 14:00:00');

-- Registered Subjects
INSERT INTO registered_subjects (course_id, student_id, registration_date, number_of_lessons, status) VALUES
('course001', 'st001', '2025-04-25', 10, 'completed'),
('course002', 'st002', '2025-04-26', 8, 'registered'),
('course003', 'st003', '2025-04-27', 12, 'registered'),
('course004', 'st004', '2025-05-20', 10, 'pending_approval'),
('course005', 'st001', '2025-06-01', 8, 'pending_payment'),
('course006', 'st005', '2025-06-20', 15, 'pending_approval'),
('course007', 'st002', '2025-06-25', 10, 'registered');

-- Bookings
INSERT INTO booking (id, course_id, tutor_id, student_id, booking_time, status, note) VALUES
('bk001', 'course001', 'tut001', 'st001', '2025-05-01 08:00:00', 'confirmed', 'Học tại nhà'),
('bk002', 'course002', 'tut002', 'st002', '2025-05-02 09:00:00', 'confirmed', 'Học online qua Zoom'),
('bk003', 'course004', 'tut004', 'st004', '2025-06-01 08:00:00', 'pending', 'Muốn học thử 1 buổi'),
('bk004', 'course006', 'tut001', 'st005', '2025-07-01 14:00:00', 'pending', 'Con học lớp 6');

-- Payments
INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status) VALUES
('pay001', 'course001', 'tut001', 'st001', 20000000, '2025-04-26 10:00:00', 'bank_transfer', 'completed'),
('pay002', 'course002', 'tut002', 'st002', 14400000, '2025-04-27 11:00:00', 'bank_transfer', 'completed'),
('pay003', 'course003', 'tut003', 'st003', 22800000, '2025-04-28 09:00:00', 'bank_transfer', 'pending');

-- Reviews
INSERT INTO review (id, tutor_id, student_id, course_id, rating, comment) VALUES
('rev001', 'tut001', 'st001', 'course001', 5, 'Thầy dạy rất hay, con tiến bộ nhiều. Rất recommend!'),
('rev002', 'tut002', 'st002', 'course002', 4, 'Cô dạy nhiệt tình, phát âm chuẩn. Con tự tin giao tiếp hơn.'),
('rev003', 'tut001', 'st004', NULL, 5, 'Thầy Cảnh rất kiên nhẫn và tận tâm với học sinh.');

-- Lessons
INSERT INTO lesson (course_id, student_id, status, time) VALUES
('course001', 'st001', 'completed', '2025-05-01 08:00:00'),
('course001', 'st001', 'completed', '2025-05-03 08:00:00'),
('course001', 'st001', 'completed', '2025-05-05 08:00:00'),
('course001', 'st001', 'completed', '2025-05-07 08:00:00'),
('course001', 'st001', 'completed', '2025-05-09 08:00:00'),
('course002', 'st002', 'completed', '2025-05-02 09:00:00'),
('course002', 'st002', 'completed', '2025-05-04 09:00:00'),
('course002', 'st002', 'scheduled', '2025-05-06 09:00:00'),
('course003', 'st003', 'scheduled', '2025-05-03 10:00:00'),
('course003', 'st003', 'scheduled', '2025-05-05 10:00:00');

-- Notifications
INSERT INTO notifications (id, account_id, title, message, type, is_read) VALUES
('notif001', 'acc001', 'Đặt lịch thành công', 'Bạn đã đặt lịch học Toán với gia sư Nguyễn Tuấn Cảnh thành công.', 'success', 1),
('notif002', 'acc004', 'Booking mới', 'Phụ huynh Phạm Thị Dung muốn đặt lịch học Vật lý.', 'info', 0),
('notif003', 'acc009', 'Gia sư mới đăng ký', 'Gia sư Đỗ Văn Thành đã đăng ký và chờ duyệt hồ sơ.', 'warning', 0);

-- Interest (Yêu thích)
INSERT INTO interest (id_st, id_tt) VALUES
('st001', 'tut001'),
('st001', 'tut004'),
('st002', 'tut002'),
('st003', 'tut003');
