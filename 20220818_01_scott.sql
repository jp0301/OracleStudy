SELECT USER
FROM DUAL;
--==>> SCOTT


--○ CASE 구문(조건문, 분기문)
/*
CASE
WHEN
THEN
ELSE
END
*/

SELECT CASE 5+2 WHEN 4 THEN '5+2=4' ELSE '5+2는 몰라요' END
FROM DUAL;
--==>> 5+2는 몰라요

SELECT CASE 5+2 WHEN 7 THEN '5+2=7' ELSE '5+2는 몰라요' END
FROM DUAL;
--==>> 5+2=7

SELECT CASE 1+1 WHEN 2 THEN '1+1=2'
                WHEN 3 THEN '1+1=3'
                WHEN 4 THEN '1+1=4'
                ELSE '몰라'
       END
FROM DUAL;
--==>> 1+1=2

SELECT CASE 1+1 WHEN 2 THEN '1+1=2'
                WHEN 3 THEN '1+1=3'
                WHEN 2 THEN '1+1=4'
                ELSE '몰라'
       END
FROM DUAL;
--==>> 1+1=2

SELECT CASE WHEN 5+2=4 THEN '5+2=4'
            WHEN 6-3=2 THEN '6-3=2'
            WHEN 2*1=2 THEN '2*1=2'
            WHEN 6/3=3 THEN '6/3=3'
            ELSE '몰라'
       END
FROM DUAL;
--==>> 2*1=2

SELECT CASE WHEN 5+2=7 THEN '5+2=7'
            WHEN 6-3=3 THEN '6-3=3'
            WHEN 2*1=2 THEN '2*1=2'
            WHEN 6/3=2 THEN '6/3=2'
            ELSE '몰라'
       END
FROM DUAL;
--==>> 5+2=7



--○ DECODE() 
SELECT DECODE(5-2, 1, '5-2=1', 2, '5-2=2', 3, '5-3=3', '5-2는 몰라요') "결과확인"
FROM DUAL;
--==>> 5-3=3


--○ CASE WHEN THEN ELSE END (조건문, 분기문) 활용
SELECT CASE WHEN 5<2 THEN '5<2'
            WHEN 5>2 THEN '5>2'
            ELSE '5와 2는 비교 불가'
       END "결과확인"
FROM DUAL;
--==>> 5>2

SELECT CASE WHEN 3<1 AND 5<2 OR 3>1 AND 2=2 THEN '대한만세'
            WHEN 5>2 OR 2=3 THEN '민국만세'
            ELSE '만만만세'
       END "결과확인"
FROM DUAL;
--==>> 대한만세


SELECT CASE WHEN 3<1 AND 5<2 OR 3>1 AND 2=2 THEN '1등만세'
            WHEN 5<2 AND 2=3 THEN '2등만세'
            ELSE '3등만세'
       END "결과확인"
FROM DUAL;
--==>> 1등만세



SELECT CASE WHEN 3<1 AND (5<2 OR 3>1) AND 2=2 THEN '대한만세'
            WHEN 5<2 AND 2=3 THEN '민국만세'
            ELSE '만만만세'
       END "결과확인"
FROM DUAL;
--==>> 만만만세


-- 실습
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.


SELECT *
FROM TBL_SAWON;
--==>> TBL_SAWON 테이블 조회


--○ TBL_SAWON 테이블을 활용하여 다음과 같은 항목을 조회할 수 있도록 쿼리문 구성
--   사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일
--   정년퇴직일, 근무일수, 남은일수, 급여, 보너스
--   단, 현재나이는 기본 한국나이 계산법에 따라 연산을 수행한다.
--   또한, 정년퇴직일은 해당 직원의 나이가 한국 나이로 60세가 되는 해의
--   그 직원의 입사 월, 일로 연산을 수행한다.
--   그리고, 보너스는 1000일 이상 2000일 미만 근무한 사원은
--   그 사원의 원래 급여 기준 30% 지급, 2000일 이상 근무한 사원은
--   그 사원의 원래 급여 기준 50% 지급을 할 수 있도록 처리한다.

SELECT SANO "사원번호",  SANAME "사원명", JUBUN "주민번호"
   -- 주번 7번째 1개 1,3이면 남자, 2,4면 여자
,  CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '남성'
        WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '여성'
   END"성별"
   --현재년도 - 태어난년도 + 1
,  CASE WHEN SUBSTR(JUBUN, 1, 1) = '0' THEN EXTRACT(YEAR FROM SYSDATE) - TO_NUMBER(CONCAT('20', SUBSTR(JUBUN, 1, 2)))+1
        ELSE EXTRACT(YEAR FROM SYSDATE) - TO_NUMBER(CONCAT('19', SUBSTR(JUBUN, 1, 2)))+1
   END "현재나이" 
, HIREDATE "입사일"

--1 , EXTRACT(YEAR FROM HIREDATE) " 테스트"                                                --2005
--2 , EXTRACT(YEAR FROM HIREDATE) - TO_NUMBER(SUBSTR(JUBUN, 1, 2))                           --2005-1994=1911
--3 , (EXTRACT(YEAR FROM HIREDATE) - TO_NUMBER(SUBSTR(JUBUN, 1, 2))-1900 +1)                  --2005-1994-1900 +1 = 12
--4 , 60 - (EXTRACT(YEAR FROM HIREDATE) - TO_NUMBER(SUBSTR(JUBUN, 1, 2)) - 1900 + 1) || '-00' -- 60-12 = 48-00
, CASE WHEN SUBSTR(JUBUN, 1, 1) = '0'
       THEN HIREDATE + TO_YMINTERVAL(CONCAT(60 - (EXTRACT(YEAR FROM HIREDATE) - TO_NUMBER(SUBSTR(JUBUN, 1, 2)) - 2000 + 1), '-00'))
       ELSE HIREDATE + TO_YMINTERVAL(CONCAT(60 - (EXTRACT(YEAR FROM HIREDATE) - TO_NUMBER(SUBSTR(JUBUN, 1, 2)) - 1900 + 1), '-00'))     
  END "정년퇴직일"
,  TRUNC(SYSDATE - HIREDATE) "근무일수"
, CASE WHEN SUBSTR(JUBUN, 1, 1) = '0'
       THEN TRUNC(HIREDATE + TO_YMINTERVAL(60 - (EXTRACT(YEAR FROM HIREDATE) - TO_NUMBER(SUBSTR(JUBUN, 1, 2)) - 2000 + 1) || '-00') - SYSDATE)+2
       ELSE TRUNC(HIREDATE + TO_YMINTERVAL(60 - (EXTRACT(YEAR FROM HIREDATE) - TO_NUMBER(SUBSTR(JUBUN, 1, 2)) - 1900 + 1) || '-00') - SYSDATE)+2     
  END  "남은일수"
, SAL "급여"
,  CASE WHEN (TRUNC(SYSDATE - HIREDATE, 0)+1) >= 1000 AND TRUNC(SYSDATE - HIREDATE, 0)+1 < 2000 THEN (SAL * 0.30)
        ELSE (SAL * 0.50)
    END "보너스"
FROM TBL_SAWON;

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

--  사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일, 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

--  사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일,  급여 먼저 처리

SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
    , CASE WHEN 주민번호 7번째자리 1개가 '1' 또는 '3' THEN '남성'
           WHEN 주민번호 7번째자리 1개가 '2' 또는 '4' THEN '여성'
           ELSE '성별확인불가'
           END "성별"
FROM TBL_SAWON;


SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
    -- 성별
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN('1', '3') THEN '남성'
           WHEN SUBSTR(JUBUN, 7, 1) IN('2', '4') THEN '여성'
           ELSE '성별확인불가'
      END "성별"  
             
FROM TBL_SAWON;


SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
    --현재 나이 = 현재년도 - 태어난 년도 + 1 (1900년대 / 2000년대)
    , CASE WHEN 1900년대 생이라면 THEN 현재년도 - (주민번호앞두자리 + 1899)
           WHEN 2000년대 생이라면 THEN 현재년도 - (주민번호앞두자리 + 1999)
           --ELSE '나이확인불가'
           ELSE -1
      END "현재나이"
      
      
    , CASE WHEN 주민번호 7번째자리 1개가 '1' 또는 '2'
           THEN 현재년도 - (주민번호앞두자리 + 1899)
           WHEN 주민번호 7번째자리 1개가 '1' 또는 '2'
           THEN 현재년도 - (주민번호앞두자리 + 1999)
           ELSE -1
      END "현재나이" 
      
      
      --현재 나이 = 현재년도 - 태어난 년도 + 1 (1900년대 / 2000년대)
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
           ELSE -1
      END "현재나이"        
FROM TBL_SAWON;


SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
    -- 입사일
    ,HIREDATE "입사일"
    -- 급여
    , SAL "급여"
FROM TBL_SAWON;



-- 잠깐 번외로 가서
SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉" , 연봉*2 "두배연봉"
FROM EMP;
--==>> 에러 발생(ORA-00904: "연봉": invalid identifier)

SELECT EMPNO, ENAME, SAL, COMM, 연봉
FROM 
(
    SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉"
    FROM EMP
);



SELECT 연봉*2 "두배연봉"
FROM 
(
    SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉"
    FROM EMP
);




CREATE VIEW VIEW_EMP
AS
SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉"
FROM EMP;
--==>> 에러 발생(권한 부족)

--○ SYS로 접속하여 SCOTT 계정에 CREATE VIEW 권한 부여 후 다시 시도
CREATE VIEW VIEW_EMP
AS
SELECT EMPNO, ENAME, SAL, COMM, SAL*12+NVL(COMM, 0) "연봉"
FROM EMP;
--==>> View VIEW_EMP이(가) 생성되었습니다.


SELECT *
FROM VIEW_EMP;
-- EMP테이블이 바뀌면 VIEW를 조회해도 바뀐 테이블로VIEW조회됨





-- 인라인 뷰
--  사원번호, 사원명, 주민번호, 성별, 현재나이, 입사일, 정년퇴직일, 근무일수, 남은일수, 급여, 보너스

SELECT T.사원번호, T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일

    -- 정년퇴직일
    -- 정년퇴직년도 → 해당 직원의 나이가 한국나이로 60세가 되는 해
    -- 현재 나이가... 57세...  3년 후   2022 → 2025
    -- 현재 나이가... 28세... 32년 후   2022 → 2054
    -- ADD_MONTHS(SYSDATE, 남은년수*12)
    -- 남은년수 : 60 - 현재나이
    -- ADD_MONTHS(SYSDATE, (60 - T.현재나이)*12) → 특정날짜
    -- TO_CHAR('특정날짜', 'YYYY')              → 정년퇴직 년도만 추출
    -- TO_CHAR('입사일', 'MM-DD')                → 입사 월일만 추출
    -- TO_CHAR('특정날짜', 'YYYY') || '-' || TO_CHAR('입사일', 'MM-DD') → 정년퇴직일
    -- TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이)*12), 'YYYY') || '-' || TO_CHAR(T.입사일, 'MM-DD')
    , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이)*12), 'YYYY') 
      || '-' || TO_CHAR(T.입사일, 'MM-DD') "정년퇴직일"
    
    -- 근무일수
    -- 근무일수 = 현재일 - 입사일
    , TRUNC(SYSDATE - T.입사일) "근무일수"
    
    -- 남은일수
    -- 남은일수 = 정년퇴직일 - 현재일
    , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이)*12), 'YYYY') 
      || '-' || TO_CHAR(T.입사일, 'MM-DD'), 'YYYY-MM-DD') - SYSDATE) "남은일수"
    
    -- 급여
    , T.급여
    
    -- 보너스
    -- 근무일수가 1000일 이상 2000일 미만이면 급여의 30% 지급
    -- 근무일수가 2000일 이상이면 급여의 50% 지급
    -- 나머지 보너스 없다.
    --------------------------------------------------------
    -- 근무일수가 2000일 이상 급여의 50% 지급 → 급여 * 0.5
    -- 근무일수가 1000일 이상 급여의 30% 지급 → 급여 * 0.3
    
    ,  CASE WHEN TRUNC(SYSDATE - T.입사일) >= 2000 THEN T.급여 * 0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 1000 THEN T.급여 * 0.3
            ELSE 0
       END "보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"
    
        -- 성별
        , CASE WHEN SUBSTR(JUBUN, 7, 1) IN('1', '3') THEN '남성'
               WHEN SUBSTR(JUBUN, 7, 1) IN('2', '4') THEN '여성'
               ELSE '성별확인불가'
          END "성별"  
                 
          --현재 나이 = 현재년도 - 태어난 년도 + 1 (1900년대 / 2000년대)
        , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
               WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
               ELSE -1
          END "현재나이"        
    
        -- 입사일
        ,HIREDATE "입사일"
        
        -- 급여
        , SAL "급여"
        
        
    FROM TBL_SAWON
) T;


-- 위에서 처리한 내용을 기반으로
-- 특정 근무일수의 사원을 확인해야 한다거나...
-- 특정 보너스 금액을 받는 사원을 확인해야 할 경우가 발생할 수 있다.
-- (즉, 추가적인 조회 조건이 발생하거나, 업무가 파생되는 경우)
-- 이와 같은 경우... 해당 쿼리문을 다시 구성해야 하는 번거로움을 줄일 수 있도록
-- 뷰(VIEW)를 만들어 저장해 둘 수 있다.


-- OR REPLACE VIEW가 기존에 없으면 만들고 있으면 새로 갱신한다.
CREATE OR REPLACE VIEW VIEW_SAWON
AS
SELECT T.사원번호, T.사원명, T.주민번호, T.성별, T.현재나이, T.입사일
    , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이)*12), 'YYYY') 
      || '-' || TO_CHAR(T.입사일, 'MM-DD') "정년퇴직일"
    , TRUNC(SYSDATE - T.입사일) "근무일수"
    , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.현재나이)*12), 'YYYY') 
      || '-' || TO_CHAR(T.입사일, 'MM-DD'), 'YYYY-MM-DD') - SYSDATE) "남은일수"

    , T.급여
    ,  CASE WHEN TRUNC(SYSDATE - T.입사일) >= 2000 THEN T.급여 * 0.5
            WHEN TRUNC(SYSDATE - T.입사일) >= 1000 THEN T.급여 * 0.3
            ELSE 0
       END "보너스"
FROM
(
    SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호"

        , CASE WHEN SUBSTR(JUBUN, 7, 1) IN('1', '3') THEN '남성'
               WHEN SUBSTR(JUBUN, 7, 1) IN('2', '4') THEN '여성'
               ELSE '성별확인불가'
          END "성별"  

        , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
               WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
               ELSE -1
          END "현재나이"        
        ,HIREDATE "입사일"
        , SAL "급여"
    FROM TBL_SAWON
) T;
--==>> View VIEW_SAWON이(가) 생성되었습니다


SELECT *
FROM VIEW_SAWON;
--==>> 위의 구문과 같은 결과값 출력됨

SELECT *
FROM VIEW_SAWON
WHERE 근무일수 >= 5000;
--==>> 근무일수 5000이상 조회 값 출력됨

SELECT *
FROM VIEW_SAWON
WHERE 보너스 >= 2000;
--==>> 보너스 2000이상 조회 값 출력됨





--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--○ 서브쿼리를 활용하여
--   TBL_SAWON 테이블을 다음과 같이 조회할 수 있도록 한다.
/*
------------------------------------------------
 사원명    성별    현재나이    급여   나이보너스
------------------------------------------------
*/
-- 단, 나이보너스는 현재 나이가 40세 이상이면 급여의 70%
-- 30세 이상 40에 미만이면 급여의 50%
-- 20세 이상 30세 미만이면 급여의 30%

-- 또한, 이렇게 완성된 조회 구문을 통해
-- VIEW_SAWON2 라는 이름의 뷰(VIEW)를 생성할 수 있도록 한다.

CREATE OR REPLACE VIEW VIEW_SAWON2
AS
SELECT A.*

    -- 나이보너스
    ,CASE WHEN A.현재나이 >= 40 THEN A.급여 * 0.7
         WHEN A.현재나이 >= 30 THEN A.급여 * 0.5
         WHEN A.현재나이 >= 20 THEN A.급여 * 0.3
         ELSE 0
    END "나이보너스"
    
FROM
(
    SELECT SANAME "사원명"
        -- 성별
        , CASE WHEN SUBSTR(JUBUN, 7, 1) IN('1', '3') THEN '남성'
               WHEN SUBSTR(JUBUN, 7, 1) IN('2', '4') THEN '여성'
               ELSE '성별확인불가'
          END "성별"
          
        -- 현재 나이
        , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
               WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
               THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
               ELSE -1
          END "현재나이" 
           
        -- 급여
        , SAL "급여"
    FROM TBL_SAWON
) A;
--==>> View VIEW_SAWON2이(가) 생성되었습니다.

SELECT *
FROM VIEW_SAWON2;
--==>>
/*
고연수	    여성  	29	3000    	 900
김보경	    여성  	25	2000	     600
정미경	    여성  	25	4000	    1200
김인교	    남성  	30	2000    	1000
이정재	    남성  	53	1000	     700
아이유	    여성  	30	3000    	1500
이하이	    여성	    20	4000	    1200
인순이	    여성  	55	1500	    1050
선동렬	    남성  	56	1300	     910
선우용녀	    여성  	58	2600	    1820
선우선	    여성  	18	1300    	   0
남궁민	    남성  	22	2400	     720
남진	        남성  	21	2800	     840
반보영	    여성	    24	5200	    1560
한은영	    여성  	24	5200	    1560
이이경	    남성  	17	1500	       0
*/
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-- 또 다른 함수들
-- 그동안은 단일 행 다중 행 복수의 레코드를 기반으로 동작하는 함수들을 들여다보겠다.

--○ RANK() -> 등수 (순위)를 반환하는 함수

SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(ORDER BY SAL DESC) "전체급여순위"
FROM EMP;
/*
7839	KING	10	5000	             1
7902	FORD	20	3000	             2
7788	SCOTT	20	3000	     2
7566	JONES	20	2975	         4
7698	BLAKE	30	2850    	     5
7782	CLARK	10	2450	         6
7499	ALLEN	30	1600	         7
7844	TURNER	30	1500	     8
7934	MILLER	10	1300	         9
7521	WARD	30	1250	            10
7654	MARTIN	30	1250	        10
7876	ADAMS	20	1100	    12
7900	JAMES	30	950	        13
7369	SMITH	20	800	        14
*/


SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서별급여순위"
     , RANK() OVER(ORDER BY SAL DESC) "전체급여순위"
FROM EMP;


SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서별급여순위"
FROM EMP
ORDER BY DEPTNO;
--==>>
/*
7839    	KING	    10	5000	    1	
7782	    CLARK	10	2450	    2	
7934	    MILLER	10	1300	    3	
7902	    FORD	    20	3000	    1	
7788	SCOTT	20	3000	    1	
7566    	JONES	20	2975	    3	
7876	ADAMS	20	1100    	4	
7369	    SMITH	20	800	    5	
7698	    BLAKE	30	2850	    1
7499    	ALLEN	30	1600	    2	
7844	TURNER	30	1500	    3	
7654    	MARTIN	30	1250	    4	
7521    	WARD	    30	1250    	4	
7900    	JAMES	30	950	    6	
*/


--○ DENSE_RANK() → 서열을 반환하는 함수

SELECT EMPNO "사원번호", ENAME "사원명", DEPTNO "부서번호", SAL "급여"
       , DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "부서별급여서열"
       , DENSE_RANK() OVER(ORDER BY SAL DESC) "전체급여서열"
FROM EMP
ORDER BY 3, 4 DESC;
/*
7839    	KING	    10	5000	    1	1
7782    	CLARK	10	2450	    2	5
7934	    MILLER	10	1300	    3	8
7902	    FORD	    20	3000	    1	2
7788	SCOTT	20	3000	    1	2
7566	    JONES	20	2975	    2	3
7876	ADAMS	20	1100	    3	10
7369	    SMITH	20	800	    4	12
7698    	BLAKE	30	2850	    1	4
7499	    ALLEN	30	1600	    2	6
7844	TURNER	30	1500	    3	7
7654	    MARTIN	30	1250	    4	9
7521	    WARD	    30	1250    	4	9
7900	    JAMES	30	950	    5	11
*/


--○ EMP 테이블의 사원 데이터를
--   사원명, 부서번호, 연봉, 부서내연봉순위, 전체연봉순위 항목으로 조회한다.
SELECT ENAME "사원명"
     , DEPTNO "부서번호"
     , SAL*12+NVL(COMM, 0) "연봉"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY (SAL*12+NVL(COMM, 0)) DESC) "부서내연봉순위"
     , RANK() OVER(ORDER BY (SAL*12+NVL(COMM, 0)) DESC) "전체연봉순위"
FROM EMP;
--==>> 
/*
KING    	10	60000	1	1
FORD	    20	36000	1	2
SCOTT	20	36000	1	2
JONES	20	35700	3	4
BLAKE	30	34200	1	5
CLARK	10	29400	2	6
ALLEN	30	19500	2	7
TURNER	30	18000	3	8
MARTIN	30	16400	4	9
MILLER	10	15600	3	10
WARD	    30	15500	5	11
ADAMS	20	13200	4	12
JAMES	30	11400	6	13
SMITH	20	9600	    5	14
*/

SELECT T.*
, RANK() OVER(PARTITION BY T.부서번호 ORDER BY T.연봉 DESC) "부서내연봉순위"
, RANK() OVER(ORDER BY T.연봉 DESC) "전체연봉순위"
FROM
(
    SELECT ENAME "사원명"
         , DEPTNO "부서번호"
         , SAL*12+NVL(COMM, 0) "연봉"
    FROM EMP
) T;



--○ EMP 테이블에서 전체 연봉 순위(등수)가 1등 부터 5등까지만...
--  사원명, 부서번호, 연봉, 전체연봉순위 항목으로 조회한다.

SELECT ENAME "사원명", DEPTNO "부서번호", SAL * 12 + NVL(COMM, 0) "연봉"
    , RANK() OVER(ORDER BY (SAL*12+NVL(COMM, 0)) DESC) "전체연봉순위"
FROM EMP
WHERE RANK() OVER(ORDER BY (SAL*12+NVL(COMM, 0)) DESC) <= 5;
--==>> 에러 발생
--     (ORA-30483: window  functions are not allowed here)
--※ 위의 내용은 RANK() OVER() 함수를 WHERE 조건절에서 사용한 경우이며...
--   이 함수는 WHERE 조건절에서 사용할 수 없기 때문에 발생하는 에러이다.
--   이 경우, 우리는 INLINE VIEW 를 활용해서 풀이해야 한다.


SELECT T.*  
FROM
(
    SELECT ENAME "사원명"
    , DEPTNO "부서번호"
    , SAL*112+NVL(COMM, 0) "연봉"
    , RANK() OVER(ORDER BY (SAL*12+NVL(COMM, 0)) DESC) "전체연봉순위"
    FROM EMP
    
) T
WHERE T.전체연봉순위 <= 5;



--○ EMP 테이블에서 각 부서별로 연봉 등수가 1등 부터 2등까지만 조회한다.
-- 사원명, 부서번호, 연봉, 부서내연봉등수, 전체연봉등수
-- 항목을 조회할 수 있도록 한다.

SELECT T.*
FROM
(
    SELECT ENAME "사원명"
    , DEPTNO "부서번호"
    , SAL * 12 + NVL(COMM, 0) "연봉"
    , RANK() OVER(PARTITION BY DEPTNO ORDER BY (SAL*12+NVL(COMM, 0)) DESC) "부서내연봉등수"
    , RANK() OVER(ORDER BY(SAL*12+NVL(COMM, 0)) DESC) "전체연봉등수"
    FROM EMP
) T
WHERE T.부서내연봉등수 BETWEEN 1 AND 2;


-- ※ 정정
-- TRIM() 함수 존재한다.
SELECT TRIM('         TEST        ') "RESULT"
FROM DUAL;
--==>> TEST

-- LN() 자연 로그 함수 존재한다.
SELECT LN(95) "RESULT"
FROM DUAL;
--==>> 4.55387689160054083460978676511404117675


--------------------------------------------------------------------------------
--■■■ 그룹 함수 ■■■--

-- SUM() 합, AVG() 평균, COUNT() 카운트, MAX() 최대값, MIN() 최소값
-- VARIENCE() 분산, STDDEV() 표준편차

--※ 그룹 함수의 가장 큰 특징
--   처리해야 할 데이터들 중 NULL 이 존재한다면(포함되어 있다면)
--   이 NULL 은 제외한 상태로 연산을 수행한다는 것이다.
--   즉, NULL 은 연산의대상에서 제외된다.

--○ SUM() 합
--EMP 테이블을 대상으로 전체 사원들의 급여 총합을 조회한다.
SELECT SAL
FROM EMP;
--==>> 레코드 14개

SELECT SUM(SAL) "급여 총합"
FROM EMP;
--==>> 29025

SELECT COMM
FROM EMP;
--==>> 널이 포함되어 있는 COMM 조회

SELECT SUM(COMM) -- NULL + 300 + 500 + ... + NULL -- (X)
FROM EMP;
--==>> 2200

--○ COUNT() 행(레코드)의 갯수 조회 → 데이터가 몇 건인지 확인....
SELECT COUNT(ENAME)
FROM EMP;
--==>> 14

SELECT COUNT(COMM)
FROM EMP;
--==>> 4

SELECT COUNT(*)
FROM EMP;
--==>> 14

--○ AVG() 평균 반환
SELECT AVG(SAL) "COL1"
    , SUM(SAL) / COUNT(SAL) "COL2"
FROM EMP;
--==>>
/*
2073.214285714285714285714285714285714286	
2073.214285714285714285714285714285714286
*/

SELECT AVG(COMM) "COL1"
, SUM(COMM) / COUNT(COMM) "COL2"
FROM EMP;
--==>> 550   550 -- 틀린 값이다.


SELECT COMM
FROM EMP;

SELECT 2200/14 "RESULT"
FROM DUAL;
--==>> 157.142857142857142857142857142857142857


--※ 데이터가 NULL 인 컬럼의 레코드는 연산 대상에서 제외되기 때문에
--   주의하여 연산 처리해야 한다.

-- VARIANCE(), STDDEV()
--※ 표준편차의 제곱이 분산, 분산의 제곱근이 표준편차

SELECT VARIANCE(SAL), STDDEV(SAL)
FROM EMP;
--==>>
/*
1398313.87362637362637362637362637362637	
1182.503223516271699458653359613061928508
*/


SELECT POWER(STDDEV(SAL), 2) "COL1"
, VARIANCE(SAL) "COL2"
FROM EMP;
--==>>
/*
1398313.87362637362637362637362637362637	
1182.503223516271699458653359613061928508
*/

SELECT SQRT(VARIANCE(SAL)) "COL1"
, STDDEV(SAL) "COL2"
FROM  EMP;
--==>>
/*
1182.503223516271699458653359613061928508	
1182.503223516271699458653359613061928508
*/

--○ MAX() / MIN()
--   최대값 / 최소값 반환

SELECT MAX(SAL) "COL1"
     , MIN(SAL) "COL2"
FROM EMP;
--==>> 5000	800

--※ 주의
SELECT ENAME, SUM(SAL)
FROM EMP;
--==>> ORA-00937: not a single-group group function

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO;
/*
30	 9400
20	10875
10	 8750
*/


SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO
ORDER BY 1;
/*
10	 8750
20	10875
30	 9400
*/

SELECT DEPTNO, SAL
FROM EMP
ORDER BY 1;
--==>>
/*
10	2450 ┐ 이렇게 묶었음
10	5000 │
10	1300 ┘
20	2975 ┐
20	3000 │
20	1100 │
20	800  │
20	3000 ┘
30	1250 ┐
30	1500 │
30	1600 │
30	950  │
30	2850 │
30	1250 ┘
*/

--○ 기존 테이블 제거
DROP TABLE TBL_EMP;
--==>> Table TBL_EMP이(가) 삭제되었습니다.

--○ 실습 테이블 다시 생성
CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;
--==>> Table TBL_EMP이(가) 생성되었습니다.

--○ 실습
INSERT INTO TBL_EMP VALUES
(8001, '김태민', 'CLERK', 7566, SYSDATE, 1500, 10, NULL);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8002, '조현하', 'CLERK', 7566, SYSDATE, 2000, 10, NULL);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8003, '김보경', 'SALESMAN', 7698, SYSDATE, 1700, NULL, NULL);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8004, '유동현', 'SALESMAN', 7698, SYSDATE, 2500, NULL, NULL);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP VALUES
(8005, '장현성', 'SALESMAN', 7698, SYSDATE, 1000, NULL, NULL);
--==>> 1 행 이(가) 삽입되었습니다.

--○ 확인
SELECT *
FROM TBL_EMP;
--==>> 
/*
7369	    SMITH	CLERK	    7902	    1980-12-17	800		        20
7499    	ALLEN	SALESMAN	    7698	    1981-02-20	1600	    300	    30
7521	    WARD	    SALESMAN	    7698	    1981-02-22	1250    	500	    30
7566	    JONES	MANAGER	    7839	    1981-04-02	2975		        20
7654	    MARTIN	SALESMAN	    7698	    1981-09-28	1250	    1400	    30
7698    	BLAKE	MANAGER	    7839    	1981-05-01	2850		        30
7782	    CLARK	MANAGER	    7839	    1981-06-09	2450		        10
7788	SCOTT	ANALYST	    7566	    1987-07-13	3000		        20
7839	    KING	    PRESIDENT		    1981-11-17	5000		        10
7844	TURNER	SALESMAN	    7698    	1981-09-08	1500	    0	    30
7876	ADAMS	CLERK	    7788	1987-07-13	1100		        20
7900	    JAMES	CLERK	    7698    	1981-12-03	950		        30
7902    	FORD    	ANALYST	    7566	    1981-12-03	3000		        20
7934	    MILLER	CLERK	    7782	    1982-01-23	1300		        10
8001	    김태민	CLERK	    7566	    2022-08-18	1500	    10	
8002	    조현하	CLERK	    7566	    2022-08-18	2000	    10	
8003	    김보경	SALESMAN	    7698	    2022-08-18	1700		
8004	    유동현	SALESMAN	    7698	    2022-08-18	2500		
8005	    장현성	SALESMAN	    7698	    2022-08-18	1000	    	
*/

--○ 커밋
COMMIT;
커밋 완료.


SELECT DEPTNO, SAL, COMM
FROM TBL_EMP
ORDER BY COMM DESC;
/*
20	800	
	1700	
	1000	
10	1300	
20	2975	
30	2850	
10	2450	
20	3000	
10	5000	
	2500	
20	1100	
30	950	
20	3000	
30	1250	    1400
30	1250	    500
30	1600	    300
	1500    	10
	2000	    10
30	1500    	0
*/

--※ 오라클에서는 NULL 을 가장 큰 값으로 간주한다.
--  (ORACLE 9i 까지는 NULLL 을 가장 작은 값으로 간주했었다.)
--  MSSQL 은 NULL 을 가장 작은 값으로 간주한다.


--○ TBL_EMP 테이블을 대상으로 부서별 급여 합 조회
--  부서번호, 급여합 항목 조회

SELECT DEPTNO "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;
--==>>
/*
10	8750
20	10875
30	9400
	8700   -- 부서번호가 NULL 인 사원들의 급여합
*/

SELECT DEPTNO "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
10	8750
20	10875
30	9400
	8700  -- 부서번호가 NULL인 직원들의 급여합
	37725 -- 모든부서 직원들의 급여 합
*/

SELECT NVL(DEPTNO, '모든부서') "부서번호", SUM(SAL) "급여합"
FROM EMP
GROUP BY ROLLUP(DEPTNO);
--==>> 에러 발생 ORA-01722: invalid number

SELECT NVL(TO_CHAR(DEPTNO), '모든부서') "부서번호", SUM(SAL) "급여합"
FROM EMP
GROUP BY ROLLUP(DEPTNO);
--==>> 
/*
10	        8750
20	        10875
30	        9400
모든부서    	29025
*/

SELECT NVL2(DEPTNO, TO_CHAR(DEPTNO), '모든부서') "부서번호", SUM(SAL) "급여합"
FROM EMP
GROUP BY ROLLUP(DEPTNO);
--==>> 위 구문이랑 결과 같음




SELECT NVL(TO_CHAR(DEPTNO), '모든부서') "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
*/

SELECT NVL2(DEPTNO, TO_CHAR(DEPTNO), '모든부서') "부서번호", SUM(SAL) "급여합"
FROM TBL_EMP
GROUP BY ROLLUP(DEPTNO);
--==>>
/*
*/








