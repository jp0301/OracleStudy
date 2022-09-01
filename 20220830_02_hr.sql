SELECT USER
FROM DUAL;
--==>> HR


--○ EMPLOYEES 테이블의 직원들 SALARY 를 10% 인상한다.
--   단, 부서명이 'IT'인 직원들만 한정한다.
-- ( 변경에 대한 결과 확인 후 ROLLBACK 수행한다.)

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
--==>> 5개 행 이(가) 업데이트되었습니다.

-- 확인
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 60;
/* -- 롤백했기 때문에 기존 값 조회
103	Alexander	Hunold	    AHUNOLD	    590.423.4567	2006-01-03	IT_PROG	9000		102	60
104	Bruce	    Ernst	    BERNST	    590.423.4568	2007-05-21	IT_PROG	6000		103	60
105	David	    Austin	    DAUSTIN	    590.423.4569	2005-06-25	IT_PROG	4800		103	60
106	Valli	    Pataballa	VPATABAL	590.423.4560	2006-02-05	IT_PROG	4800		103	60
107	Diana	    Lorentz	    DLORENTZ	590.423.5567	2007-02-07	IT_PROG	4200		103	60
*/

-- 업데이트 한 결과  ROLLBACK;
ROLLBACK;
--==>> 롤백 완료.



--○ EMPLOYEES 테이블에서 JOBS_TITLE 이 Sales Manager 인 사원들의
--   SALARY 를 해당 직무(직종)의 최고급여(MAX_SALARY)로 수정한다.
--   단, 입사일이 2006년 이전(해당 년도 제외) 입사자에 한해 적용할 수 있도록 처리한다.
--   (변경에 대한 결과 확인 후 ROLLBACK 수행한다.)

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



--확인 (변경 전)
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


--확인 (변경 후)
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE = 'Sales Manager')
  AND HIRE_DATE < TO_DATE('2006-01-01', 'YYYY-MM-DD');
/*
145	John	Russell	    JRUSSEL	    011.44.1344.429268	2004-10-01	SA_MAN	14000	0.4	100	80
146	Karen	Partners	KPARTNER	011.44.1344.467268	2005-01-05	SA_MAN	14000	0.3	100	80
147	Alberto	Errazuriz	AERRAZUR	011.44.1344.429278	2005-03-10	SA_MAN	14000	0.3	100	80
*/


-- 업데이트 한 결과  ROLLBACK;
ROLLBACK;
--==>> 롤백 완료.



SELECT *
FROM DEPARTMENTS;

SELECT *
FROM EMPLOYEES;

--○ EMPLOYEES 테이블에서 SALARY 를
--   각 부서의 이름별로 다른 인상률을 적용하여 수정할 수 있도록 한다.
--   Finance -> 10% 인상
--   Executive -> 15% 인상
--   Accounting -> 20% 인상
--   (변경에 대한 결과 확인 후 Rollback)

-- 변경 전
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
--==>>  11개 행 이(가) 업데이트되었습니다.


-- 변경 후
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

-- 업데이트 한 결과  ROLLBACK;
ROLLBACK;
--==>> 롤백 완료.


--------------------------------------------------------------------------------
--■■■ DELETE ■■■--

-- 1. 테이블에서 지정된 행(레코드)을 삭제하는 데 사용하는 구문

-- 2. 형식 및 구조
-- DELETE [FROM] 테이블명
-- [WHERE 조건절];

-- 테이블 복사(데이터 위주)
CREATE TABLE TBL_EMPLOYEES
AS
SELECT *
FROM EMPLOYEES;
--==>> Table TBL_EMPLOYEES이(가) 생성되었습니다.

SELECT *
FROM TBL_EMPLOYEES
WHERE EMPLOYEE_ID = 198;


ROLLBACK;

--○ EMPLOYEES 테이블에서 직원들의 데이터를 삭제한다.
--   단, 부서명이 'IT'인 경우로 한정한다.

-- ※ 실제로는 EMPLOYEES 테이블의 데이터가 (삭제하고자 하는 대상 데이터)
--    다른 레코드에 의해 참조당하고 있는 경우
--    삭제되지 않을 수 있다는 사실을 염두해야 하며...
--    그에 대한 이유도 알아야 한다.


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
오류 보고 -
ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found  

DEPARTMENTS 테이블에서 MANAGER_ID 를 참조하고 있기 때문이다.
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

--■■■ 뷰(VIEW) ■■■--

-- 1. 뷰(VIEW)란 이미 특정한 데이터베이스 내에 존재하는
--    하나 이상의 테이블에서 사용자가 얻기 원하는 데이터들만을
--    정확하고 편하게 가져오기 위하여 사전에 원하는 컬럼들만을 모아서
--    만들어놓은 가상의 테이블로 편의성 및 보안에 목적이 있다.

--    가상의 테이블이란... 뷰가 실제로 존재하는 테이블(객체)이 아니라
--    하나 이상의 테이블에서 파생된 또 다른 정보를 볼 수 있는 방법이며
--    그 정보를 추출해내는 SQL 문장이라고 볼 수 있다.

-- 2. 형식 및 구조
-- CREATE [OR REPLACE] VIEW 뷰이름
-- [(ALIAS[, ALIAS, ...])]
-- AS
-- 서브쿼리(SUBQUERY)
-- [WITH CHECK OPTION]
-- [WITH READ ONLY]


--○ 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_EMPLOYEES
AS
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY
, C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID;
--==>> View VIEW_EMPLOYEES이(가) 생성되었습니다.


SELECT *
FROM VIEW_EMPLOYEES;
--==>>
/*
...
*/


--○ 뷰(VIEW)의 구조 조회
DESC VIEW_EMPLOYEES;
--==>>
/*
이름              널?       유형           
--------------- -------- ------------ 
FIRST_NAME               VARCHAR2(20) 
LAST_NAME       NOT NULL VARCHAR2(25) 
DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
CITY            NOT NULL VARCHAR2(30) 
COUNTRY_NAME             VARCHAR2(40) 
REGION_NAME              VARCHAR2(25) 
*/



--○ 뷰(VIEW) 소스 확인 -- CHECK~!!!
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



