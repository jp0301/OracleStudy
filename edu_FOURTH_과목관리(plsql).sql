/*
--�� ���� ����
1. PRC_SUB_INSERET(������, �����, ����Ⱓ, �����, �����ڸ�) (���� ���)
2. VIEW_SUB_INFO (�������)
   SELECT ������, ���ǽ�, ����Ⱓ, �����, �����ڸ�
3. PRC_SUB_UPDATE(�����ڵ�, �����ҵ�����)   (�������)
4. PRC_SUB_DELETE(�����ڵ�)         (�������)
*/


--�� ���� ������ ����
CREATE SEQUENCE TBL_SUB_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999
NOCYCLE
NOCACHE;
--==>> Sequence TBL_SUB_SEQ��(��) �����Ǿ����ϴ�.

--�� ���� ���
--   1. PRC_SUB_INSERT(�����ڵ�, �����)
CREATE OR REPLACE PROCEDURE PRC_SUB_INSERT
( V_SUB_NAME     IN TBL_SUB.SUB_NAME%TYPE
)
IS 
    SUB_CHECK_NAME TBL_SUB.SUB_NAME%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    -- �̹� �ִ� ��������� Ȯ��
    SELECT NVL((SELECT SUB_NAME
                FROM TBL_SUB
                WHERE SUB_NAME = V_SUB_NAME), '0') INTO SUB_CHECK_NAME
    FROM DUAL;
    
    -- ���� : ���� �߻�
    IF (SUB_CHECK_NAME != '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    INSERT INTO TBL_SUB(SUB_CODE, SUB_NAME)
    VALUES(('SUB' || LPAD(TO_CHAR(TBL_SUB_SEQ.NEXTVAL), 3, '0')), V_SUB_NAME);
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20501, '�̹� ��ϵ� �����Դϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

    -- Ŀ��
    COMMIT;
END;
--==>> Procedure PRC_SUB_INSERT��(��) �����ϵǾ����ϴ�.



--�� ���� ����
--   2. PRC_SUB_UPDATE(�����ڵ�, �����Ұ����)
CREATE OR REPLACE PROCEDURE PRC_SUB_UPDATE
( V_SUB_CODE    IN TBL_SUB.SUB_CODE%TYPE -- �����ڵ�
, V_SUB_NAME    IN TBL_SUB.SUB_NAME%TYPE -- ������ �����
)
IS 
    SUB_CHECK_CODE TBL_SUB.SUB_CODE%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN

    -- �����ڵ尡 ������ �Ǵ��ϱ� ���� ��ȸ
    SELECT NVL((SELECT SUB_CODE
                FROM TBL_SUB
                WHERE SUB_CODE = V_SUB_CODE), '0') INTO SUB_CHECK_CODE
    FROM DUAL;
    
    -- ���� �Ǵ����� �����߻�, �ڵ尡 ������ ����
    IF (SUB_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
 

    -- �����̸� ���� 
    UPDATE TBL_SUB
    SET SUB_NAME = V_SUB_NAME
    WHERE SUB_CODE = V_SUB_CODE;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20502, '�������� ���� �ڵ��Դϴ�..');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK; 
    -- Ŀ��
    COMMIT;
END
--==>> Procedure PRC_SUB_UPDATE��(��) �����ϵǾ����ϴ�.

--�� ���� ���
--   3. PRC_SUB_DELETE(�����ڵ�)
CREATE OR REPLACE PROCEDURE PRC_SUB_DELETE
( V_SUB_CODE IN TBL_SUB.SUB_CODE%TYPE
)
IS 
    SUB_CHECK_CODE TBL_SUB.SUB_CODE%tYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN

    SELECT NVL((SELECT SUB_CODE
                FROM TBL_SUB
                WHERE SUB_CODE = V_SUB_CODE), '0') INTO SUB_CHECK_CODE
    FROM DUAL;

    IF (SUB_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    DELETE
    FROM TBL_SUB
    WHERE SUB_CODE = V_SUB_CODE;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20503, '�������� �ʴ� �����Դϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
            
    --Ŀ��
    COMMIT;   
END;
--==>> Procedure PRC_SUB_DELETE��(��) �����ϵǾ����ϴ�.


--�� ���� ���̵����ͳ־�����µ� ������������ �����ϰ� ���ν����� �ٽ� �Է½�����
EXEC PRC_SUB_INSERT('JAVA');
EXEC PRC_SUB_INSERT('ORACLE');
EXEC PRC_SUB_INSERT('HTML/CSS+Javascript');
EXEC PRC_SUB_INSERT('JSP');
EXEC PRC_SUB_INSERT('Spring Framework');
EXEC PRC_SUB_INSERT('Python');
EXEC PRC_SUB_INSERT('R Programming');
EXEC PRC_SUB_INSERT('Hadoop Programming');
EXEC PRC_SUB_INSERT('Python ML');




--�� 4. �� ���� VIEW_SUB_INFO (�������)
CREATE OR REPLACE VIEW VIEW_SUB_INFO
AS
 
SELECT CO.COURSE_NAME "������"
, CL.CLASS_NAME "���ǽǸ�"
, SB.SUB_NAME "�����"
, OS.OPENSUB_START "���������"
, OS.OPENSUB_END "����������"
, BK.BOOK_NAME "�����"
, PR.PROF_NAME "�����̸�"
FROM TBL_OPENSUB OS
JOIN TBL_OPENCOU OC
ON OS.OPENCOU_CODE = OC.OPENCOU_CODE
JOIN TBL_CLASS CL
ON OC.CLASS_CODE = CL.CLASS_CODE
JOIN TBL_COURSE CO
ON OC.COURSE_CODE = CO.COURSE_CODE
JOIN TBL_SUB SB
ON OS.SUB_CODE = SB.SUB_CODE
JOIN TBL_BOOK BK
ON OS.BOOK_CODE = BK.BOOK_CODE
JOIN TBL_PROF PR
ON OS.PROF_CODE = PR.PROF_CODE;


SELECT *
FROM VIEW_SUB_INFO;
 
 
 
 
 



