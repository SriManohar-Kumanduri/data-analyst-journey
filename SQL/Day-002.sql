-- ============================================
-- Day 2: March 21, 2026
-- Topic: SQL LEFT JOIN, CASE WHEN, Subqueries, Aggregations
-- Source: Scaler Academy - Module 2 (SQL)
-- Problems Solved: 4
-- ============================================


-- Problem 1: Display all authors with book counts per language
-- Including authors with no books or non-English books
-- Highlight authors with at least one English book

SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS author_fn,
    IFNULL(p.publication_language, 'No books published') AS p_language,
    COUNT(b.book_id) AS book_count,
    SUM(CASE WHEN p.publication_language = 'English' THEN 1 ELSE 0 END) AS total_eng_books,
    SUM(CASE WHEN p.publication_language != 'English' THEN 1 ELSE 0 END) AS total_non_eng_books
FROM `library.author` a
LEFT JOIN `library.book_author` ba
    ON a.author_id = ba.author_id
LEFT JOIN `library.book` b
    ON b.book_id = ba.book_id
LEFT JOIN `library.publisher` p
    ON p.publisher_id = b.publisher_id
GROUP BY author_fn, p_language
HAVING book_count = 0
    OR total_eng_books > 0
    OR (total_non_eng_books > 0);

-- Unique author count:
SELECT COUNT(DISTINCT author_id) AS total_unique_authors FROM `library.author`;

-- Concepts: LEFT JOIN, IFNULL, CASE WHEN, GROUP BY, HAVING, COUNT, SUM


-- Problem 2: Identify all members with their city, account type, membership status
-- and number of books currently issued and underdue
-- Sorted by books issued (desc) then by name to prioritise high-usage members

SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS member_full_name,
    m.city,
    ms.account_type,
    CASE
        WHEN ms.account_status = 'Active' THEN 'Active'
        ELSE 'Inactive'
    END AS membership_status,
    COUNT(bi.book_id) AS books_issued_count
FROM `library.member` AS m
LEFT JOIN `library.member_status` AS ms
    ON m.active_status_id = ms.active_status_id
LEFT JOIN `library.book_issue` AS bi
    ON bi.member_id = m.member_id
    AND LOWER(bi.issue_status) LIKE '%underdue%'
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC, 1;

-- Concepts: LEFT JOIN, CASE WHEN, LOWER, LIKE, GROUP BY, ORDER BY


-- Problem 3: Total members with outstanding fine balance
-- Considering total fine due vs total paid (defaulting to zero if none)
-- Only members with positive payments and remaining balance

SELECT
    fd.member_id,
    fd.total_fine,
    fp.total_paid,
    fd.total_fine - fp.total_paid AS fine_balance
FROM (
    SELECT member_id, SUM(fine_total) AS total_fine
    FROM `library.fine_due`
    GROUP BY member_id
) AS fd
INNER JOIN (
    SELECT member_id, SUM(payment_amount) AS total_paid
    FROM `library.fine_payment`
    GROUP BY member_id
) AS fp
    ON fd.member_id = fp.member_id
WHERE fd.total_fine - fp.total_paid > 0;

-- Concepts: Subqueries as derived tables, INNER JOIN, SUM, GROUP BY, WHERE


-- Problem 4: Book categories with total books, copies available, and distinct publishers
-- Only books published after 2010
-- Sorted by total books (desc) then category name for inventory prioritisation

SELECT
    c.category_name,
    COUNT(b.book_id) AS total_books,
    SUM(b.copies_available) AS total_copies_available,
    COUNT(DISTINCT b.publisher_id) AS distinct_publishers
FROM `library.category` AS c
INNER JOIN `library.book` AS b
    ON b.category_id = c.category_id
WHERE b.publication_year > '2010'
GROUP BY c.category_name
ORDER BY total_books DESC, c.category_name;

-- Concepts: INNER JOIN, COUNT, SUM, COUNT(DISTINCT), WHERE, GROUP BY, ORDER BY


-- ============================================
-- Concepts Used Today:
-- LEFT JOIN, INNER JOIN
-- CASE WHEN, IFNULL
-- Subqueries as derived tables
-- GROUP BY, HAVING, ORDER BY
-- COUNT, SUM, COUNT(DISTINCT)
-- LIKE, LOWER for string matching
-- ============================================
