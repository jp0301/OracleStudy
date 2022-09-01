SELECT USER
FROM DUAL; 
--==>> SCOTT


--�� TBL_INSA ���̺��� �޿� ��� ���� �Լ��� �����Ѵ�.
--   �޿��� (�⺻��*12)+����  ������� ������ �����Ѵ�.
--   �Լ��� : FN_PAY(�⺻��, ����)

DESC TBL_INSA;

CREATE OR REPLACE FUNCTION FN_PAY(V_BASICPAY NUMBER, V_SUDANG NUMBER)
RETURN NUMBER
IS
    V_SAL NUMBER;
BEGIN
    V_SAL := (NVL(V_BASICPAY, 0) * 12) + NVL(V_SUDANG, 0);
    RETURN V_SAL;
END;



--�� TBL_INSA ���̺��� �Ի����� ��������
--   ��������� �ٹ������ ��ȯ�ϴ� �Լ��� �����Ѵ�.
--   ��, �ٹ������ �Ҽ��� ���� ���ڸ����� ��� - TRUNC(��, 1)
--   �Լ��� : FN_WORKYEAR()


CREATE OR REPLACE FUNCTION FN_WORKYEAR(V_IBSADATE DATE)
RETURN NUMBER
IS
    V_RESULT NUMBER;
BEGIN
    V_RESULT := TRUNC((SYSDATE - V_IBSADATE)/365, 1);
    
    RETURN V_RESULT;
END;
--==>> Function FN_WORKYEAR��(��) �����ϵǾ����ϴ�.




--1
SELECT MONTHS_BETWEEN(SYSDATE, '2002-02-11')/12
FROM DUAL;

--2
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, '2002-02-11')/12)||'��'||
       TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, '2002-02-11'), 12))||'����'
FROM DUAL;

--3
SELECT NAME, IBSADATE, FN_WORKYEAR(IBSADATE) "�ٹ��Ⱓ"
FROM TBL_INSA;


CREATE OR REPLACE FUNCTION FN_WORKYEAR2(V_IBSADATE DATE)
RETURN VARCHAR2
IS
    V_RESULT VARCHAR2(20);
BEGIN
    V_RESULT := TRUNC(MONTHS_BETWEEN(SYSDATE, V_IBSADATE)/12)||'��'||
                TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, V_IBSADATE), 12))||'����';
                
    RETURN V_RESULT;
END;
--==>> Function 
--==>> Function FN_WORKYEAR2��(��) �����ϵǾ����ϴ�.



--------------------------------------------------------------------------------

--�� ����

--1. INSERT, UPDATE, DELETE, (MERGE)
--==>> DML(Data Manipulation Language)
-- COMMIT / ROLLBACK �� �ʿ��ϴ�.


--2. CREATE, DROP, ALTER, (TRUNCATE)
--==>> DDL(Data Definition Language)
-- �����ϸ� �ڵ����� COMMIT �ȴ�.

--3. GRANT, REVOKE
--==>> DCL(Data Control Language)
-- �����ϸ� �ڵ����� COMMIT �ȴ�.

--4. COMMIT, ROLLBACK
--==>> TCL(Transaction Control Language)


--------------------------------------------------------------------------------


--���� PROCEDURE (���ν���) ����--

-- 1. PL/SQL ���� ���� ��ǥ���� ������ ������ ���ν�����
--    �����ڰ� ���� �ۼ��ؾ� �ϴ� ������ �帧��
--    �̸� �ۼ��Ͽ� �����ͺ��̽� ���� ������ �ξ��ٰ�
--    �ʿ��� �� ���� ȣ���Ͽ� ������ �� �ֵ��� ó���� �ִ� �����̴�.


-- 2. ���� �� ����
/*
CREATE [OR REPLACE] PROCEDURE ���ν�����
[( �Ű����� IN ������Ÿ��
 , �Ű����� OUT ������Ÿ��
 , �Ű����� INOUT ������Ÿ��
)]
IS 
    [--�ֿ� ���� ����]
BEGIN
    -- ���� ����;
    ...
    [EXCEPTION]
        -- ���� ó�� ����;
END;
*/

--�� FUNCTION �� ������ ��
--   'RETURN ��ȯ�ڷ���' �κ��� �������� ������,
--   'RETURN' �� ��ü�� �������� ������,
--   ���ν��� ���� �� �Ѱ��ְ� �Ǵ� �Ű�������
--   IN, OUT, INOUT ���� ���еȴ�.


-- 3. ����(ȣ��)
/*
EXEC[UTE] ���ν�����[(�μ�1, �μ�2, ...)];
*/


-- ���ν��� ���� �ǽ� ������ ����
-- 20220901_02_scott.sql ���Ͽ�
-- ���̺� ���� �� ������ �Է� ����


--�� ���ν��� ����(PRC_STUDENTS_INSERT())
-- ���ν��� �� : PRC_STUDENTS_INSERT(���̵�, �н�����,�̸�, ��ȭ, �ּ�)
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_INSERT
( ���̵�, �н�����, �̸�, ��ȭ, �ּ�
)
IS
BEGIN
END;

CREATE OR REPLACE PROCEDURE PRC_STUDENTS_INSERT
( V_ID      IN TBL_IDPW.ID%TYPE
, V_PW      IN TBL_IDPW.PW%TYPE
, V_NAME    IN TBL_STUDENTS.NAME%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS
        
BEGIN
    INSERT INTO TBL_IDPW(ID, PW) VALUES(V_ID, V_PW);
    
    INSERT INTO TBL_STUDENTS(ID, NAME, TEL, ADDR)
    VALUES(V_ID, V_NAME, V_TEL, V_ADDR);
    
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_INSERT��(��) �����ϵǾ����ϴ�.



--�� TBL_SUNGJUK ���̺� ������ �Է� ��
--   Ư�� �׸��� �����͸� �Է��ϸ�
--   -----------------
--   (�й�, �̸�, ��������, ��������, ��������)
--   ���������� ����, ���, ��� �׸� ���� ó���� �Բ� �̷���� �� �ֵ��� �ϴ�
--   ���ν����� �ۼ��Ѵ�. (�����Ѵ�.)
--   ���ν��� �� : PRC_SUNGJUK_INSERT()

/*
���� ��)
EXEC PRC_SUNGJUK_INSERT(1, '���ҿ�', 90, 80, 70);

�� ���ν��� ȣ��� ó���� ���
�й�     �̸�      ��������      ��������     ��������    ����    ���   ���
 1      ���ҿ�        90           80           70       240    80       2     
*/

CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_INSERT
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_NAME    IN TBL_SUNGJUK.NAME%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    V_TOT   TBL_SUNGJUK.TOT%TYPE;
    V_AVG   TBL_SUNGJUK.AVG%TYPE;
    V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN

    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := (V_TOT)/3;
        
    IF V_AVG >= 90
        THEN V_GRADE := 'A';
    ELSIF V_AVG >= 80
        THEN V_GRADE := 'B';
    ELSIF V_AVG >= 70
        THEN V_GRADE := 'C';
    ELSIF V_AVG >= 60
        THEN V_GRADE := 'D';
    ELSE V_GRADE := 'F';
    END IF;
    
    INSERT INTO TBL_SUNGJUK(HAKBUN, NAME, KOR, ENG, MAT, TOT, AVG, GRADE)
    VALUES(V_HAKBUN, V_NAME, V_KOR, V_ENG, V_MAT, V_TOT, V_AVG, V_GRADE);
    
    COMMIT;
END;
--==>> Procedure PRC_SUNGJUK_INSERT��(��) �����ϵǾ����ϴ�.



--�� TBL_SUNGJUK ���̺��� Ư�� �л��� ���� ������ ���� ��
-- Ư�� �׸��� �����͸� �Է��ϸ�
-- (�й�, ��������, ��������, ��������)
-- ���������� ����, ���, ��� �׸� ���� ó���� �Բ� �̷���� �� �ֵ��� �ϴ�
-- ���ν����� �ۼ��Ѵ�. (�����Ѵ�.)
-- ���ν��� �� : PRC_SUNGJUK_UPDATE()

/*
���� ��)
EXEC PRC_SUNGJUK_UPDATE(1, 50, 50, 50);

�� ���ν��� ȣ��� ó���� ���
�й� �̸� �������� �������� �������� ���� ��� ���
 1   ���ҿ�  50      50      50   150   50     F

*/


CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    V_TOT TBL_SUNGJUK.TOT%TYPE;
    V_AVG TBL_SUNGJUK.AVG%TYPE; 
    V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- �����
    -- UPDATE ������ ���࿡ �ռ� �߰��� ������ �ַ� �����鿡 �� ��Ƴ���
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT/3;
    
    IF (V_AVG >= 90)
        THEN V_GRADE := 'A';
    ELSIF (V_AVG >= 80)
        THEN V_GRADE := 'B';
    ELSIF (V_AVG >= 70)
        THEN V_GRADE := 'C';
    ELSIF (V_AVG >= 60)
        THEN V_GRADE := 'D';
    ELSE V_GRADE := 'F';
    END IF;
    
    -- UPDATE ������ ����
    UPDATE TBL_SUNGJUK
    SET KOR = V_KOR, ENG = V_ENG, MAT=V_MAT
        , TOT = V_TOT, AVG = V_AVG, GRADE = V_GRADE
    WHERE HAKBUN = V_HAKBUN;

    COMMIT;
END;
--==>>Procedure PRC_SUNGJUK_UPDATE��(��) �����ϵǾ����ϴ�.



---�� TBL_STUDENTS ���̺��� ��ȭ��ȣ�� �ּ� �����͸� �����ϴ�(�����ϴ�) 
-- ���ν����� �ۼ��Ѵ�.
--    ��, ID�� PW �� ��ġ�ϴ� ��쿡�� ������ ������ �� �ֵ��� ó���Ѵ�.
--    ���ν��� �� : PRC_STUDENTS_UPDATE
/*
���� ��)
EXEC PRC_STUDENTS_UPDATE('superman','java002','010-9876-5432','������ Ⱦ��');
--> �н����� ��ġ���� ���� --==>> ������ ���� X

EXEC PRC_STUDENTS_UPDATE('superman','java002$','010-9876-5432','������ Ⱦ��');
--> �н����� ��ġ�� --==>> ������ ���� ��

*/

CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID  IN TBL_IDPW.ID%TYPE
, V_PW  IN TBL_IDPW.PW%TYPE
, V_TEL IN TBL_STUDENTS.TEL%TYPE
, V_ADDR IN TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL, ADDR = V_ADDR
    WHERE ID = V_ID
      AND (SELECT PW FROM TBL_IDPW WHERE ID=V_ID) = V_PW;
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_UPDATE��(��) �����ϵǾ����ϴ�.


-- ����
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID      IN TBL_IDPW.ID%TYPE
, V_PW      IN TBL_IDPW.PW%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    UPDATE ( SELECT I.ID, I.PW, S.TEL, S.ADDR
              FROM TBL_IDPW I JOIN TBL_STUDENTS S
              ON I.ID = S.ID) T
    SET T.TEL = V_TEL, T.ADDR = V_ADDR
    WHERE T.ID = V_ID AND T.PW = V_PW;
    
    COMMIT;
END;


CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID  IN TBL_IDPW.ID%TYPE
, V_PW  IN TBL_IDPW.PW%TYPE
, V_TEL IN TBL_STUDENTS.TEL%TYPE
, V_ADDR IN TBL_STUDENTS.ADDR%TYPE
)
IS
    -- �ʿ��� ���� ����
    V_PW2   TBL_IDPW.PW%TYPE;
    V_FLAG  NUMBER := 0;
BEGIN
    -- �н����尡 �´��� Ȯ��
    SELECT PW INTO V_PW2
    FROM TBL_IDPW
    WHERE ID = V_ID;

    -- �н����� ��ġ ���ο� ���� �б�
    IF (V_PW = V_PW2)
        THEN V_FLAG := 1;
    ELSE
        V_FLAG := 2;
    END IF;

    -- UPDATE ������ ���� �� TBL_STUDENTS (�б� ��� �ݿ�)
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL, ADDR = V_ADDR
    WHERE ID = V_ID
      AND V_FLAG = 1;

    -- Ŀ��
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_UPDATE��(��) �����ϵǾ����ϴ�.



--�� TBL_INSA ���̺��� ������� �ű� ������ �Է� ���ν����� �ۼ��Ѵ�.
--NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG
--���� ������ �÷� ��
--NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG
--�� ������ �Է� ��
--NUM �÷�(�����ȣ)�� ����
--���� �ο��� ��� ��ȣ�� ������ ��ȣ �� ���� ��ȣ�� �ڵ����� �Է�ó���� �� �ִ�
-- ���ν����� �����Ѵ�.
-- ���ν��� �� : PRC_INSA_INSERT()
/*
���� ��)
EXEC PRC_INSA_INSERT('������',''970124-2234567',SYSDATE, '����', '010-7202-6306'
, '���ߺ�', '�븮', 2000000, 2000000);

�� ���ν��� ȣ��� ó���� ���
1061 ������ .... 2000000 
�� �����Ͱ� �ű� �Էµ� ��Ȳ
*/

CREATE OR REPLACE PROCEDURE PRC_INSA_INSERT
( V_NAME        IN TBL_INSA.NAME%TYPE
, V_SSN         IN TBL_INSA.SSN%TYPE
, V_IBSADATE    IN TBL_INSA.IBSADATE%TYPE
, V_CITY        IN TBL_INSA.CITY%TYPE
, V_TEL         IN TBL_INSA.TEL%TYPE
, V_BUSEO       IN TBL_INSA.BUSEO%TYPE
, V_JIKWI       IN TBL_INSA.JIKWI%TYPE
, V_BASICPAY    IN TBL_INSA.BASICPAY%TYPE
, V_SUDANG      IN TBL_INSA.SUDANG%TYPE
)
IS
    V_LASTNUM TBL_INSA.NUM%TYPE;
BEGIN
    
    SELECT MAX(NVL(NUM, 0)) + 1 INTO V_LASTNUM
    FROM TBL_INSA;
    

    INSERT INTO TBL_INSA(NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI,BASICPAY,SUDANG)
    VALUES(V_LASTNUM, V_NAME, V_SSN, V_IBSADATE, V_CITY, V_TEL, V_BUSEO, V_JIKWI, V_BASICPAY, V_SUDANG);
    
    COMMIT;
END;
--==>> Procedure PRC_INSA_INSERT��(��) �����ϵǾ����ϴ�.









