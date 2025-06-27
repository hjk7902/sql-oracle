--------------------------------
--10장 테이블 생성과 관리
--------------------------------
--
CREATE TABLE dept (
   deptno  NUMBER(2),
   dname   VARCHAR2(14),
   loc     VARCHAR2(13) );

DESCRIBE dept

CREATE TABLE emp2 AS SELECT * FROM employees;
SELECT COUNT(*) FROM emp2;
CREATE TABLE emp3 AS SELECT * FROM employees WHERE 1=2;
SELECT COUNT(*) FROM emp3;

CREATE TABLE emp_dept50 
AS
  SELECT employee_id, first_name, salary*12 AS ann_sal, hire_date
  FROM employees
  WHERE department_id=50;
  
ALTER TABLE emp_dept50
ADD (job VARCHAR2(10));

SELECT * FROM emp_dept50;

ALTER TABLE emp_dept50
RENAME COLUMN job TO job_id;

DESC emp_dept50;

ALTER TABLE emp_dept50
MODIFY (first_name VARCHAR2(30));

ALTER TABLE emp_dept50
MODIFY (first_name VARCHAR2(10));

SELECT MAX(LENGTHB(first_name)) FROM emp_dept50;

ALTER TABLE emp_dept50
MODIFY (first_name VARCHAR2(7));

ALTER TABLE emp_dept50
DROP COLUMN job_id;

DESC emp_dept50;

ALTER TABLE emp_dept50 SET  UNUSED (first_name);
DESC emp_dept50;
ALTER TABLE emp_dept50 DROP UNUSED COLUMNS;

desc USER_UNUSED_COL_TABS;
SELECT * FROM USER_UNUSED_COL_TABS;

RENAME emp_dept50 TO employees_dept50;

DROP TABLE employees_dept50;

DESC employees_dept50;

TRUNCATE TABLE emp2;
SELECT * FROM emp2;
DESC emp2;