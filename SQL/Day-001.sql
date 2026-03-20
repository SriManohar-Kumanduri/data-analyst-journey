-- ============================================
-- Day 1: March 20, 2026
-- Topic: SQL Joins, Aggregations & Filtering - Library Management System
-- Source: Scaler Academy - Module 2 (SQL)
-- Problems Solved: 6/6
-- ============================================


-- Problem 1: Retrieve details of all members with membership year range and total count
-- Display: ID, Name, City, Account Type, Account Status, Start Year, End Year, Total Members

SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city,
    m.account_type,
    m.account_status,
    YEAR(m.membership_start_date) AS start_year,
    YEAR(m.membership_end_date) AS end_year
FROM library.member m;

-- Total count of members:
SELECT COUNT(*) AS total_members FROM library.member;


-- Problem 2: Find all inactive student members and their count

SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city,
    m.account_type,
    m.account_status
FROM library.member m
WHERE m.account_type = 'Student'
    AND m.account_status = 'Inactive';

-- Count of inactive student members:
SELECT COUNT(*) AS inactive_student_count
FROM library.member
WHERE account_type = 'Student'
    AND account_status = 'Inactive';


-- Problem 3: Find inactive members with outstanding fines and their count

SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.account_status,
    fd.fine_total
FROM library.member m
INNER JOIN library.fine_due fd
    ON m.member_id = fd.member_id
WHERE m.account_status = 'Inactive'
    AND fd.fine_total > 0;

-- Count of such members:
SELECT COUNT(DISTINCT m.member_id) AS inactive_with_fines
FROM library.member m
INNER JOIN library.fine_due fd
    ON m.member_id = fd.member_id
WHERE m.account_status = 'Inactive'
    AND fd.fine_total > 0;


-- Problem 4: Display total active and inactive memberships

SELECT
    account_status,
    COUNT(*) AS total_count
FROM library.member
GROUP BY account_status;


-- Problem 5: Fine history for members whose name contains 'Kumar'
-- Also count separate fine instances per member

SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    fd.fine_date,
    fd.fine_total,
    fd.fine_reason
FROM library.member m
INNER JOIN library.fine_due fd
    ON m.member_id = fd.member_id
WHERE CONCAT(m.first_name, ' ', m.last_name) LIKE '%Kumar%';

-- Count of fine instances per member:
SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    COUNT(*) AS fine_instances
FROM library.member m
INNER JOIN library.fine_due fd
    ON m.member_id = fd.member_id
WHERE CONCAT(m.first_name, ' ', m.last_name) LIKE '%Kumar%'
GROUP BY m.member_id, m.first_name, m.last_name;


-- Problem 6: Find members with unpaid fines + librarian who issued latest fine-causing book
-- Display: Full Name, Total Fine Due, Total Paid, Fine Balance, Librarian Name

SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS member_full_name,
    fd.total_fine_due,
    fp.total_paid AS total_fine_paid,
    fd.total_fine_due - fp.total_paid AS fine_balance,
    s.staff_name AS librarian_name
FROM library.member m
INNER JOIN (
    SELECT member_id, SUM(fine_total) AS total_fine_due
    FROM library.fine_due
    GROUP BY member_id
) fd ON m.member_id = fd.member_id
INNER JOIN (
    SELECT member_id, SUM(payment_amount) AS total_paid
    FROM library.fine_payment
    GROUP BY member_id
) fp ON m.member_id = fp.member_id
INNER JOIN library.fine_due fd2
    ON m.member_id = fd2.member_id
INNER JOIN (
    SELECT member_id, MAX(fine_date) AS latest_date
    FROM library.fine_due
    GROUP BY member_id
) latest ON fd2.member_id = latest.member_id
    AND fd2.fine_date = latest.latest_date
INNER JOIN library.book_issue bi
    ON fd2.issue_id = bi.issue_id
INNER JOIN library.library_staff s
    ON bi.issued_by_id = s.issue_by_id
WHERE fd.total_fine_due - fp.total_paid > 0;

-- Count of members with pending fines:
SELECT COUNT(DISTINCT m.member_id) AS members_with_pending_fines
FROM library.member m
INNER JOIN (
    SELECT member_id, SUM(fine_total) AS total_fine_due
    FROM library.fine_due
    GROUP BY member_id
) fd ON m.member_id = fd.member_id
INNER JOIN (
    SELECT member_id, SUM(payment_amount) AS total_paid
    FROM library.fine_payment
    GROUP BY member_id
) fp ON m.member_id = fp.member_id
WHERE fd.total_fine_due - fp.total_paid > 0;


-- ============================================
-- Concepts Used Today:
-- SELECT, WHERE, LIKE, COUNT, SUM, MAX
-- INNER JOIN (multiple tables)
-- Subqueries as derived tables
-- GROUP BY, HAVING
-- CONCAT for string operations
-- Aggregation with filtering
-- ============================================
