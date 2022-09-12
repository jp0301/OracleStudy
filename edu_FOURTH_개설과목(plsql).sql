


--�� �������� ������ ����
CREATE SEQUENCE TBL_OPENSUB_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999
NOCYCLE
NOCACHE;
--==>> Sequence TBL_SUB_SEQ��(��) �����Ǿ����ϴ�.


/*
���� ���������� ����
PRC_OPENSUB_INSERT
( OPENSUB_CODE   ���������ڵ� ������ ó��
, OPENCOU_CODE   ���������ڵ� TBL_OPENCOU
, SUB_CODE       �����ڵ� TBL_SUB
, PROF_CODE      �����ڵ� TBL_PROF
, BOOK_CODE      �����ڵ� TBL_BOOK
, OPENSUB_DATE   ��������� TBL_OPENSUB
, OPENSUB_END    ���������� TBL_OPENSUB
, OPENSUB_ATTEND ������  TBL_OPENSUB
, OPENSUB_WRITE  �ʱ����  TBL_OPENSUB
, OPENSUB_PRAC   �Ǳ����  TBL_OPENSUB
)
*/


--�� ���� ���� ���
CREATE OR REPLACE PROCEDURE PRC_OPENSUB_INSERT
( V_OPENCOU_CODE        IN TBL_OPENCOU.OPENCOU_CODE%TYPE
, V_SUB_CODE            IN TBL_SUB.SUB_CODE%TYPE
, V_PROF_CODE           IN TBL_PROF.PROF_CODE%TYPE
, V_BOOK_CODE           IN TBL_BOOK.BOOK_CODE%TYPE
, V_OPENSUB_START       IN TBL_OPENSUB.OPENSUB_START%TYPE
, V_OPENSUB_END         IN TBL_OPENSUB.OPENSUB_END%TYPE
, V_OPENSUB_ATTEND      IN TBL_OPENSUB.OPENSUB_ATTEND%TYPE
, V_OPENSUB_WRITE       IN TBL_OPENSUB.OPENSUB_WRITE%TYPE
, V_OPENSUB_PRAC        IN TBL_OPENSUB.OPENSUB_PRAC%TYPE
)
IS
    OPENCOU_CHECK_CODE      TBL_OPENCOU.OPENCOU_CODE%TYPE;
    SUB_CHECK_CODE      TBL_SUB.SUB_CODE%TYPE;
    PROF_CHECK_CODE         TBL_PROF.PROF_CODE%TYPE;
    BOOK_CHECK_CODE         TBL_BOOK.BOOK_CODE%TYPE;

    V_OPENSUB_CODE TBL_OPENSUB.OPENSUB_CODE%TYPE;
    
    COU_START DATE; --���� ���� ������
    COU_END DATE; --���� ���� ������
    
    OLD_START DATE; --���� ���� ������
    OLD_END DATE; --���� ���� ������
    
    CURSOR CUR_CHECK_DATE
    IS
    SELECT OPENSUB_START, OPENSUB_END
    FROM TBL_OPENSUB
    WHERE OPENCOU_CODE = V_OPENCOU_CODE;
    
    
    -- ���� ����
    USER_DEFINE_ERROR1 EXCEPTION;
    USER_DEFINE_ERROR2 EXCEPTION;
    USER_DEFINE_ERROR3 EXCEPTION;
    USER_DEFINE_ERROR4 EXCEPTION;
    USER_DEFINE_ERROR5 EXCEPTION;
    USER_DEFINE_ERROR6 EXCEPTION;
    USER_DEFINE_ERROR7 EXCEPTION;
BEGIN
    -- ������ ������ 100�� �Ǿ�� �Ѵ�. �ȵǸ� ���� �߻�
    IF (V_OPENSUB_ATTEND + V_OPENSUB_WRITE + V_OPENSUB_PRAC != 100)
        THEN RAISE USER_DEFINE_ERROR1;
    END IF;
    
    -- ���� ���� üũ
    SELECT NVL(MAX(OPENCOU_CODE), '0') INTO OPENCOU_CHECK_CODE
    FROM TBL_OPENCOU
    WHERE OPENCOU_CODE = V_OPENCOU_CODE;
    
    IF (OPENCOU_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR2;
    END IF;
    
    -- ���� ���� üũ
    SELECT NVL(MAX(SUB_CODE), '0') INTO SUB_CHECK_CODE
    FROM TBL_SUB
    WHERE SUB_CODE = V_SUB_CODE;
    
    IF (SUB_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR3;
    END IF;
    
    -- ���� ���� üũ
    SELECT NVL(MAX(PROF_CODE), '0') INTO PROF_CHECK_CODE
    FROM TBL_PROF
    WHERE PROF_CODE = V_PROF_CODE;
    
    IF (PROF_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR4;
    END IF;
    
    
    -- ���� ���� üũ
    SELECT NVL(MAX(BOOK_CODE), '0') INTO BOOK_CHECK_CODE
    FROM TBL_BOOK
    WHERE BOOK_CODE = V_BOOK_CODE;
    
    IF (BOOK_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR5;
    END IF;
    

    
    -- ���� �����ϰ� ������ ��������
    SELECT OPENCOU_START, OPENCOU_END INTO COU_START, COU_END
    FROM TBL_OPENCOU
    WHERE OPENCOU_CODE = V_OPENCOU_CODE;

    -- ����������ڰ� ���纸�� �����̸� �ȵ�
    IF (V_OPENSUB_START < SYSDATE
        -- ���� �����ϰ� ���� �������� ���� �����ϰ� ���� ������ ���̿� �־�� ��
        OR V_OPENSUB_START NOT BETWEEN COU_START AND COU_END
        OR V_OPENSUB_END NOT BETWEEN COU_START AND COU_END)
        THEN RAISE USER_DEFINE_ERROR6;
    END IF;
    


    -- ������ �ִ� ������ ������, ������ ������ ��ġ�� �ȵȴ�.
    -- Ŀ�� ����
    OPEN CUR_CHECK_DATE;
        LOOP
            -- FETCH ��������޾Ƽ�ó��
            FETCH CUR_CHECK_DATE INTO OLD_START, OLD_END;
            
            EXIT WHEN CUR_CHECK_DATE%NOTFOUND; --Ŀ���� ������ EXIT
                      
            -- �Է��� ���� �������� ������ ��������� ����, �����̰�
            -- �Է��� ���� �������� ������ ��������� ����, �����̸� ���� �߻�
            IF (V_OPENSUB_START <= OLD_START AND V_OPENSUB_END >= OLD_START)
                THEN RAISE USER_DEFINE_ERROR7;            
            -- �Է��� ���� �������� ������ ��������� ����, �����̰�
            -- �Է��� ���� �������� ������ ���������� ����, �����̸� ���� �߻�
            ELSIF (V_OPENSUB_START <= OLD_END AND V_OPENSUB_END >= OLD_END)
                THEN RAISE USER_DEFINE_ERROR7;            
            -- �Է��� ���� �������� �����ǰ�������� ����, �����̰�
            -- �Է��� ���� �������� ������ ���������� ����, �����̸� ���� �߻�
            ELSIF (V_OPENSUB_START >= OLD_START AND V_OPENSUB_END >= OLD_END)
                THEN RAISE USER_DEFINE_ERROR7;
            END IF;
        END LOOP;
        
    CLOSE CUR_CHECK_DATE;
        
        
    -- ���������ڵ� �Է�
    V_OPENSUB_CODE := 'OSJ' || LPAD(TO_CHAR(TBL_OPENSUB_SEQ.NEXTVAL), 3, '0');
    
    -- INSERT ������
    INSERT INTO TBL_OPENSUB(OPENSUB_CODE, OPENCOU_CODE, PROF_CODE, SUB_CODE, BOOK_CODE
    , OPENSUB_START, OPENSUB_END, OPENSUB_ATTEND, OPENSUB_WRITE, OPENSUB_PRAC)
    VALUES(V_OPENSUB_CODE, V_OPENCOU_CODE, V_PROF_CODE, V_SUB_CODE, V_BOOK_CODE
    , V_OPENSUB_START, V_OPENSUB_END, V_OPENSUB_ATTEND, V_OPENSUB_WRITE, V_OPENSUB_PRAC);
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20951, '���� ������ 100���̾�� �մϴ�.');            
            ROLLBACK;
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20952, '���� ������ �����ϴ�.');
            ROLLBACK;
        WHEN USER_DEFINE_ERROR3
            THEN RAISE_APPLICATION_ERROR(-20953, '�ش� ������ �����ϴ�.');
            ROLLBACK;            
        WHEN USER_DEFINE_ERROR4
            THEN RAISE_APPLICATION_ERROR(-20954, '�ش� ������ �����ϴ�.');
            ROLLBACK;            
        WHEN USER_DEFINE_ERROR5
            THEN RAISE_APPLICATION_ERROR(-20955, '�ش� ����� �����ϴ�.');
            ROLLBACK;            
        WHEN USER_DEFINE_ERROR6
            THEN RAISE_APPLICATION_ERROR(-20956, '������ �����Ϸ��� ������������ ����/���Ŀ��� ������ �� �����ϴ�.');
            ROLLBACK;
        WHEN USER_DEFINE_ERROR7
            THEN RAISE_APPLICATION_ERROR(-20957, '�Է±Ⱓ �߿� �������� ������ �ֽ��ϴ�.');
            ROLLBACK;
    
    -- Ŀ�� 
    COMMIT;
END;


--�� �������� ��� ���ν��� ����
EXEC PRC_OPENSUB_INSERT('OPC004','SUB001','PRO001','BOK001','2022-09-10','2023-01-01','20','40','40');

--OPC004	COU004	CLA004	2022-09-09	2023-01-16

EXEC PRC_OPENSUB_INSERT('OPC004','SUB001','PRO001','BOK010','2022-09-10','2022-12-21','20','40','40');
--==>> �����߻�
-- ORA-20955: �ش� ����� �����ϴ�.