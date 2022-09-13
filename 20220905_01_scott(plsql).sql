SELECT USER
FROM DUAL;


--���� TRIGGER(Ʈ����) ����--

-- �������� �ǹ� : ��Ƽ�, �˹߽�Ű��, �߱��ϴ�, �����ϴ�.

-- Ư���δ� ���� ���̴� �κ�Ʈ���� �����غ���.
-- ���̺� ���̴� ��

-- 1. TRIGGER(Ʈ����)�� DML �۾� ��, INSERT, UPDATE, DELETE �۾�� �Ͼ ��
-- �ڵ������� ����Ǵ� (���ߵǴ�, �˹ߵǴ�) ��ü��
-- �̿� ���� Ư¡�� �����Ͽ� DML TRIGGER ��� �θ��⵵ �Ѵ�.
-- TRIGGER �� ���Ἲ �� �ƴ϶� ������ ���� �۾����� �θ� ���ȴ�.

    -- �ڵ����� �Ļ��� �� �� ����
    -- �߸��� Ʈ����� ����
    -- ������ ���� ���� ���� ����
    -- �л� �����ͺ��̽� ��� �󿡼� ���� ���Ἲ ���� ����
    -- ������ ���� ��Ģ ���� ����
    -- ������ �̺�Ʈ �α� ����
    -- ������ ���� ����
    -- ���� ���̺� ���� ��������
    -- ���̺� �׼��� ��� ����


-- 2. TRIGGER �������� COMMIT, ROLLBACK ���� ����� �� ����.

-- 3. Ư¡ �� ����
--    - BEFORE STATEMENT
--      : SQL ������ ����Ǳ� ���� �� ���忡 ���� �� �� ����
--    - BEFORE ROW
--      : SQL ������ ����Ǳ� ����(DML �۾��� �����ϱ� ����)
--        �� ��(ROW)�� ���� �� ���� ����
--    - AFTER STATEMENT
--      : SQL ������ ����� �Ŀ� �� ���忡 ���� �� �� ����
--    - AFTER ROW
--      : SQL ������ ����� �Ŀ�(DML �۾��� ������ �Ŀ�)
--        �� ��(ROW)�� ���� �� ���� ����


-- 4. ���� �� ����
/*
CREATE [OR REPLACE] TRIGGER Ʈ���Ÿ�
       [BEFORE | AFTER]
       �̺�Ʈ1 [OR �̺�Ʈ2 [OR �̺�Ʈ3]] ON ���̺��
       [FOR EACH ROW [WHEN TRIGGER ����]]
[DECLARE]
    -- ���� ����;
BEGIN
    -- ���� ����;
END;
*/

--���� AFTER STATEMENT TRIGGER ��Ȳ �ǽ� ����--
-- �� DML �۾��� ���� �̺�Ʈ ��Ͽ��� ���� ���δ�.

--�� TRIGGER(Ʈ����) ����
-- Ʈ���� �� : TRG_EVENTLOG

CREATE OR REPLACE TRIGGER TRG_EVENTLOG
    AFTER
    INSERT OR UPDATE OR DELETE ON TBL_TEST1
BEGIN
    -- �̺�Ʈ ���� ���� (���ǹ��� ���� �б�)
    IF (INSERTING)
        THEN INSERT INTO TBL_EVENTLOG(MEMO)
             VALUES('INSERT ������ ����Ǿ����ϴ�.');
    ELSIF (UPDATING)
        THEN INSERT INTO TBL_EVENTLOG(MEMO)
             VALUES('UPDATE ������ ����Ǿ����ϴ�.');
    ELSIF (DELETING)
        THEN INSERT INTO TBL_EVENTLOG(MEMO)
             VALUES('DELETE ������ ����Ǿ����ϴ�.');
    END IF;
    
    --�� Ʈ���ſ����� TCL ����(COMMIT/ROLLBACK) ����ϸ� �ȵȴ�. �Ұ�~!!!
    --COMMIT;
END;
--==>> Trigger TRG_EVENTLOG��(��) �����ϵǾ����ϴ�.


--���� BEFORE STATEMENT TRIGGER ��Ȳ �ǽ� ����--
--�� DML �۾� ���� ���� �۾��� ���� ���� ���� Ȯ�� 

--�� TRIGGER(Ʈ����) ����
-- Ʈ���� �� : TRG_EVENTLOG
CREATE OR REPLACE TRIGGER TRG_TEST1_DML
    BEFORE
    INSERT OR UPDATE OR DELETE ON TBL_TEST1
BEGIN
    IF (�۾��ð��� ���� 8�� �����̰ų�... ���� 6�� ���Ķ��...)
        THEN �۾��� �������� ���ϵ��� ó���ϰڴ�.
    END IF;
END;

---------------

CREATE OR REPLACE TRIGGER TRG_TEST1_DML
    BEFORE
    INSERT OR UPDATE OR DELETE ON TBL_TEST1
BEGIN
    --IF (�۾��ð��� ���� 8�� �����̰ų�... ���� 6�� ���Ķ��...)
    IF (TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) < 11
        OR
        TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) > 17 )
        --THEN �۾��� �������� ���ϵ��� ó���ϰڴ�.
        THEN RAISE_APPLICATION_ERROR(-20003, '�۾��� 8:00 ~ 18:00 ������ ����.');
    END IF;
END;
--==>> Trigger TRG_TEST1_DML��(��) �����ϵǾ����ϴ�.




--���� BEFORE ROW TRIGGER ��Ȳ �ǽ� ����--
--�� ���� ���谡 ������ ������(�ڽ�) ������ ���� �����ϴ� ��

--�� TRIGGER(Ʈ����) ����
-- Ʈ���� �� : TRG_TEST_DELETE
CREATE OR REPLACE TRIGGER TRG_TEST2_DELETE
         BEFORE 
         DELETE ON TBL_TEST2
         FOR EACH ROW 
BEGIN
    DELETE
    FROM TBL_TEST3
    WHERE CODE = :OLD.CODE;
END;
--==>> Trigger TRG_TEST2_DELETE��(��) �����ϵǾ����ϴ�.


--�� ��:OLD��
--    ���� �� ���� ��
--    (INSERT : �Է��ϱ� ���� ������, DELETE : �����ϱ� ���� ������ ��, ������ ������)

--�� UPDATE : DELETE �׸��� INSERT �� ���յ� ����, ��ü�δ� ���� ����� �����Է��ϴ� �����̴�.
--            UPDATE �ϱ� ������ �����ʹ� ��:OLD��
--            UPDATE �� ���� �����ʹ� ��:NEW��


--���� AFTER ROW TRIGGER ��Ȳ �ǽ� ����--
--�� ���� ���̺� ���� Ʈ����� ó���� ���� ���� ���δ�.

-- TBL_�԰�, TBL_���, TBL_��ǰ

--�� TBL_�԰� ���̺��� ������ �Է� ��(��, �԰� �̺�Ʈ �߻� ��)
--   TBL_��ǰ ���̺��� ������ ���� Ʈ���� ����
--   Ʈ���� �� : TRG_IBGO

CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT ON TBL_�԰�
        FOR EACH ROW
BEGIN
    IF (INSERTING) 
        THEN UPDATE TBL_��ǰ
             SET ������ = ���� ������ + ���� �԰�Ǵ� ��ǰ�� �԰����
             WHERE ��ǰ�ڵ� = ���� �԰�Ǵ� ��ǰ�� ��ǰ�ڵ�;
    END IF;
END;
---------

CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT ON TBL_�԰�
        FOR EACH ROW
BEGIN
    IF (INSERTING) 
        THEN UPDATE TBL_��ǰ
             SET ������ = ������ + :NEW.�԰����
             WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    END IF;
END;
---------

CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT ON TBL_�԰�
        FOR EACH ROW
BEGIN
    UPDATE TBL_��ǰ
    SET ������ = ������ + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
END;
--==>> Trigger TRG_IBGO��(��) �����ϵǾ����ϴ�.
---------

--�� TBL_�԰� ���̺��� ������ �Է�, ����, ���� ��
--   TBL_��ǰ ���̺��� ������ ���� Ʈ���� �ۼ�
--   Ʈ���� �� : TRG_IBGO

CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT OR UPDATE OR DELETE ON TBL_�԰�
        FOR EACH ROW
BEGIN
    IF(INSERTING) 
        THEN UPDATE TBL_��ǰ
             SET ������ = ������ + :NEW.�԰����
             WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    ELSIF(UPDATING)
        THEN UPDATE TBL_��ǰ
             SET ������ = ������ + (:NEW.�԰����-:OLD.�԰����)
             WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    ELSIF(DELETING)
        THEN UPDATE TBL_��ǰ
             SET ������ = ������ - :OLD.�԰����
             WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
    END IF;
END;
--==>> Trigger TRG_IBGO��(��) �����ϵǾ����ϴ�.



---------



--�� TBL_��� ���̺��� ������ �Է�, ����, ���� ��
--   TBL_��ǰ ���̺��� ������ ���� Ʈ���� �ۼ�
--   Ʈ���� �� : TRG_CHULGO
CREATE OR REPLACE TRIGGER TRG_CHULGO
    AFTER
    INSERT OR UPDATE OR DELETE ON TBL_���
    FOR EACH ROW
BEGIN
    IF(INSERTING)
        THEN UPDATE TBL_��ǰ
             SET ������ = ������ - :New.������
             WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    ELSIF(UPDATING)
        THEN UPDATE TBL_��ǰ
            -- ���̺��� ���������� ������Ʈ �ϱ� ������ �������� �����ش�����
            -- �ٽ� ���Ӱ� ������Ʈ �� �������� ����.
             SET ������ = ������ + :OLD.������ - :NEW.������
             WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    ELSIF(DELETING)
        THEN UPDATE TBL_��ǰ
             SET ������ = ������ + :OLD.������ + :NEW.������
             WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;   
    END IF;
END;
--==>> Trigger TRG_CHULGO��(��) �����ϵǾ����ϴ�.



--���� PACKAGE(��Ű��) ����--

-- 1. PL/SQL �� ��Ű���� ����Ǵ� Ÿ��, ���α׷� ��ü
--    ���� ���α׷�(PROCEDURE, FUNCTION ��)��
--    �������� ������� ������
--    ����Ŭ���� �����ϴ� ��Ű�� �� �ϳ��� �ٷ� 'DBMS_OUTPUT'�̴�.

-- 2. ��Ű���� ���� ������ ������ ���Ǵ� ���� ���� ���ν����� �Լ���
--    �ϳ��� ��Ű���� ����� ���������ν� ���� ���������� ���ϰ�
--    ��ü ���α׷��� ���ȭ �� �� �ִ� ������ �ִ�.


-- 3. ��Ű���� ����(PACKAGE SPECIFICATION)�� 
--    ��ü��(PACKAGE BODY)�� �����Ǿ� ������
--    �� �κп��� TYPE, CONSTRATNT, VARIABLE, EXCEPTION, CURSOR, SUBPROGRAM�� ����ǰ�
--    ��ü �κп��� �̵��� ���� ������ �����Ѵ�.
--    �׸���, ȣ���� ������ '��Ű����.���ν�����' ������ ������ �̿��ؾ� �Ѵ�.

-- 4. ���� �� ����(����)
/*
CREATE [OR REPLACE] PACKAGE ��Ű����
IS
    �������� ����;
    Ŀ�� ����;
    ���� ����;
    �Լ� ����;
    ���ν��� ����;
        :
END ��Ű����;
*/

-- 5. ���� �� ����(��ü��)
/*
CREATE [OR REPLACE] PACKAGE BODY ��Ű����
IS
    FUNCTION �Լ���[(�μ�, ...)]
    RETURN �ڷ���
    IS
        ���� ����;
    BEGIN
        �Լ� ��ü ���� �ڵ�;
        RETURN ��;
    END;
    
    PROCEDURE ���ν�����[(�μ�, ...)]
    IS
        ���� ����;
    BEGIN
        ���ν��� ��ü ���� �ڵ�;
    END;
        
END ��Ű����;
*/


-- ��Ű�� ��� �ǽ�

--�� ���� �ۼ�
CREATE OR REPLACE PACKAGE INSA_PACK
IS
    FUNCTION FN_GENDER(V_SSN VARCHAR2)
    RETURN VARCHAR2;
END INSA_PACK;
--==>> Package INSA_PACK��(��) �����ϵǾ����ϴ�.

--�� ��ü�� �ۼ�
CREATE OR REPLACE PACKAGE BODY INSA_PACK
IS
    FUNCTION FN_GENDER(V_SSN VARCHAR2)
    RETURN VARCHAR2
    IS
        V_RESULT VARCHAR2(20);
    BEGIN
        IF (SUBSTR(V_SSN,8,1) IN ('1', '3'))
            THEN V_RESULT := '����';
        ELSIF (SUBSTR(V_SSN, 8, 1) IN ('2', '4'))
            THEN V_RESULT := '����';
        ELSE
            V_RESULT := 'Ȯ�κҰ�';
        END IF;
        
        RETURN V_RESULT;
    END;
END INSA_PACK;
--==>> Package Body INSA_PACK��(��) �����ϵǾ����ϴ�.










