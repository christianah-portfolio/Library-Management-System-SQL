-- -----------------------------------------------------------------------------
-- LIBRARY MANAGEMENT SYSTEM: SQL DATA ANALYSIS
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- 1. DATABASE SETUP
-- -----------------------------------------------------------------------------

-- Creating the Database 
CREATE DATABASE [Library_Management_System]

-- Selecting the library database for subsequent operations
USE [Library_Management_System]


-- -----------------------------------------------------------------------------
-- 2. DATA REVIEW
-- -----------------------------------------------------------------------------

-- Reviewing book records and available book information
SELECT * FROM books

-- Reviewing the library's branch records
SELECT * FROM branch

-- Reviewing employee records across the library branches
SELECT * FROM employees

-- Reviewing book issuance transactions
SELECT * FROM issued_status

-- Reviewing registered library members
SELECT * FROM members

-- Reviewing book return transactions
SELECT * FROM return_status

-- -----------------------------------------------------------------------------
-- 3. LIBRARY RECORD MANAGEMENT
-- -----------------------------------------------------------------------------

-- Registering a new book in the library's collection
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher) 
VALUES (
      '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes','Harper Lee',
'J.B. Lippincott & CO'
)

-- Verifying the newly aded book record
SELECT * FROM books

-- Updating the registered address of an existing library member
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101'

-- Verifying the member's updated information
SELECT * FROM members

-- Removing an issuance record identified for deletion
DELETE FROM issued_status
WHERE issued_id = 'IS121'

-- Verifying the remaining book issuance records
SELECT * FROM issued_status


-- -----------------------------------------------------------------------------
-- 4. BOOK ISSUANCE ANALYSIS
-- -----------------------------------------------------------------------------

-- Review book issuance transactions handled by a specific employee
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

-- Identifying members who have borrowed more than one book
SELECT issued_member_id
          --COUNT(issued_id) AS total_books_issued
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_id) > 1

-- -----------------------------------------------------------------------------
-- 5. SUMMARY TABLE CREATION
-- -----------------------------------------------------------------------------

-- Creating a summary table showing the number of times each book was issued
SELECT b.isbn,
       b.book_title,
      COUNT(ist.issued_id) as no_issued
INTO book_issued_summary
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title, ist.issued_id

-- Reviewing the book issuance summary
SELECT * FROM book_issued_summary

-- -----------------------------------------------------------------------------
-- 6. CATEGORY AND REVENUE ANALYSIS
-- -----------------------------------------------------------------------------

-- Reviewing all books classified under the Classic category
SELECT * FROM books
WHERE category = 'Classic'

-- Analysing total Rental Income by Category
SELECT b.category,
       SUM(b.rental_price) AS total_rental_income,
       COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON b.isbn = ist.issued_book_isbn
GROUP BY b.category

-- -----------------------------------------------------------------------------
-- 7. MEMBER REGISTRATION ANALYSIS
-- -----------------------------------------------------------------------------

-- Identifying members who registered within the past 1,000 days
SELECT * FROM members
WHERE reg_date >= DATEADD (DAY, -1000, GETDATE())

-- -----------------------------------------------------------------------------
-- 8. EMPLOYEE AND BRANCH ANALYSIS
-- -----------------------------------------------------------------------------

-- Linking employees to their branch details and branch managers
SELECT 
     e1.*,
     b.manager_id,
     e2.emp_name AS manager
FROM employees AS e1
JOIN
branch AS b
ON b.branch_id = e1.branch_id
JOIN 
employees as e2
ON b.manager_id = e2.emp_id

-- -----------------------------------------------------------------------------
-- 9. RENTAL PRICE ANALYSIS
-- -----------------------------------------------------------------------------

-- Creating a separate table for books with rental prices above $7
SELECT * 
INTO books_rental_above_7
FROM books
WHERE rental_price > 7

-- -----------------------------------------------------------------------------
-- 10. OUTSTANDING BOOK RETURNS
-- -----------------------------------------------------------------------------

-- Identifying books not yet returned
SELECT 
     DISTINCT ist.issued_book_name,
     COUNT(*) AS no_issued
FROM issued_status AS ist
LEFT JOIN
     return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL
GROUP BY ist.issued_book_name





