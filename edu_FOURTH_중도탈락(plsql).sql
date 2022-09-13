
--�� �ߵ�Ż�� ������ ����
CREATE SEQUENCE TBL_OUT_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999
NOCYCLE
NOCACHE;
--==>> Sequence TBL_OUT_SEQ��(��) �����Ǿ����ϴ�.



--�� �ߵ�Ż�� ��� ���ν���
-- PRC_OUT_INSERT(�����ڵ�, ����Ż�������ڵ�)
CREATE OR REPLACE PROCEDURE PRC_OUT_INSERT
( V_SUGANG_CODE         IN TBL_OUT.SUGANG_CODE%TYPE
, V_OUT_REASON_CODE     IN TBL_OUT.OUT_REASON_CODE%TYPE
)
IS
    -- üũ�� �ڵ� ����
    CHECK_OUT_CODE TBL_OUT.OUT_CODE%TYPE;
    CHECK_SUGANG_CODE TBL_SUGANG.SUGANG_CODE%TYPE;
    CHECK_OUT_REASON_CODE TBL_OUT_REASON.OUT_REASON_CODE%TYPE;
    -- �ߵ�Ż�� �ڵ�
    V_OUT_CODE TBL_OUT.OUT_CODE%TYPE;
    
    -- ���� �����ϰ� ������
    V_OPENCOU_START TBL_OPENCOU.OPENCOU_START%TYPE;
    V_OPENCOU_END TBL_OPENCOU.OPENCOU_END%TYPE;
    
    -- ���� ó��
    USER_DEFINE_ERROR1 EXCEPTION;
    USER_DEFINE_ERROR2 EXCEPTION;
    USER_DEFINE_ERROR3 EXCEPTION;
    USER_DEFINE_ERROR4 EXCEPTION;
BEGIN
    
    -- �߰�Ż���ڵ尡 �̹� ������ ���� �߻�
    -- �߰�Ż���ڵ尡 ��� 0�̵Ǹ� ��� ����
    SELECT NVL((SELECT OUT_CODE FROM TBL_OUT WHERE OUT_CODE = V_OUT_CODE), '0') INTO CHECK_OUT_CODE
    FROM DUAL;
    
    IF (CHECK_OUT_CODE != '0')
        THEN RAISE USER_DEFINE_ERROR1;
    END IF;
    
    -- �����ڵ尡 ������ ����, ������ ���� �߻�
    SELECT NVL((SELECT SUGANG_CODE FROM TBL_SUGANG WHERE SUGANG_CODE = V_SUGANG_CODE), '0') INTO CHECK_SUGANG_CODE
    FROM DUAL;
    
    IF (CHECK_SUGANG_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR2;
    END IF;
    
    -- Ż�������ڵ尡 ������ ����, ������ ���� �߻�
    SELECT NVL((SELECT OUT_REASON_CODE FROM TBL_OUT_REASON WHERE OUT_REASON_CODE = V_OUT_REASON_CODE), '0') INTO CHECK_OUT_REASON_CODE
    FROM DUAL;
    
    IF (CHECK_OUT_REASON_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR3;
    END IF;   
    
    
    -- ���������ϰ� ������ ���̿� ���� ������ �ߵ� ����,Ż����ų �� ���� ó���Ѵ�.
    -- ������û ���̺� �ִ� ���� �ڵ�� �Է��� �����ڵ尡 ���� ���� ã��
    -- �����ڵ带 ��������
    -- �� �����ڵ尡 �����������̺� �ִ� �����ڵ�� ���� ����
    -- �������� ������, �������� �������� �����´�.
    SELECT OPENCOU_START, OPENCOU_END INTO V_OPENCOU_START, V_OPENCOU_END
    FROM TBL_OPENCOU
    WHERE OPENCOU_CODE = (SELECT OPENCOU_CODE FROM TBL_SUGANG WHERE SUGANG_CODE = V_SUGANG_CODE);
    
    IF (SYSDATE NOT BETWEEN V_OPENCOU_START AND V_OPENCOU_END)
        THEN RAISE USER_DEFINE_ERROR4;
    END IF;
    
    
    -- INSERT ����
    INSERT INTO TBL_OUT(OUT_CODE, SUGANG_CODE, OUT_REASON_CODE, OUT_DATE)
    VALUES(('OT' || LPAD(TO_CHAR(TBL_OUT_SEQ.NEXTVAL), 3, '0')), V_SUGANG_CODE, V_OUT_REASON_CODE, SYSDATE);
    
    -- ���� �̴��� ���� ����ؼ� �ߵ�Ż���� ��Ͻ�Ű���� ������ ������ �������������� ���������ʾ�����..?
    
    -- ����ó�� 
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20971, '�̹� �ش� ������ �ߵ� ����,Ż���� �л��Դϴ�.');
            ROLLBACK;
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20972, '�������� ���� �����ڵ��Դϴ�.');
            ROLLBACK;  
        WHEN USER_DEFINE_ERROR3
            THEN RAISE_APPLICATION_ERROR(-20973, '�������� ���� Ż�������ڵ��Դϴ�.');
            ROLLBACK;  
        WHEN USER_DEFINE_ERROR4
            THEN RAISE_APPLICATION_ERROR(-20974, 'ó���� �� �ִ� �����Ⱓ�� �ƴմϴ�.');
            ROLLBACK;  
            
    -- Ŀ��
    COMMIT;
END;
--==>> Procedure PRC_OUT_INSERT��(��) �����ϵǾ����ϴ�.


--�� �ߵ�Ż�� ���� ���ν���
-- PRC_OUT_UPDATE(�ߵ�Ż���ڵ�, ������ �ߵ�Ż�������ڵ�)
CREATE OR REPLACE PROCEDURE PRC_OUT_UPDATE
( V_OUT_CODE        IN TBL_OUT.OUT_CODE%TYPE
, V_OUT_REASON_CODE IN TBL_OUT_REASON.OUT_REASON_CODE%TYPE
)
IS
    CHECK_OUT_REASON_CODE TBL_OUT_REASON.OUT_REASON_CODE%TYPE;
    
    USER_DEFINE_ERROR1 EXCEPTION;
BEGIN

    -- ���� ���� �ߵ�Ż�������ڵ尡 �ߵ�Ż�����̺� �����ϴ� �ڵ����� Ȯ��
    SELECT NVL((SELECT OUT_REASON_CODE 
                FROM TBL_OUT_REASON 
                WHERE OUT_REASON_CODE = V_OUT_REASON_CODE), '0') INTO CHECK_OUT_REASON_CODE
    FROM DUAL;

    IF (CHECK_OUT_REASON_CODE != '0')
        THEN RAISE USER_DEFINE_ERROR1;
    END IF;
    
    UPDATE TBL_OUT
    SET OUT_REASON_CODE = V_OUT_REASON_CODE
    WHERE OUT_CODE = V_OUT_CODE;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20973, '�������� ���� Ż�������ڵ��Դϴ�.');
            ROLLBACK;
    
    COMMIT;

END;






