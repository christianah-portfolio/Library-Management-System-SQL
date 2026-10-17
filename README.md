# Library-Management-System-SQL

**A SQL Server project exploring a library database containing related records for books, members, book issues, and returns. Using T-SQL queries, joins, and aggregations, the project examines borrowing activity, rental income, and return-record completeness to demonstrate practical relational database analysis.**

---

## Project Overview

**Tools & Skills Used**
Microsoft SQL Server, T-SQL, Relational Databases, SQL Joins, Aggregations, Filtering, Data Analysis.

**Project Goals**
To explore relationships between library records, analyse borrowing patterns, examine rental income, and identify records requiring further review.

**Key Findings**
The analysis identified 20 issued-book records out of 34 that had no matching return record. Classic books generated 59.00 in rental income across 10 issues, while six members had borrowed more than one book.

---

## Business Questions
This project uses SQL Server to explore library operations, book borrowing activity, rental income, member registrations, and employee-branch relationships.

1. **Book Issuance**: Which book issuance transactions were handled by a specific employee?
2. **Member Borrowing Activity**: Which members have borrowed more than one book?
3. **Book Popularity**: How many times has each book been issued?
4. **Category and Rental Income Analysis**: How does rental income compare across book categories?
5. **Recent Member Registrations**: Which members registered within the past 1,000 days?
6. **Employee and Branch Relationships**: How are employees linked to their branches and branch managers?
7. **Rental Price Analysis**: Which books have rental prices above $7?
8. **Outstanding Returns**: Which issued books have no matching return record?
   
---

## Dataset

Six related tables:

| Table | Records | What it holds |
|---|---|---|
| `books` | 35 | ISBN, title, category, rental price, availability, author, publisher |
| `branch` | 5 | Branch address, contact number, and manager |
| `employees` | 11 | Name, position, salary, and branch |
| `members` | 12 | Name, address, and registration date |
| `issued_status` | 35 | Which member borrowed which book, when, and who issued it |
| `return_status` | 14 | Return records linked to issued books |

**How the tables connect**

- `issued_status.issued_book_isbn` links to `books.isbn`
- `issued_status.issued_member_id` links to `members.member_id`
- `issued_status.issued_emp_id` links to `employees.emp_id`
- `return_status.issued_id` links to `issued_status.issued_id`
- `employees.branch_id` and `branch.branch_id` link employees to branches
- `branch.manager_id` links to `employees.emp_id`

---

## Record Management

The script also changes the data with `INSERT`, `UPDATE`, and `DELETE`:

| Action | What it did |
|---|---|
| `INSERT` | Added a new book, *To Kill a Mockingbird* (Classic, rental price 6.00), so the library holds 36 books |
| `UPDATE` | Changed the address of member `C101` from 123 Main St to 125 Main St |
| `DELETE` | Removed issue record `IS121`, leaving 34 issued records |

After each change I ran a `SELECT` to check the result.

---

## Key Findings

| Question | Result |
|---|---|
| Books not yet returned | **20 of 34** issued books have no return record, and Animal Farm appears twice |
| Members borrowing more than one book | **6 members**: C105, C106, C107, C108, C109, and C110 |
| Rental income by category | Classic **59.00** (10 issues), History **49.50** (7), Fantasy 28.50 (4), Dystopian 25.50 (4), then smaller categories. Total across all categories: **214.00** from 34 issues |
| Classic collection | **9** books, the biggest category |
| Books with rental price above 7 | **7** books, saved in a new table, `books_rental_above_7` |
| Recent members | Two members, C118 and C119, registered in 2024 |
| Employees and managers | Daniel Anderson manages branches B001 to B003 and Laura Martinez manages B004 and B005 |
| Employee E101 | Issued 2 books, *Moby Dick* and *To Kill a Mockingbird* |

**What this means:** a large share of borrowed books have not come back, so the library may need reminders or a clearer tracking process. Classic books are the most borrowed and earn the most, so they are worth keeping well stocked.

---

## Example Queries

**Books not yet returned** (`LEFT JOIN` with `IS NULL`)
```sql
SELECT
     DISTINCT ist.issued_book_name,
     COUNT(*) AS no_issued
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL
GROUP BY ist.issued_book_name
```

**Employees with their branch managers** (self-join)
```sql
SELECT
     e1.*,
     b.manager_id,
     e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b
ON b.branch_id = e1.branch_id
JOIN employees AS e2
ON b.manager_id = e2.emp_id
```

**Rental income by category**
```sql
SELECT b.category,
       SUM(b.rental_price) AS total_rental_income,
       COUNT(*)
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY b.category
```

The full script, with all queries, is here: [sql/library_management_system.sql](sql/library_management_system.sql)

---

## How to Run This Project

1. Open SQL Server Management Studio (SSMS) and create the database (section 1 of the script).
2. Import the six CSV files from the `data` folder, one table for each file, and name the tables `books`, `branch`, `employees`, `issued_status`, `members`, and `return_status`.
3. Open `sql/library_management_system.sql` and run it section by section.
4. Run the record management section (insert, update, delete) and the table creation queries only once. Running them again will cause errors or duplicate records.

---

## Limitations

- The query for recently registered members uses `GETDATE()`, so its result changes depending on the day you run it.
- The `return_book_name` and `return_book_isbn` columns in `return_status` are empty, so returns are tracked only through the `issued_id`.
- Rental income here is the rental price of each issued book. The data has no due dates or late fees.

---

## Project Files

```
library-management-sql-analytics/
├── README.md
├── sql/
│   └── library_management_system.sql
└── data/
    ├── books.csv
    ├── branch.csv
    ├── employees.csv
    ├── issued_status.csv
    ├── members.csv
    └── return_status.csv
```
