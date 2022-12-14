/*
--○ 과목 관리
1. PRC_SUB_INSERET(과정명, 과목명, 과목기간, 교재명, 교수자명) (과목 등록)
2. VIEW_SUB_INFO (정보출력)
   SELECT 과정명, 강의실, 과목기간, 교재명, 교수자명
3. PRC_SUB_UPDATE(과목코드, 수정할데이터)   (과목수정)
4. PRC_SUB_DELETE(과목코드)         (과목삭제)
*/


--○ 과목 시퀀스 생성
CREATE SEQUENCE TBL_SUB_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999
NOCYCLE
NOCACHE;
--==>> Sequence TBL_SUB_SEQ이(가) 생성되었습니다.

--○ 과목 등록
--   1. PRC_SUB_INSERT(과목코드, 과목명)
CREATE OR REPLACE PROCEDURE PRC_SUB_INSERT
( V_SUB_NAME     IN TBL_SUB.SUB_NAME%TYPE
)
IS 
    SUB_CHECK_NAME TBL_SUB.SUB_NAME%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    -- 이미 있는 과목명인지 확인
    SELECT NVL((SELECT SUB_NAME
                FROM TBL_SUB
                WHERE SUB_NAME = V_SUB_NAME), '0') INTO SUB_CHECK_NAME
    FROM DUAL;
    
    -- 조건 : 에러 발생
    IF (SUB_CHECK_NAME != '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    INSERT INTO TBL_SUB(SUB_CODE, SUB_NAME)
    VALUES(('SUB' || LPAD(TO_CHAR(TBL_SUB_SEQ.NEXTVAL), 3, '0')), V_SUB_NAME);
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20501, '이미 등록된 과목입니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_SUB_INSERT이(가) 컴파일되었습니다.



--○ 과목 수정
--   2. PRC_SUB_UPDATE(과목코드, 수정할과목명)
CREATE OR REPLACE PROCEDURE PRC_SUB_UPDATE
( V_SUB_CODE    IN TBL_SUB.SUB_CODE%TYPE -- 과목코드
, V_SUB_NAME    IN TBL_SUB.SUB_NAME%TYPE -- 수정할 과목명
)
IS 
    SUB_CHECK_CODE TBL_SUB.SUB_CODE%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN

    -- 과목코드가 같은지 판단하기 위한 조회
    SELECT NVL((SELECT SUB_CODE
                FROM TBL_SUB
                WHERE SUB_CODE = V_SUB_CODE), '0') INTO SUB_CHECK_CODE
    FROM DUAL;
    
    -- 조건 판단으로 에러발생, 코드가 없으면 예외
    IF (SUB_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
 

    -- 과목이름 변경 
    UPDATE TBL_SUB
    SET SUB_NAME = V_SUB_NAME
    WHERE SUB_CODE = V_SUB_CODE;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20502, '존재하지 않은 코드입니다..');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK; 
    -- 커밋
    COMMIT;
END
--==>> Procedure PRC_SUB_UPDATE이(가) 컴파일되었습니다.

--○ 과목 등록
--   3. PRC_SUB_DELETE(과목코드)
CREATE OR REPLACE PROCEDURE PRC_SUB_DELETE
( V_SUB_CODE IN TBL_SUB.SUB_CODE%TYPE
)
IS 
    SUB_CHECK_CODE TBL_SUB.SUB_CODE%tYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN

    SELECT NVL((SELECT SUB_CODE
                FROM TBL_SUB
                WHERE SUB_CODE = V_SUB_CODE), '0') INTO SUB_CHECK_CODE
    FROM DUAL;

    IF (SUB_CHECK_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    DELETE
    FROM TBL_SUB
    WHERE SUB_CODE = V_SUB_CODE;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20503, '존재하지 않는 과목입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
            
    --커밋
    COMMIT;   
END;
--==>> Procedure PRC_SUB_DELETE이(가) 컴파일되었습니다.


--○ 원래 더미데이터넣어놨었는데 시퀀스때문에 삭제하고 프로시저로 다시 입력시켰음
EXEC PRC_SUB_INSERT('JAVA');
EXEC PRC_SUB_INSERT('ORACLE');
EXEC PRC_SUB_INSERT('HTML/CSS+Javascript');
EXEC PRC_SUB_INSERT('JSP');
EXEC PRC_SUB_INSERT('Spring Framework');
EXEC PRC_SUB_INSERT('Python');
EXEC PRC_SUB_INSERT('R Programming');
EXEC PRC_SUB_INSERT('Hadoop Programming');
EXEC PRC_SUB_INSERT('Python ML');




--○ 4. 뷰 생성 VIEW_SUB_INFO (정보출력)
CREATE OR REPLACE VIEW VIEW_SUB_INFO
AS
 
SELECT CO.COURSE_NAME "과정명"
, CL.CLASS_NAME "강의실명"
, SB.SUB_NAME "과목명"
, OS.OPENSUB_START "과목시작일"
, OS.OPENSUB_END "과목종료일"
, BK.BOOK_NAME "교재명"
, PR.PROF_NAME "교수이름"
FROM TBL_OPENSUB OS
JOIN TBL_OPENCOU OC
ON OS.OPENCOU_CODE = OC.OPENCOU_CODE
JOIN TBL_CLASS CL
ON OC.CLASS_CODE = CL.CLASS_CODE
JOIN TBL_COURSE CO
ON OC.COURSE_CODE = CO.COURSE_CODE
JOIN TBL_SUB SB
ON OS.SUB_CODE = SB.SUB_CODE
JOIN TBL_BOOK BK
ON OS.BOOK_CODE = BK.BOOK_CODE
JOIN TBL_PROF PR
ON OS.PROF_CODE = PR.PROF_CODE;


SELECT *
FROM VIEW_SUB_INFO;
 
 
 
 
 



