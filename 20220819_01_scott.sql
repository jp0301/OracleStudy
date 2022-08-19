SELECT USER
FROM DUAL;
--==>> SCOTT

-- TBL_EMP 테이블로 조회를 하면 정상적인 결과값이 출력되지 않음
-- 새로 추가한 데이터들의 합은 모든부서가 들어가면안됨
SELECT NVL(TO_CHAR(DEPTNO), '모든부서') "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	        8750
20	        10875
30	        9400
모든부서    	8700
모든부서	    37725
*/

SELECT NVL2(DEPTNO, TO_CHAR(DEPTNO), '모든부서') "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	        8750
20	        10875
30	        9400
모든부서    	8700
모든부서	    37725
*/

-- GROUPING()
SELECT GROUPING(DEPTNO) "GROUPING", DEPTNO "부서번호" , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
---------- ---------- ----------
  GROUPING    부서번호     급여합
---------- ---------- ----------
         0         10       8750
         0         20      10875
         0         30       9400
         0      (null)      8700
         1      (null)     37725
---------- ---------- ----------
*/


SELECT DEPTNO "부서번호" , SUM(SAL) "급여합"
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

--○ 위에서 조회한 해당 내용을
/*
10	      8750
20	     10875
30	      9400
인턴	  8700
모든부서 37725
*/
-- 이와 같이 조회되도록 쿼리문을 구성한다.

--※ 참고 위에 그룹핑 구문 참고
SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴') 
            ELSE '모든부서'
       END "부서번호"
,      SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	      8750
20	     10875
30	      9400
인턴	  8700
모든부서	 37725
*/

--○ 같이 풀이
-- 1. THEN DEPTNO를 넣으면 숫자형이기 때문에 → 에러 발생
-- 2. 따라서 DEPTNO를 문자타입으로 바꿔준다. → 부서번호는 정상 출력, NULL 남음
-- 3. NULL 값 처리, NVL(TO_CHAR(DEPTNO), '인턴')
-- 4. 해결





--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

--○ TBL_SAWON 테이블을 대상으로
--   다음과 같이 조회될 수 있도록 쿼리문을 구성한다.
/*
----------------- ---------------------
 성별              급여합
----------------- ---------------------
 남                  xxxx
 여                 xxxxx
 모든사원          xxxxxx
----------------- ---------------------
*/

-- 1단계
SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여'
            ELSE '몰러'
       END "성별"
    
    , SAL "급여"
FROM TBL_SAWON;


-- 2단계 
SELECT T.성별 "성별"
     , SUM(T.급여) "급여합"
FROM
(   
    SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여'
                ELSE '성별확인불가'
           END "성별"
        
        , SAL "급여"
    FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.성별);
    

-- 3단계 
SELECT NVL(T.성별, '모든사원') "성별"
       -- CASE GROUPING(T.성별) WHEN 0 THEN T.성별 ELSE '모든사원' END "성별"
     , SUM(T.급여) "급여합"
FROM
(   
    SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여'
                ELSE '성별확인불가'
           END "성별"
        
        , SAL "급여"
    FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.성별);
--==>>
/*
성별        급여합
---------- ---------
남	        11000
여	        31800
모든사원    	42800
*/
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--○ TBL_SAWON 테이블을 대상으로
--   다음과 같이 조회될 수 있도록 쿼리문을 구성한다.
/*
--------- ------------
연령대    인원수
--------- ------------
10            ㅌ
20            ㅌ
30            ㅌ
50            ㅌ
전체          16
--------- ------------
*/

SELECT *
FROM TBL_SAWON;


-- 방법 1. → INLINE VIEW 를 두 번 중첩
SELECT NVL(TO_CHAR(T2.연령대), '전체') "연령대"
-- CASE GROUPING(T2.연령대) WHEN 0 THEN TO_CHAR(T2.연령대) ELSE '전체'
, COUNT(*) "인원수"
FROM
(
    SELECT 
        --연령대
        CASE WHEN T1.나이 >=50 THEN 50
             WHEN T1.나이 >=40 THEN 40
             WHEN T1.나이 >=30 THEN 30
             WHEN T1.나이 >=20 THEN 20
             WHEN T1.나이 >=10 THEN 10
             ELSE 0
        END "연령대"
        
    FROM
    (
        --나이
        SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) +1899) 
                    WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') 
                    THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) +1999) 
                    ELSE -1
               END "나이"
        FROM TBL_SAWON
    ) T1
) T2
GROUP BY ROLLUP(T2.연령대);



-- 방법 2. → INLINE VIEW 를 한 번 사용
SELECT
  CASE WHEN T.연령대 IS NULL THEN '전체'
       ELSE TO_CHAR(T.연령대)
  END "연령대"
, COUNT(*) "인원수"

FROM
(
    SELECT
        TRUNC(CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
             THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
             WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
             THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
             ELSE 0
             END, -1) "연령대"
    FROM TBL_SAWON
) T
GROUP BY ROLLUP(T.연령대);
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■



SELECT DEPTNO
, JOB "직종"
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


--○ CUBE() → ROLLUP() 보다 더 자세한 결과를 반환받는다.
SELECT DEPTNO
, JOB "직종"
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
	ANALYST	    6000 -- 모든 부서 ANALYST 직종의 급여합 --추가
	CLERK	    4150 -- ...
	MANAGER	    8275 -- ...
	PRESIDENT	5000
	SALESMAN	    5600
                29025
*/

--※ ROLLUP()과 CUBE()는
--   그룹을 묶어주는 방식이 다르다. (차이)

-- ex.

-- ROLLUP(A, B, C)
-- → (A, B, C) / (A, B) / (A) / ()

-- CUBE(A, B, C)
-- → (A,B,C) / (A,B) / (A,C) / (B,C) / (A) / (B) / (C) / ()

--==>> 위의 과정은(ROLLUP)) 묶음 방식이 다소 모자랄 때가 있고
--     아래 과정은(CUBE()) 묶음 방식이 다소 지나칠 때가 있기 때문에
--     다음과 같은 방식의 쿼리를 더 많이 사용하게 된다.
--     다음 작성하는 쿼리는 조회하고자 하는 그룹만
--     GROUPING SETS 를 이용하여 묶어주는 방식이다.


SELECT *
FROM TBL_EMP;

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
                             ELSE '전체부서'                      
       END "부서번호"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '전체직종' 
         END "직종"
       , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY 1, 2;
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        전체직종	    8750

20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        전체직종	    10875

30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	    5600
30	        전체직종	    9400

인턴	    CLERK	    3500
인턴	    SALESMAN	    5200
인턴	    전체직종	    8700

전체부서	    전체직종	    37725
*/

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
                             ELSE '전체부서'                      
       END "부서번호"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '전체직종' 
         END "직종"
       , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY 1, 2;
/*
10	        CLERK	    1300
10	        MANAGER	    2450
10	        PRESIDENT	5000
10	        전체직종	    8750

20	        ANALYST	    6000
20	        CLERK	    1900
20	        MANAGER	    2975
20	        전체직종	    10875

30	        CLERK	    950
30	        MANAGER	    2850
30	        SALESMAN	    5600
30	        전체직종	    9400

인턴	    CLERK	    3500
인턴	    SALESMAN    	5200
인턴	    전체직종	    8700

전체부서	    ANALYST	    6000
전체부서    	CLERK	    7650
전체부서    	MANAGER	    8275
전체부서	    PRESIDENT	5000
전체부서	    SALESMAN	    10800

전체부서	    전체직종	    37725
*/

--○ GROUPING SETS
-- GROUPING SETS 는 커스터마이징하는 것이라고 생각하면됨
SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
                             ELSE '전체부서'                      
       END "부서번호"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '전체직종' 
         END "직종"
       , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY GROUPING SETS((DEPTNO, JOB), (DEPTNO), (JOB), ())
ORDER BY 1, 2;
-- GROUP BY GROUPING SETS((DEPTNO, JOB), (DEPTNO), (JOB), ())
-- 이렇게 되면 CUBE()를 사용한 결과와 같은 조회 결과 반환

SELECT CASE GROUPING(DEPTNO) WHEN 0 THEN NVL(TO_CHAR(DEPTNO), '인턴')
                             ELSE '전체부서'                      
       END "부서번호"
       , CASE GROUPING(JOB) WHEN 0 THEN JOB
                            ELSE '전체직종' 
         END "직종"
       , SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY GROUPING SETS((DEPTNO, JOB), (DEPTNO), ())
ORDER BY 1, 2;
-- ROLLUP() 을 사용한 결과와 같은 조회 결과 반환


--------------------------------------------------------------------------------

SELECT *
FROM TBL_EMP
ORDER BY HIREDATE;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

SELECT *
FROM TBL_EMP
ORDER BY HIREDATE;


--○ TBL_EMP 테이블을 대상으로
--   입사년도별 인원수를 조회한다.

SELECT T.입사년도
,      COUNT(*) "인원수"
FROM
(
    SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
    FROM TBL_EMP
) T
GROUP BY T.입사년도
ORDER BY T.입사년도;


SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
, COUNT(*) "인원수"
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

SELECT EXTRACT(YEAR FROM HIREDATE) "입사년도"
, COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY ROLLUP(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;

SELECT TO_CHAR(HIREDATE, 'YYYY') "입사년도"
, COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY EXTRACT(YEAR FROM HIREDATE)
ORDER BY 1;
--==>> ORA-00979: not a GROUP BY expression

SELECT TO_CHAR(HIREDATE, 'YYYY') "입사년도"
, COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY ROLLUP(TO_CHAR(HIREDATE, 'YYYY'))
ORDER BY 1;




SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 
            THEN EXTRACT(YEAR FROM HIREDATE)
            ELSE '전체'
       END "입사년도"
    , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>> 에러 발생 ORA-00932: inconsistent datatypes: expected NUMBER got CHAR


SELECT CASE GROUPING(TO_CHAR(HIREDATE, 'YYYY')) WHEN 0 
            THEN EXTRACT(YEAR FROM HIREDATE)
            ELSE '전체'
       END "입사년도"
    , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;


SELECT CASE GROUPING(TO_CHAR(HIREDATE, 'YYYY')) WHEN 0 
            THEN TO_CHAR(HIREDATE, 'YYYY')
            ELSE '전체'
       END "입사년도"
    , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>> 에러 발생 ORA-00979: not a GROUP BY expression



SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 
            THEN TO_CHAR(HIREDATE, 'YYYY')
            ELSE '전체'
       END "입사년도"
    , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;
--==>> 에러 발생 ORA-00979: not a GROUP BY expression


SELECT CASE GROUPING(TO_CHAR(HIREDATE, 'YYYY')) WHEN 0 
            THEN TO_CHAR(HIREDATE, 'YYYY')
            ELSE '전체'
       END "입사년도"
    , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(TO_CHAR(HIREDATE, 'YYYY'))
ORDER BY 1;
/*
1980	    1
1981	10
1982	    1
1987	2
2022	    5
전체	    19
*/

SELECT CASE GROUPING(EXTRACT(YEAR FROM HIREDATE)) WHEN 0 
            THEN EXTRACT(YEAR FROM HIREDATE)
            ELSE -1
       END "입사년도"
    , COUNT(*) "인원수"
FROM TBL_EMP
GROUP BY CUBE(EXTRACT(YEAR FROM HIREDATE))
ORDER BY 1;

--------------------------------------------------------------------------------

--■■■ HAVING ■■■--

--○ EMP테이블에서 부서 번호가 20, 30인 부서를 대상으로
--   부서의 총 급여가 10000 보다 적을 경우만 부서별 총 급여를 조회한다.


SELECT *
FROM EMP;


SELECT DEPTNO, SUM(SAL)
FROM EMP
WHERE DEPTNO IN (20, 30) -- OR
AND SUM(SAL) < 10000
GROUP BY DEPTNO;
--==>> 에러 발생 ORA-00934: group function is not allowed here


SELECT DEPTNO, SUM(SAL) "부서별총합계"
FROM EMP
WHERE DEPTNO IN (20, 30) -- OR
GROUP BY DEPTNO
HAVING SUM(SAL) < 10000;
--==>> 30    9400


SELECT DEPTNO, SUM(SAL) "부서별총합계"
FROM EMP
GROUP BY DEPTNO
HAVING SUM(SAL) < 10000
   AND DEPTNO IN (20, 30);
-- 논리적으로 맞지만
-- 하지만 WHERE 쓴 구문이 더 바람직한 구문이다.

--------------------------------------------------------------------------------

--■■■ 중첩 그룹함수 / 분석함수 ■■■--

-- 그룹 함수는 2 LEVEL 까지 중첩해서 사용할 수 있다.

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
--> ORACLE 9i 부터 적용.... MSSQL 2005 부터 적용...

--> 하위 버전에서는 RANK() 나 DENSE_RANK() 를 사용할 수 없기 때문에
--  예를 들어... 급여 순위를 구하고자 한다면...
--  해당 사원의 급여보다 더 큰 값이 몇 개인지 확인한 후
--  확인한 숫자에 +1을 추가 연산해주면...
--  그 값이 곧 해당 사원의 등수가 된다.

SELECT ENAME, SAL
FROM EMP;


SELECT COUNT(*) + 1
FROM EMP
WHERE SAL > 800;    -- SMITH의 급여
--==>> 14           -- SMITH의 급여 등수


SELECT COUNT(*) + 1
FROM EMP
WHERE SAL > 1600;    -- SMITH의 급여
--==>> 8


--※ 서브 상관 쿼리(상관 서브 쿼리)
--   메인 쿼리가 있는 테이블의 컬럼이
--   서브 쿼리의 조건절(WHERE 절, HAVING 절)에 사용되는 경우
--   우리는 이 쿼리문을 서브 상관 쿼리(상관 서브 쿼리)라고 부른다.

SELECT ENAME "사원명" , SAL "급여", 1 "급여등수"
FROM EMP;



SELECT ENAME "사원명" , SAL "급여", (1) "급여등수"
FROM EMP;

SELECT ENAME "사원명" , SAL "급여" 
, (SELECT COUNT(*) + 1
   FROM EMP
   WHERE SAL > 800) "급여등수"
FROM EMP;


SELECT E.ENAME "사원명" , E.SAL "급여" 
, (SELECT COUNT(*) + 1
   FROM EMP
   WHERE SAL > E.SAL) "급여등수"
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


--○ EMP 테이블을 대상으로
--   사원명, 급여, 부서번호, 부서내급여등수, 전체급여등수 항목을 조회한다.
--   단, RANK() 함수를 사용하지 않고 서브상관쿼리를 활용할 수 있도록 한다.


SELECT E.ENAME "사원명", E.DEPTNO "부서번호", E.SAL "급여"

,( SELECT COUNT(*) + 1
   FROM EMP
   WHERE SAL > E.SAL AND DEPTNO = E.DEPTNO
 ) "부서내급여등수"

,(SELECT COUNT(*) + 1
  FROM EMP
  WHERE SAL > E.SAL) "전체급여등수"

FROM EMP E


ORDER BY DEPTNO, SAL DESC;
/*
사원명 부서번호 급여 부서내급여등수 전체급여등수
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



--○ EMP 테이블을 대상으로 다음과 같이 조회될 수 있도록 쿼리문을 구성한다.
/*
                                            -각 부서 내에서 입사일자별로 누적된 급여의 합
--------------------------------------------------------------------------
 사원명 부서번호      입사일        급여    부서내입사별급여누적
--------------------------------------------------------------------------
 SMITH	   20	    1980-12-17	     800		    800
 JONES	   20       1981-04-02	     2975		3775
 FORD      20       1981-12-03     	3000	     	6775
 SCOTT	   20     	1987-07-13	    3000		    9775
 ADAMS	   20        1987-07-13	    1100		    10875

*/

SELECT
ENAME "사원명"
, DEPTNO "부서번호"
, HIREDATE "입사일"
, SAL "급여"
, (
SELECT SUM(SAL)
FROM EMP
WHERE DEPTNO = E.DEPTNO
AND HIREDATE <= E.HIREDATE

) "부서내입사별급여누적"
FROM EMP E
ORDER BY DEPTNO, HIREDATE;



SELECT E1.ENAME "사원명", E1.DEPTNO "부서번호", E1.HIREDATE "입사일", E1.SAL "급여"
     , (
     
     SELECT SUM(E2.SAL)
     FROM EMP E2
     WHERE E2.DEPTNO = E1.DEPTNO
     
     ) "부서내입사별급여누적"
FROM SCOTT.EMP E1
ORDER BY 2, 3;




SELECT E1.ENAME "사원명", E1.DEPTNO "부서번호", E1.HIREDATE "입사일", E1.SAL "급여"
     , (
     
     SELECT SUM(E2.SAL)
     FROM EMP E2
     WHERE E2.DEPTNO = E1.DEPTNO
       AND E2.HIREDATE <= E1.HIREDATE
     ) "부서내입사별급여누적"
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



--○ EMP 테이블을 대상으로
--   입사한 사원의 수가 가장 많았을 때의
--  입사년월과 인원수를 조회할 수 있도록 쿼리문을 구성한다.
/*
---------- -------------------
 입사년월   인원수
---------- -------------------
 1981-02      2
 1981-09      2
 1987-07      2
---------- -------------------
*/


SELECT *
FROM EMP;

SELECT T.입사년월 "입사년월", COUNT(*) "인원수"
FROM 
(
    SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "입사년월"
    FROM EMP
) T
GROUP BY T.입사년월
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM EMP GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM'));
--==>>
/*
1981-12	2
1981-09	2
1981-02	2
1987-07	2
*/


SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "입사년월"
, COUNT(*) "인원수"
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM EMP GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM'));
--COUNT(*) = (입사년월 기준 최대 인원);



