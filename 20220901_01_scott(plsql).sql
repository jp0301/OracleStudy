SELECT USER
FROM DUAL; 
--==>> SCOTT


--○ TBL_INSA 테이블의 급여 계산 전용 함수를 정의한다.
--   급여는 (기본급*12)+수당  기반으로 연산을 수행한다.
--   함수명 : FN_PAY(기본급, 수당)

DESC TBL_INSA;

CREATE OR REPLACE FUNCTION FN_PAY(V_BASICPAY NUMBER, V_SUDANG NUMBER)
RETURN NUMBER
IS
    V_SAL NUMBER;
BEGIN
    V_SAL := (NVL(V_BASICPAY, 0) * 12) + NVL(V_SUDANG, 0);
    RETURN V_SAL;
END;



--○ TBL_INSA 테이블에서 입사일을 기준으로
--   현재까지의 근무년수를 반환하는 함수를 정의한다.
--   단, 근무년수는 소수점 이하 한자리까지 계산 - TRUNC(값, 1)
--   함수명 : FN_WORKYEAR()


CREATE OR REPLACE FUNCTION FN_WORKYEAR(V_IBSADATE DATE)
RETURN NUMBER
IS
    V_RESULT NUMBER;
BEGIN
    V_RESULT := TRUNC((SYSDATE - V_IBSADATE)/365, 1);
    
    RETURN V_RESULT;
END;
--==>> Function FN_WORKYEAR이(가) 컴파일되었습니다.




--1
SELECT MONTHS_BETWEEN(SYSDATE, '2002-02-11')/12
FROM DUAL;

--2
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, '2002-02-11')/12)||'년'||
       TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, '2002-02-11'), 12))||'개월'
FROM DUAL;

--3
SELECT NAME, IBSADATE, FN_WORKYEAR(IBSADATE) "근무기간"
FROM TBL_INSA;


CREATE OR REPLACE FUNCTION FN_WORKYEAR2(V_IBSADATE DATE)
RETURN VARCHAR2
IS
    V_RESULT VARCHAR2(20);
BEGIN
    V_RESULT := TRUNC(MONTHS_BETWEEN(SYSDATE, V_IBSADATE)/12)||'년'||
                TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, V_IBSADATE), 12))||'개월';
                
    RETURN V_RESULT;
END;
--==>> Function 
--==>> Function FN_WORKYEAR2이(가) 컴파일되었습니다.



--------------------------------------------------------------------------------

--※ 참고

--1. INSERT, UPDATE, DELETE, (MERGE)
--==>> DML(Data Manipulation Language)
-- COMMIT / ROLLBACK 이 필요하다.


--2. CREATE, DROP, ALTER, (TRUNCATE)
--==>> DDL(Data Definition Language)
-- 실행하면 자동으로 COMMIT 된다.

--3. GRANT, REVOKE
--==>> DCL(Data Control Language)
-- 실행하면 자동으로 COMMIT 된다.

--4. COMMIT, ROLLBACK
--==>> TCL(Transaction Control Language)


--------------------------------------------------------------------------------


--■■■ PROCEDURE (프로시저) ■■■--

-- 1. PL/SQL 에서 가장 대표적인 구조인 스토어드 프로시저는
--    개발자가 자주 작성해야 하는 업무의 흐름을
--    미리 작성하여 데이터베이스 내에 저장해 두었다가
--    필요할 때 마다 호출하여 실행할 수 있도록 처리해 주는 구문이다.


-- 2. 형식 및 구조
/*
CREATE [OR REPLACE] PROCEDURE 프로시저명
[( 매개변수 IN 데이터타입
 , 매개변수 OUT 데이터타입
 , 매개변수 INOUT 데이터타입
)]
IS 
    [--주요 변수 선언]
BEGIN
    -- 실행 구문;
    ...
    [EXCEPTION]
        -- 예외 처리 구문;
END;
*/

--※ FUNCTION 과 비교했을 때
--   'RETURN 반환자료형' 부분이 존재하지 않으며,
--   'RETURN' 문 자체도 존재하지 않으며,
--   프로시저 실행 시 넘겨주게 되는 매개변수는
--   IN, OUT, INOUT 으로 구분된다.


-- 3. 실행(호출)
/*
EXEC[UTE] 프로시저명[(인수1, 인수2, ...)];
*/


-- 프로시저 관련 실습 진행을 위해
-- 20220901_02_scott.sql 파일에
-- 테이블 생성 및 데이터 입력 수행


--○ 프로시저 생성(PRC_STUDENTS_INSERT())
-- 프로시저 명 : PRC_STUDENTS_INSERT(아이디, 패스워드,이름, 전화, 주소)
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_INSERT
( 아이디, 패스워드, 이름, 전화, 주소
)
IS
BEGIN
END;

CREATE OR REPLACE PROCEDURE PRC_STUDENTS_INSERT
( V_ID      IN TBL_IDPW.ID%TYPE
, V_PW      IN TBL_IDPW.PW%TYPE
, V_NAME    IN TBL_STUDENTS.NAME%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS
        
BEGIN
    INSERT INTO TBL_IDPW(ID, PW) VALUES(V_ID, V_PW);
    
    INSERT INTO TBL_STUDENTS(ID, NAME, TEL, ADDR)
    VALUES(V_ID, V_NAME, V_TEL, V_ADDR);
    
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_INSERT이(가) 컴파일되었습니다.



--○ TBL_SUNGJUK 테이블에 데이터 입력 시
--   특정 항목의 데이터만 입력하면
--   -----------------
--   (학번, 이름, 국어점수, 영어점수, 수학점수)
--   내부적으로 총점, 평균, 등급 항목에 대한 처리가 함께 이루어질 수 있도록 하는
--   프로시저를 작성한다. (생성한다.)
--   프로시저 명 : PRC_SUNGJUK_INSERT()

/*
실행 예)
EXEC PRC_SUNGJUK_INSERT(1, '엄소연', 90, 80, 70);

→ 프로시저 호출로 처리된 결과
학번     이름      국어점수      영어점수     수학점수    총점    평균   등급
 1      엄소연        90           80           70       240    80       2     
*/

CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_INSERT
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_NAME    IN TBL_SUNGJUK.NAME%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    V_TOT   TBL_SUNGJUK.TOT%TYPE;
    V_AVG   TBL_SUNGJUK.AVG%TYPE;
    V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN

    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := (V_TOT)/3;
        
    IF V_AVG >= 90
        THEN V_GRADE := 'A';
    ELSIF V_AVG >= 80
        THEN V_GRADE := 'B';
    ELSIF V_AVG >= 70
        THEN V_GRADE := 'C';
    ELSIF V_AVG >= 60
        THEN V_GRADE := 'D';
    ELSE V_GRADE := 'F';
    END IF;
    
    INSERT INTO TBL_SUNGJUK(HAKBUN, NAME, KOR, ENG, MAT, TOT, AVG, GRADE)
    VALUES(V_HAKBUN, V_NAME, V_KOR, V_ENG, V_MAT, V_TOT, V_AVG, V_GRADE);
    
    COMMIT;
END;
--==>> Procedure PRC_SUNGJUK_INSERT이(가) 컴파일되었습니다.



--○ TBL_SUNGJUK 테이블에서 특정 학생의 점수 데이터 수정 시
-- 특정 항목의 데이터만 입력하면
-- (학번, 국어점수, 영어점수, 수학점수)
-- 내부적으로 총점, 평균, 등급 항목에 대한 처리가 함께 이루어질 수 있도록 하는
-- 프로시저를 작성한다. (생성한다.)
-- 프로시저 명 : PRC_SUNGJUK_UPDATE()

/*
실행 예)
EXEC PRC_SUNGJUK_UPDATE(1, 50, 50, 50);

→ 프로시저 호출로 처리된 결과
학번 이름 국어점수 영어점수 수학점수 총점 평균 등급
 1   엄소연  50      50      50   150   50     F

*/


CREATE OR REPLACE PROCEDURE PRC_SUNGJUK_UPDATE
( V_HAKBUN  IN TBL_SUNGJUK.HAKBUN%TYPE
, V_KOR     IN TBL_SUNGJUK.KOR%TYPE
, V_ENG     IN TBL_SUNGJUK.ENG%TYPE
, V_MAT     IN TBL_SUNGJUK.MAT%TYPE
)
IS
    V_TOT TBL_SUNGJUK.TOT%TYPE;
    V_AVG TBL_SUNGJUK.AVG%TYPE; 
    V_GRADE TBL_SUNGJUK.GRADE%TYPE;
BEGIN
    -- 실행부
    -- UPDATE 쿼리문 수행에 앞서 추가로 선언한 주료 변수들에 값 담아내기
    V_TOT := V_KOR + V_ENG + V_MAT;
    V_AVG := V_TOT/3;
    
    IF (V_AVG >= 90)
        THEN V_GRADE := 'A';
    ELSIF (V_AVG >= 80)
        THEN V_GRADE := 'B';
    ELSIF (V_AVG >= 70)
        THEN V_GRADE := 'C';
    ELSIF (V_AVG >= 60)
        THEN V_GRADE := 'D';
    ELSE V_GRADE := 'F';
    END IF;
    
    -- UPDATE 쿼리문 수행
    UPDATE TBL_SUNGJUK
    SET KOR = V_KOR, ENG = V_ENG, MAT=V_MAT
        , TOT = V_TOT, AVG = V_AVG, GRADE = V_GRADE
    WHERE HAKBUN = V_HAKBUN;

    COMMIT;
END;
--==>>Procedure PRC_SUNGJUK_UPDATE이(가) 컴파일되었습니다.



---○ TBL_STUDENTS 테이블에서 전화번호와 주소 데이터를 변경하는(수정하는) 
-- 프로시저를 작성한다.
--    단, ID와 PW 가 일치하는 경우에는 수정을 진행할 수 있도록 처리한다.
--    프로시저 명 : PRC_STUDENTS_UPDATE
/*
실행 예)
EXEC PRC_STUDENTS_UPDATE('superman','java002','010-9876-5432','강원도 횡성');
--> 패스워드 일치하지 않음 --==>> 데이터 수정 X

EXEC PRC_STUDENTS_UPDATE('superman','java002$','010-9876-5432','강원도 횡성');
--> 패스워드 일치함 --==>> 데이터 수정 ○

*/

CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID  IN TBL_IDPW.ID%TYPE
, V_PW  IN TBL_IDPW.PW%TYPE
, V_TEL IN TBL_STUDENTS.TEL%TYPE
, V_ADDR IN TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL, ADDR = V_ADDR
    WHERE ID = V_ID
      AND (SELECT PW FROM TBL_IDPW WHERE ID=V_ID) = V_PW;
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_UPDATE이(가) 컴파일되었습니다.


-- 조인
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID      IN TBL_IDPW.ID%TYPE
, V_PW      IN TBL_IDPW.PW%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    UPDATE ( SELECT I.ID, I.PW, S.TEL, S.ADDR
              FROM TBL_IDPW I JOIN TBL_STUDENTS S
              ON I.ID = S.ID) T
    SET T.TEL = V_TEL, T.ADDR = V_ADDR
    WHERE T.ID = V_ID AND T.PW = V_PW;
    
    COMMIT;
END;


CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID  IN TBL_IDPW.ID%TYPE
, V_PW  IN TBL_IDPW.PW%TYPE
, V_TEL IN TBL_STUDENTS.TEL%TYPE
, V_ADDR IN TBL_STUDENTS.ADDR%TYPE
)
IS
    -- 필요한 변수 선언
    V_PW2   TBL_IDPW.PW%TYPE;
    V_FLAG  NUMBER := 0;
BEGIN
    -- 패스워드가 맞는지 확인
    SELECT PW INTO V_PW2
    FROM TBL_IDPW
    WHERE ID = V_ID;

    -- 패스워드 일치 여부에 따른 분기
    IF (V_PW = V_PW2)
        THEN V_FLAG := 1;
    ELSE
        V_FLAG := 2;
    END IF;

    -- UPDATE 쿼리문 수행 → TBL_STUDENTS (분기 결과 반영)
    UPDATE TBL_STUDENTS
    SET TEL = V_TEL, ADDR = V_ADDR
    WHERE ID = V_ID
      AND V_FLAG = 1;

    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_UPDATE이(가) 컴파일되었습니다.



--○ TBL_INSA 테이블을 대상으로 신규 데이터 입력 프로시저를 작성한다.
--NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG
--으로 구성된 컬럼 중
--NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG
--의 데이터 입력 시
--NUM 컬럼(사원번호)의 값은
--기존 부여된 사원 번호의 마지막 번호 그 다음 번호를 자동으로 입력처리할 수 있는
-- 프로시저로 구성한다.
-- 프로시저 명 : PRC_INSA_INSERT()
/*
실행 예)
EXEC PRC_INSA_INSERT('조현하',''970124-2234567',SYSDATE, '서울', '010-7202-6306'
, '개발부', '대리', 2000000, 2000000);

→ 프로시저 호출로 처리된 결과
1061 조현하 .... 2000000 
의 데이터가 신규 입력된 상황
*/

CREATE OR REPLACE PROCEDURE PRC_INSA_INSERT
( V_NAME        IN TBL_INSA.NAME%TYPE
, V_SSN         IN TBL_INSA.SSN%TYPE
, V_IBSADATE    IN TBL_INSA.IBSADATE%TYPE
, V_CITY        IN TBL_INSA.CITY%TYPE
, V_TEL         IN TBL_INSA.TEL%TYPE
, V_BUSEO       IN TBL_INSA.BUSEO%TYPE
, V_JIKWI       IN TBL_INSA.JIKWI%TYPE
, V_BASICPAY    IN TBL_INSA.BASICPAY%TYPE
, V_SUDANG      IN TBL_INSA.SUDANG%TYPE
)
IS
    V_LASTNUM TBL_INSA.NUM%TYPE;
BEGIN
    
    SELECT MAX(NVL(NUM, 0)) + 1 INTO V_LASTNUM
    FROM TBL_INSA;
    

    INSERT INTO TBL_INSA(NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI,BASICPAY,SUDANG)
    VALUES(V_LASTNUM, V_NAME, V_SSN, V_IBSADATE, V_CITY, V_TEL, V_BUSEO, V_JIKWI, V_BASICPAY, V_SUDANG);
    
    COMMIT;
END;
--==>> Procedure PRC_INSA_INSERT이(가) 컴파일되었습니다.









