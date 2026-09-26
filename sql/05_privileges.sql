-- Run once from a DBA-privileged account (for example, SYSTEM)
CREATE ROLE librarian_role;

-- Run from the schema owner
GRANT SELECT, INSERT, UPDATE ON BORROWING TO librarian_role;
GRANT SELECT ON V_BOOK_CATALOG TO PUBLIC;

-- Example privilege removal
REVOKE UPDATE ON BORROWING FROM librarian_role;
