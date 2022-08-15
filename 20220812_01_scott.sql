select user
from dual;


SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO = 20 OR DEPTNO = 30;
--==>>
/*
7369	SMITH	CLERK	800	20
7499	ALLEN	SALESMAN	1600	30
7521	WARD	SALESMAN	1250	30
7566	JONES	MANAGER	2975	20
7654	MARTIN	SALESMAN	1250	30
7698	BLAKE	MANAGER	2850	30
7788	SCOTT	ANALYST	3000	20
7844	TURNER	SALESMAN	1500	30
7876	ADAMS	CLERK	1100	20
7900	JAMES	CLERK	950	30
7902	FORD	ANALYST	3000	20
*/

--※ 위의 구문은 IN 연산자를 활용하여
--   다음과 같이 처리할 수 있으며
--   위 구문의 처리 결과와 같은 결과를 반환한다.

SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO IN (20, 30);


--○ EMP 테이블에서 직종이 CLERK 인 사원들의 데이터를 모두 조회한다.
SELECT *
FROM EMP
WHERE JOB = 'CLERK';
--==>>
/*
7369	SMITH	CLERK	7902    	80/12/17    	800		20
7876	ADAMS	CLERK	7788	87/07/13	    1100		20
7900	    JAMES	CLERK	7698	81/12/03    	950		30
7934	MILLER	CLERK	7782    	82/01/23	    1300		10
*/


select *
from Emp
where Job = 'clerk';
--==>> 조회 결과 없음


select *
from Emp
where Job = 'CLERK';
--==>>
/*
7369	SMITH	CLERK	7902    	80/12/17    	800		20
7876	ADAMS	CLERK	7788	87/07/13	    1100		20
7900	    JAMES	CLERK	7698	81/12/03    	950		30
7934	MILLER	CLERK	7782    	82/01/23	    1300		10
*/

--※ 오라클에서... 입력된 데이터의 값 만큼은
--   반.드.시. 대소문자 구분을 한다.


--○ EMP 테이블에서 직종이 CLERK 인 사원들 중
--   20번 부서에 근무하는 사원들의
--   사원번호, 사원명, 직종명, 급여, 부서번호 항목을 조회한다.
--   ALIAS 사용~!!!

SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE JOB = 'CLERK' AND DEPTNO = 20;
--==>>
/*
7369	SMITH	CLERK	 800	    20
7876	ADAMS	CLERK	1100	    20
*/


--○ EMP 테이블의 구조와 데이터를 확인해서
--   이와 똑같은 데이터가 들어있는 테이블의 구조를 생성한다.
--   (팀별로... EMP1, EMP2, EMP3, EMP4)

-- 1. 복사할 대상 테이블의 구조 확인
DESCRIBE EMP;
--==>>
/*
이름       널?       유형           
-------- -------- ------------ 
EMPNO    NOT NULL NUMBER(4)    
ENAME             VARCHAR2(10) 
JOB               VARCHAR2(9)  
MGR               NUMBER(4)    
HIREDATE          DATE         
SAL               NUMBER(7,2)  
COMM              NUMBER(7,2)  
DEPTNO            NUMBER(2)
*/

-- 2. 대상 테이블의 구조에 따라 새로운 테이블 생성
CREATE TABLE EMP4
( EMPNO     NUMBER(4)
, ENAME     VARCHAR2(10)
, JOB       VARCHAR2(9)
, MGR       NUMBER(4)
, HIREDATE  DATE
, SAL       NUMBER(7,2)
, COMM      NUMBER(7,2)
, DEPTNO    NUMBER(2)
);

-- 3. 대상 테이블의 데이터 조회
SELECT *
FROM EMP;

-- 4. 대상 테이블의 데이터를 복사할 테이블에 입력
-- to_date('17-12-1980','dd-mm-yyyy')
INSERT INTO EMP4 VALUES (7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20);
INSERT INTO EMP4 VALUES (7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 16000, 300, 30);
INSERT INTO EMP4 VALUES (7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 30);
INSERT INTO EMP4 VALUES (7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 20);
INSERT INTO EMP4 VALUES (7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250, 1400, 30);
INSERT INTO EMP4 VALUES (7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 30);
INSERT INTO EMP4 VALUES (7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 10);
INSERT INTO EMP4 VALUES (7788, 'SCOTT', 'ANALYST', 7566, '1987-07-13', 3000, NULL, 20);
INSERT INTO EMP4 VALUES (7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10);
INSERT INTO EMP4 VALUES (7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500, 0, 30);
INSERT INTO EMP4 VALUES (7876, 'ADAMS', 'CLERK', 7788, '1987-07-13', 1100, NULL, 20);
INSERT INTO EMP4 VALUES (7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950, NULL, 30);
INSERT INTO EMP4 VALUES (7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 20);
INSERT INTO EMP4 VALUES (7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300, NULL, 10);
--==>> 1행 이(가) 삽입되었습니다. * 14


-- 5. 확인
SELECT *
FROM EMP4;


--○ 대상 테이블의 내용에 따라 테이블 생성
CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;

SELECT *
FROM TBL_EMP;

DESC TBL_EMP;


--○ 복사한 테이블 조회
SELECT *
FROM TBL_EMP;


--○ DEPT 테이블을 복사하여 위와 같이 TBL_DEPT 테이블을 생성한다.
CREATE TABLE TBL_DEPT
AS
SELECT *
FROM DEPT;


--○ 복사한 테이블 확인
SELECT *
FROM TBL_DEPT;



--○ 테이블의 커맨트 정보 확인
SELECT *
FROM USER_TAB_COMMENTS;
--==>>
/*
DEPT	        TABLE	(null)
EMP	            TABLE	(null)
BONUS	        TABLE	(null)
SALGRADE	        TABLE	(null)
TBL_EXAMPLE1	    TABLE	(null)
TBL_EXAMPLE2	    TABLE	(null)
EMP4	        TABLE	(null)
TBL_EMP	        TABLE   (null)	
TBL_DEPT	        TABLE   (null)	
*/


--○ 테이블 레벨의 커멘트 정보 입력
COMMENT ON TABLE TBL_EMP IS '사원 정보';
--==>> Comment이(가) 생성되었습니다.

--○ 테이블의 커맨트 정보 입력 후 다시 확인
SELECT *
FROM USER_TAB_COMMENTS;
--==>>
/*
TBL_DEPT	        TABLE	
TBL_EMP	        TABLE	사원 정보
EMP4	        TABLE	
TBL_EXAMPLE2	    TABLE	
TBL_EXAMPLE1	    TABLE	
SALGRADE	        TABLE	
BONUS	        TABLE	
EMP	            TABLE	
DEPT	        TABLE	
*/

--○ TBL_DEPT 테이블을 대상으로 테이블 레벨의 커맨트 데이터 입력
--   → 부서 정보
COMMENT ON TABLE TBL_DEPT IS '부서 정보';
--==>> Comment이(가) 생성되었습니다.

--○ 커멘트 데이터 입력 후 확인
SELECT *
FROM USER_TAB_COMMENTS;
--==>>
/*
TBL_DEPT	        TABLE	부서 정보
TBL_EMP	        TABLE	사원 정보
EMP4	        TABLE	
TBL_EXAMPLE2    	TABLE	
TBL_EXAMPLE1	    TABLE	
SALGRADE	        TABLE	
BONUS	        TABLE	
EMP	            TABLE	
DEPT	        TABLE	
*/


--○ 컬럼(COLUMN) 레벨의 커맨트 데이터 확인
SELECT *
FROM USER_COL_COMMENTS;
--==>>
/*
EMP	            JOB	
TBL_EXAMPLE2    	NAME	
EMP4	        MGR	
DEPT	        LOC	
BONUS	        COMM	
BONUS	        SAL	
EMP4	        DEPTNO	
EMP	            SAL	
SALGRADE	LO      SAL	
TBL_EMP	        EMPNO	
EMP4	        COMM	
EMP4	        EMPNO	
EMP	            DEPTNO	
SALGRADE        	HISAL	
EMP	            EMPNO	
TBL_EMP	        MGR	
TBL_EXAMPLE1    	NAME	
DEPT	        DEPTNO	
DEPT	        DNAME	
TBL_EMP	        HIREDATE	
TBL_DEPT	        DNAME	
TBL_EMP	        JOB	
TBL_DEPT        	LOC	
EMP	            COMM	
SALGRADE        	GRADE	
TBL_EMP	        ENAME	
TBL_EXAMPLE1	    ADDR	
TBL_EXAMPLE2    	ADDR	
EMP	            HIREDATE	
EMP4	        SAL	
EMP4	        JOB	
TBL_EXAMPLE2	    NO	
BONUS	        JOB	
TBL_EXAMPLE1	    NO	
TBL_EMP	        COMM	
EMP	            ENAME	
TBL_EMP	        DEPTNO	
TBL_DEPT        	DEPTNO	
EMP	            MGR	
EMP4	        HIREDATE	
TBL_EMP	        SAL	
EMP4	        ENAME	
BONUS	        ENAME	
*/


-- 휴지통 비우기
--PURGE RECYCLEBIN;
-- RECYCLEBIN이(가) 비워졌습니다.
-- 굳이 사용하지 않는다.


--○ 컬럼(COLUMN) 레벨의 커맨트 데이터 확인(TBL_DEPT 테이블 소속의 컬럼들만 조회)
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME='TBL_DEPT';        -- 조건 추가
--==>>
/*
TBL_DEPT    	DEPTNO	
TBL_DEPT	    DNAME	
TBL_DEPT	    LOC	
*/

-- COMMENT ON TABLE 테이블명 IS '커멘트';

--○ 테이블에 소속된(포함된) 컬럼에 대한 커멘트 데이터 입력(설정)
COMMENT ON COLUMN TBL_DEPT.DEPTNO IS '부서 번호';
--==>> Comment이(가) 생성되었습니다.
COMMENT ON COLUMN TBL_DEPT.DNAME IS '부서 이름';
--==>> Comment이(가) 생성되었습니다.
COMMENT ON COLUMN TBL_DEPT.LOC IS '부서 위치';
--==>> Comment이(가) 생성되었습니다.

--○ 커멘트 데이터가 입력된 테이블의
--   컬럼 레벨 커멘트 데이터 확인(TBL_DEPT 테이블 소속의 컬럼들만 조회0
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_DEPT';
--==>>
/*
TBL_DEPT	DEPTNO	부서 번호
TBL_DEPT	DNAME	부서 이름
TBL_DEPT	LOC	    부서 위치
*/


--○ TBL_EMP 테이블을 대상으로
--   이 테이블에 소속된(포함된) 컬럼에 대한 커멘트 데이터 입력(설정)
DESC TBL_EMP;

COMMENT ON COLUMN TBL_EMP.EMPNO IS '사원 번호';
COMMENT ON COLUMN TBL_EMP.ENAME IS '사원명';
COMMENT ON COLUMN TBL_EMP.JOB IS '직종명';
COMMENT ON COLUMN TBL_EMP.MGR IS '관리자 사원번호';
COMMENT ON COLUMN TBL_EMP.HIREDATE IS '입사일';
COMMENT ON COLUMN TBL_EMP.SAL IS '급여';
COMMENT ON COLUMN TBL_EMP.COMM IS '수당';
COMMENT ON COLUMN TBL_EMP.DEPTNO IS '부서번호';
--==>> Comment이(가) 생성되었습니다. * 8

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME='TBL_EMP';
--==>>
/*
TBL_EMP	EMPNO	사원 번호
TBL_EMP	ENAME	사원명
TBL_EMP	JOB	직종명
TBL_EMP	MGR	관리자 사원번호
TBL_EMP	HIREDATE	입사일
TBL_EMP	SAL	급여
TBL_EMP	COMM	수당
TBL_EMP	DEPTNO	부서번호
*/



--■■■ 컬럼 구조의 추가 및 제거 ■■■--

SELECT *
FROM TBL_EMP;

--○ TBL_EMP 테이블에 주민등록번호 데이터를 담을 수 있는 컬럼 추가
ALTER TABLE TBL_EMP
ADD SSN CHAR(13);
--==>> Table TBL_EMP이(가) 변경되었습니다.

SELECT '01048484114'
FROM DUAL;
--==>> 01048484114


SELECT 01048484114
FROM DUAL;
--==>> 1048484114


--○ 확인
SELECT *
FROM TBL_EMP;

DESC TBL_EMP;
--==>>
/*
이름       널? 유형           
-------- -- ------------ 
EMPNO       NUMBER(4)    
ENAME       VARCHAR2(10) 
JOB         VARCHAR2(9)  
MGR         NUMBER(4)    
HIREDATE    DATE         
SAL         NUMBER(7,2)  
COMM        NUMBER(7,2)  
DEPTNO      NUMBER(2)    
SSN         CHAR(13)
*/

--> SSN(주민등록번호) 컬럼이 정상적으로 포함(추가)된 사항을 확인


--※ 테이블 내에서 컬럼의 순서는 구조적으로 의미 없음.


--○ TBL_EMP 테이블에 추가한 SSN(주민등록번호) 컬럼 제거
ALTER TABLE TBL_EMP
DROP COLUMN SSN;
--==>> Table TBL_EMP이(가) 변경되었습니다.

SELECT *
FROM TBL_EMP;

DESC TBL_EMP;

--> SSN(주민등록번호) 컬럼이 정상적으로  삭제되었음을 확인


DELETE TBL_EMP;
--==>> 14개 행이(가) 삭제되었습니다.

SELECT *
FROM TBL_EMP;
--> 테이블의 구조(뼈대, 틀)는 그대로 남아있는 상태에서
--  데이터만 모두 소실(삭제)된 상황임을 확인

DROP TABLE TBL_EMP;
--==>> Table TBL_EMP이(가) 삭제되었습니다.

SELECT *
FROM TBL_EMP;
--==>> 에러 발생
-- (ORA-00942: table or view does not exist)

--> 테이블 자체가 구조적으로 제거된 상황




--○ 테이블 다시 복사(생성)
CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;
--==>> Table TBL_EMP이(가) 생성되었습니다.


--○ NULL 의 처리

SELECT 2, 10+2, 10-2, 10*2, 10/2
FROM DUAL;
--==>> 2    	12	8	20	5


SELECT NULL, NULL+2, NULL-2, NULL*2, NULL/2
FROM DUAL;
--==>> (null) (null) (null) (null) (null) 

--※ 관찰의 결과
--   NULL은 상태의 값을 의미하며... 실제 존재하지 않는 값이기 때문에
--   이 NULL 이 연산에 포함될 경우
--   그 결과는 무조건 NULL 이다.


--○ TBL_EMP 테이블에서 커미션(COMM, 수당)이 NULL인 직원의
--   사원명, 직종명, 급여, 커미션 항목을 조회한다.
SELECT *
FROM TBL_EMP;

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "수당"
FROM TBL_EMP
WHERE COMM = NULL;
--==>> 조회 결과 없음

SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "수당"
FROM TBL_EMP
WHERE COMM = 'NULL';
--==>> 에러 발생


SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "수당"
FROM TBL_EMP
WHERE COMM = (null);
--==>> 조회 결과 없음


--※ NULL은 실제 존재하는 값이 아니기 때문에
--   일반적인 연산자를 활용하여 비교할 수 없다.
--   NULL 을 대상으로 사용할 수 없는 연산자들...
--   >=, <=, =, >, <, !=(같지않다), <>(뭐가 작은지 모르겠고 같지 않다),^=(같지않다.)


SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "수당"
FROM TBL_EMP
WHERE COMM IS NULL;
--==>>
/*
SMITH	CLERK	    800	
JONES	MANAGER	    2975	
BLAKE	MANAGER	    2850	
CLARK	MANAGER	    2450	
SCOTT	ANALYST	    3000	
KING    	PRESIDENT   	5000	
ADAMS	CLERK	    1100	
JAMES	CLERK	    950	
FORD	    ANALYST	    3000	
MILLER	CLERK	    1300	
*/


--○ TBL_EMP 테이블에서 20번 부서에 근무하지 않는 직원들의
--   사원명, 직종명, 부서번호 항목을 조회한다.

SELECT ENAME, JOB, DEPTNO
FROM TBL_EMP
WHERE DEPTNO != 20;
--WHERE DEPTNO <> 20;
--WHERE DEPTNO ^= 20;
--==>>
/*
ALLEN	SALESMAN	    30
WARD	    SALESMAN	    30
MARTIN	SALESMAN	    30
BLAKE	MANAGER	    30
CLARK	MANAGER	    10
KING	    PRESIDENT	10
TURNER	SALESMAN	    30
JAMES	CLERK	    30
MILLER	CLERK	    10
*/


--○ TBL_EMP 테이블에서 커미션이 NULL이 아닌 직원들의
--   사원명, 직종명, 급여, 커미션 항목을 조회한다.
SELECT ENAME, JOB, SAL, COMM
FROM TBL_EMP
WHERE COMM IS NOT NULL;  -- && AND || OR ! NOT
--==>>
/*
ALLEN	SALESMAN	    1600	     300
WARD    	SALESMAN	    1250	     500
MARTIN	SALESMAN	    1250	    1400
TURNER	SALESMAN	    1500    	   0
*/


SELECT ENAME, JOB, SAL, COMM
FROM TBL_EMP
WHERE NOT COMM IS NULL; 
--==>>
/*
ALLEN	SALESMAN	    1600	     300
WARD    	SALESMAN	    1250	     500
MARTIN	SALESMAN	    1250	    1400
TURNER	SALESMAN	    1500    	   0
*/


--○ TBL_EMP 테이블에서 모든 사원들의
--   사원번호, 사원명, 급여, 커미션, 연봉 항목을 조회한다.
--   단, 급여(SAL)는 매월 지급한다.
--   또한, 수당(COMM)은 연 1회 지급하며, 연봉 내역에 포함된다.

SELECT EMPNO "사원번호", ENAME "사원명", SAL "급여", COMM "수당", ((SAL*12) + COMM) "연봉" 
FROM TBL_EMP;
--==>> 
/*
7369	SMITH	800		
7499	ALLEN	1600    	300 19500
7521	    WARD	    1250    	500	15500
7566	JONES	2975		
7654	MARTIN	1250    	1400    	16400
7698	BLAKE	2850		
7782    	CLARK	2450		
7788	SCOTT	3000		
7839	KING	    5000		
7844	TURNER	1500	0	18000
7876	ADAMS	1100		
7900	    JAMES	950		
7902	    FORD	    3000		
7934	MILLER	1300		
*/


--○ NVL()
SELECT NULL "COL1", NVL(NULL, 10) "COL2", NVL(5,10) "COL3"
FROM DUAL;
--==>> (null)  10 5
--  첫 번째 파라미터 값이 NULL 이면, 두 번째 파라미터 값을 반환한다.
--  첫 번째 파라미터 값이 NULL 이 아니면, 그 값을 그대로 반환한다.


SELECT EMPNO "사원번호", ENAME "사원명", SAL "급여", NVL(COMM, 0) "수당", (SAL*12) + NVL(COMM, 0) "연봉" 
FROM TBL_EMP;
--==>> 
/*
7369	SMITH	800	    0	    9600
7499	ALLEN	1600	    300	    19500
7521	    WARD	    1250	    500	    15500
7566	JONES	2975	0	3570    0
7654	MARTIN	1250	    1400	    16400
7698	BLAKE	2850	0	34200
7782	    CLARK	2450	0	29400
7788	SCOTT	3000	0	36000
7839	KING	    5000    	0	    60000
7844	TURNER	1500	    0	    18000
7876	ADAMS	1100    	0	    13200
7900	    JAMES	950	    0	    11400
7902	    FORD	    3000	    0	    36000
7934	MILLER	1300	    0	    15600
*/

--○ NVL2()
--> 첫 번째 파라미터 값이 NULL 이 아닌 경우, 두 번째 파라미터 값을 반환하고
--  첫 번째 파라미터 값이 NULL 인 경우, 세 번째 파라미터 값을 반환한다.

SELECT ENAME "사원명", NVL2(COMM, '청기올려', '백기올려') "수당확인"
FROM TBL_EMP;


SELECT EMPNO "사원번호", ENAME "사원명", SAL "급여", 
NVL2(COMM, COMM, 0) "수당", (SAL * 12) + NVL2(COMM, COMM, 0) "연봉" 
FROM TBL_EMP;


SELECT EMPNO "사원번호", ENAME "사원명", SAL "급여", 
NVL2(COMM, COMM, 0) "수당", NVL2(COMM, SAL*12+COMM, SAL*12) "연봉" 
FROM TBL_EMP;


--○ COALESCE()
--> 매개변수 제한이 없는 형태로 인지하고 활용한다.
--  맨 앞에 있는 매개변수부터 차례로 NULL 인지 아닌지 확인하여
--  NULL 이 아닐 경우 반환하고,
--  NULL 인 경우에는 그 다음 매개변수의 값을 반환한다.
--  NVL() 이나 NVL2() 와 비교하여
--  모~~~~~ 든 경우의 수를 고려할 수 있다는 특징을 갖는다.

SELECT NULL "COL1"
    , COALESCE(NULL, NULL, NULL, 40) "COL2"
    , COALESCE(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100) "COL3"
    , COALESCE(NULL, NULL, 30, NULL, NULL, 60) "COL4"
    , COALESCE(10, NULL, NULL, NULL, NULL, NULL, 60) "COL5"
FROM DUAL;

--○ 실습을 위한 데이터 추가 입력

INSERT INTO TBL_EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO)
VALUES(8000, '영주니', 'SALESMAN', 7369, SYSDATE, 10);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO, COMM)
VALUES(8001, '나유니', 'SALESMAN', 7369, SYSDATE, 10, 10);
--==>> 1 행 이(가) 삽입되었습니다.

COMMIT;
--==>> 커밋 완료.


--○ 확인
SELECT *
FROM TBL_EMP;


SELECT EMPNO "사원번호", ENAME "사원명", 
        NVL(SAL, 0) "급여",
        NVL(COMM, 0) "수당",
        COALESCE( (SAL*12) + COMM, (SAL*12), COMM, 0) "연봉"
FROM TBL_EMP;


--※ 날짜에 대한 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
--==>> Session이(가) 변경되었습니다.

--○ 컬럼과 컬럼의 연결(결합)
SELECT 1, 2
FROM DUAL;

SELECT 1 + 2
FROM DUAL;

SELECT '영과니', '보영이'
FROM DUAL;

SELECT '영과니' + '보영이'
FROM DUAL;
--==>> 에러 발생
--      (ORA-01722: invalid number)

SELECT '영과니' || '보영이'
FROM DUAL;
--==>> 영과니보영이


SELECT ENAME, JOB
FROM TBL_EMP;

SELECT ENAME || JOB
FROM TBL_EMP;

SELECT 'OO이는 ', SYSDATE, '에 연봉 ', 500, '억을 원한다.'
FROM DUAL;
--==>> OO이는    2022-08-12 04:03:44 에 연봉     500     억을 원한다.
--    -------    ------------------ --------    ---      -----------
--    문자타입     날짜타입         문자타입    숫자타입  문자타입

--○ 현재 날짜 및 시간을 반환하는 함수
SELECT SYSDATE, CURRENT_DATE, LOCALTIMESTAMP
FROM DUAL;
--==>> 2022-08-12 04:05:08	2022-08-12 04:05:08	22/08/12 16:05:08.000000000

SELECT 'OO이는 '|| SYSDATE || '에 연봉 '|| 500 || '억을 원한다.'
FROM DUAL;
--==>> OO이는 2022-08-12 04:06:09에 연봉 500억을 원한다.
--     ------------------------------------------------
--  ※ 오라클에서는 문자 타입의 형태로 형 변환하는 별도의 과정 없이
--     『||』만 삽입해 주면 간단히 컬럼과 컬럼(서로 다른 종류의 데이터)을
--     결합하는 것이 가능하다.
--     cf) MSSQL 에서는 모든 데이터를 문자열로 CONVERT 해야 한다.


--○ TBL_EMP 테이블의 데이터를 활용하여
--   다음과 같은 결과를 얻을 수 있도록 쿼리문을 구성한다.
--   『SMITH 의 현재 연봉은 9600 인데 희망 연봉은 19200이다.
--     ALLEN 의 현재 연봉은 19500인데 희망 연봉은 39000이다.
--                             :
--                             :
--     나유니의 현재 연봉은 10인데 희망 연봉은 20이다.』
--     단, 레코드마다 위와 같은 내용이 한 컬럼에 모두 조회될 수 있도록 처리한다.

SELECT *
FROM TBL_EMP;

SELECT ENAME || '의 현재 연봉은 '
    || COALESCE((SAL*12+COMM), SAL*12, COMM, 0)
    || '인데 희망 연봉은 '
    || (COALESCE((SAL*12+COMM), SAL*12, COMM, 0))*2
    || '이다.'
FROM TBL_EMP;
--==>>
/*
SMITH의 현재 연봉은9600인데 희망 연봉은 19200이다.
ALLEN의 현재 연봉은19500인데 희망 연봉은 39000이다.
WARD의 현재 연봉은15500인데 희망 연봉은 31000이다.
JONES의 현재 연봉은35700인데 희망 연봉은 71400이다.
MARTIN의 현재 연봉은16400인데 희망 연봉은 32800이다.
BLAKE의 현재 연봉은34200인데 희망 연봉은 68400이다.
CLARK의 현재 연봉은29400인데 희망 연봉은 58800이다.
SCOTT의 현재 연봉은36000인데 희망 연봉은 72000이다.
KING의 현재 연봉은60000인데 희망 연봉은 120000이다.
TURNER의 현재 연봉은18000인데 희망 연봉은 36000이다.
ADAMS의 현재 연봉은13200인데 희망 연봉은 26400이다.
JAMES의 현재 연봉은11400인데 희망 연봉은 22800이다.
FORD의 현재 연봉은36000인데 희망 연봉은 72000이다.
MILLER의 현재 연봉은15600인데 희망 연봉은 31200이다.
영주니의 현재 연봉은0인데 희망 연봉은 0이다.
나유니의 현재 연봉은10인데 희망 연봉은 20이다.
*/


--※ 날짜에 대한 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--○ TBL_EMP 테이블의 데이터를 활용하여
--   다음과 같은 결과를 얻을 수 있도록 쿼리문을 구성한다.
--   『SMITH's 입사일은 1980-12-17이다. 그리고 급여는 800이다.
--     ALLEN's 입사일은 1981-02-20이다. 그리고 급여는 1600이다.
--                           :
--                           :
--     나유니's 입사일은 2022-08-12이다. 그리고 급여는 0이다.』
--   단, 레코드마다 위와 같은 내용이 한 컬렘에 모두 조회될 수 있도록 처리한다.

SELECT *
FROM TBL_EMP;


SELECT ENAME || '''s 입사일은'
       || HIREDATE || '이다. 그리고 급여는 '
       || COALESCE(SAL, 0) || '이다.'
FROM TBL_EMP;

--※ 문자열을 나타내는 홑따옴표 사이에서(시작과 끝)
--   홑따옴표 두 개가 홑따옴표 하나(어퍼스트로피)를 의미한다.
--   홑따옴표 『'』하나는 문자열의 시작을 나타내고
--   홑따옴표 『''』두 개는 문자열 영역 안에서 어퍼스트로피를 나타내며
--   다시 등장하는 홑따옴표 『'』 하나가 
--   문자열 영역의 종료를 이미하게 되는 것이다.

--==>>
/*
SMITH's 입사일은1980-12-17이다. 그리고 급여는 800이다.
ALLEN's 입사일은1981-02-20이다. 그리고 급여는 1600이다.
WARD's 입사일은1981-02-22이다. 그리고 급여는 1250이다.
JONES's 입사일은1981-04-02이다. 그리고 급여는 2975이다.
MARTIN's 입사일은1981-09-28이다. 그리고 급여는 1250이다.
BLAKE's 입사일은1981-05-01이다. 그리고 급여는 2850이다.
CLARK's 입사일은1981-06-09이다. 그리고 급여는 2450이다.
SCOTT's 입사일은1987-07-13이다. 그리고 급여는 3000이다.
KING's 입사일은1981-11-17이다. 그리고 급여는 5000이다.
TURNER's 입사일은1981-09-08이다. 그리고 급여는 1500이다.
ADAMS's 입사일은1987-07-13이다. 그리고 급여는 1100이다.
JAMES's 입사일은1981-12-03이다. 그리고 급여는 950이다.
FORD's 입사일은1981-12-03이다. 그리고 급여는 3000이다.
MILLER's 입사일은1982-01-23이다. 그리고 급여는 1300이다.
영주니's 입사일은2022-08-12이다. 그리고 급여는 0이다.
나유니's 입사일은2022-08-12이다. 그리고 급여는 0이다.
*/


--○ UPPER(), LOWER(), INITCAP()

SELECT 'oRaCLe' "COL1"
    , UPPER('oRaCLe') "COL2"
    , LOWER('oRaCLe') "COL3"
    , INITCAP('oRaCLe') "COL4"
FROM DUAL;
--==>> oRaCle ORACLE oracle Oracle
-- UPPER() 는 모두 대문자로 반환
-- LOWER() 는 모두 소문자로 반환
-- INITCAP() 은 첫 글자만 대문자로 하고 나머지는 모두 소문자로 변환


--○ TBL_EMP 테이블을 대상으로 검색값이 'sALeSmAN'인 조건으로
--   해당 직종 사원의 사원번호, 사원명, 직종명을 조회한다.

SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE JOB = UPPER('sALeSmAN');


--※ 실습을 위한 추가 데이터 입력
INSERT INTO TBL_EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO, COMM)
VALUES(8002, '태미니', 'salesman', 7369, SYSDATE, 20, 100);
--==>> 1 행 이(가) 삽입되었습니다.

--※ 커밋
COMMIT;
--==>> 커밋 완료.

--○ TBL_EMP 테이블을 대상으로 검색값이 'sALeSmAN'인 조건으로
--   영업사원(세일즈맨)의 사원번호, 사원명, 직종명을 조회한다.

SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE JOB IN (UPPER('sALeSmAN'), LOWER('sALeSmAN'), INITCAP('sALeSmAN'));


SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE LOWER(JOB) = LOWER('sALeSmAN');

SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE UPPER(JOB) = UPPER('sALeSmAN');


SELECT EMPNO, ENAME, JOB
FROM TBL_EMP
WHERE INITCAP(JOB) = INITCAP('sALeSmAN');



--○ TBL_EMP 테이블에서 입사일이 1981년 9월 28일 입사한 직원의
--   사원명, 직종명, 입사일 항목을 조회한다.
SELECT ENAME, JOB, HIREDATE
FROM TBL_EMP
WHERE HIREDATE = '1981-09-28';
--==>> MARTIN	SALESMAN	1981-09-28

DESC TBL_EMP;

SELECT ENAME, JOB, HIREDATE
FROM TBL_EMP
WHERE HIREDATE = '1981-09-28';

-- 오라클의 자동형변환은 내가 믿고 기대하면 안된다. 중요!

--○ TO_DATE()

SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE = TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>>
/*
MARTIN	SALESMAN	    1981-09-28
*/

--○ TBL_EMP 테이블에서 입사일이 1981년 9월 28일 이후(해당일 포함)
--   입사한 직원의 사원명, 직종명, 입사일 항목을 조회한다.

SELECT ENAME, JOB, HIREDATE
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>>
/*
MARTIN	SALESMAN	    1981-09-28
SCOTT	ANALYST	    1987-07-13
KING    	PRESIDENT	1981-11-17
ADAMS	CLERK	    1987-07-13
JAMES	CLERK	    1981-12-03
FORD    	ANALYST	    1981-12-03
MILLER	CLERK	    1982-01-23
영주니	SALESMAN	    2022-08-12
나유니	SALESMAN	    2022-08-12
태미니	salesman	    2022-08-12
*/


--※ 오라클에서는 날짜 데이터의 크기 비교가 가능하다.
--   오라클에서는 날짜 데이터에 대한 크기 비교 시
--   과거보다 미래를 더 큰 값으로 간주한다.

--○ TBL_EMP 테이블에서 입사일이 1981년 4월 2일 부터
--   1981년 9월 28일 사이에 입사한 직원들의
--   사원명, 직종명, 입사일 항목을 조회한다. (해당일 포함)

SELECT ENAME, JOB, HIREDATE
FROM TBL_EMP
--WHERE HIREDATE >= TO_DATE('1981-04-02', 'YYYY-MM-DD')
--AND HIREDATE <= TO_DATE('1981-09-28', 'YYYY-MM-DD');
WHERE BETWEEN TO_DATE('1981-04-02','YYYY-MM-DD') AND TO_DATE('1981-09-28', 'YYYY-MM-DD');










