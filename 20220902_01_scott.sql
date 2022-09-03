SELECT USER
FROM DUAL;
--==>> SCOTT


--○ 실습 테이블 생성(TBL_상품)
CREATE TABLE TBL_상품
( 상품코드      VARCHAR2(20)
, 상품명        VARCHAR2(100)
, 소비자가격    NUMBER
, 재고수량      NUMBER DEFAULT 0
, CONSTRAINT 상품_상품코드_PK PRIMARY KEY(상품코드)
);
--==>> Table TBL_상품이(가) 생성되었습니다.

--○ 실습 테이블 생성(TBL_입고)
CREATE TABLE TBL_입고
( 입고번호  NUMBER
, 상품코드  VARCHAR2(20)
, 입고일자  DATE DEFAULT SYSDATE
, 입고수량  NUMBER
, 입고단가  NUMBER
, CONSTRAINT 입고_입고번호_PK PRIMARY KEY(입고번호)
, CONSTRAINT 입고_상품코드_FK FOREIGN KEY(상품코드) REFERENCES TBL_상품(상품코드)
);
--==>> Table TBL_입고이(가) 생성되었습니다.

--○ TBL_상품 테이블에 상품 데이터 입력
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C001','구구콘',1500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C002','월드콘',1500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C003','브라보콘',1300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C004','누가콘',1800);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('C005','슈퍼콘',1900);
--==>> 1 행 이(가) 삽입되었습니다. * 5

INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H001','스크류바',1000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H002','캔디바',300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H003','쌍쌍바',500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H004','돼지바',600);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('H005','메로나',500);
--==>> 1 행 이(가) 삽입되었습니다. * 5

INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E001','찰떡아이스',2500);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E002','붕어싸만코',2000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E003','빵또아',2300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E004','거북알',2300);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E005','쿠키오',2400);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E006','국화빵',2000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E007','투게더',3000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E008','엑설런트',3000);
INSERT INTO TBL_상품(상품코드, 상품명, 소비자가격) VALUES('E009','셀렉션',3000);
--==>> 1 행 이(가) 삽입되었습니다. * 9


--○ 확인
SELECT *
FROM TBL_상품;
--==>>
/*
C001	구구콘	    1500	0
C002	월드콘	    1500	0
C003	브라보콘	    1300	0
C004	누가콘	    1800	0
C005	슈퍼콘	    1900	0
H001	스크류바	    1000	0
H002	캔디바	     300	0
H003	쌍쌍바	     500	0
H004	돼지바	     600	0
H005	메로나	     500	0
E001	찰떡아이스	2500	0
E002	붕어싸만코	2000	0
E003	빵또아	    2300	0
E004	거북알	    2300	0
E005	쿠키오	    2400	0
E006	국화빵	    2000	0
E007	투게더	    3000	0
E008	엑설런트	    3000	0
E009	셀렉션	    3000	0
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.


SELECT *
FROM TBL_입고;


SELECT MAX(입고번호)
FROM TBL_입고;
--==>> (NULL)



--○ 프로시저 호출을 통한 정상 작동여부 확인
EXEC PRC_입고_INSERT('C001', 30, 1200);           --구구콘 30개 입고
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_입고_INSERT('C002', 30, 1200);           --월드콘 30개 입고
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
/*
C001	구구콘	1500	30
C002	월드콘	1500	30
*/

SELECT *
FROM TBL_입고;
/*
1	C001	2022-09-02	30	1200
2	C002	2022-09-02	30	1200
*/

EXEC PRC_입고_INSERT('H001', 50, 800);--스크류바 50개 입고
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_입고_INSERT('H002', 50, 200);--캔디바 50개 입고
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.


SELECT *
FROM TBL_상품;
/*
C001	구구콘	    1500	30
C002	월드콘	    1500	30
C003	브라보콘	    1300	0
C004	누가콘	    1800	0
C005	슈퍼콘	    1900	0
H001	스크류바    	1000	50
H002	캔디바	    300	    100
H003	쌍쌍바	    500	    0
H004	돼지바	    600	    0
H005	메로나	    500	    0
E001	찰떡아이스	2500	0
E002	붕어싸만코	2000	0
E003	빵또아	    2300	0
E004	거북알	    2300	0
E005	쿠키오	    2400	0
E006	국화빵	    2000	0
E007	투게더	    3000	0
E008	엑설런트	    3000	0
E009	셀렉션	    3000	0
*/

SELECT *
FROM TBL_입고;
/*
1	C001	2022-09-02	30	1200
2	C002	2022-09-02	30	1200
3	H001	2022-09-02	50	 800
4	H002	2022-09-02	100	 200
*/

EXEC PRC_입고_INSERT('H001', 50, 800);            --스크류바 50개 입고
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

EXEC PRC_입고_INSERT('H002', 50, 200); --캔디바 50개 입고
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
/*
C001	구구콘	1500	30
C002	월드콘	1500	30
C003	브라보콘	1300	0
C004	누가콘	1800	0
C005	슈퍼콘	1900	0
H001	스크류바	1000	100
H002	캔디바	300	    100
H003	쌍쌍바	500	    0
H004	돼지바	600	    0
H005	메로나	500	    0
E001	찰떡아이스	2500	0
E002	붕어싸만코	2000	0
E003	빵또아	2300	0
E004	거북알	2300	0
E005	쿠키오	2400	0
E006	국화빵	2000	0
E007	투게더	3000	0
E008	엑설런트	3000	0
E009	셀렉션	3000	0
*/

SELECT *
FROM TBL_입고;
/*
1	C001	2022-09-02	30	1200
2	C002	2022-09-02	30	1200
3	H001	2022-09-02	50	800
4	H002	2022-09-02	50	200
5	H001	2022-09-02	50	800
6	H002	2022-09-02	50	200
*/






--------------------------------------------------------------------------------
--■■■ 프로시저 내에서의 예외 처리 ■■■--

--○ 실습 테이블 생성(TBL_MEMBER)
CREATE TABLE TBL_MEMBER
( NUM   NUMBER
, NAME  VARCHAR2(30)
, TEL   VARCHAR2(60)
, CITY  VARCHAR2(60)
, CONSTRAINT MEMBER_NUM_PK PRIMARY KEY(NUM)
);
--==>> Table TBL_MEMBER이(가) 생성되었습니다.


--○ 프로시저 호출을 통한 확인
EXEC PRC_TBL_MEMBER_INSERT('임시연','010-1111-1111','서울');
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
--==>> 데이터 입력 ○

SELECT *
FROM TBL_MEMBER;
--==>> 1	임시연	010-1111-1111	서울

EXEC PRC_TBL_MEMBER_INSERT('김보경','010-2222-2222','부산');
--==>> 에러 발생
--     ORA-20001: 서울,경기,대전만 입력이 가능합니다.
--     데이터 입력 Ⅹ

SELECT *
FROM TBL_MEMBER;
--==>> 1	임시연	010-1111-1111	서울






DESC TBL_입고;


--○ 실습 테이블 생성(TBL_출고)
CREATE TABLE TBL_출고
( 출고번호  NUMBER
, 상품코드  VARCHAR2(20)
, 출고일자  DATE DEFAULT SYSDATE
, 출고수량  NUMBER
, 출고단가  NUMBER
);
--==>> Table TBL_출고이(가) 생성되었습니다.


-- 출고번호 PK 지정
ALTER TABLE TBL_출고
ADD CONSTRAINTS 출고_출고번호_PK PRIMARY KEY(출고번호);
--==>> Table TBL_출고이(가) 변경되었습니다.

-- 상품코드 FK 지정
ALTER TABLE TBL_출고
ADD CONSTRAINT 출고_상품코드_FK FOREIGN KEY(상품코드)
                            REFERENCES TBL_상품(상품코드);
--==>> Table TBL_출고이(가) 변경되었습니다.

SELECT *
FROM TBL_출고;

SELECT *
FROM TBL_상품;
--==>>
/*
C001	구구콘	    1500	 30
C002	월드콘	    1500	 30
C003	브라보콘	    1300	  0
C004	누가콘	    1800	  0
C005	슈퍼콘	    1900	  0
H001	스크류바	    1000	100
H002	캔디바	    300	    100
H003	쌍쌍바	    500	      0
H004	돼지바	    600	      0
H005	메로나	    500	      0
E001	찰떡아이스	2500	  0
E002	붕어싸만코	2000	  0
E003	빵또아	    2300	  0
E004	거북알	    2300	  0
E005	쿠키오	    2400	  0
E006	국화빵	    2000	  0
E007	투게더	    3000	  0
E008	엑설런트	    3000	  0
E009	셀렉션	    3000	  0
*/

SELECT *
FROM TBL_출고;
--==>> 조회 결과 없음

--○ 프로시저 호출을 통한 정상 작동여부 확인
EXEC PRC_출고_INSERT('H001', 50, 1000);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	스크류바	1000	50

SELECT *
FROM TBL_출고;
--==>> 1	H001	2022-09-02	50	1000

EXEC PRC_출고_INSERT('H001', 80, 1000);
--==>> 에러 발생
--     ORA-20002: 재고수량이 부족합니다

SELECT *
FROM TBL_상품;
--==>>H001	스크류바	1000	50

SELECT *
FROM TBL_출고;
--==>> 1	H001	2022-09-02	50	1000




--○ 프로시저 호출을 통한 정상 작동여부 확인
EXEC PRC_출고_UPDATE(1, 110);
--==>> 에러 발생
-- ORA-20003: 재고수량이 부족합니다

SELECT *
FROM TBL_상품;
--==>>H001	스크류바	1000	50

SELECT *
FROM TBL_출고;
--==>> 1	H001	2022-09-02	50	1000

EXEC PRC_출고_UPDATE(1, 100);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	스크류바	1000	0

SELECT *
FROM TBL_출고;
--==>> 1	H001	2022-09-02	100	1000

SELECT *
FROM TBL_INSA;










