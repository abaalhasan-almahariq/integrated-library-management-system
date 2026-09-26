CREATE TABLE PUBLISHERS (
    publisher_id NUMBER PRIMARY KEY,
    publisher_name VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20)
);

CREATE TABLE CATEGORIES (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE AUTHORS (
    author_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    nationality VARCHAR2(50)
);

CREATE TABLE BOOKS (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(150) NOT NULL,
    isbn VARCHAR2(20) UNIQUE,
    publisher_id NUMBER REFERENCES PUBLISHERS(publisher_id),
    category_id NUMBER REFERENCES CATEGORIES(category_id),
    publish_date DATE,
    total_copies NUMBER DEFAULT 1 CHECK (total_copies >= 0),
    available_copies NUMBER DEFAULT 1 CHECK (available_copies >= 0)
);

CREATE TABLE BOOK_AUTHORS (
    book_id NUMBER REFERENCES BOOKS(book_id),
    author_id NUMBER REFERENCES AUTHORS(author_id),
    PRIMARY KEY (book_id, author_id)
);

CREATE TABLE MEMBERS (
    member_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    join_date DATE DEFAULT SYSDATE,
    membership_type VARCHAR2(20)
        CHECK (membership_type IN ('Regular','Student','VIP'))
);

CREATE TABLE STAFF (
    staff_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    position VARCHAR2(50),
    hire_date DATE,
    salary NUMBER CHECK (salary > 0)
);

CREATE TABLE BORROWING (
    borrow_id NUMBER PRIMARY KEY,
    member_id NUMBER NOT NULL REFERENCES MEMBERS(member_id),
    book_id NUMBER NOT NULL REFERENCES BOOKS(book_id),
    staff_id NUMBER REFERENCES STAFF(staff_id),
    borrow_date DATE DEFAULT SYSDATE,
    due_date DATE NOT NULL,
    return_date DATE
);

CREATE TABLE FINES (
    fine_id NUMBER PRIMARY KEY,
    borrow_id NUMBER UNIQUE REFERENCES BORROWING(borrow_id),
    amount NUMBER CHECK (amount >= 0),
    paid_status VARCHAR2(10) DEFAULT 'Unpaid'
        CHECK (paid_status IN ('Paid','Unpaid')),
    fine_date DATE DEFAULT SYSDATE
);
