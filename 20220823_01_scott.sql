SELECT USER
FROM DUAL;
--==>> SCOTT


-- (20220822_03_scott.sql ���� �ð� �̾ ����)

--�� UNION �� �׻� ������� ù ��° �÷��� ��������
--   �������� ������ �����Ѵ�.
--   �ݸ�, UNION ALL �� ���յ� ����(�������� ���̺��� ����� ����)���
--   ��ȸ�� ����� �ִ� �״�� ��ȯ�Ѵ�.
--   �̷� ���� UNION �� ���ϰ� �� ũ��. (���ҽ� �Ҹ� �� ũ��.)
--   ����, UNION�� ������� �ߺ��� ���ڵ�(��)�� ������ ���
--   �ߺ��� �����ϰ� 1�� �ุ ��ȸ�� ����� ��ȯ�ϰ� �ȴ�.

--�� ���ݱ��� �ֹ����� �����͸� ����
--   ��ǰ �� �� �ֹ����� ��ȸ�� �� �ִ� �������� �����Ѵ�.

-- ��� ��
SELECT J.JECODE "��ǰ�ڵ�", SUM(J.JUSU) "���ֹ���"
FROM
(
    SELECT *
    FROM TBL_JUMUN
    UNION ALL
    SELECT *
    FROM TBL_JUMUNBACKUP
) J
GROUP BY J.JECODE;


--��INTERSECT / MINUS (�����հ� ������)

-- TBL_JUMUNBACKUP ���̺�� TBL_JUMUN ���̺���
-- ��ǰ�ڵ�� �ֹ������� ���� �Ȱ��� �ุ �����ϰ��� �Ѵ�.

SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
MINUS
SELECT JECODE, JUSU
FROM TBL_JUMUN;


SELECT JECODE, JUSU
FROM TBL_JUMUNBACKUP
INTERSECT
SELECT JECODE, JUSU
FROM TBL_JUMUN;
/*
���ڱ�	20
������	30
������	10
Ȩ����	10
*/


--�� TBL_JUMUNBACKUP ���̺�� TBL_JUMUN ���̺��� �������
-- ��ǰ�ڵ�� �ֹ����� ���� �Ȱ��� ���� ������
-- �ֹ���ȣ, ��ǰ�ڵ�,  �ֹ���, �ֹ����� �׸����� ��ȸ�Ѵ�.


-- ��� 1.
SELECT T2.JUNO "�ֹ���ȣ", T1.JECODE "��ǰ�ڵ�", T1.JUSU "�ֹ�����", T2.JUDAY "�ֹ�����"
FROM
(
    SELECT JECODE, JUSU
    FROM TBL_JUMUNBACKUP
    INTERSECT
    SELECT JECODE, JUSU
    FROM TBL_JUMUN
) T1
JOIN
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T2
ON T1.JECODE = T2.JECODE
AND T1.JUSU = T2.JUSU;





-- ��� 2.
SELECT T.JUNO "�ֹ���ȣ", T.JECODE "��ǰ�ڵ�", T.JUSU "�ֹ���", T.JUDAY "�ֹ�����"
FROM
(
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUNBACKUP
    UNION ALL
    SELECT JUNO, JECODE, JUSU, JUDAY
    FROM TBL_JUMUN
) T
/*
WHERE T.JECODE || T.JUSU = ANY (
    SELECT JECODE || JUSU
    FROM TBL_JUMUNBACKUP
    INTERSECT
    SELECT JECODE || JUSU
    FROM TBL_JUMUN
);
*/
WHERE CONCAT(T.JECODE, T.JUSU) IN (
    SELECT CONCAT(JECODE, JUSU)
    FROM TBL_JUMUNBACKUP
    INTERSECT
    SELECT CONCAT(JECODE, JUSU)
    FROM TBL_JUMUN
);

--------------------------------------------------------------------------------

SELECT D.DEPTNO, D.DNAME, E.ENAME, E.SAL
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E JOIN DEPT D;
--==>> ���� �߻� ORA-00905: missing keyword

SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E NATURAL JOIN DEPT D;
--==>>
/*
10	ACCOUNTING	CLARK	2450
10	ACCOUNTING	KING    	5000
10	ACCOUNTING	MILLER	1300
20	RESEARCH    	JONES	2975
20	RESEARCH	    FORD	    3000
20	RESEARCH    	ADAMS	1100
20	RESEARCH	    SMITH	800
20	RESEARCH	    SCOTT	3000
30	SALES	    WARD	    1250
30	SALES	    TURNER	1500
30	SALES	    ALLEN	1600
30	SALES	    JAMES	950
30	SALES	    BLAKE	2850
30	SALES	    MARTIN	1250
*/

-- (==)
SELECT DEPTNO, DNAME, ENAME, SAL
FROM EMP E JOIN DEPT D
USING(DEPTNO);

--------------------------------------------------------------------------------

--�� TBL_EMP ���̺��� �޿��� ���� ���� �����
--   �����ȣ, �����, ������, �޿� �׸��� ��ȸ�ϴ� �������� �����Ѵ�.

SELECT *
FROM TBL_EMP;

SELECT EMPNO "�����ȣ", ENAME "�����", JOB "������", SAL "�޿�"
FROM TBL_EMP
WHERE SAL = (SELECT MAX(SAL) FROM TBL_EMP);


-- �޿��� ���� ���� �޴� ����� �޿�
SELECT MAX(SAL)
FROM TBL_EMP;
--==>> 5000

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE �޿��� ���� ���� �޴� ���;

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL = �޿��� ���� ���� �޴� ���;

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL = (SELECT MAX(SAL) FROM TBL_EMP;);


--��=ANY��

--��=ALL��

SELECT SAL
FROM TBL_EMP;


SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL = ANY( SELECT SAL
                FROM TBL_EMP );

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >= ANY( SELECT SAL
                FROM TBL_EMP );

--==>> �� ������ �Ȱ��� ����� ���´�.

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE SAL >= ALL ( SELECT SAL
                FROM TBL_EMP );
--==>> 7839	KING	PRESIDENT	5000
-- MAX �������ʰ� �ִ� ���� ��Ÿ�� �� ����



--�� TBL_EMP ���̺��� 20�� �μ��� �ٹ��ϴ� ����� ��
--   �޿��� ���� ���� �����
--   �����ȣ, �����, ������, �޿� �׸��� ��ȸ�ϴ� �������� �����Ѵ�.
SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE DEPTNO = 20
  AND SAL =(SELECT MAX(SAL) FROM TBL_EMP WHERE DEPTNO=20);


SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE DEPTNO = 20
  AND SAL >= ALL (SELECT SAL FROM TBL_EMP WHERE DEPTNO=20);
--==>>
/*
7902	FORD	ANALYST	3000
7788	SCOTT	ANALYST	3000
*/


--�� TBL_EMP ���̺��� ����(Ŀ�̼�, COMM)�� ���� ���� �����
--   �����ȣ, �����, �μ���ȣ, ������, Ŀ�̼� �׸��� ��ȸ�Ѵ�.

SELECT *
FROM TBL_EMP;

SELECT MAX(COMM)
FROM TBL_EMP;

SELECT EMPNO "�����ȣ", ENAME "�����", DEPTNO "�μ���ȣ", JOB "������", COMM "����"
FROM TBL_EMP
WHERE COMM = (SELECT MAX(COMM) FROM TBL_EMP);
--==>> 7654	MARTIN	30	SALESMAN	    1400

SELECT EMPNO, ENAME, DEPTNO, JOB, COMM
FROM TBL_EMP
WHERE COMM >=ALL(SELECT COMM FROM TBL_EMP);
--==>> ��ȸ ��� ����

SELECT EMPNO, ENAME, DEPTNO, JOB, COMM
FROM TBL_EMP
WHERE COMM >=ALL(SELECT COMM FROM TBL_EMP);
--==>> NULL �� ���� ����� ó����������

SELECT EMPNO, ENAME, DEPTNO, JOB, COMM
FROM TBL_EMP
WHERE COMM >=ALL(SELECT NVL(COMM,0) FROM TBL_EMP);
--==>> 7654	MARTIN	30	SALESMAN	    1400

SELECT EMPNO, ENAME, DEPTNO, JOB, COMM
FROM TBL_EMP
WHERE COMM >=ALL(SELECT COMM FROM TBL_EMP WHERE COMM IS NOT NULL);
--==>> 7654	MARTIN	30	SALESMAN	    1400


--�� DISTINCT() �ߺ� ��(���ڵ�)�� �����ϴ� �Լ�

-- TBL_EMP ���̺��� �����ڷ� ��ϵ� �����
-- �����ȣ, �����, �������� ��ȸ�Ѵ�.

SELECT *
FROM TBL_EMP;

SELECT EMPNO "�����ȣ", ENAME "�����", JOB "������"
FROM TBL_EMP
WHERE EMPNO =ANY(SELECT MGR FROM TBL_EMP);

SELECT DISTINCT(MGR)
FROM TBL_EMP;
--==>>
/*
7839
NULL
7782
7698
7902
7566
7788
*/

SELECT EMPNO "�����ȣ", ENAME "�����", JOB "������"
FROM TBL_EMP
WHERE EMPNO =ANY(SELECT DISTINCT(MGR) FROM TBL_EMP);
--==>> ���ҽ� �Ҹ� ��

SELECT DISTINCT(JOB)
FROM TBL_EMP;

-------------------------------------------------------------------------------

SELECT *
FROM TBL_SAWON;

--�� TBL_SAWON ���̺� ���(������ ����) �� �� ���̺� ���� ���質 �������� ���� ������ ����
CREATE TABLE TBL_SAWONBACKUP
AS
SELECT *
FROM TBL_SAWON;
--==>> Table TBL_SAWONBACKUP��(��) �����Ǿ����ϴ�.
-- TBL_SAWON ���̺��� �����͵鸸 ����� ����
-- ��, �ٸ� �̸��� ���̺� ���·� ������ �� ��Ȳ

--�� ������ ����
UPDATE TBL_SAWON
SET SANAME = '�ʶ���';

COMMIT;

SELECT *
FROM TBL_SAWON;

ROLLBACK;


UPDATE TBL_SAWON
SET SANAME = (  SELECT SANAME
                FROM TBL_SAWONBACKUP 
                WHERE SANO = TBL_SAWON.SANO )
WHERE SANAME = '�ʶ���';

SELECT *
FROM TBL_SAWON;


COMMIT;

















