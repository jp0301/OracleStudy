CREATE OR REPLACE VIEW VIEW_PROF_SCORE_INFO
AS
-- �������(����)
-- �����, ���������, ����������, �����, �л���, ���, �Ǳ�, �ʱ�, ����, ���, �ߵ�Ż������
SELECT T.�����, T.����Ⱓ, T.�����, T.�л���, T.���, T.�ʱ�, T.�Ǳ�, T.����
, RANK() OVER(PARTITION BY T.���������ڵ� ORDER BY T.���� DESC) "���"
, T.�ߵ�Ż������
FROM (
        SELECT SB.SUB_NAME "�����"
        , OS.OPENSUB_START || ' ~ ' || OS.OPENSUB_END "����Ⱓ"
        , BK.BOOK_NAME "�����"
        , SD.STD_NAME "�л���"
        , SC.SCO_ATTEND "���"
        , SC.SCO_WRITE "�ʱ�"
        , SC.SCO_PRAC "�Ǳ�"
        , FN_TOTAL_SCORE(SC.SCO_CODE, OS.OPENSUB_CODE)"����"
        , OS.OPENSUB_CODE "���������ڵ�"
        , CASE WHEN SG.SUGANG_CODE = OT.SUGANG_CODE
               THEN '��'
               ELSE '��'
                END "�ߵ�Ż������"
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
--==>> View VIEW_PROF_SCORE_INFO��(��) �����Ǿ����ϴ�.

SELECT *
FROM VIEW_PROF_SCORE_INFO;