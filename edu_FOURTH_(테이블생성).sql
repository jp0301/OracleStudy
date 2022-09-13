
--�� ���� ��� PRC_BOOK_INSERT(�����ڵ�, �����, ����)
CREATE OR REPLACE PROCEDURE PRC_BOOK_INSERT
( V_BOOK_CODE   IN TBL_BOOK.BOOK_CODE%TYPE
, V_BOOK_NAME   IN TBL_BOOK.BOOK_NAME%TYPE
, V_BOOK_AUTHOR IN TBL_BOOK.BOOK_AUTHOR%TYPE
)
IS
    BOOK_CHECK_NAME TBL_BOOK.BOOK_NAME%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    -- �Է¹��� å �̸��� �ִ��� Ȯ���ϰ� 
    -- BOOK_CHECK_NAME�� ������ �Է� ���� �̸� �״�� �ְ� ������ 0�� �ִ´�.
    SELECT NVL((SELECT BOOK_NAME 
                FROM TBL_BOOK 
                WHERE BOOK_NAME = 'Java�� ����'), '0') INTO BOOK_CHECK_NAME
    FROM DUAL;
    
    -- ���ǹ����� BOOK_CHECK_NAME�� å �̸��� �������� ���� �߻�
    -- �װ� �ƴ϶�� INSERT�� �������� �Ѿ��.
    IF (BOOK_CHECK_NAME != '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- INSERT ������ ����
    INSERT INTO TBL_BOOK(BOOK_CODE, BOOK_NAME, BOOK_AUTHOR)
    VALUES(V_BOOK_CODE, V_BOOK_NAME, V_BOOK_AUTHOR);
    
    -- ���� ó��
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004, '�̹� ��ϵ� �����Դϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    -- Ŀ��
    COMMIT;
END;


--�� ���� ��� PRC_BOOK_INSERT(�����ڵ�, �����, ����)
CREATE OR REPLACE PROCEDURE PRC_BOOK_INSERT

