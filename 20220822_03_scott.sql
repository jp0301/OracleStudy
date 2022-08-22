SELECT USER
FROM DUAL;
--==>> SCOTT

SELECT *
FROM TAB;

--■■■ UNION / UNION ALL ■■■--

--○ 실습 테이블 생성(TBL_JUMUN)
CREATE TABLE TBL_JUMUN              -- 주문 테이블 생성
( JUNO      NUMBER                  -- 주문 번호
, JECODE    VARCHAR2(30)            -- 주문 번호
, JUSU      NUMBER                  -- 주문 수량
, JUDAY     DATE DEFAULT SYSDATE    -- 주문 일자
);
--==>> Table TBL_JUMUN이(가) 생성되었습니다.
--> 고객의 주문이 발생(접수)되었을 경우
--  주문 내용에 대한 데이터가 입력될 수 있도록 처리하는 테이블

--○ 데이터 입력 → 고객 주문 발생(접수)
INSERT INTO TBL_JUMUN
VALUES(1, '치토스', 20, TO_DATE('2001-11-01 09:10:12', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(2, '빼빼로', 10, TO_DATE('2001-11-01 10:10:12', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(3, '맛동산', 30, TO_DATE('2001-11-01 13:10:12', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(4, '오레오', 10, TO_DATE('2001-11-02 11:11:11', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(5, '포카칩', 20, TO_DATE('2001-11-01 17:50:11', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(6, '죠리퐁', 10, TO_DATE('2001-11-03 10:00:10', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(7, '감자깡', 20, TO_DATE('2001-11-04 05:05:05', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(8, '사또밥', 20, TO_DATE('2001-11-04 06:07:08', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(9, '새우깡', 10, TO_DATE('2001-11-05 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(10, '스윙칩', 20, TO_DATE('2001-11-05 14:10:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(11, '홈런볼', 10, TO_DATE('2001-11-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(12, '홈런볼', 10, TO_DATE('2001-11-05 15:10:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(13, '꼬북칩', 20, TO_DATE('2001-11-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(14, '다이제', 10, TO_DATE('2001-11-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(15, '꼬깔콘', 20, TO_DATE('2001-11-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(16, '포스틱', 10, TO_DATE('2001-11-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(17, '오감자', 20, TO_DATE('2001-11-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(18, '홈런볼', 10, TO_DATE('2001-11-11 15:10:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(19, '포스틱', 10, TO_DATE('2001-11-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TBL_JUMUN
VALUES(20, '포스틱', 20, TO_DATE('2001-11-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
--==>>  1 행 이(가) 삽입되었습니다. * 20

--○ 날짜에 대한 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

--○ 확인
SELECT *
FROM TBL_JUMUN;
/*
1	치토스	20	2001-11-01 09:10:12
2	빼빼로	10	2001-11-01 10:10:12
3	맛동산	30	2001-11-01 13:10:12
4	오레오	10	2001-11-02 11:11:11
5	포카칩	20	2001-11-01 17:50:11
6	죠리퐁	10	2001-11-03 10:00:10
7	감자깡	20	2001-11-04 05:05:05
8	사또밥	20	2001-11-04 06:07:08
9	새우깡	10	2001-11-05 13:00:00
10	스윙칩	20	2001-11-05 14:10:00
11	홈런볼	10	2001-11-05 15:00:00
12	홈런볼	10	2001-11-05 15:10:00
13	꼬북칩	20	2001-11-06 12:00:00
14	다이제	10	2001-11-07 12:00:00
15	꼬깔콘	20	2001-11-08 12:00:00
16	포스틱	10	2001-11-09 12:00:00
17	오감자	20	2001-11-10 12:00:00
18	홈런볼	10	2001-11-11 15:10:00
19	포스틱	10	2001-11-12 12:00:00
20	포스틱	20	2001-11-13 12:00:00
*/


--○ 커밋
COMMIT;
--==>> 커밋 완료.

--○ 추가 데이터 입력 → 2001년 부터 시작된 주문이 현재(2022년)까지 계속 발생~!!! 진행중!
INSERT INTO TBL_JUMUN VALUES(98764, '꼬북칩', 10, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98765, '빼빼로', 30, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98766, '빼빼로', 20, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98767, '에이스', 40, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98768, '홈런볼', 10, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98769, '감자깡', 20, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98770, '맛동산', 10, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98771, '웨하스', 20, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98772, '맛동산', 30, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98773, '오레오', 20, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98774, '빼빼로', 10, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.
INSERT INTO TBL_JUMUN VALUES(98775, '오감자', 10, SYSDATE);
--==>> 1 행 이(가) 삽입되었습니다.

--○ 확인
SELECT *
FROM TBL_JUMUN;
--==>>
/*
1	    치토스	20	2001-11-01 09:10:12
2	    빼빼로	10	2001-11-01 10:10:12
3	    맛동산	30	2001-11-01 13:10:12
4	    오레오	10	2001-11-02 11:11:11
5	    포카칩	20	2001-11-01 17:50:11
6	    죠리퐁	10	2001-11-03 10:00:10
7	    감자깡	20	2001-11-04 05:05:05
8	    사또밥	20	2001-11-04 06:07:08
9	    새우깡	10	2001-11-05 13:00:00
10	    스윙칩	20	2001-11-05 14:10:00
11	    홈런볼	10	2001-11-05 15:00:00
12	    홈런볼	10	2001-11-05 15:10:00
13	    꼬북칩	20	2001-11-06 12:00:00
14	    다이제	10	2001-11-07 12:00:00
15	    꼬깔콘	20	2001-11-08 12:00:00
16	    포스틱	10	2001-11-09 12:00:00
17	    오감자	20	2001-11-10 12:00:00
18	    홈런볼	10	2001-11-11 15:10:00
19	    포스틱	10	2001-11-12 12:00:00
20	    포스틱	20	2001-11-13 12:00:00
98764	꼬북칩	10	2022-08-22 16:50:08
98765	빼빼로	30	2022-08-22 16:50:14
98766	빼빼로	20	2022-08-22 16:50:20
98767	에이스	40	2022-08-22 16:50:25
98768	홈런볼	10	2022-08-22 16:50:30
98769	감자깡	20	2022-08-22 16:50:35
98770	맛동산	10	2022-08-22 16:50:40
98771	웨하스	20	2022-08-22 16:50:45
98772	맛동산	30	2022-08-22 16:50:50
98773	오레오	20	2022-08-22 16:50:55
98774	빼빼로	10	2022-08-22 16:51:01
98775	오감자	10	2022-08-22 16:51:06
*/


--※ 현성이가 과자 쇼핑몰 운영 중...
--   TBL_JUMUN 테이블이 무거워진 상황
--   어플리케이션과의 연동으로 인해 주문 내역을 다른 테이블에
--   저장될 수 있도록 만드는 것은 거의 불가능한 상황.
--   기존의 모든 데이터를 덮어놓고 지우는 것도 불가능한 상황
--   → 결과적으로...
--      현재까지 누적된 주문 데이터 중
--      금일 발생한 주문 재역을 제외하고
--      나머지 데이터를 다른 테이블(TBL_JUMUNBACKUP)로 데이터를 이관하여 백업을 수행할 계획

CREATE TABLE TBL_JUMUNBACKUP
AS
SELECT *
FROM TBL_JUMUN
WHERE 금일발생한주문이아닌것;


CREATE TABLE TBL_JUMUNBACKUP
AS
SELECT *
FROM TBL_JUMUN
WHERE TO_CHAR(JUDAY, 'YYYY-MM-DD') != TO_CHAR(SYSDATE, 'YYYY-MM-DD');
                                    -----------------------------    
                                       -- '2022-08-02'
--==>> Table TBL_JUMUNBACKUP이(가) 생성되었습니다.

-- 확인
SELECT *
FROM TBL_JUMUNBACKUP;
/*
1	치토스	20	2001-11-01 09:10:12
2	빼빼로	10	2001-11-01 10:10:12
3	맛동산	30	2001-11-01 13:10:12
4	오레오	10	2001-11-02 11:11:11
5	포카칩	20	2001-11-01 17:50:11
6	죠리퐁	10	2001-11-03 10:00:10
7	감자깡	20	2001-11-04 05:05:05
8	사또밥	20	2001-11-04 06:07:08
9	새우깡	10	2001-11-05 13:00:00
10	스윙칩	20	2001-11-05 14:10:00
11	홈런볼	10	2001-11-05 15:00:00
12	홈런볼	10	2001-11-05 15:10:00
13	꼬북칩	20	2001-11-06 12:00:00
14	다이제	10	2001-11-07 12:00:00
15	꼬깔콘	20	2001-11-08 12:00:00
16	포스틱	10	2001-11-09 12:00:00
17	오감자	20	2001-11-10 12:00:00
18	홈런볼	10	2001-11-11 15:10:00
19	포스틱	10	2001-11-12 12:00:00
20	포스틱	20	2001-11-13 12:00:00
*/
--> TBL_JUMUN 테이블의 데이터들 중
--  금일 주문 내역 이외의 데이터는 모두 TBL_JUMUNBACKUP 테이블에
--  백업을 마친 상태

-- TBL_JUMUN 테이블의 데이터들 중
-- 백업을 마친 데이터들 → 즉, 금일 발생한 주문 내역이 아닌 데이터들 → 제거
DELETE 
FROM TBL_JUMUN
WHERE TO_CHAR(JUDAY, 'YYYY-MM-DD') != TO_CHAR(SYSDATE, 'YYYY-MM-DD');
--==>> 20개 행 이(가) 삭제되었습니다.
--가정) (98763개 행 이(가) 삭제되었습니다.)

-- 확인
SELECT *
FROM TBL_JUMUN;
/*
98764	꼬북칩	10	2022-08-22 16:50:08
98765	빼빼로	30	2022-08-22 16:50:14
98766	빼빼로	20	2022-08-22 16:50:20
98767	에이스	40	2022-08-22 16:50:25
98768	홈런볼	10	2022-08-22 16:50:30
98769	감자깡	20	2022-08-22 16:50:35
98770	맛동산	10	2022-08-22 16:50:40
98771	웨하스	20	2022-08-22 16:50:45
98772	맛동산	30	2022-08-22 16:50:50
98773	오레오	20	2022-08-22 16:50:55
98774	빼빼로	10	2022-08-22 16:51:01
98775	오감자	10	2022-08-22 16:51:06
*/

-- 커밋
COMMIT;
--==>> 커밋 완료.


--※ 아직 제품 발송이 이루어지지 않은 금일 주문 데이터를 제외하고
--   이전의 모든 주문 데이터들이 삭제된 상황이므로
--   테이블은 행(레코드)의 갯수가 줄어들어 매우 가벼워진 상황이다.


-- 그런데, 지금까지 주문받은 내역에 대한 정보를
-- 제품별 총 주문량으로 나태내어야 할 상황이 발생하게 되었다.

-- 그렇다면,  TBL_JUMUNBACKUP 테이블의 레코드(행)와
-- TBL_JUMUN  테이블의 레코드(행)를 모두 합쳐
-- 하나의 테이블을 조회하는 것과 같은 결과를 확인할 수 있도록
--  조회가 이루어져야 한다.

--※ 컬럼과 컬럼의 관계를 고려하여 테이블을 결합하고자 하는 경우
--   JOIN을 사용하지만
--   레코드와 레코드를 결합하고자 하는 경우
--  UNION / UNION ALL 을 사용할 수 있다.

SELECT *
FROM TBL_JUMUNBACKUP
UNION 
SELECT *
FROM TBL_JUMUN;

SELECT *
FROM TBL_JUMUNBACKUP
UNION ALL 
SELECT *
FROM TBL_JUMUN;





SELECT *
FROM TBL_JUMUN
UNION 
SELECT *
FROM TBL_JUMUNBACKUP;

SELECT *
FROM TBL_JUMUN
UNION ALL 
SELECT *
FROM TBL_JUMUNBACKUP;

--※ UNION 은 항상 결과물의 첫 번째 컬럼을 기준으로
--   오름차순 정렬을 수행한다.
--   반면, UNION ALL 은 결합된 순서(구문에서 테이블을 명시한 순서)대로
--   조회한 결과를 있는 그대로 반환한다.
--   이로 인해 UNION 이 부하가 더 크다. (리소스 소모가 더 크다.)
--   또한, UNION은 결과물에 중복된 레코드(행)가 존재할 경우
--   중복을 제거하고 1개 행만 조회된 결과를 반환하게 된다.


--○ 지금까지 주문받은 데이터를 통해
--   제품 별 총 주문량을 조회할 수 있는 쿼리문을 구성한다.

SELECT J.JECODE "제품코드", SUM(J.JUSU) "총주문량"
FROM
(
    SELECT *
    FROM TBL_JUMUN
    UNION ALL
    SELECT *
    FROM TBL_JUMUNBACKUP
) J
GROUP BY JECODE;






































