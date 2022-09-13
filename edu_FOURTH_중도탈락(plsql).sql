
--○ 중도탈락 시퀀스 생성
CREATE SEQUENCE TBL_OUT_SEQ
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999
NOCYCLE
NOCACHE;
--==>> Sequence TBL_OUT_SEQ이(가) 생성되었습니다.



--○ 중도탈락 등록 프로시저
-- PRC_OUT_INSERT(수강코드, 수강탈락사유코드)
CREATE OR REPLACE PROCEDURE PRC_OUT_INSERT
( V_SUGANG_CODE         IN TBL_OUT.SUGANG_CODE%TYPE
, V_OUT_REASON_CODE     IN TBL_OUT.OUT_REASON_CODE%TYPE
)
IS
    -- 체크용 코드 선언
    CHECK_OUT_CODE TBL_OUT.OUT_CODE%TYPE;
    CHECK_SUGANG_CODE TBL_SUGANG.SUGANG_CODE%TYPE;
    CHECK_OUT_REASON_CODE TBL_OUT_REASON.OUT_REASON_CODE%TYPE;
    -- 중도탈락 코드
    V_OUT_CODE TBL_OUT.OUT_CODE%TYPE;
    
    -- 과정 시작일과 종료일
    V_OPENCOU_START TBL_OPENCOU.OPENCOU_START%TYPE;
    V_OPENCOU_END TBL_OPENCOU.OPENCOU_END%TYPE;
    
    -- 예외 처리
    USER_DEFINE_ERROR1 EXCEPTION;
    USER_DEFINE_ERROR2 EXCEPTION;
    USER_DEFINE_ERROR3 EXCEPTION;
    USER_DEFINE_ERROR4 EXCEPTION;
BEGIN
    
    -- 중간탈락코드가 이미 있으면 에러 발생
    -- 중간탈락코드가 없어서 0이되면 등록 진행
    SELECT NVL((SELECT OUT_CODE FROM TBL_OUT WHERE OUT_CODE = V_OUT_CODE), '0') INTO CHECK_OUT_CODE
    FROM DUAL;
    
    IF (CHECK_OUT_CODE != '0')
        THEN RAISE USER_DEFINE_ERROR1;
    END IF;
    
    -- 수강코드가 있으면 진행, 없으면 에러 발생
    SELECT NVL((SELECT SUGANG_CODE FROM TBL_SUGANG WHERE SUGANG_CODE = V_SUGANG_CODE), '0') INTO CHECK_SUGANG_CODE
    FROM DUAL;
    
    IF (CHECK_SUGANG_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR2;
    END IF;
    
    -- 탈락사유코드가 있으면 진행, 없으면 에러 발생
    SELECT NVL((SELECT OUT_REASON_CODE FROM TBL_OUT_REASON WHERE OUT_REASON_CODE = V_OUT_REASON_CODE), '0') INTO CHECK_OUT_REASON_CODE
    FROM DUAL;
    
    IF (CHECK_OUT_REASON_CODE = '0')
        THEN RAISE USER_DEFINE_ERROR3;
    END IF;   
    
    
    -- 과정시작일과 종료일 사이에 있지 않으면 중도 포기,탈락시킬 수 없게 처리한다.
    -- 수강신청 테이블에 있는 수강 코드와 입력한 수강코드가 같은 것을 찾아
    -- 과정코드를 가져오고
    -- 그 과정코드가 개설과정테이블에 있는 과정코드와 같은 것의
    -- 개설과정 시작일, 개설과정 종료일을 가져온다.
    SELECT OPENCOU_START, OPENCOU_END INTO V_OPENCOU_START, V_OPENCOU_END
    FROM TBL_OPENCOU
    WHERE OPENCOU_CODE = (SELECT OPENCOU_CODE FROM TBL_SUGANG WHERE SUGANG_CODE = V_SUGANG_CODE);
    
    IF (SYSDATE NOT BETWEEN V_OPENCOU_START AND V_OPENCOU_END)
        THEN RAISE USER_DEFINE_ERROR4;
    END IF;
    
    
    -- INSERT 구문
    INSERT INTO TBL_OUT(OUT_CODE, SUGANG_CODE, OUT_REASON_CODE, OUT_DATE)
    VALUES(('OT' || LPAD(TO_CHAR(TBL_OUT_SEQ.NEXTVAL), 3, '0')), V_SUGANG_CODE, V_OUT_REASON_CODE, SYSDATE);
    
    -- 성적 미달을 따로 계산해서 중도탈락에 등록시키려면 성적의 총점이 몇점이하인지가 나와있지않았을까..?
    
    -- 예외처리 
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20971, '이미 해당 수강을 중도 포기,탈락된 학생입니다.');
            ROLLBACK;
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20972, '존재하지 않은 수강코드입니다.');
            ROLLBACK;  
        WHEN USER_DEFINE_ERROR3
            THEN RAISE_APPLICATION_ERROR(-20973, '존재하지 않은 탈락사유코드입니다.');
            ROLLBACK;  
        WHEN USER_DEFINE_ERROR4
            THEN RAISE_APPLICATION_ERROR(-20974, '처리할 수 있는 과정기간이 아닙니다.');
            ROLLBACK;  
            
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_OUT_INSERT이(가) 컴파일되었습니다.


--○ 중도탈락 수정 프로시저
-- PRC_OUT_UPDATE(중도탈락코드, 변경할 중도탈락사유코드)
CREATE OR REPLACE PROCEDURE PRC_OUT_UPDATE
( V_OUT_CODE        IN TBL_OUT.OUT_CODE%TYPE
, V_OUT_REASON_CODE IN TBL_OUT_REASON.OUT_REASON_CODE%TYPE
)
IS
    CHECK_OUT_REASON_CODE TBL_OUT_REASON.OUT_REASON_CODE%TYPE;
    
    USER_DEFINE_ERROR1 EXCEPTION;
BEGIN

    -- 새로 적은 중도탈락사유코드가 중도탈락테이블에 존재하는 코드인지 확인
    SELECT NVL((SELECT OUT_REASON_CODE 
                FROM TBL_OUT_REASON 
                WHERE OUT_REASON_CODE = V_OUT_REASON_CODE), '0') INTO CHECK_OUT_REASON_CODE
    FROM DUAL;

    IF (CHECK_OUT_REASON_CODE != '0')
        THEN RAISE USER_DEFINE_ERROR1;
    END IF;
    
    UPDATE TBL_OUT
    SET OUT_REASON_CODE = V_OUT_REASON_CODE
    WHERE OUT_CODE = V_OUT_CODE;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20973, '존재하지 않은 탈락사유코드입니다.');
            ROLLBACK;
    
    COMMIT;

END;






