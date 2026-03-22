-- ============================================
-- Day 3: March 22, 2026
-- Topic: SQL LEFT JOIN, INNER JOIN, GROUP BY, HAVING, IFNULL
-- Source: Scaler Academy - Module 2 (SQL)
-- Problems Solved: 2
-- ============================================


-- Problem 1: Identify each library staff member with total books issued
-- and distinct members served, sorted by books issued (desc) then name
-- Include staff who haven't issued any books (showing 0)

SELECT
    ls.staff_name,
    ls.staff_designation,
    IFNULL(COUNT(book_id), 0) AS total_books,
    COUNT(DISTINCT bi.member_id) AS members_served
FROM `library.library_staff` AS ls
LEFT JOIN `library.book_issue` AS bi
    ON ls.issue_by_id = bi.issued_by_id
GROUP BY 1, 2
ORDER BY 3 DESC, 1 ASC;

-- Concepts: LEFT JOIN, IFNULL, COUNT, COUNT(DISTINCT), GROUP BY, ORDER BY


-- Problem 2: Book categories with total books and distinct shelves
-- Only categories spread across more than one shelf
-- Sorted by distinct shelves (desc) then category name

SELECT
    c.category_name,
    COUNT(b.book_id) AS total_books,
    COUNT(DISTINCT l.shelf_no) AS distinct_shelfs
FROM library.category AS c
INNER JOIN library.book AS b
    ON c.category_id = b.category_id
INNER JOIN library.location AS l
    ON b.location_id = l.location_id
GROUP BY 1
HAVING distinct_shelfs > 1
ORDER BY 3 DESC, 1;

-- Concepts: INNER JOIN (multiple), COUNT(DISTINCT), GROUP BY, HAVING, ORDER BY


-- ============================================
-- Concepts Used Today:
-- LEFT JOIN, INNER JOIN
-- IFNULL, COUNT, COUNT(DISTINCT)
-- GROUP BY, HAVING, ORDER BY
-- ============================================
