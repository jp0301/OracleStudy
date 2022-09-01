SELECT USER
FROM DUAL;


--■■■ PL/SQL ■■■--


-- 1. PL/SQL(Procedural Language extension to SQL) 은
--    프로그램 언어의 특성을 가지는 SQL 의 확장이며,
--    데이터 조작과 질의 문장은 PL/SQL 의 절차적 코드 안에 포함된다.
--    또한, PL/SQL 을 사용하면 SQL 로 할 수 없는 절차적 작업이 가능하다.
--    여기에서 『절차적』이라는 단어가 가지는 의미는
--    어떤 것이 어떤 과정을 거쳐서 어떻게 완료되는지
--    그 방법을 정확하게 코드에 기술한다는 것을 의미한다.

-- 2. PL/SQL 은 절차적으로 표현하기 위해
--    변수를 선언할 수 있는 기능,
--    참과 거짓을 구별할 수 있는 기능,
--    실행 흐름을 컨트롤할 수 있는 기능 등을 제공한다.

-- 3. PL/SQL 은 블럭 구조로 되어 있으며
---   블럭은 선언 부분, 실행 부분, 예외 처리 부분의
--    세 부분으로 구성되어 있다.
--    또한, 반드시 실행 부분은 존재해야 하며, 구조는 다음과 같다.

-- 4. 형식 및 구조
/*
[DECLARE]
    -- 선언문(DECLARATIONS)
BEGIN
    -- 실행문(STATEMENTS)
    
    [EXCEPTION]
        -- 예외 처리문(EXCEPTION HANDLERS)
END;
*/


/*

int num = 10;

String name;

*/

-- 5. 변수 선언
DECLARE
    -- 선언부
    변수명 자료형;
    변수명 자료형 := 초기값;
    
BEGIN
    -- 실행부

END;


--※ DBMS_OUTPUT.PUT_LINE() 을 통해
--   화면에 결과를 출력하기 위한 환경변수 설정
SET SERVEROUTPUT ON;


--○ 변수에 임의의 값을 대입하고 출력하는 구문 작성
DECLARE
    -- 선언부
    D1 NUMBER := 10;
    D2 VARCHAR2(30) := 'HELLO';
    D3 VARCHAR2(20) := 'Oracle';
BEGIN
    -- 실행부
    --System.out.println(D1);
    DBMS_OUTPUT.PUT_LINE(D1);
    DBMS_OUTPUT.PUT_LINE(D2);
    DBMS_OUTPUT.PUT_LINE(D3);
END;
/*
10
HELLO
Oracle
*/

--○ 변수에 임의의 값을 대입하고 출력하는 구문 작성
DECLARE
    -- 선언부
    V1 NUMBER := 10;
    V2 VARCHAR2(30) := 'HELLO';
    V3 VARCHAR2(20) := 'ORACLE';
BEGIN
    -- 실행부
    -- (연산 및 처리)
    V1 := V1 * 10;           --V1 *= 10;
    V2 := V2 || '정미경';      -- +=
    V3 := V3 || ' World~!!!';   -- +=
    
    -- (결과 출력)
    DBMS_OUTPUT.PUT_LINE(V1);
    DBMS_OUTPUT.PUT_LINE(V2);
    DBMS_OUTPUT.PUT_LINE(V3);
END;
--==>>
/*
100
HELLO정미경
ORACLE World~!!!
*/



--○ IF 문(조건문)
-- IF ~ THEN ~ ELSE ~ END IF;

-- 1. PL/SQL 의 IF 문장은 다른 언어의 IF 조건문과 거의 유사하다.
--    일치하는 조건에 따라 선택적으로 작업을 수행할 수 있도록 한다.
--    IF 조건에서 처리한 결과가 TRUE 이면 THEN과 ELSE 사이의 문장을 수행하고
--    FALSE 나 NULL 이면 ELSE 와 END IF; 사이의 문장을 수행하게 된다.

-- 2. 형식 및 구조
--① 
/*
IF 조건
    THEN 처리문;
END IF;
*/

--②
/*
IF 조건
    THEN 처리문;
ELSE
    처리문;
END IF;
*/

--③
/*
IF 조건
    THEN 처리문;
ELSIF 조건
    THEN 처리문;
ELSIF 조건
    THEN 처리문;
ELSIF 조건
    THEN 처리문;
ELSE
    처리문;
END IF;





*/




