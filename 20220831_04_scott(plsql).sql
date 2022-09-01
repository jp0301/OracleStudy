SELECT USER
FROM DUAL;

SELECT *
FROM TBL_INSA;

--○ TBL_INSA 테이블을 대상으로
--   주민번호(SSN)를 가지고 성별을 조회한다.

SELECT NAME, SSN
, DECODE(SUBSTR(SSN,8,1),'1','남자','2', '여자','3', '남자','4','여자','성별확인불가') "성별"
FROM TBL_INSA;

SELECT NAME, SSN
, FN_GENDER(SSN) "성별2"
FROM TBL_INSA;

SELECT FN_GENDER('980301-1322222') "성별확인"
FROM DUAL;



SELECT FN_POW(10,3)
FROM DUAL;
--==>> 1000











