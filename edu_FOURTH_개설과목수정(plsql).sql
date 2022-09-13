-- �������� ����
-- (���������ڵ�, ���������, ����������, ���������ڵ�, �����ڵ�, �����ڵ�, ������, �ʱ����, �Ǳ����)
CREATE OR REPLACE PROCEDURE PRC_OPENSUB_UPDATE
( V_OPENSUB_CODE        IN TBL_OPENSUB.OPENSUB_CODE%TYPE
, V_OPENSUB_START       IN TBL_OPENSUB.OPENSUB_START%TYPE
, V_OPENSUB_END         IN TBL_OPENSUB.OPENSUB_END%TYPE
, V_OPENCOU_CODE       IN TBL_OPENCOU.OPENCOU_CODE%TYPE
, V_BOOK_CODE           IN TBL_BOOK.BOOK_CODE%TYPE
, V_SUB_CODE            IN TBL_SUB.SUB_CODE%TYPE
, V_OPENSUB_ATTEND      IN TBL_OPENSUB.OPENSUB_ATTEND%TYPE
, V_OPENSUB_WRITE       IN TBL_OPENSUB.OPENSUB_WRITE%TYPE
, V_OPENSUB_PRAC        IN TBL_OPENSUB.OPENSUB_PRAC%TYPE
)
IS
    CHECK_OPENCOU_CODE TBL_OPENCOU.OPENCOU_CODE%TYPE;
    CHECK_OPENSUB_CODE TBL_OPENSUB.OPENSUB_CODE%TYPE;
    OPENSUB_CODE_CHECK TBL_OPENSUB.OPENSUB_CODE%TYPE;
    
    USER_DEFINE_ERROR0 EXCEPTION;
    
    USER_DEFINE_ERROR1 EXCEPTION; -- ������ ���� �� ���� �߻�
    USER_DEFINE_ERROR2 EXCEPTION; -- ������ ���� �� ���� �߻�
    USER_DEFINE_ERROR3 EXCEPTION; -- ���� ����� �Ⱓ ��ĥ�� ����
    USER_DEFINE_ERROR4 EXCEPTION; -- ���� ���� ���� �߻�
    USER_DEFINE_ERROR5 EXCEPTION; -- ���� ������, ������ ���� �����϶� ���� �߻�
    
    V_OPENCOU_START TBL_OPENCOU.OPENCOU_START%TYPE;
    V_OPENCOU_END TBL_OPENCOU.OPENCOU_END%TYPE;
    
    OPENSUB_OLD_START DATE;
    OPENSUB_OLD_END DATE;
    
    CURSOR CUR_CHECK_DATE
    IS
    SELECT OPENSUB_START, OPENSUB_END
    FROM TBL_OPENSUB
    WHERE OPENCOU_CODE = V_OPENCOU_CODE
      AND SUB_CODE != V_SUB_CODE;
BEGIN

    -- ���������ڵ� üũ
    SELECT NVL(MAX(OPENSUB_CODE), '0') INTO OPENSUB_CODE_CHECK
    FROM TBL_OPENSUB
    WHERE OPENSUB_CODE = V_OPENSUB_CODE;

    IF (OPENSUB_CODE_CHECK = '0')
        THEN RAISE USER_DEFINE_ERROR0;
    END IF;

    -- ���� ���� üũ
    SELECT NVL(MAX(OPENCOU_CODE), '0') INTO CHECK_OPENCOU_CODE
    FROM TBL_OPENSUB
    WHERE OPENCOU_CODE = V_OPENCOU_CODE;

    IF (CHECK_OPENCOU_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR1;
    END IF;

    -- ���� ���� üũ
    SELECT NVL(MAX(SUB_CODE), '0') INTO CHECK_OPENSUB_CODE
    FROM TBL_OPENSUB
    WHERE SUB_CODE = V_SUB_CODE
    AND OPENCOU_CODE = V_OPENCOU_CODE;

    IF (CHECK_OPENSUB_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR2;
    END IF;


    -- ���� ������, ���� ������ ���� ���� üũ
    SELECT OPENCOU_START, OPENCOU_END INTO V_OPENCOU_START, V_OPENCOU_END
    FROM TBL_OPENCOU
    WHERE OPENCOU_CODE = V_OPENCOU_CODE;
    
    -- ���� �Է��� ���� �������� ������ ���� �����Ϻ��� �����̰ų�
    -- ���� �Է��� ���� �������� ������ ���� �����Ϻ��� �����̰ų�
    IF (V_OPENSUB_START < V_OPENCOU_START OR V_OPENSUB_END > V_OPENCOU_END)
        THEN RAISE USER_DEFINE_ERROR3;
    END IF;
    
    -- ���� 100�� �ʰ��� �����߻�
    IF (V_OPENSUB_ATTEND + V_OPENSUB_WRITE + V_OPENSUB_PRAC != 100)
        THEN RAISE USER_DEFINE_ERROR4;
    END IF;
    
    
    -- ������ �ִ� ������ �Ⱓ�� ��ĥ ��� ���� �߻�
    OPEN CUR_CHECK_DATE;
    
    LOOP
        FETCH CUR_CHECK_DATE INTO OPENSUB_OLD_START, OPENSUB_OLD_END;
        EXIT WHEN CUR_CHECK_DATE%NOTFOUND;
        
        -- �Է��� ����������� ����, �����̰� �Է��� ������������ ����, �����̸� �����߻�
        IF (V_OPENSUB_START <= OPENSUB_OLD_START AND V_OPENSUB_END >= OPENSUB_OLD_END)
            THEN RAISE USER_DEFINE_ERROR5;
        ELSIF (V_OPENSUB_START <= OPENSUB_OLD_END AND V_OPENSUB_END >= OPENSUB_OLD_END)
            THEN RAISE USER_DEFINE_ERROR5;    
        ELSIF (V_OPENSUB_START >= OPENSUB_OLD_START AND V_OPENSUB_END <= OPENSUB_OLD_END)
            THEN RAISE USER_DEFINE_ERROR5;  
        END IF;
    END LOOP;
    
    CLOSE CUR_CHECK_DATE;
    
    
    UPDATE TBL_OPENSUB
    SET OPENSUB_START = V_OPENSUB_START
    , OPENSUB_END = V_OPENSUB_END
    , OPENSUB_ATTEND = V_OPENSUB_ATTEND
    , OPENSUB_WRITE = V_OPENSUB_WRITE
    , OPENSUB_PRAC = V_OPENSUB_PRAC
    , BOOK_CODE = V_BOOK_CODE
    , OPENCOU_CODE = V_OPENCOU_CODE
    , SUB_CODE = V_SUB_CODE
    WHERE OPENSUB_CODE = V_OPENSUB_CODE;
    
    
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR0
            THEN RAISE_APPLICATION_ERROR(-20961, '���� ���� �ڵ尡 �����ϴ�.');
                ROLLBACK;
                
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20961, '���� ������ �����ϴ�.');
                ROLLBACK;
            
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20962, '�ش�������� �ش� ������ �����ϴ�.');
                ROLLBACK;
                
        WHEN USER_DEFINE_ERROR3
            THEN RAISE_APPLICATION_ERROR(-20963, '���� ������ ���� ���� �Ⱓ���� ����/������ �� �����ϴ�.');
                ROLLBACK;
                                
        WHEN USER_DEFINE_ERROR4
            THEN RAISE_APPLICATION_ERROR(-20964, '������ ������ 100�� �̾�� �մϴ�.');
                ROLLBACK;
                
        WHEN USER_DEFINE_ERROR5
            THEN RAISE_APPLICATION_ERROR(-20965, '�ش� �Ⱓ�� ���� ���� ������ �ֽ��ϴ�.');
                ROLLBACK;
                
    --Ŀ��
    COMMIT;
    
END;
---==>> Procedure PRC_OPENSUB_UPDATE��(��) �����ϵǾ����ϴ�.








