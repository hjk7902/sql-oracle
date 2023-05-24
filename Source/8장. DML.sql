--------------------------------
--8장 데이터 조작(DML)
--------------------------------
--1. DML

--2. CTAS
CREATE TABLE emp1 AS SELECT * FROM employees;
DESC emp1;
SELECT * FROM emp1;
-- 테이블의 제약조건은 복사되지 않는다. 단 Not Null은 복사됨.
-- NN을 제외한 다른 제약조건은 복사되지 않는다.

CREATE TABLE emp2 AS SELECT * FROM employees WHERE 1=2;
SELECT * FROM emp2;
DESC emp2;

DROP TABLE emp2; --실행 후 취소가 안됨, 이전 작업이 취소됨
-- DROP TABLE은 DDL(데이터 정의어)구문이고 이 구문이 실행되면 이전 트랜젝션은 COMMIT됨

CREATE TABLE dept_temp AS SELECT * FROM departments;

DESC dept_temp;

INSERT INTO departments 
VALUES (280, 'Data Analytics', null, 1700);

SELECT * 
FROM departments
WHERE department_id=280;

ROLLBACK;

--3. INSERT
--DROP TABLE managers;
CREATE TABLE managers AS 
SELECT employee_id, first_name, job_id, salary, hire_date
FROM   employees
WHERE  1=2;

SELECT *
FROM   employees;

INSERT INTO managers 
  (employee_id, first_name, job_id, salary, hire_date)
  SELECT employee_id, first_name, job_id, salary, hire_date
  FROM   employees
  WHERE  job_id LIKE '%MAN';

SELECT * FROM managers;

--DROP TABLE emps;
CREATE TABLE emps AS SELECT * FROM employees;
select employee_id, first_name, manager_id from employees;
--ALTER TABLE emps
--ADD CONSTRAINT emps_pk
--PRIMARY KEY(employee_id);
--ALTER TABLE emps DROP CONSTRAINT emps_pk;

ALTER TABLE emps
ADD (CONSTRAINT emps_emp_id_pk PRIMARY KEY (employee_id),
--  CONSTRAINT emps_dept_fk FOREIGN KEY (department_id) REFERENCES depts,
--  CONSTRAINT emps_job_fk FOREIGN KEY (job_id) REFERENCES jobs (job_id),
  CONSTRAINT emps_manager_fk FOREIGN KEY (manager_id) REFERENCES emps
);

ALTER TABLE emps
ADD CONSTRAINT emps_mgr_fk
PRIMARY KEY(employee_id);

DROP TABLE depts;
CREATE TABLE depts AS SELECT * FROM departments;

--4. UPDATE
SELECT employee_id, first_name, salary
FROM   emps
WHERE  employee_id=103;

UPDATE emps
SET    salary=salary*1.1
WHERE  employee_id=103;

SELECT employee_id, first_name, salary
FROM   emps
WHERE  employee_id=103;

COMMIT;

--109번 사원(Daniel)은 FI_ACCOUNT(Accountant)직무입니다. 
--그의 직무를 108번 사원(Nancy)의 직무(FI_MGR(Finance Manager))로 변경시키면서,
--급여, 매니저아이디도 108번 사원의 급여, 매니저 아이디로 업데이트 합니다.

select * from jobs;

SELECT employee_id, first_name, job_id, salary, manager_id 
FROM emps
WHERE  employee_id IN (108, 109);

UPDATE emps 
SET (job_id, salary, manager_id) =
    (SELECT job_id, salary, manager_id 
     FROM   emps
     WHERE  employee_id = 108)
WHERE employee_id=109;

SELECT *
FROM   emps;

--5. DELETE
DELETE FROM emps
WHERE employee_id=104;

DELETE FROM emps
WHERE employee_id=103;

DROP TABLE depts;
CREATE TABLE depts AS 
  SELECT * FROM departments;

DESC depts;

DELETE FROM emps
WHERE department_id=
                   (SELECT department_id 
                    FROM depts
                    WHERE department_name='Shipping');
rollback;

emp_name.exists;

--여기부터 SQL Command Line에서 실행하세요.
VARIABLE emp_name VARCHAR2(50);
VARIABLE emp_sal  NUMBER;
VARIABLE;

DELETE emps
WHERE  employee_id=109
RETURNING first_name, salary INTO :emp_name, :emp_sal;

PRINT emp_name;
PRINT emp_sal;
--여기까지 SQL Command Line에서 실행하세요.

--6. MERGE
SELECT * FROM emps;

DROP TABLE emps;
CREATE TABLE emps_it AS SELECT * FROM employees WHERE 1=2;
DESC emps_it 

INSERT 
  INTO emps_it (employee_id, first_name, last_name, email, hire_date, job_id) 
VALUES
  (105, 'David', 'Kim', 'DAVIDKIM', '06/03/04', 'IT_PROG');
COMMIT;

MERGE INTO emps_it c
  USING (SELECT * FROM employees WHERE job_id='IT_PROG') e
  ON (c.employee_id = e.employee_id)
WHEN MATCHED THEN
  UPDATE SET
    c.phone_number = e.phone_number,
    c.hire_date = e.hire_date,
    c.job_id = e.job_id,
    c.salary = e.salary,
    c.commission_pct = e.commission_pct,
    c.manager_id = e.manager_id,
    c.department_id = e.department_id
WHEN NOT MATCHED THEN
  INSERT VALUES(e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, 
                e.hire_date, e.job_id, e.salary, e.commission_pct,
                e.manager_id, e.department_id);

--7. Multiple INSERT
SELECT * FROM emps_it;
DROP TABLE emp2;
CREATE TABLE emp2 AS SELECT * FROM employees;
SELECT COUNT(*) FROM emp2;

CREATE TABLE emp3 AS SELECT * FROM employees WHERE 1=2;
SELECT COUNT(*) FROM emp3;

INSERT ALL 
  INTO emp2 
    VALUES (300, 'Kildong', 'Hong', 'KHONG', '011.624.7902', 
      TO_DATE('2015-05-11', 'YYYY-MM-DD'), 'IT_PROG', 6000, 
      null, 100, 90)
  INTO emp3 
    VALUES (400, 'Kilseo', 'Hong', 'KSHONG', '011.3402.7902', 
      TO_DATE('2015-06-20', 'YYYY-MM-DD'), 'IT_PROG', 5500, 
      null, 100, 90)
  SELECT * FROM dual;
  
CREATE TABLE emp_salary AS 
  SELECT employee_id, first_name, salary, commission_pct 
  FROM employees
  WHERE 1=2;
  
CREATE TABLE emp_hire_date AS
  SELECT employee_id, first_name, hire_date, department_id
  FROM employees
  WHERE 1=2;

INSERT ALL
  INTO emp_salary VALUES (employee_id, first_name, salary, commission_pct)
  INTO emp_hire_date VALUES (employee_id, first_name, hire_date, department_id)
  SELECT * FROM employees;
SELECT * FROM emp_salary;
SELECT * FROM emp_hire_date;

CREATE TABLE emp_10 AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE emp_20 AS SELECT * FROM employees WHERE 1=2;

INSERT ALL
  WHEN department_id=10 THEN
    INTO emp_10 VALUES
         (employee_id, first_name, last_name, email, phone_number, 
          hire_date, job_id, salary, commission_pct, manager_id, 
          department_id)
  WHEN department_id=20 THEN
    INTO emp_20 VALUES
         (employee_id, first_name, last_name, email, phone_number, 
           hire_date, job_id, salary, commission_pct, manager_id, 
           department_id)
  SELECT * FROM employees;

SELECT * FROM emp_10;
SELECT * FROM emp_20;

--SELECT first_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS year
--FROM employees;
SELECT first_name, salary
FROM employees;

--DROP TABLE emp_year;
--CREATE TABLE emp_year AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE emp_sal5000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal10000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal15000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal20000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal25000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;

INSERT FIRST
  WHEN salary <= 5000 THEN
    INTO emp_sal5000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 10000 THEN
    INTO emp_sal10000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 15000 THEN
    INTO emp_sal15000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 20000 THEN
    INTO emp_sal20000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 25000 THEN
    INTO emp_sal25000 VALUES (employee_id, first_name, salary)
  SELECT employee_id, first_name, salary FROM employees;

SELECT COUNT(*) FROM emp_sal5000;
SELECT COUNT(*) FROM emp_sal10000;
SELECT COUNT(*) FROM emp_sal15000;
SELECT COUNT(*) FROM emp_sal20000;
SELECT COUNT(*) FROM emp_sal25000;

--Pivoting Insert
DROP TABLE sales;
CREATE TABLE sales(
  employee_id        NUMBER(6),
  week_id            NUMBER(2),
  sales_mon          NUMBER(8,2),
  sales_tue          NUMBER(8,2),
  sales_wed          NUMBER(8,2),
  sales_thu          NUMBER(8,2),
  sales_fri          NUMBER(8,2));

INSERT INTO sales VALUES(1101, 4, 100, 150, 80, 60, 120);
INSERT INTO sales VALUES(1102, 5, 300, 300, 230, 120, 150);

COMMIT;
SELECT * FROM sales; --열 단위로 저장된 데이터

CREATE TABLE sales_data(
 employee_id        NUMBER(6),
 week_id            NUMBER(2),
 week_day           VARCHAR2(10),
 sales              NUMBER(8,2)
); 

TRUNCATE TABLE sales_data;
INSERT ALL
  INTO sales_data VALUES(employee_id, week_id, 'SALES_MON', sales_mon) 
  INTO sales_data VALUES(employee_id, week_id, 'SALES_TUE', sales_tue)
  INTO sales_data VALUES(employee_id, week_id, 'SALES_WED', sales_wed)
  INTO sales_data VALUES(employee_id, week_id, 'SALES_THU', sales_thu)
  INTO sales_data VALUES(employee_id, week_id, 'SALES_FRI', sales_fri) 
  SELECT employee_id, week_id, sales_mon, sales_tue, 
       sales_wed, sales_thu, sales_fri 
  FROM sales;

SELECT * FROM sales_data; --행 단위로 저장된 데이터
