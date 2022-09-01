SELECT USER
FROM DUAL;
--==>> SCOTT

SET SERVEROUTPUT ON;

--�� ������ ������ ���� �����ϰ� ����ϴ� ���� �ۼ�
DECLARE
    --�����
    GRADE CHAR;
BEGIN
    --�����
    GRADE := 'A';
    
    IF GRADE = 'A'
        THEN DBMS_OUTPUT.PUT_LINE('EXCELLENT');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL');
    END IF;
END;
--==>> EXCELLENT


DECLARE
    --�����
    GRADE CHAR;
BEGIN
    --�����
    GRADE := 'B';
    
    IF GRADE = 'A'
        THEN DBMS_OUTPUT.PUT_LINE('EXCELLENT');
    ELSIF GRADE = 'B'
        THEN DBMS_OUTPUT.PUT_LINE('GOOD');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('FAIL');
    END IF;
END;
--==>> GOOD

--�� CASE ��(���ǹ�)
-- CASE ~ WHEN ~ THEN ~ ELSE ~ END CASE;

-- 1. ���� �� ����
/*
CASE ����
    WHEN ��1 THEN ���๮;
    WHEN ��2 THEN ���๮;
    ELSE ���๮N+1;
END CASE;
*/




-- ����1 ����2 �Է��ϼ���
-- 1
-- �����Դϴ�.

-- ����1 ����2 �Է��ϼ���
-- 2
-- �����Դϴ�.

ACCEPT NUM PROMPT '����1 ����2 �Է��ϼ���';
DECLARE
    -- ����� �� �ֿ� ���� ����
    SEL NUMBER := &NUM;
    RESULT VARCHAR2(10) := '����';
BEGIN
    -- �׽�Ʈ
    DBMS_OUTPUT.PUT_LINE('SEL : ' || SEL);
END;
--==>> SEL : 1




ACCEPT NUM PROMPT '����1 ����2 �Է��ϼ���';
DECLARE
    -- ����� �� �ֿ� ���� ����
    SEL NUMBER := &NUM;
    RESULT VARCHAR2(10) := '����';
BEGIN
    /*
    CASE SEL
        WHEN 1
        THEN DBMS_OUTPUT.PUT_LINE('�����Դϴ�.');
        WHEN 2
        THEN DBMS_OUTPUT.PUT_LINE('�����Դϴ�.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Ȯ�κҰ�');
    END CASE;
    */
    
    CASE SEL
        WHEN 1
        THEN RESULT := '����';
        WHEN 2
        THEN RESULT := '����';
        ELSE
             RESULT := 'Ȯ�κҰ�';
    END CASE;
    
    -- ��� ���
    DBMS_OUTPUT.PUT_LINE('ó�� �����' || RESULT || '�Դϴ�.');
END;
-- 2 �Է� --==>> ó�� ����� �����Դϴ�.


--�� �ܺ� �Է� ó��
--ACCEPT ����
--ACCEPT ������ PROMPT '�޼���';
--> �ܺ� �����κ��� �Է¹��� �����͸� ���� ������ ������ ��
-- ��&�ܺκ����� ���·� �����ϰ� �ȴ�.


--�� ���� �� ���� �ܺηκ���(����ڷκ���) �Է¹޾�
--   �̵��� ���� ����� ����ϴ� PL/SQL ������ �ۼ��Ѵ�.

ACCEPT NUM1 PROMPT 'ù ��° ������ �Է����ּ���.';
ACCEPT NUM2 PROMPT '�� ��° ������ �Է����ּ���.';
DECLARE
    N1 NUMBER := &NUM1;
    N2 NUMBER := &NUM2;
    TOTAL NUMBER := 0;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('N1 : ' || N1);
    DBMS_OUTPUT.PUT_LINE('N2 : ' || N2);
    -- ���� �� ó��
    TOTAL := N1 + N2;
    -- ��� ���
    DBMS_OUTPUT.PUT_LINE(N1 || '+' || N2 || '=' || TOTAL);
END;
--==>>
/*
N1 : 23
N2 : 47
23+47=70

*/


--�� ����ڷκ��� �Է¹��� �ݾ��� ȭ�� ������ �����Ͽ� ����ϴ� ���α׷��� �ۼ��Ѵ�.
--   ��, ��ȯ �ݾ��� ���ǻ� 1õ�� �̸�, 10�� �̻� �����ϴٰ� �����Ѵ�.
/*
���� ��)
���ε� ���� �Է� ��ȭâ �� �ݾ� �Է� : 990��

�Է¹��� �ݾ� �Ѿ� : 990��
ȭ����� : ����� 1, ��� 4, ���ʿ� 1, �ʿ� 4
*/

ACCEPT MONEY PROMPT '�ݾ��� �Է����ּ���.';

DECLARE
    COIN NUMBER := &MONEY;
    C500 NUMBER := 0;
    C100 NUMBER := 0;
    C50  NUMBER := 0;
    C10  NUMBER := 0;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('�Է¹��� �ݾ� �Ѿ� : ' || COIN);
    
    C500 := TRUNC(COIN / 500);
    COIN := MOD(COIN, 500);
    
    C100 := TRUNC(COIN / 100);
    COIN := MOD(COIN, 100);
    
    C50 := TRUNC(COIN / 50);
    COIN := MOD(COIN, 50);
    
    C10 := TRUNC(COIN / 10);
    COIN := MOD(COIN, 10);
    
    
    DBMS_OUTPUT.PUT_LINE('ȭ����� : ����� ' || C500 || ' ��� ' || C100 || ' ���ʿ� ' || C50 || ' �ʿ� ' || C500);
END;
/*
�Է¹��� �ݾ� �Ѿ� : 990
ȭ����� : ����� 1 ��� 4 ���ʿ� 1 �ʿ� 1
*/


ACCEPT INPUT PROMPT '�ݾ� �Է�';
DECLARE
    MONEY NUMBER := &INPUT; -- ������ ���� �Է°��� ��Ƶ� ����
    MONEY2 NUMBER := &INPUT;          -- ��� ����� ���� �Է°��� ��Ƶ� ����
                            -- (MONEY ������ ���� �������� ���� ���ϱ� ������...)
    M500 NUMBER := 0;       -- 500�� ¥�� ������ ��Ƶ� ����
    M100 NUMBER := 0;
    M50  NUMBER := 0;
    M10  NUMBER := 0;
BEGIN
    
    -- ���� �� ó��
    --MONEY �� 500���� ������ ���� ���ϰ� �������� ������. �� 500���� ����
    M500 := TRUNC(MONEY / 500);
    --MONEY�� 500���� ������ ���� ������ �������� ���Ѵ�. �� 500���� ���� Ȯ��
    -- �� ����� �ٽ� MONEY�� ��Ƴ���.
    MONEY := MOD(MONEY, 500);
    
    M100 := TRUNC(MONEY / 100);
    MONEY := MOD(MONEY, 100);
    
    M50 := TRUNC(MONEY / 50);
    MONEY := MOD(MONEY, 50);
    
    M10 := TRUNC(MONEY / 10);
    MONEY := MOD(MONEY, 10);
    
    DBMS_OUTPUT.PUT_LINE('�Է¹��� �ݾ� �Ѿ� : ' || MONEY2);
    DBMS_OUTPUT.PUT_LINE('ȭ����� : ����� ' || M500 || ' ��� ' || M100 || ' ���ʿ� ' || M50 || ' �ʿ� ' || M10);
END;



--�� �⺻ �ݺ���
-- LOOP ~ END LOOP

-- 1. ���ǰ� ������� ������ �ݺ��ϴ� ����.

-- 2. ���� �� ����
/*
LOOP
    --���๮
    EXIT WHEN ����;   -- ������ ���� ��� �ݺ����� ����������.
END LOOP;
*/


--�� 1���� 10������ �� ���(LOOP �� Ȱ��)
DECLARE
    NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        EXIT WHEN NUM >= 10;
        NUM := NUM+1;
    END LOOP;
END;
/*
1
2
3
4
5
6
7
8
9
10
*/




--�� WHILE �ݺ���
-- WHILE LOOP ~ END LOOP;

-- 1. ���� ������ TRUE �� ���� �Ϸ��� ������ �ݺ��ϱ� ����
-- WHILE LOOP ������ ����Ѵ�.
-- ������ �ݺ��� ���۵Ǵ� ������ üũ�ϰ� �Ǿ�
-- LOOP ���� ������ �� ���� ������� ���� ��쵵 �ִ�.
-- LOOP �� ������ �� ������ FALSE �̸� �ݺ� ������ Ż���ϰ� �ȴ�.

-- 2. ���� �� ����
/*
WHILE ���� LOOP       -- ������ ���� ��� �ݺ� ����
        -- ���๮;
END LOOP;
*/

--�� 1���� 10������ �� ���(WHILE �� Ȱ��)
DECLARE
    NUM NUMBER := 1;
BEGIN
    WHILE NUM <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM+1;
    END LOOP;
END;
/*
1
2
3
4
5
6
7
8
9
10
*/


--�� FOR �ݺ���
--FOR LOOP ~ END LOOP;

-- 1. �����ۼ������� 1�� �����Ͽ�
--    ������������ �� ������ �ݺ� �����Ѵ�.

-- 2. ���� �� ����
/*
FOR ī���� IN ���ۼ� .. ������ LOOP
    --���๮;
END LOOP;
*/


--�� 1���� 10������ �� ���(FOR LOOP �� Ȱ��)
DECLARE
    N NUMBER;
BEGIN
    
    FOR N IN 1 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/*
1
2
3
4
5
6
7
8
9
10
*/

--�� ����ڷκ��� ������ ��(������)�� �Է¹޾�
--   �ش� �ܼ��� �������� ����ϴ� PL/SQL ������ �ۼ��Ѵ�.
/*
���� ��)
���ε� ���� �Է� ��ȭâ �� ���� �Է��ϼ��� : 2

2 * 1 = 2
    :
2 * 9 = 18
*/

-- 1. LOOP ��
ACCEPT INPUT PROMPT '���� �Է��ϼ���.';

DECLARE
    N NUMBER;
    N1 NUMBER;
BEGIN
    N := &INPUT;
    N1 := 1;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(N || ' * ' || N1 || ' = ' || N*N1);
        EXIT WHEN N1 > 10;
        N1 := N1+1;
    END LOOP;
END;



-- 2. WHILE LOOP��
ACCEPT INPUT PROMPT '���� �Է��ϼ���.';

DECLARE
    N NUMBER;
    N1 NUMBER;
BEGIN
    N := &INPUT;
    N1 := 1;
    
    WHILE N1 < 10 LOOP
        DBMS_OUTPUT.PUT_LINE(N || ' * ' || N1 || ' = ' || N*N1);
        N1 := N1+1;
    END LOOP;
END;


-- 3. FOR LOOP��
ACCEPT INPUT PROMPT '���� �Է��ϼ���.';

DECLARE
    N NUMBER;
    N1 NUMBER;
BEGIN
    N := &INPUT;
    N1 := 1;
    
    FOR CN IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(N || ' * ' || CN || ' = ' || N*CN);
    END LOOP;
END;


--�� ������ ��ü(2�� ~ 9��)�� ����ϴ� PL/SQL ������ �ۼ��Ѵ�.
--   ��, ���� �ݺ���(�ݺ����� ��ø) ������ Ȱ���Ѵ�.
/*
���� ��)
===[2��]===
2 * 1 = 2
2 * 2 = 4
:

===[3��]===
3 * 1 = 3
3 * 2 = 6
:
9 * 9 = 91
*/

-- FOR��
DECLARE
    DAN NUMBER;
    N NUMBER;
BEGIN
    FOR DAN IN 2 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE('==['|| DAN || '��' ||']==');
        FOR N IN 1 .. 9 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
        END LOOP;
    END LOOP;
END;



-- WHILE ��
DECLARE
    DAN NUMBER := 2;
    N NUMBER := 1;
BEGIN
    WHILE DAN < 10 LOOP
        DBMS_OUTPUT.PUT_LINE('==['|| DAN || '��' ||']==');
        
        WHILE N < 10 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
            N := N+1;
        END LOOP;
        N := 1;
        DAN := DAN+1;
    END LOOP;
END;



-- LOOP ��
DECLARE
    DAN NUMBER := 2;
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('==['|| DAN || '��' ||']==');
        LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || (DAN*N) );
            N := N+1;
            EXIT WHEN N > 10;
        END LOOP;
        N := 1;
        DAN := DAN+1;
        EXIT WHEN DAN > 10;
    END LOOP;
END;


