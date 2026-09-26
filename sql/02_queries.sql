-- 1. Books published between two dates
SELECT title, publish_date
FROM BOOKS
WHERE publish_date BETWEEN TO_DATE('1950-01-01','YYYY-MM-DD')
                       AND TO_DATE('2000-12-31','YYYY-MM-DD');

-- 2. Members of selected membership types
SELECT full_name
FROM MEMBERS
WHERE membership_type IN ('Student','VIP');

-- 3. Titles starting with A
SELECT title
FROM BOOKS
WHERE title LIKE 'A%';

-- 4. Borrowing records not yet returned
SELECT borrow_id, book_id
FROM BORROWING
WHERE return_date IS NULL;

-- 5. Distinct membership types
SELECT DISTINCT membership_type
FROM MEMBERS;

-- 6. Books ordered by total copies
SELECT title, total_copies
FROM BOOKS
ORDER BY total_copies DESC;

-- 7. Return status using NVL and TO_CHAR
SELECT borrow_id,
       NVL(TO_CHAR(return_date,'DD-MON-YYYY'), 'Not returned yet') AS status
FROM BORROWING;

-- 8. Membership discount label using DECODE
SELECT full_name,
       DECODE(
           membership_type,
           'VIP', '20% discount',
           'Student', '10% discount',
           'No discount'
       ) AS discount
FROM MEMBERS;

-- 9. Date functions
SELECT borrow_id,
       due_date,
       ADD_MONTHS(due_date, 1) AS extended_due,
       MONTHS_BETWEEN(SYSDATE, borrow_date) AS months_passed,
       NEXT_DAY(due_date, 'MONDAY') AS next_monday,
       LAST_DAY(due_date) AS end_of_month,
       ROUND(SYSDATE - borrow_date) AS days_borrowed,
       TRUNC(SYSDATE - due_date) AS days_overdue
FROM BORROWING;

-- 10. Number of borrows per member, only members with more than one
SELECT member_id, COUNT(*) AS total_borrows
FROM BORROWING
GROUP BY member_id
HAVING COUNT(*) > 1;

-- 11. Average fine by payment status
SELECT paid_status, AVG(amount) AS avg_fine
FROM FINES
GROUP BY paid_status;

-- 12. INNER JOIN: books with publisher and category
SELECT b.title, p.publisher_name, c.category_name
FROM BOOKS b
JOIN PUBLISHERS p ON b.publisher_id = p.publisher_id
JOIN CATEGORIES c ON b.category_id = c.category_id;

-- 13. LEFT JOIN: all members, including members with no borrowing record
SELECT m.full_name, br.borrow_id
FROM MEMBERS m
LEFT JOIN BORROWING br ON m.member_id = br.member_id;

-- 14. JOIN through junction table: books and their authors
SELECT bk.title, a.full_name
FROM BOOKS bk
JOIN BOOK_AUTHORS ba ON bk.book_id = ba.book_id
JOIN AUTHORS a ON ba.author_id = a.author_id;

-- 15. Books that have never been borrowed
SELECT title
FROM BOOKS
WHERE book_id NOT IN (
    SELECT book_id
    FROM BORROWING
);

-- 16. Member who borrowed the most (Oracle 10g-compatible)
SELECT full_name
FROM MEMBERS
WHERE member_id = (
    SELECT member_id
    FROM (
        SELECT member_id, COUNT(*) AS total_borrows
        FROM BORROWING
        GROUP BY member_id
        ORDER BY COUNT(*) DESC
    )
    WHERE ROWNUM = 1
);
