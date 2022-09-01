SELECT USER
FROM DUAL;
--==>> SCOTT

SET SERVEROUTPUT ON;

--○ 변수에 임의의 값을 대입하고 출력하는 구문 작성
DECLARE
    --선언부
    GRADE CHAR;
BEGIN
    --실행부
    GRADE := 'A';
    
    IF GRADE = 'A'
        THEN DBMS_OUTPUT.PUT_LINE('EXCELLENT');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL');
    END IF;
END;
--==>> EXCELLENT


DECLARE
    --선언부
    GRADE CHAR;
BEGIN
    --실행부
    GRADE := 'B';
    
    IF GRADE = 'A'
        THEN DBMS_OUTPUT.PUT_LINE('EXCELLENT');
    ELSIF GRADE = 'B'
        THEN DBMS_OUTPUT.PUT_LINE('GOOD');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('FAIL');
    END IF;
END;
--==>> GOOD

--○ CASE 문(조건문)
-- CASE ~ WHEN ~ THEN ~ ELSE ~ END CASE;

-- 1. 형식 및 구조
/*
CASE 변수
    WHEN 값1 THEN 실행문;
    WHEN 값2 THEN 실행문;
    ELSE 실행문N+1;
END CASE;
*/




-- 남자1 여자2 입력하세요
-- 1
-- 남자입니다.

-- 남자1 여자2 입력하세요
-- 2
-- 여자입니다.

ACCEPT NUM PROMPT '남자1 여자2 입력하세요';
DECLARE
    -- 선언부 → 주요 변수 선언
    SEL NUMBER := &NUM;
    RESULT VARCHAR2(10) := '남자';
BEGIN
    -- 테스트
    DBMS_OUTPUT.PUT_LINE('SEL : ' || SEL);
END;
--==>> SEL : 1




ACCEPT NUM PROMPT '남자1 여자2 입력하세요';
DECLARE
    -- 선언부 → 주요 변수 선언
    SEL NUMBER := &NUM;
    RESULT VARCHAR2(10) := '남자';
BEGIN
    /*
    CASE SEL
        WHEN 1
        THEN DBMS_OUTPUT.PUT_LINE('남자입니다.');
        WHEN 2
        THEN DBMS_OUTPUT.PUT_LINE('여자입니다.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('확인불가');
    END CASE;
    */
    
    CASE SEL
        WHEN 1
        THEN RESULT := '남자';
        WHEN 2
        THEN RESULT := '여자';
        ELSE
             RESULT := '확인불가';
    END CASE;
    
    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE('처리 결과는' || RESULT || '입니다.');
END;
-- 2 입력 --==>> 처리 결과는 여자입니다.


--○ 외부 입력 처리
--ACCEPT 구문
--ACCEPT 변수명 PROMPT '메세지';
--> 외부 변수로부터 입력받은 데이터를 내부 변수에 전달할 때
-- 『&외부변수명』 형태로 접근하게 된다.


--○ 정수 두 개를 외부로부터(사용자로부터) 입력받아
--   이들의 덧셈 결과를 출력하는 PL/SQL 구문을 작성한다.

ACCEPT NUM1 PROMPT '첫 번째 정수를 입력해주세요.';
ACCEPT NUM2 PROMPT '두 번째 정수를 입력해주세요.';
DECLARE
    N1 NUMBER := &NUM1;
    N2 NUMBER := &NUM2;
    TOTAL NUMBER := 0;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('N1 : ' || N1);
    DBMS_OUTPUT.PUT_LINE('N2 : ' || N2);
    -- 연산 및 처리
    TOTAL := N1 + N2;
    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE(N1 || '+' || N2 || '=' || TOTAL);
END;
--==>>
/*
N1 : 23
N2 : 47
23+47=70

*/


--○ 사용자로부터 입력받은 금액을 화폐 단위로 구분하여 출력하는 프로그램을 작성한다.
--   단, 반환 금액은 편의상 1천원 미만, 10원 이상만 가능하다고 가정한다.
/*
실행 예)
바인딩 변수 입력 대화창 → 금액 입력 : 990원

입력받은 금액 총액 : 990원
화폐단위 : 오백원 1, 백원 4, 오십원 1, 십원 4
*/

ACCEPT MONEY PROMPT '금액을 입력해주세요.';

DECLARE
    COIN NUMBER := &MONEY;
    C500 NUMBER := 0;
    C100 NUMBER := 0;
    C50  NUMBER := 0;
    C10  NUMBER := 0;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('입력받은 금액 총액 : ' || COIN);
    
    C500 := TRUNC(COIN / 500);
    COIN := MOD(COIN, 500);
    
    C100 := TRUNC(COIN / 100);
    COIN := MOD(COIN, 100);
    
    C50 := TRUNC(COIN / 50);
    COIN := MOD(COIN, 50);
    
    C10 := TRUNC(COIN / 10);
    COIN := MOD(COIN, 10);
    
    
    DBMS_OUTPUT.PUT_LINE('화폐단위 : 오백원 ' || C500 || ' 백원 ' || C100 || ' 오십원 ' || C50 || ' 십원 ' || C500);
END;
/*
입력받은 금액 총액 : 990
화폐단위 : 오백원 1 백원 4 오십원 1 십원 1
*/


ACCEPT INPUT PROMPT '금액 입력';
DECLARE
    MONEY NUMBER := &INPUT; -- 연산을 위해 입력값을 담아둘 변수
    MONEY2 NUMBER := &INPUT;          -- 결과 출력을 위해 입력값을 담아둘 변수
                            -- (MONEY 변수가 연산 과정에서 값이 변하기 때문에...)
    M500 NUMBER := 0;       -- 500원 짜리 갯수를 담아둘 변수
    M100 NUMBER := 0;
    M50  NUMBER := 0;
    M10  NUMBER := 0;
BEGIN
    
    -- 연산 및 처리
    --MONEY 를 500으로 나눠서 몫을 취하고 나머지는 버린다. → 500원의 갯수
    M500 := TRUNC(MONEY / 500);
    --MONEY를 500으로 나눠서 몫은 버리고 나머지를 취한다. → 500원의 갯수 확인
    -- 이 결과를 다시 MONEY에 담아낸다.
    MONEY := MOD(MONEY, 500);
    
    M100 := TRUNC(MONEY / 100);
    MONEY := MOD(MONEY, 100);
    
    M50 := TRUNC(MONEY / 50);
    MONEY := MOD(MONEY, 50);
    
    M10 := TRUNC(MONEY / 10);
    MONEY := MOD(MONEY, 10);
    
    DBMS_OUTPUT.PUT_LINE('입력받은 금액 총액 : ' || MONEY2);
    DBMS_OUTPUT.PUT_LINE('화폐단위 : 오백원 ' || M500 || ' 백원 ' || M100 || ' 오십원 ' || M50 || ' 십원 ' || M10);
END;



--○ 기본 반복문
-- LOOP ~ END LOOP

-- 1. 조건과 상관없이 무조건 반복하는 구문.

-- 2. 형식 및 구조
/*
LOOP
    --실행문
    EXIT WHEN 조건;   -- 조건이 참인 경우 반복문을 빠져나간다.
END LOOP;
*/


--○ 1부터 10까지의 수 출력(LOOP 문 활용)
DECLARE
    NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        EXIT WHEN NUM >= 10;
        NUM := NUM+1;
    END LOOP;
END;
/*
1
2
3
4
5
6
7
8
9
10
*/




--○ WHILE 반복문
-- WHILE LOOP ~ END LOOP;

-- 1. 제어 조건이 TRUE 인 동안 일련의 문장을 반복하기 위해
-- WHILE LOOP 구문을 사용한다.
-- 조건은 반복이 시작되는 시점에 체크하게 되어
-- LOOP 내의 문장이 한 번도 수행되지 않을 경우도 있다.
-- LOOP 를 시작할 때 조건이 FALSE 이면 반복 문장을 탈출하게 된다.

-- 2. 형식 및 구조
/*
WHILE 조건 LOOP       -- 조건이 참인 경우 반복 수행
        -- 실행문;
END LOOP;
*/

--○ 1부터 10까지의 수 출력(WHILE 문 활용)
DECLARE
    NUM NUMBER := 1;
BEGIN
    WHILE NUM <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM+1;
    END LOOP;
END;
/*
1
2
3
4
5
6
7
8
9
10
*/


--○ FOR 반복문
--FOR LOOP ~ END LOOP;

-- 1. 『시작수』에서 1씩 증가하여
--    『끝냄수』가 될 때까지 반복 수행한다.

-- 2. 형식 및 구조
/*
FOR 카운터 IN 시작수 .. 끝냄수 LOOP
    --실행문;
END LOOP;
*/


--○ 1부터 10까지의 수 출력(FOR LOOP 문 활용)
DECLARE
    N NUMBER;
BEGIN
    
    FOR N IN 1 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/*
1
2
3
4
5
6
7
8
9
10
*/

--○ 사용자로부터 임의의 단(구구단)을 입력받아
--   해당 단수의 구구단을 출력하는 PL/SQL 구문을 작성한다.
/*
실행 예)
바인딩 변수 입력 대화창 → 단을 입력하세요 : 2

2 * 1 = 2
    :
2 * 9 = 18
*/

-- 1. LOOP 문
ACCEPT INPUT PROMPT '단을 입력하세요.';

DECLARE
    N NUMBER;
    N1 NUMBER;
BEGIN
    N := &INPUT;
    N1 := 1;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(N || ' * ' || N1 || ' = ' || N*N1);
        EXIT WHEN N1 > 10;
        N1 := N1+1;
    END LOOP;
END;



-- 2. WHILE LOOP문
ACCEPT INPUT PROMPT '단을 입력하세요.';

DECLARE
    N NUMBER;
    N1 NUMBER;
BEGIN
    N := &INPUT;
    N1 := 1;
    
    WHILE N1 < 10 LOOP
        DBMS_OUTPUT.PUT_LINE(N || ' * ' || N1 || ' = ' || N*N1);
        N1 := N1+1;
    END LOOP;
END;


-- 3. FOR LOOP문
ACCEPT INPUT PROMPT '단을 입력하세요.';

DECLARE
    N NUMBER;
    N1 NUMBER;
BEGIN
    N := &INPUT;
    N1 := 1;
    
    FOR CN IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(N || ' * ' || CN || ' = ' || N*CN);
    END LOOP;
END;


--○ 구구단 전체(2단 ~ 9단)를 출력하는 PL/SQL 구문을 작성한다.
--   단, 이중 반복문(반복문의 중첩) 구문을 활용한다.
/*
실행 예)
===[2단]===
2 * 1 = 2
2 * 2 = 4
:

===[3단]===
3 * 1 = 3
3 * 2 = 6
:
9 * 9 = 91
*/

-- FOR문
DECLARE
    DAN NUMBER;
    N NUMBER;
BEGIN
    FOR DAN IN 2 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE('==['|| DAN || '단' ||']==');
        FOR N IN 1 .. 9 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
        END LOOP;
    END LOOP;
END;



-- WHILE 문
DECLARE
    DAN NUMBER := 2;
    N NUMBER := 1;
BEGIN
    WHILE DAN < 10 LOOP
        DBMS_OUTPUT.PUT_LINE('==['|| DAN || '단' ||']==');
        
        WHILE N < 10 LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || DAN*N);
            N := N+1;
        END LOOP;
        N := 1;
        DAN := DAN+1;
    END LOOP;
END;



-- LOOP 문
DECLARE
    DAN NUMBER := 2;
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('==['|| DAN || '단' ||']==');
        LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || N || ' = ' || (DAN*N) );
            N := N+1;
            EXIT WHEN N > 10;
        END LOOP;
        N := 1;
        DAN := DAN+1;
        EXIT WHEN DAN > 10;
    END LOOP;
END;


