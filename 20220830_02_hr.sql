SELECT USER
FROM DUAL;
--==>> HR


--�� EMPLOYEES ���̺��� ������ SALARY �� 10% �λ��Ѵ�.
--   ��, �μ����� 'IT'�� �����鸸 �����Ѵ�.
-- ( ���濡 ���� ��� Ȯ�� �� ROLLBACK �����Ѵ�.)

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME ='IT');
                       
                       
UPDATE EMPLOYEES
SET SALARY = SALARY * 1.1
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME ='IT');
--==>> 5�� �� ��(��) ������Ʈ�Ǿ����ϴ�.

-- Ȯ��
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 60;
/* -- �ѹ��߱� ������ ���� �� ��ȸ
103	Alexander	Hunold	    AHUNOLD	    590.423.4567	2006-01-03	IT_PROG	9000		102	60
104	Bruce	    Ernst	    BERNST	    590.423.4568	2007-05-21	IT_PROG	6000		103	60
105	David	    Austin	    DAUSTIN	    590.423.4569	2005-06-25	IT_PROG	4800		103	60
106	Valli	    Pataballa	VPATABAL	590.423.4560	2006-02-05	IT_PROG	4800		103	60
107	Diana	    Lorentz	    DLORENTZ	590.423.5567	2007-02-07	IT_PROG	4200		103	60
*/

-- ������Ʈ �� ���  ROLLBACK;
ROLLBACK;
--==>> �ѹ� �Ϸ�.



--�� EMPLOYEES ���̺��� JOBS_TITLE �� Sales Manager �� �������
--   SALARY �� �ش� ����(����)�� �ְ�޿�(MAX_SALARY)�� �����Ѵ�.
--   ��, �Ի����� 2006�� ����(�ش� �⵵ ����) �Ի��ڿ� ���� ������ �� �ֵ��� ó���Ѵ�.
--   (���濡 ���� ��� Ȯ�� �� ROLLBACK �����Ѵ�.)

SELECT *
FROM EMPLOYEES;


SELECT MAX_SALARY
FROM JOBS
WHERE JOB_TITLE = 'Sales Manager';
--==>> 20080

SELECT JOB_ID
FROM JOBS
WHERE JOB_TITLE = 'Sales Manager';
--==>> SA_MAN



--Ȯ�� (���� ��)
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE = 'Sales Manager')
  AND HIRE_DATE < TO_DATE('2006-01-01', 'YYYY-MM-DD');
/*
145	John	Russell	    JRUSSEL	    011.44.1344.429268	2004-10-01	SA_MAN	14000	0.4	100	80
146	Karen	Partners	KPARTNER	011.44.1344.467268	2005-01-05	SA_MAN	13500	0.3	100	80
147	Alberto	Errazuriz	AERRAZUR	011.44.1344.429278	2005-03-10	SA_MAN	12000	0.3	100	80
*/


UPDATE EMPLOYEES 
SET SALARY = (SELECT MAX_SALARY
              FROM JOBS
              WHERE JOB_TITLE = 'Sales Manager')
WHERE JOB_ID = (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE = 'Sales Manager')
  AND HIRE_DATE < TO_DATE('2006-01-01', 'YYYY-MM-DD');


--Ȯ�� (���� ��)
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE = 'Sales Manager')
  AND HIRE_DATE < TO_DATE('2006-01-01', 'YYYY-MM-DD');
/*
145	John	Russell	    JRUSSEL	    011.44.1344.429268	2004-10-01	SA_MAN	14000	0.4	100	80
146	Karen	Partners	KPARTNER	011.44.1344.467268	2005-01-05	SA_MAN	14000	0.3	100	80
147	Alberto	Errazuriz	AERRAZUR	011.44.1344.429278	2005-03-10	SA_MAN	14000	0.3	100	80
*/


-- ������Ʈ �� ���  ROLLBACK;
ROLLBACK;
--==>> �ѹ� �Ϸ�.



SELECT *
FROM DEPARTMENTS;

SELECT *
FROM EMPLOYEES;

--�� EMPLOYEES ���̺��� SALARY ��
--   �� �μ��� �̸����� �ٸ� �λ���� �����Ͽ� ������ �� �ֵ��� �Ѵ�.
--   Finance -> 10% �λ�
--   Executive -> 15% �λ�
--   Accounting -> 20% �λ�
--   (���濡 ���� ��� Ȯ�� �� Rollback)

-- ���� ��
SELECT SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (90, 100, 110);
/*
24000
17000
17000
12008
9000
8200
7700
7800
6900
12008
8300
*/

UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID
                  WHEN (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME ='Finance')
                  THEN SALARY * 1.1
                  WHEN (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME ='Executive')
                  THEN SALARY * 1.15
                  WHEN (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME ='Accounting')
                  THEN SALARY * 1.2
                  ELSE SALARY
                  END
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME IN ('Finance', 'Executive', 'Accounting'));
--==>>  11�� �� ��(��) ������Ʈ�Ǿ����ϴ�.


-- ���� ��
SELECT SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (90, 100, 110);
/*
27600
19550
19550
13208.8
9900
9020
8470
8580
7590
14409.6
9960
*/

-- ������Ʈ �� ���  ROLLBACK;
ROLLBACK;
--==>> �ѹ� �Ϸ�.


--------------------------------------------------------------------------------
--���� DELETE ����--

-- 1. ���̺��� ������ ��(���ڵ�)�� �����ϴ� �� ����ϴ� ����

-- 2. ���� �� ����
-- DELETE [FROM] ���̺��
-- [WHERE ������];

-- ���̺� ����(������ ����)
CREATE TABLE TBL_EMPLOYEES
AS
SELECT *
FROM EMPLOYEES;
--==>> Table TBL_EMPLOYEES��(��) �����Ǿ����ϴ�.

SELECT *
FROM TBL_EMPLOYEES
WHERE EMPLOYEE_ID = 198;


ROLLBACK;

--�� EMPLOYEES ���̺��� �������� �����͸� �����Ѵ�.
--   ��, �μ����� 'IT'�� ���� �����Ѵ�.

-- �� �����δ� EMPLOYEES ���̺��� �����Ͱ� (�����ϰ��� �ϴ� ��� ������)
--    �ٸ� ���ڵ忡 ���� �������ϰ� �ִ� ���
--    �������� ���� �� �ִٴ� ����� �����ؾ� �ϸ�...
--    �׿� ���� ������ �˾ƾ� �Ѵ�.


SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME='IT';

SELECT FIRST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ( SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME='IT' );
--==>>
/*
Alexander	60
Bruce	    60
David	    60
Valli	    60
Diana	    60
*/

DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ( SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME='IT' );
/*
���� ���� -
ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found  

DEPARTMENTS ���̺��� MANAGER_ID �� �����ϰ� �ֱ� �����̴�.
*/                      

SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME='DEPARTMENTS';
/*
HR	DEPT_NAME_NN	DEPARTMENTS	C	DEPARTMENT_NAME	"DEPARTMENT_NAME" IS NOT NULL	
HR	DEPT_ID_PK	    DEPARTMENTS	P	DEPARTMENT_ID		
HR	DEPT_LOC_FK	    DEPARTMENTS	R	LOCATION_ID		NO ACTION
HR	DEPT_MGR_FK	    DEPARTMENTS	R	MANAGER_ID		NO ACTION
*/          



------------------------------------------------------------------------------------

--���� ��(VIEW) ����--

-- 1. ��(VIEW)�� �̹� Ư���� �����ͺ��̽� ���� �����ϴ�
--    �ϳ� �̻��� ���̺��� ����ڰ� ��� ���ϴ� �����͵鸸��
--    ��Ȯ�ϰ� ���ϰ� �������� ���Ͽ� ������ ���ϴ� �÷��鸸�� ��Ƽ�
--    �������� ������ ���̺�� ���Ǽ� �� ���ȿ� ������ �ִ�.

--    ������ ���̺��̶�... �䰡 ������ �����ϴ� ���̺�(��ü)�� �ƴ϶�
--    �ϳ� �̻��� ���̺��� �Ļ��� �� �ٸ� ������ �� �� �ִ� ����̸�
--    �� ������ �����س��� SQL �����̶�� �� �� �ִ�.

-- 2. ���� �� ����
-- CREATE [OR REPLACE] VIEW ���̸�
-- [(ALIAS[, ALIAS, ...])]
-- AS
-- ��������(SUBQUERY)
-- [WITH CHECK OPTION]
-- [WITH READ ONLY]


--�� ��(VIEW) ����
CREATE OR REPLACE VIEW VIEW_EMPLOYEES
AS
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
, C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID;
--==>> View VIEW_EMPLOYEES��(��) �����Ǿ����ϴ�.


SELECT *
FROM VIEW_EMPLOYEES;
--==>>
/*
...
*/


--�� ��(VIEW)�� ���� ��ȸ
DESC VIEW_EMPLOYEES;
--==>>
/*
�̸�              ��?       ����           
--------------- -------- ------------ 
FIRST_NAME               VARCHAR2(20) 
LAST_NAME       NOT NULL VARCHAR2(25) 
DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
CITY            NOT NULL VARCHAR2(30) 
COUNTRY_NAME             VARCHAR2(40) 
REGION_NAME              VARCHAR2(25) 
*/



--�� ��(VIEW) �ҽ� Ȯ�� -- CHECK~!!!
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS
WHERE VIEW_NAME = 'VIEW_EMPLOYEES';
--==>>
-- TEXT
/*
"SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
      , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID"
*/



