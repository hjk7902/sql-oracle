--시퀀스
DESC depts;
SELECT * FROM depts;

CREATE SEQUENCE depts_seq
    INCREMENT BY 1
    START WITH  91
    MAXVALUE   100
    NOCACHE
    NOCYCLE;

DROP TABLE depts CASCADE CONSTRAINTS;
CREATE TABLE depts (
  deptno     NUMBER(2),
  dname      VARCHAR2(14),
  loc        VARCHAR2(13),
  CONSTRAINT depts_dname_uk UNIQUE(dname),
  CONSTRAINT depts_deptno_pk PRIMARY KEY(deptno));

SELECT sequence_name, min_value, max_value,
       increment_by, last_number
FROM USER_SEQUENCES;

SELECT object_name 
FROM   user_objects 
WHERE  object_type='SEQUENCE';

INSERT INTO depts(deptno, dname, loc)
VALUES (depts_seq.NEXTVAL, 'MARKETING', 'SAN DIEGO');

SELECT * FROM depts;

SELECT depts_seq.CURRVAL
FROM   dual;

ALTER SEQUENCE depts_seq
      MAXVALUE 99999;


DROP SEQUENCE depts_seq;

SELECT depts_seq.CURRVAL
FROM   dual;

--IDENTITY열은 12C부터 사용가능
--CREATE TABLE depts (
--  deptno     NUMBER(2) GENERATED ALWAYS AS IDENTITY (START WITH 10 INCREMENT BY 10),
--  dname      VARCHAR2(14),
--  loc        VARCHAR2(13),
--  CONSTRAINT depts_deptno_pk PRIMARY KEY(deptno),
--  CONSTRAINT depts_dname_uk UNIQUE(dname)
--);

--인덱스
DESC emps;
SELECT * FROM emps;
DROP TABLE emps;

CREATE TABLE emps AS SELECT * FROM employees;

SELECT * FROM emps WHERE first_name='David';
CREATE INDEX emps_first_name_idx
ON           emps(first_name);
SELECT * FROM emps WHERE first_name='David';


SELECT  ic.index_name, ic.column_name, 
        ix.uniqueness
FROM    USER_INDEXES ix, USER_IND_COLUMNS ic
WHERE   ic.index_name = ix.index_name
AND     ic.table_name = 'EMPLOYEES';

CREATE BITMAP INDEX emps_comm_idx 
ON emps(commission_pct); 

--CREATE BITMAP INDEX emps_comm_idx ON emps(commission_pct); 
DROP INDEX emps_email_idx;
SELECT * FROM emps WHERE email='DAUSTIN';
CREATE UNIQUE INDEX emps_email_idx ON emps(email);


SELECT * FROM emps 
WHERE COALESCE(salary+salary*commission_pct, salary) > 10000;

DROP INDEX emps_annsal_idx;
CREATE INDEX emps_annsal_idx
ON emps(COALESCE(salary+salary*commission_pct, salary));

SELECT * FROM emps 
WHERE COALESCE(salary+salary*commission_pct, salary) > 10000;

SELECT * FROM emps WHERE first_name='Peter' AND last_name='Hall';

CREATE UNIQUE INDEX emps_name_indx ON emps(first_name, last_name);

SELECT * FROM emps WHERE first_name='Peter' AND last_name='Hall';

--동의어

CREATE SYNONYM emp60
FOR            emp_dept60;

SELECT * FROM emp60;

DROP SYNONYM emp60;