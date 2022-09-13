CREATE OR REPLACE VIEW VIEW_PROF_SCORE_INFO
AS
-- 성적출력(교수)
-- 과목명, 과목시작일, 과목종료일, 교재명, 학생명, 출결, 실기, 필기, 총점, 등수, 중도탈락여부
SELECT T.과목명, T.과목기간, T.교재명, T.학생명, T.출결, T.필기, T.실기, T.총점
, RANK() OVER(PARTITION BY T.개설과목코드 ORDER BY T.총점 DESC) "등수"
, T.중도탈락여부
FROM (
        SELECT SB.SUB_NAME "과목명"
        , OS.OPENSUB_START || ' ~ ' || OS.OPENSUB_END "과목기간"
        , BK.BOOK_NAME "교재명"
        , SD.STD_NAME "학생명"
        , SC.SCO_ATTEND "출결"
        , SC.SCO_WRITE "필기"
        , SC.SCO_PRAC "실기"
        , FN_TOTAL_SCORE(SC.SCO_CODE, OS.OPENSUB_CODE)"총점"
        , OS.OPENSUB_CODE "개설과목코드"
        , CASE WHEN SG.SUGANG_CODE = OT.SUGANG_CODE
               THEN '○'
               ELSE 'Ⅹ'
                END "중도탈락여부"
        FROM TBL_OPENSUB OS
        JOIN TBL_PROF PR
          ON OS.PROF_CODE = PR.PROF_CODE
        JOIN TBL_SUB SB
          ON OS.SUB_CODE = SB.SUB_CODE
        JOIN TBL_BOOK BK
          ON OS.BOOK_CODE = BK.BOOK_CODE
        JOIN TBL_SCO SC
          ON OS.OPENSUB_CODE = SC.OPENSUB_CODE
        JOIN TBL_SUGANG SG
          ON SC.SUGANG_CODE = SG.SUGANG_CODE
        JOIN TBL_STD SD
          ON SG.STD_CODE = SD.STD_CODE
        LEFT JOIN TBL_OUT OT
               ON SG.SUGANG_CODE = OT.SUGANG_CODE

) T;
--==>> View VIEW_PROF_SCORE_INFO이(가) 생성되었습니다.

SELECT *
FROM VIEW_PROF_SCORE_INFO;