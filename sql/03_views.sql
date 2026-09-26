CREATE VIEW V_OVERDUE_BOOKS AS
SELECT m.full_name,
       bk.title,
       br.due_date
FROM BORROWING br
JOIN MEMBERS m ON br.member_id = m.member_id
JOIN BOOKS bk ON br.book_id = bk.book_id
WHERE br.return_date IS NULL
  AND br.due_date < SYSDATE;

CREATE VIEW V_BOOK_CATALOG AS
SELECT bk.title,
       p.publisher_name,
       c.category_name,
       bk.available_copies
FROM BOOKS bk
JOIN PUBLISHERS p ON bk.publisher_id = p.publisher_id
JOIN CATEGORIES c ON bk.category_id = c.category_id;
