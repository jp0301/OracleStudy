SELECT USER
FROM DUAL;
--==>> SCOTT

-- TBL_EMP ���̺�� ��ȸ�� �ϸ� �������� ������� ��µ��� ����
-- ���� �߰��� �����͵��� ���� ���μ��� ����ȵ�
SELECT NVL(TO_CHAR(DEPTNO), '���μ�') "�μ���ȣ", SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	        8750
20	        10875
30	        9400
���μ�    	8700
���μ�	    37725
*/

SELECT NVL2(DEPTNO, TO_CHAR(DEPTNO), '���μ�') "�μ���ȣ", SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	        8750
20	        10875
30	        9400
���μ�    	8700
���μ�	    37725
*/

-- GROUPING()
SELECT GROUPING(DEPTNO) "GROUPING", DEPTNO "�μ���ȣ" , SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
---------- ---------- ----------
  GROUPING    �μ���ȣ     �޿���
---------- ---------- ----------
         0         10       8750
         0         20      10875
         0         30       9400
         0      (null)      8700
         1      (null)     37725
---------- ---------- ----------
*/


SELECT DEPTNO "�μ���ȣ" , SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	8750
20	10875
30	9400
	8700
	37725
*/

--�� ������ ��ȸ�� �ش� ������
/*
10	      8750
20	     10875
30	      9400
����	  8700
���μ� 37725
*/
-- �̿� ���� ��ȸ�ǵ��� �������� �����Ѵ�.

--�� ���� ���� �׷��� ���� ����
SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '����') 
            ELSE '���μ�'
       END "�μ���ȣ"
,      SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	      8750
20	     10875
30	      9400
����	  8700
���μ�	 37725
*/

--�� ���� Ǯ��
-- 1. THEN DEPTNO�� ������ �������̱� ������ �� ���� �߻�
-- 2. ���� DEPTNO�� ����Ÿ������ �ٲ��ش�. �� �μ���ȣ�� ���� ���, NULL ����
-- 3. NULL �� ó��, NVL(TO_CHAR(DEPTNO), '����')
-- 4. �ذ�





--����������������������������������������

--�� TBL_SAWON ���̺��� �������
--   ������ ���� ��ȸ�� �� �ֵ��� �������� �����Ѵ�.
/*
----------------- ---------------------
 ����              �޿���
----------------- ---------------------
 ��                  xxxx
 ��                 xxxxx
 �����          xxxxxx
----------------- ---------------------
*/

-- 1�ܰ�
SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '��'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '��'
            ELSE '����'
       END "����"
    
    , SAL "�޿�"
FROM TBL_SAWON;


-- 2�ܰ� 
SELECT T.���� "����"
     , SUM(T.�޿�) "�޿���"
FROM
(   
    SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '��'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '��'
                ELSE '����Ȯ�κҰ�'
           END "����"
        
        , SAL "�޿�"
    FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.����);
    

-- 3�ܰ� 
SELECT NVL(T.����, '�����') "����"
       -- CASE GROUPING(T.����) WHEN 0 THEN T.���� ELSE '�����' END "����"
     , SUM(T.�޿�) "�޿���"
FROM
(   
    SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '��'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '��'
                ELSE '����Ȯ�κҰ�'
           END "����"
        
        , SAL "�޿�"
    FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.����);
--==>>
/*
����        �޿���
---------- ---------
��	        11000
��	        31800
�����    	42800
*/
--����������������������������������������

--����������������������������������������
--�� TBL_SAWON ���̺��� �������
--   ������ ���� ��ȸ�� �� �ֵ��� �������� �����Ѵ�.
/*
--------- ------------
���ɴ�    �ο���
--------- ------------
10            ��
20            ��
30            ��
50            ��
��ü          16
--------- ------------
*/

SELECT *
FROM TBL_SAWON;


-- ��� 1. �� INLINE VIEW �� �� �� ��ø
SELECT NVL(TO_CHAR(T2.���ɴ�), '��ü') "���ɴ�"
-- CASE GROUPING(T2.���ɴ�) WHEN 0 THEN TO_CHAR(T2.���ɴ�) ELSE '��ü'
, COUNT(*) "�ο���"
FROM
(
    SELECT 
        --���ɴ�
        CASE WHEN T1.���� >=50 THEN 50
             WHEN T1.���� >=40 THEN 40
             WHEN T1.���� >=30 THEN 30
             WHEN T1.���� >=20 THEN 20
             WHEN T1.���� >=10 THEN 10
             ELSE 0
        END "���ɴ�"
        
    FROM
    (
        --����
        SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) +1899) 
                    WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) +1999) 
                    ELSE -1
               END "����"
        FROM TBL_SAWON
    ) T1
) T2
GROUP BY ROLLUP(T2.���ɴ�);



-- ��� 2. �� INLINE VIEW �� �� �� ���
SELECT
  CASE WHEN T.���ɴ� IS NULL THEN '��ü'
       ELSE TO_CHAR(T.���ɴ�)
  END "���ɴ�"
, COUNT(*) "�ο���"

FROM
(
    SELECT
        TRUNC(CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
             THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
             WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
             THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
             ELSE 0
             END, -1) "���ɴ�"
    FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.���ɴ�);
--����������������������������������������



SELECT DEPTNO
, JOB "����"
, SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO,JOB)
ORDER BY 1, 2;
/*
10	CLERK	     1300
10	MANAGER	     2450
10	PRESIDENT	 5000
10		         8750
20	ANALYST	     6000
20	CLERK	     1900
20	MANAGER	     2975
20		        10875
30	CLERK	     950
30	MANAGER	     2850
30	SALESMAN	     5600
30		         9400
                29025
*/


--�� CUBE() �� ROLLUP() ���� �� �ڼ��� ����� ��ȯ�޴´�.
SELECT DEPTNO
, JOB "����"
, SUM(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO,JOB)
ORDER BY 1, 2;
/*
10	CLERK	    1300
10	MANAGER	    2450
10	PRESIDENT	5000
10		        8750
20	ANALYST	    6000
20	CLERK	    1900
20	MANAGER	    2975
20		        10875
30	CLERK	    950
30	MANAGER	    2850
30	SALESMAN	    5600
30		        9400
	ANALYST	    6000 -- ��� �μ� ANALYST ������ �޿��� --�߰�
	CLERK	    4150 -- ...
	MANAGER	    8275 -- ...
	PRESIDENT	5000
	SALESMAN	    5600
                29025
*/

--�� ROLLUP()�� CUBE()��
--   �׷��� �����ִ� ����� �ٸ���. (����)

-- ex.

-- ROLLUP(A, B, C)
-- �� (A, B, C) / (A, B) / (A) / ()

-- CUBE(A, B, C)
-- �� (A,B,C) / (A,B) / (A,C) / (B,C) / (A) / (B) / (C) / ()

--==>> ���� ������(ROLLUP)) ���� ����� �ټ� ���ڶ� ���� �ְ�
--     �Ʒ� ������(CUBE()) ���� ����� �ټ� ����ĥ ���� �ֱ� ������
--     ������ ���� ����� ������ �� ���� ����ϰ� �ȴ�.
--     ���� �ۼ��ϴ� ������ ��ȸ�ϰ��� �ϴ� �׷츸
--     GROUPING SETS �� �̿��Ͽ� �����ִ� ����̴�.


SELECT *
FROM TBL_EMP;

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '����')
                             ELSE '��ü�μ�'                      
       END "�μ���ȣ"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '��ü����' 
         END "����"
       , SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY 1, 2;
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        ��ü����	    8750

20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        ��ü����	    10875

30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	    5600
30	        ��ü����	    9400

����	    CLERK	    3500
����	    SALESMAN	    5200
����	    ��ü����	    8700

��ü�μ�	    ��ü����	    37725
*/

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '����')
                             ELSE '��ü�μ�'                      
       END "�μ���ȣ"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '��ü����' 
         END "����"
       , SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY 1, 2;
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        ��ü����	    8750

20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        ��ü����	    10875

30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	    5600
30	        ��ü����	    9400

����	    CLERK	    3500
����	    SALESMAN    	5200
����	    ��ü����	    8700

��ü�μ�	    ANALYST	    6000
��ü�μ�    	CLERK	    7650
��ü�μ�    	MANAGER	    8275
��ü�μ�	    PRESIDENT	5000
��ü�μ�	    SALESMAN	    10800

��ü�μ�	    ��ü����	    37725
*/

--�� GROUPING SETS
-- GROUPING SETS �� Ŀ���͸���¡�ϴ� ���̶�� �����ϸ��
SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '����')
                             ELSE '��ü�μ�'                      
       END "�μ���ȣ"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '��ü����' 
         END "����"
       , SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY GROUPING SETS((DEPTNO, JOB), (DEPTNO), (JOB), ())
ORDER BY 1, 2;
-- GROUP BY GROUPING SETS((DEPTNO, JOB), (DEPTNO), (JOB), ())
-- �̷��� �Ǹ� CUBE()�� ����� ����� ���� ��ȸ ��� ��ȯ

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '����')
                             ELSE '��ü�μ�'                      
       END "�μ���ȣ"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '��ü����' 
         END "����"
       , SUM(SAL) "�޿���"
FROM TBL_EMP
GROUP BY GROUPING SETS((DEPTNO, JOB), (DEPTNO), ())
ORDER BY 1, 2;
-- ROLLUP() �� ����� ����� ���� ��ȸ ��� ��ȯ


--------------------------------------------------------------------------------

SELECT *
FROM TBL_EMP
ORDER BY HIREDATE;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session��(��) ����Ǿ����ϴ�.

SELECT *
FROM TBL_EMP
ORDER BY HIREDATE;


--�� TBL_EMP ���̺��� �������
--   �Ի�⵵�� �ο����� ��ȸ�Ѵ�.

SELECT T.�Ի�⵵
,      COUNT(*) "�ο���"
FROM
(
    SELECT EXTRACT(YEAR FROM HIREDATE) "�Ի�⵵"
    FROM TBL_EMP
) T
GROUP BY T.�Ի�⵵
ORDER BY T.�Ի�⵵;


SELECT EXTRACT(YEAR FROM HIREDATE) "�Ի�⵵"
, COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY EXTRACT(YEAR FROM HIREDATE)
ORDER BY 1;
--==>>
/*
1980	    1
1981	10
1982	    1
1987	2
2022    	5
*/

SELECT EXTRACT(YEAR FROM HIREDATE) "�Ի�⵵"
, COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY ROLLUP(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;

SELECT TO_CHAR(HIREDATE, 'YYYY') "�Ի�⵵"
, COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY EXTRACT(YEAR FROM HIREDATE)
ORDER BY 1;
--==>> ORA-00979: not a GROUP BY expression

SELECT TO_CHAR(HIREDATE, 'YYYY') "�Ի�⵵"
, COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY ROLLUP(TO_CHAR(HIREDATE, 'YYYY'))
ORDER BY 1;




SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 
            THEN EXTRACT(YEAR FROM HIREDATE)
            ELSE '��ü'
       END "�Ի�⵵"
    , COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>> ���� �߻� ORA-00932: inconsistent datatypes: expected NUMBER got CHAR


SELECT CASE GROUPING(TO_CHAR(HIREDATE, 'YYYY')) WHEN 0 
            THEN EXTRACT(YEAR FROM HIREDATE)
            ELSE '��ü'
       END "�Ի�⵵"
    , COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;


SELECT CASE GROUPING(TO_CHAR(HIREDATE, 'YYYY')) WHEN 0 
            THEN TO_CHAR(HIREDATE, 'YYYY')
            ELSE '��ü'
       END "�Ի�⵵"
    , COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>> ���� �߻� ORA-00979: not a GROUP BY expression



SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 
            THEN TO_CHAR(HIREDATE, 'YYYY')
            ELSE '��ü'
       END "�Ի�⵵"
    , COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>> ���� �߻� ORA-00979: not a GROUP BY expression


SELECT CASE GROUPING(TO_CHAR(HIREDATE, 'YYYY')) WHEN 0 
            THEN TO_CHAR(HIREDATE, 'YYYY')
            ELSE '��ü'
       END "�Ի�⵵"
    , COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY CUBE(TO_CHAR(HIREDATE, 'YYYY'))
ORDER BY 1;
/*
1980	    1
1981	10
1982	    1
1987	2
2022	    5
��ü	    19
*/

SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 
            THEN EXTRACT(YEAR FROM HIREDATE)
            ELSE -1
       END "�Ի�⵵"
    , COUNT(*) "�ο���"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;

--------------------------------------------------------------------------------

--���� HAVING ����--

--�� EMP���̺��� �μ� ��ȣ�� 20, 30�� �μ��� �������
--   �μ��� �� �޿��� 10000 ���� ���� ��츸 �μ��� �� �޿��� ��ȸ�Ѵ�.


SELECT *
FROM EMP;


SELECT DEPTNO, SUM(SAL)
FROM EMP
WHERE DEPTNO IN (20, 30) -- OR
AND SUM(SAL) < 10000
GROUP BY DEPTNO;
--==>> ���� �߻� ORA-00934: group function is not allowed here


SELECT DEPTNO, SUM(SAL) "�μ������հ�"
FROM EMP
WHERE DEPTNO IN (20, 30) -- OR
GROUP BY DEPTNO
HAVING SUM(SAL) < 10000;
--==>> 30    9400


SELECT DEPTNO, SUM(SAL) "�μ������հ�"
FROM EMP
GROUP BY DEPTNO
HAVING SUM(SAL) < 10000
   AND DEPTNO IN (20, 30);
-- �������� ������
-- ������ WHERE �� ������ �� �ٶ����� �����̴�.

--------------------------------------------------------------------------------

--���� ��ø �׷��Լ� / �м��Լ� ����--

-- �׷� �Լ��� 2 LEVEL ���� ��ø�ؼ� ����� �� �ִ�.

SELECT SUM(SAL)
FROM EMP
GROUP BY DEPTNO;
--==>>
/*
9400
10875
8750
*/

SELECT MAX(SUM(SAL))
FROM EMP
GROUP BY DEPTNO;
--==>> 10875

-- RANK() / DENSE_RANK()
--> ORACLE 9i ���� ����.... MSSQL 2005 ���� ����...

--> ���� ���������� RANK() �� DENSE_RANK() �� ����� �� ���� ������
--  ���� ���... �޿� ������ ���ϰ��� �Ѵٸ�...
--  �ش� ����� �޿����� �� ū ���� �� ������ Ȯ���� ��
--  Ȯ���� ���ڿ� +1�� �߰� �������ָ�...
--  �� ���� �� �ش� ����� ����� �ȴ�.

SELECT ENAME, SAL
FROM EMP;


SELECT COUNT(*) + 1
FROM EMP
WHERE SAL > 800;    -- SMITH�� �޿�
--==>> 14           -- SMITH�� �޿� ���


SELECT COUNT(*) + 1
FROM EMP
WHERE SAL > 1600;    -- SMITH�� �޿�
--==>> 8


--�� ���� ��� ����(��� ���� ����)
--   ���� ������ �ִ� ���̺��� �÷���
--   ���� ������ ������(WHERE ��, HAVING ��)�� ���Ǵ� ���
--   �츮�� �� �������� ���� ��� ����(��� ���� ����)��� �θ���.

SELECT ENAME "�����" , SAL "�޿�", 1 "�޿����"
FROM EMP;



SELECT ENAME "�����" , SAL "�޿�", (1) "�޿����"
FROM EMP;

SELECT ENAME "�����" , SAL "�޿�" 
, (SELECT COUNT(*) + 1
   FROM EMP
   WHERE SAL > 800) "�޿����"
FROM EMP;


SELECT E.ENAME "�����" , E.SAL "�޿�" 
, (SELECT COUNT(*) + 1
   FROM EMP
   WHERE SAL > E.SAL) "�޿����"
FROM EMP E;
--==>>
/*
SMITH	 800    	14
ALLEN	1600	     7
WARD	    1250    	10
JONES	2975	     4
MARTIN	1250	    10
BLAKE	2850	     5
CLARK	2450	     6
SCOTT	3000	     2
KING	    5000    	 1
TURNER	1500	     8
ADAMS	1100	    12
JAMES	 950	    13
FORD	    3000    	 2
MILLER	1300    	 9
*/


--�� EMP ���̺��� �������
--   �����, �޿�, �μ���ȣ, �μ����޿����, ��ü�޿���� �׸��� ��ȸ�Ѵ�.
--   ��, RANK() �Լ��� ������� �ʰ� ������������ Ȱ���� �� �ֵ��� �Ѵ�.


SELECT E.ENAME "�����", E.DEPTNO "�μ���ȣ", E.SAL "�޿�"

,( SELECT COUNT(*) + 1
   FROM EMP
   WHERE SAL > E.SAL AND DEPTNO = E.DEPTNO
 ) "�μ����޿����"

,(SELECT COUNT(*) + 1
  FROM EMP
  WHERE SAL > E.SAL) "��ü�޿����"

FROM EMP E


ORDER BY DEPTNO, SAL DESC;
/*
����� �μ���ȣ �޿� �μ����޿���� ��ü�޿����
KING	    10	    5000	    1	        1
CLARK	10	    2450	    2	        6
MILLER	10	    1300	    3	        9
SCOTT	20	    3000	    1	        2
FORD	    20	    3000	    1	        2
JONES	20	    2975	    3	        4
ADAMS	20	    1100	    4	        12
SMITH	20	    800	    5	        14
BLAKE	30	    2850	    1	        5
ALLEN	30	    1600	    2	        7
TURNER	30	    1500	    3	        8
MARTIN	30	    1250	    4	        10
WARD	    30	    1250	    4	        10
JAMES	30	    950	    6	        13
*/



--�� EMP ���̺��� ������� ������ ���� ��ȸ�� �� �ֵ��� �������� �����Ѵ�.
/*
                                            -�� �μ� ������ �Ի����ں��� ������ �޿��� ��
--------------------------------------------------------------------------
 ����� �μ���ȣ      �Ի���        �޿�    �μ����Ի纰�޿�����
--------------------------------------------------------------------------
 SMITH	   20	    1980-12-17	     800		    800
 JONES	   20       1981-04-02	     2975		3775
 FORD      20       1981-12-03     	3000	     	6775
 SCOTT	   20     	1987-07-13	    3000		    9775
 ADAMS	   20        1987-07-13	    1100		    10875

*/

SELECT
ENAME "�����"
, DEPTNO "�μ���ȣ"
, HIREDATE "�Ի���"
, SAL "�޿�"
, (
SELECT SUM(SAL)
FROM EMP
WHERE DEPTNO = E.DEPTNO
AND HIREDATE <= E.HIREDATE

) "�μ����Ի纰�޿�����"
FROM EMP E
ORDER BY DEPTNO, HIREDATE;



SELECT E1.ENAME "�����", E1.DEPTNO "�μ���ȣ", E1.HIREDATE "�Ի���", E1.SAL "�޿�"
     , (
     
     SELECT SUM(E2.SAL)
     FROM EMP E2
     WHERE E2.DEPTNO = E1.DEPTNO
     
     ) "�μ����Ի纰�޿�����"
FROM SCOTT.EMP E1
ORDER BY 2, 3;




SELECT E1.ENAME "�����", E1.DEPTNO "�μ���ȣ", E1.HIREDATE "�Ի���", E1.SAL "�޿�"
     , (
     
     SELECT SUM(E2.SAL)
     FROM EMP E2
     WHERE E2.DEPTNO = E1.DEPTNO
       AND E2.HIREDATE <= E1.HIREDATE
     ) "�μ����Ի纰�޿�����"
FROM SCOTT.EMP E1
ORDER BY 2, 3;
--==>>
/*
CLARK	10	1981-06-09	2450	    2450
KING	    10	1981-11-17	5000	    7450
MILLER	10	1982-01-23	1300	    8750
SMITH	20	1980-12-17	800	    800
JONES	20	1981-04-02	2975	    3775
FORD	    20	1981-12-03	3000    	6775
SCOTT	20	1987-07-13	3000    	10875
ADAMS	20	1987-07-13	1100    	10875
ALLEN	30	1981-02-20	1600	    1600
WARD    	30	1981-02-22	1250	    2850
BLAKE	30	1981-05-01	2850	    5700
TURNER	30	1981-09-08	1500	    7200
MARTIN	30	1981-09-28	1250	    8450
JAMES	30	1981-12-03	950	    9400
*/



--�� EMP ���̺��� �������
--   �Ի��� ����� ���� ���� ������ ����
--  �Ի����� �ο����� ��ȸ�� �� �ֵ��� �������� �����Ѵ�.
/*
---------- -------------------
 �Ի���   �ο���
---------- -------------------
 1981-02      2
 1981-09      2
 1987-07      2
---------- -------------------
*/


SELECT *
FROM EMP;

SELECT T.�Ի��� "�Ի���", COUNT(*) "�ο���"
FROM 
(
    SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "�Ի���"
    FROM EMP
) T
GROUP BY T.�Ի���
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM EMP GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM'));
--==>>
/*
1981-12	2
1981-09	2
1981-02	2
1987-07	2
*/


SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "�Ի���"
, COUNT(*) "�ο���"
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM EMP GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM'));
--COUNT(*) = (�Ի��� ���� �ִ� �ο�);



