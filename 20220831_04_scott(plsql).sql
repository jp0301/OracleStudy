SELECT USER
FROM DUAL;

SELECT *
FROM TBL_INSA;

--�� TBL_INSA ���̺��� �������
--   �ֹι�ȣ(SSN)�� ������ ������ ��ȸ�Ѵ�.

SELECT NAME, SSN
, DECODE(SUBSTR(SSN,8,1),'1','����','2', '����','3', '����','4','����','����Ȯ�κҰ�') "����"
FROM TBL_INSA;

SELECT NAME, SSN
, FN_GENDER(SSN) "����2"
FROM TBL_INSA;

SELECT FN_GENDER('980301-1322222') "����Ȯ��"
FROM DUAL;



SELECT FN_POW(10,3)
FROM DUAL;
--==>> 1000











