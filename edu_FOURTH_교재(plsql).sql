
--�� ���� ������ ����
CREATE SEQUENCE TBL_BOOK_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999
NOCYCLE
NOCACHE;
--==>> Sequence TBL_BOOK_SEQ��(��) �����Ǿ����ϴ�.


--�� ���� ��� PRC_BOOK_INSERT(�����ڵ�, �����, ����)
CREATE OR REPLACE PROCEDURE PRC_BOOK_INSERT
( V_BOOK_NAME   IN TBL_BOOK.BOOK_NAME%TYPE
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
                WHERE BOOK_NAME = V_BOOK_NAME), '0') INTO BOOK_CHECK_NAME
    FROM DUAL;
    
    -- ���ǹ����� BOOK_CHECK_NAME�� å �̸��� �������� ���� �߻�
    -- �װ� �ƴ϶�� INSERT�� �������� �Ѿ��.
    IF (BOOK_CHECK_NAME != '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- INSERT ������ ����
    INSERT INTO TBL_BOOK(BOOK_CODE, BOOK_NAME, BOOK_AUTHOR)
    VALUES(('BOK' || LPAD(TO_CHAR(TBL_BOOK_SEQ.NEXTVAL), 3, '0')), V_BOOK_NAME, V_BOOK_AUTHOR);
    
    -- ���� ó��
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004, '�̹� ��ϵ� �����Դϴ�.');
            ROLLBACK;
        --WHEN OTHERS
            --THEN ROLLBACK;
    -- Ŀ��
    COMMIT;
END;
--==>> Procedure PRC_BOOK_INSERT��(��) �����ϵǾ����ϴ�.


EXEC PRC_BOOK_INSERT('Java�� ����','���ü�');
EXEC PRC_BOOK_INSERT('����Ŭ','������');
EXEC PRC_BOOK_INSERT('HTML+CSS+JS','�����');
EXEC PRC_BOOK_INSERT('JSP','�ֹ���');
EXEC PRC_BOOK_INSERT('������5','��� ī��');
EXEC PRC_BOOK_INSERT('���̽�','�ۼ���');
EXEC PRC_BOOK_INSERT('R�ڵ�','��ö��');
EXEC PRC_BOOK_INSERT('�ϵ��ڵ�','����ȭ');
EXEC PRC_BOOK_INSERT('Python ML','��ö��');



--�� ���� ���� PRC_BOOK_UPDATE(�����ڵ�, �����, ����)
CREATE OR REPLACE PROCEDURE PRC_BOOK_UPDATE
( V_BOOK_CODE   IN TBL_BOOK.BOOK_CODE%TYPE
, V_BOOK_NAME   IN TBL_BOOK.BOOK_NAME%TYPE
, V_BOOK_AUTHOR IN TBL_BOOK.BOOK_AUTHOR%TYPE  
)
IS
    BOOK_CHECK_CODE TBL_BOOK.BOOK_CODE%TYPE;
    BOOK_CHECK_NAME TBL_BOOK.BOOK_NAME%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
    USER_DEFINE_ERROR2 EXCEPTION;
BEGIN


    -- �����ڵ尡 ������ �Ǵ��ϱ� ���� ��ȸ
    SELECT NVL((SELECT BOOK_CODE
                FROM TBL_BOOK
                WHERE BOOK_CODE = V_BOOK_CODE), '0') INTO BOOK_CHECK_CODE
    FROM DUAL;
    
    -- ���� �Ǵ����� �����߻�, �ڵ尡 ������ ����
    IF (BOOK_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- ������� ������ �Ǵ��ϱ� ���� ��ȸ
    SELECT NVL((SELECT BOOK_NAME 
                FROM TBL_BOOK 
                WHERE BOOK_NAME = V_BOOK_NAME), '0') INTO BOOK_CHECK_NAME
    FROM DUAL;
    
    -- ���� �Ǵ����� �����߻�
    IF (BOOK_CHECK_NAME != '0')
        THEN RAISE USER_DEFINE_ERROR2;
    END IF;


    -- ������Ʈ ������
    UPDATE TBL_BOOK
    SET BOOK_NAME = V_BOOK_NAME, BOOK_AUTHOR = V_BOOK_AUTHOR
    WHERE BOOK_CODE = V_BOOK_CODE;
    
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20801, '��ϵ��� ���� �����ڵ��Դϴ�.');
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20802, '�̹� ��ϵ� �����Դϴ�.');
        ROLLBACK;
    
    -- Ŀ��
    COMMIT;
END;
--==>> Procedure PRC_BOOK_UPDATE��(��) �����ϵǾ����ϴ�.



--�� ���� ���� PRC_BOOK_DELETE(�����ڵ�)
CREATE OR REPLACE PROCEDURE PRC_BOOK_DELETE
( V_BOOK_CODE   IN TBL_BOOK.BOOK_CODE%TYPE
)
IS
    BOOK_CHECK_CODE TBL_BOOK.BOOK_CODE%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;
    USER_DEFINE_ERROR2 EXCEPTION;
BEGIN

    -- �����ڵ� ��ȸ
     SELECT NVL((SELECT BOOK_CODE
                FROM TBL_BOOK
                WHERE BOOK_CODE = V_BOOK_CODE), '0') INTO BOOK_CHECK_CODE
    FROM DUAL;
    
    -- ���� �Ǵ����� �����߻�, �����ڵ尡 ������ ���� �߻�
    IF (BOOK_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;   
    
    
    -- �����Ϸ��� ���縦 ���� ������� ������ �ִ��� ��ȸ�� �Ѵ�.
    SELECT NVL((SELECT COUNT(BOOK_CODE)
                FROM TBL_OPENSUB
                WHERE BOOK_CODE = V_BOOK_CODE), '0') INTO BOOK_CHECK_CODE
    FROM DUAL;
    
    IF (BOOK_CHECK_CODE != '0')
        THEN RAISE USER_DEFINE_ERROR2;
    END IF;
    
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20801, '��ϵ��� ���� �����ڵ��Դϴ�.');
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20803, '�ش� ���縦 �̹� ������Դϴ�.');
        ROLLBACK;
        
    -- Ŀ��
    COMMIT;
END;
--==>> Procedure PRC_BOOK_DELETE��(��) �����ϵǾ����ϴ�.