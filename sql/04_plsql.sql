CREATE OR REPLACE PROCEDURE SP_BORROW_BOOK (
    p_borrow_id NUMBER,
    p_member_id NUMBER,
    p_book_id NUMBER,
    p_staff_id NUMBER
) IS
    v_available NUMBER;
BEGIN
    SELECT available_copies
    INTO v_available
    FROM BOOKS
    WHERE book_id = p_book_id
    FOR UPDATE;

    IF v_available <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'No available copies for book_id ' || p_book_id
        );
    END IF;

    INSERT INTO BORROWING (
        borrow_id,
        member_id,
        book_id,
        staff_id,
        borrow_date,
        due_date
    )
    VALUES (
        p_borrow_id,
        p_member_id,
        p_book_id,
        p_staff_id,
        SYSDATE,
        SYSDATE + 14
    );

    UPDATE BOOKS
    SET available_copies = available_copies - 1
    WHERE book_id = p_book_id;

    COMMIT;
END;
/

CREATE OR REPLACE FUNCTION FN_CALC_FINE (
    p_borrow_id NUMBER
)
RETURN NUMBER IS
    v_due_date DATE;
    v_days_late NUMBER;
BEGIN
    SELECT due_date
    INTO v_due_date
    FROM BORROWING
    WHERE borrow_id = p_borrow_id;

    v_days_late := GREATEST(TRUNC(SYSDATE - v_due_date), 0);

    RETURN v_days_late * 0.5;
END;
/
