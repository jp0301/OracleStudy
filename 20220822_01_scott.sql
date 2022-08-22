SELECT USER
FROM DUAL;

-- 19일 금 마지막에 했던 것 이어서 진행한다.


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

-- 방법 1
SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "입사년월"
, COUNT(*) "인원수"
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM EMP GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM'));
--COUNT(*) = (입사년월 기준 최대 인원);


-- 방법 2

SELECT T1.입사년월, T1.인원수
FROM 
(
    SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "입사년월"
    , COUNT(*) "인원수"
    FROM EMP
    GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
) T1
WHERE T1.인원수 = ( SELECT MAX(T2.인원수)
                    FROM
                    (
                        SELECT TO_CHAR(HIREDATE, 'YYYY-MM') "입사년월"
                        , COUNT(*) "인원수"
                        FROM EMP
                        GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM')
                    ) T2
                  )
ORDER BY 1;
/*
1981-02	2
1981-09	2
1981-12	2
1987-07	2
*/


--■■■ ROW_NUMBER ■■■--

SELECT ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP;

SELECT  ROW_NUMBER() OVER(ORDER BY SAL DESC) "테스트"
        , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP;
/*
1	KING	    5000	81/11/17
2	FORD	    3000	81/12/03
3	SCOTT	3000	87/07/13
4	JONES	2975	81/04/02
5	BLAKE	2850	81/05/01
6	CLARK	2450	81/06/09
7	ALLEN	1600	81/02/20
8	TURNER	1500	81/09/08
9	MILLER	1300	82/01/23
10	WARD	    1250	81/02/22
11	MARTIN	1250	81/09/28
12	ADAMS	1100	87/07/13
13	JAMES	950	81/12/03
14	SMITH	800	80/12/17
*/
SELECT  ROW_NUMBER() OVER(ORDER BY SAL DESC) "테스트"
        , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP
ORDER BY ENAME;
--==>>
/*
12	ADAMS	1100	87/07/13
7	ALLEN	1600	81/02/20
5	BLAKE	2850	81/05/01
6	CLARK	2450	81/06/09
2	FORD	    3000	81/12/03
13	JAMES	950	81/12/03
4	JONES	2975	81/04/02
1	KING    	5000	81/11/17
11	MARTIN	1250	81/09/28
9	MILLER	1300	82/01/23
3	SCOTT	3000	87/07/13
14	SMITH	800	80/12/17
8	TURNER	1500	81/09/08
10	WARD	    1250	81/02/22
*/

SELECT  ROW_NUMBER() OVER(ORDER BY ENAME) "테스트"
        , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP
ORDER BY ENAME;
/*
1	ADAMS	1100	87/07/13
2	ALLEN	1600	81/02/20
3	BLAKE	2850	81/05/01
4	CLARK	2450	81/06/09
5	FORD	    3000	81/12/03
6	JAMES	950	81/12/03
7	JONES	2975	81/04/02
8	KING	    5000	81/11/17
9	MARTIN	1250	81/09/28
10	MILLER	1300	82/01/23
11	SCOTT	3000	87/07/13
12	SMITH	800	80/12/17
13	TURNER	1500	81/09/08
14	WARD    	1250	81/02/22
*/

SELECT  ROW_NUMBER() OVER(ORDER BY ENAME) "테스트"
        , ENAME "사원명", SAL "급여", HIREDATE "입사일"
FROM EMP
WHERE DEPTNO = 20
ORDER BY ENAME;
/*
1	ADAMS	1100	    87/07/13
2	FORD	    3000	    81/12/03
3	JONES	2975	    81/04/02
4	SCOTT	3000    	87/07/13
5	SMITH	800	    80/12/17
*/


-- ROW_NUMBER는 게시판의 게시물을 조회할 때 많이 쓴다.
-- 번호         제목          작성자      작성일자     조회수
--------------------------------------------------------------
--   2    화이팅 입니다요오.   냐옹이     2022-08-22      16
--   1    한 주의 시작이네요   댕댕이     2022-08-22      20
--------------------------------------------------------------

--※ 게시판의 게시물 번호를 SEQUENCE 나 IDENTITY 를 사용하게 되면
--   게시물을 삭제했을 경우... 삭제한 게시물의 자리에 다음 번호를 가진
--   게시물이 등록되는 상황이 발생하게 된다.
--   이는... 보안성 측면이나... 미관상.... 바람직하지 않은 상태일 수 있기 때문에
--   ROW_NUMBER() 의 사용을 고려해 볼 수 있다.
--   관리의 목적으로 사용할 때에는 SEQUENCE 나 IDENTITY 를 사용하지만,
--   단순히 게시물을 목록화하여 사용자에게 리스트 형식으로 보여줄 때에는
--   사용하지 않는 것이 바람직할 수 있다.

-- 그때 그때 트렌드가 달라지기 때문에 무조건적으로 사용한다는 것이 아니라. 선택이다.

-- ○ SEQUENCE(시퀀스: 주문번호) 예) 은행의 번호표
--    → 사전적인 의미 : 1.(일련의) 연속적인 사건들, 2.(사건, 행동 등의) 순서

CREATE SEQUENCE SEQ_BOARD -- 긴본적인 시퀀스 생성 구문 (이거 한줄만 실행해도 만들어짐)
START WITH 1  -- 시퀀스 시작값
INCREMENT BY 1 -- 증가값
NOMAXVALUE -- 최대값
NOCACHE; -- 캐시 사용 안함(안함)
--==>> Sequence SEQ_BOARD이(가) 생성되었습니다.

--○ 실습 테이블 생성
CREATE TABLE TBL_BOARD            -- TBL_BOARD 테이블 생성 구문 → 게시판 테이블
( NO        NUMBER                -- 게시물 번호       X
, TITLE     VARCHAR2(50)          -- 게시물 제목       ○
, CONTENTS  VARCHAR2(100)         -- 게시물 내용       ○
, NAME      VARCHAR2(20)          -- 게시물 작성자     △
, PW        VARCHAR2(20)          -- 게시물 패스워드   △
, CREATED   DATE DEFAULT SYSDATE  -- 게시물 작성일     X
);
--== >> Table TBL_BOARD이(가) 생성되었습니다.

--○ 데이터 입력 → 게시판에 게시물을 작성한 액션
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '아~ 자고싶다', '10분만 자고 올께요', '장현성', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '아~ 웃겨', '현성군 완전 재미있어요', '엄소연', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '보고싶다', '원석이가 너무 보고싶어요', '조영관', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '배고파요', '아침인데 배고파요', '유동현', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '너무멀어요', '집에서 교육원까지 너무 멀어요', '김태민', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '모자라요', '아직 잠이 모자라요', '장현성', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '저두요', '저두 잠이 많이 모자라요', '유동현', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '비온대요', '오늘밤부터 비온대요', '박원석', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.

--○ 확인
SELECT *
FROM TBL_BOARD;
/*
1	아~ 자고싶다 	10분만 자고 올께요	            장현성	java002$    	22/08/22
2	아~ 웃겨	        현성군 완전 재미있어요	        엄소연	java002$    	22/08/22
3	보고싶다	        원석이가 너무 보고싶어요	        조영관	java002$	    22/08/22
4	배고파요	        아침인데 배고파요	            유동현	java002$	    22/08/22
5	너무멀어요	    집에서 교육원까지 너무 멀어요	    김태민	java002$	    22/08/22
6	모자라요	        아직 잠이 모자라요	            장현성	java002$	    22/08/22
7	저두요	        저두 잠이 많이 모자라요	        유동현	java002$	    22/08/22
8	비온대요	        오늘밤부터 비온대요	            박원석	java002$    	22/08/22
*/

--○ 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

--※ 문제가 있으면 아래처럼 해보기
/*
DROP TABLE TBL_BOARD PURGE;
DROP SEQUENCE SEQ_BOARD;
그리고 다시 → 테이블 생성구문 실행 → 시퀀스 생성 구문 실행
→ 그리고 INSERT 데이터 입력 구문 차례대로 다시 실행
*/

--○ 이상 없으면 커밋하기
COMMIT;
--==>> 커밋 완료.

--○ 게시물 삭제
DELETE 
FROM TBL_BOARD
WHERE NO = 1;
--==>> 1 행 이(가) 삭제되었습니다


DELETE 
FROM TBL_BOARD
WHERE NO = 6;
--==>> 1 행 이(가) 삭제되었습니다

DELETE 
FROM TBL_BOARD
WHERE NO = 8;
--==>> 1 행 이(가) 삭제되었습니다

--○ 확인
SELECT *
FROM TBL_BOARD;

--○ 게시물 작성
INSERT INTO TBL_BOARD VALUES
(SEQ_BOARD.NEXTVAL, '집중합시다', '전 전혀 졸리지 않아요', '유동현', 'java002$', DEFAULT);
--==>> 1 행 이(가) 삽입되었습니다.

--○ 게시물 삭제
DELETE
FROM TBL_BOARD
WHERE NO= 7;
--==>> 1 행 이(가) 삭제되었습니다.

--○ 확인
SELECT *
FROM TBL_BOARD;
--==>>
/*
2	아~ 웃겨	    현성군 완전 재미있어요	        엄소연	java002$	    2022-08-22 10:18:48
3	보고싶다	    원석이가 너무 보고싶어요	        조영관	java002$	    2022-08-22 10:18:52
4	배고파요	    아침인데 배고파요	            유동현	java002$	    2022-08-22 10:19:11
5	너무멀어요	집에서 교육원까지 너무 멀어요	    김태민	java002$	    2022-08-22 10:19:17
9	집중합시다	전 전혀 졸리지 않아요	        유동현	java002$	    2022-08-22 10:35:32
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.


-- 게시물 삭제를 할 때 NO를 썼었다.
-- 제목, 이름, 등등 겹칠 수 있기 때문에 고유하게 이용될 수 있는 게시물 번호를 이용한 것이다.



--○ 게시판의 게시물 리스트 조회
SELECT NO "글번호", TITLE "제목", NAME "이름", CREATED "작성일"
FROM TBL_BOARD;
--==>>
/*
2	아~ 웃겨	    엄소연	2022-08-22 10:18:48
3	보고싶다	    조영관	2022-08-22 10:18:52
4	배고파요	    유동현	2022-08-22 10:19:11
5	너무멀어요	김태민	2022-08-22 10:19:17
9	집중합시다	유동현	2022-08-22 10:35:32
*/

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "글번호"
       , TITLE "제목", NAME "이름", CREATED "작성일"
FROM TBL_BOARD;
--==>>
/*
1	아~ 웃겨	    엄소연	2022-08-22 10:18:48
2	보고싶다    	조영관	2022-08-22 10:18:52
3	배고파요	    유동현	2022-08-22 10:19:11
4	너무멀어요	김태민	2022-08-22 10:19:17
5	집중합시다	유동현	2022-08-22 10:35:32
*/

SELECT ROW_NUMBER() OVER(ORDER BY CREATED) "글번호"
       , TITLE "제목", NAME "이름", CREATED "작성일"
FROM TBL_BOARD
ORDER BY 4 DESC;
--==>>
/*
5	집중합시다	유동현	2022-08-22 10:35:32
4	너무멀어요	김태민	2022-08-22 10:19:17
3	배고파요	    유동현	2022-08-22 10:19:11
2	보고싶다	    조영관	2022-08-22 10:18:52
1	아~ 웃겨   	엄소연	2022-08-22 10:18:48
*/

-- 게시물 작성하면 실제 번호는 10번으로 만들어질테지만 보여지는것은 6번일 것이다.

--------------------------------------------------------------------------------

--■■■ JOIN(조인) ■■■--

-- 1. SQL 1992 CODE

-- CROSS JOIN
SELECT *
FROM EMP, DEPT; -- 56건
--> 수학에서 말하는 데카르트 곱(CATERSIAN PRODUCT)
--  두 테이블을 결합한 모든 경우의 수

SELECT *
FROM DEPT; --4건

SELECT *
FROM EMP; --14건

-- EQUI JOIN : 서로 정확히 일치하는 것들끼리 연결하여 결합시키는 결합 방법
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO; -- 14건

SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO; -- 같은 결과값 출력

-- NON EQUI JOIN : 범위 안에 적합한 것들끼리 연결시키는 결합 방법
SELECT *
FROM SALGRADE;

SELECT *
FROM EMP;

SELECT *
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;

-- EQUI JOIN 시 (+) 를 활용한 결합 방법
SELECT *
FROM TBL_EMP; --19 건

SELECT *
FROM TBL_DEPT; --4 건


SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO;
--> 총 14건의 데이터가 결합되어 조회된 상황
-- 즉, 부서번호를 갖지 못한 사원들(5) 모두 누락
-- 또한, 소속 사원을 갖지 못한 부서(1) 모두 누락

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO(+);
--> 총 19 건 데이터가 결합되어 조회된 상황
-- 소속 사원을 갖지 못한 부서(1) 누락     ----------------(+)
-- 부서번호를 갖지 못한 사원들 모두 조회
-- LEFT JOIN

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;
--> 총 15 건의 데이터가 결합되어 조회된 상황
-- 부서번호를 갖지 못한 사원들(5) 모두 누락 -----------------(+)
-- 소속 사원을 갖지 못한 부서(1) 조회

--※ (+) 가 없는 쪽 테이블의 데이터를 모두 메모리에 적재한 후    -- 기준
--   (+) 가 있는 쪽 테이블의 데이터를 하나하나 확인하여 결합시키는 형태로 -- 추가(첨가)
--   JOIN 이 이루어진다.

-- 이와 같은 이유로...
SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO(+);
-- 이런 형식의 JOIN 은 존재하지 않는다.
--==>> ORA-01468: a predicate may reference only one outer-joined table


SELECT *
FROM EMP E, DEPT D
WHERE D.DEPTNO = 20
  AND E.DEPTNO = D.DEPTNO;


-- 2. SQL 1999 CODE → JOIN 키워드 등장 → JOIN(결합)의 유형 명시
--                 → ON 키워드 등장 → 결합 조건은 WHERE 대신 ON

-- CROSS JOIN
SELECT *
FROM EMP CROSS JOIN DEPT;

-- INNER JOIN
SELECT *
FROM EMP E INNER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
-- INNER JOIN에서 INNER는 생략 가능



-- OUTER JOIN
SELECT *
FROM TBL_EMP E LEFT JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E RIGHT JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E FULL JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

-----------------------------------------------------------------------------
SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO
AND E.JOB = 'CLERK';
--> 이와 같은 방법으로 쿼리문을 구성해도
-- 조회 결과를 얻는 과정에 문제는 없다.


SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB = 'CLERK';
--> 하지만, 이와 같이 구성하여
-- 조회하는 것을 권장한다.

-----------------------------------------------------------------------------

--○ EMP 테이블과 DEPT 테이블을 대상으로
--   직종이 MANAGER 와 CLERK 인 사원들만
-- 부서번호, 부서명, 사원명, 직종명, 급여 항목을 조회한다.

SELECT *
FROM EMP;

SELECT D.DEPTNO "부서번호", DNAME "부서명", ENAME "사원명", JOB "직종명", SAL "급여"
FROM EMP E FULL JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB IN('MANAGER', 'CLERK');

-- 부서번호, 부서명, 사원명, 직종명, 급여
-- DEPTNO    DNAME   ENAME   JOB     SAL
-- E, D      D       E       E       E

SELECT DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;
--==>> 에러 발생 ORA-00918: column ambiguously defined
-- 두 테이블 간 중복되는 컬럼에 대한
-- 소속 테이블을 정해줘야(명시해줘야) 한다.

SELECT E.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;

SELECT D.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;

--> E.DEPTNO, D.DEPTNO 처럼 소속테이블을 명시해줘야 한다.
-- 왜 에러나는지를 분석해봐야 한다.
-- 오라클이 DEPTNO 라는 컬럼을 얻기 위해서 EMP, DEPT 테이블 둘 다 들여다본다는 것을 의미한다.
-- 즉, EMP에서 찾았더라도 DEPTNO 로 가서 찾아본다.
-- 찾았다고 해서 바로 가져오는 것이아니라 다른 테이블에 들어가서도 컬럼을 찾아본다.

-- 그래서 소속 테이블을 명시해 주는데...
-- 단, 부모 테이블이어야 한다.
-- 자식 테이블 것을 쓰다보면 그 값을 온전히 못가져오는 케이스가 생길 수 있다.
-- 그러면 부모테이블이 E 와 D 중 어떤 것인가?
-- 두 테이블이 관계를 맺고 있으며 둘의 관계 컬럼이 몇 개인지 본다.

SELECT *
FROM EMP;
-- DEPTNO는 여러 개 -- 자식 테이블
SELECT *
FROM DEPT;
-- DEPTNO 20이 하나 -- 부모 테이블

-- 따라서, DEPT테이블이 부모 테이블이다.

--※ 두 테이블 간 중복되는 컬럼에 대해 소속 테이블을 명시하는 경우
--   부모 테이블의 컬럼을 참조할 수 있도록 처리해야 한다.

SELECT D.DEPTNO, D.DNAME, E.ENAME, E.JOB, E.SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;

-- 두 테이블에 모두 포함되어 있는 중복된 컬럼이 아니더라도
-- 컬럼의 소속 테이블을 명시해 줄 수 있도록 권장한다.

SELECT E.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;

SELECT D.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;

--------------------------------------------------------------------------------
--○ SELF JOIN(자기 조인)

-- EMP 테이블의 데이터를 다음과 같이 조회할 수 있도록 쿼리문을 구성한다.
-----------------------------------------------------------------------
-- 사원번호  사원명  직종명  관리자번호  관리자명  관리자직종명
-----------------------------------------------------------------------
-- 7369      SMITH   CLERK    7902       FORD       ANALYST
--                              :

SELECT *
FROM EMP;

SELECT E1.EMPNO "사원번호", E1.ENAME "사원명", E1.JOB "직종명"
, E2.MGR "관리자번호", E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO(+);


SELECT E1.EMPNO "사원번호", E1.ENAME "사원명", E1.JOB "직종명"
, E2.MGR "관리자번호", E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1 JOIN EMP E2
ON E1.MGR = E2.EMPNO;






















