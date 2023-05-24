SELECT * FROM employees;

SELECT * FROM USER_ROLE_PRIVS;

SELECT * FROM USER_SYS_PRIVS;


CREATE VIEW emp_view_dept60
AS SELECT   employee_id, first_name, last_name, job_id, salary
   FROM     employees
   WHERE    department_id=60;

DESC emp_view_dept60;

SELECT * FROM emp_view_dept60;

DROP VIEW emp_view_dept60;

CREATE VIEW emp_dept60_salary
AS SELECT   
     employee_id AS empno, 
     first_name || ' ' || last_name AS name, 
     salary AS monthly_salary
   FROM     employees
   WHERE    department_id=60;


DROP VIEW emp_dept60_salary;

CREATE VIEW emp_dept60_salary (empno, name, monthly_salary)
AS SELECT   
     employee_id,
     first_name || ' ' || last_name,
     salary
   FROM     employees
   WHERE    department_id=60;

DESC emp_dept60_salary;

SELECT * FROM emp_dept60_salary;

CREATE OR REPLACE VIEW emp_dept60_salary
AS SELECT   
     employee_id AS empno, 
     first_name || ' ' || last_name AS name, 
     job_id AS job,
     salary
   FROM     employees
   WHERE    department_id=60;

DESC emp_dept60_salary;

DROP VIEW emp_dept60_salary;

CREATE VIEW emp_view
AS SELECT 
    e.employee_id AS id, 
    e.first_name AS name, 
    d.department_name AS department, 
    j.job_title AS job
FROM   employees e
JOIN   departments d ON e.department_id = d.department_id
JOIN   jobs j ON e.job_id = j.job_id;

SELECT * FROM emp_view;

SELECT * FROM emp_details_view;

ROLLBACK;
DROP TABLE emps;
CREATE TABLE emps AS SELECT * FROM employees;
DESC emps;

--�����͸� ������ �� �ִ� ���
CREATE OR REPLACE VIEW emp_dept60
AS SELECT * FROM emps WHERE department_id=60;

SELECT * FROM emp_dept60;
SELECT * FROM emps WHERE employee_id=104;
--104�� ��� Burce�� ������ �����մϴ�.
DELETE FROM emp_dept60 WHERE employee_id=104;
--���� ���̺��� Burce�� ������ ��ȸ�� ���ϴ�.
SELECT * FROM emps WHERE employee_id=104;


--�� ���Ű� �� �Ǵ� ��� : �׷��Լ�, GROUP BY, DISTINCT ���
CREATE OR REPLACE VIEW emp_dept60
AS SELECT DISTINCT * FROM emps WHERE department_id=60;

SELECT * FROM emp_dept60;
SELECT * FROM emps WHERE employee_id=106;
--106�� ����� ������ �����մϴ�.
DELETE FROM emp_dept60 WHERE employee_id=106;

select * from emp_details_view;


--������ ������ �� �Ǵ� ��� : �� ���� �ȵ� ��, ǥ���� ���, ROWNUM ���
CREATE OR REPLACE VIEW emp_dept60
AS SELECT 
     employee_id, 
     first_name || ', ' || last_name AS name, 
     salary*12 AS annual_salary
FROM emps WHERE department_id=60;

SELECT * FROM emp_dept60;
SELECT * FROM emps WHERE employee_id=106;
--106�� ����� ������ �����մϴ�.(����)
UPDATE emp_dept60 SET annual_salary=annual_salary*1.1 
WHERE employee_id=106;
--106�� ����� ������ �����մϴ�.(����)
DELETE FROM emp_dept60 WHERE employee_id=106;


--������ �Է��� �� �Ǵ� ��� : �� ���� �ȵ� ��, ������ ���� �ȵ� ��, �⺻ ���̺� �ִ� NOT NULL �Ӽ��� ���� ���� �信 ���� ���õ��� ���� ���
CREATE OR REPLACE VIEW emp_dept60
AS SELECT 
     employee_id, 
     first_name, 
     last_name,
     email,
     salary
FROM emps WHERE department_id=60;

SELECT * FROM emp_dept60;

INSERT INTO emp_dept60
VALUES(500, 'JinKyoung', 'Heo', 'HEOJK', 8000); -- ����



CREATE TABLE emps AS SELECT * FROM employees;

CREATE OR REPLACE VIEW emp_dept60
AS SELECT   
     employee_id, first_name, hire_date, salary, department_id
   FROM     emps
   WHERE    department_id=60
WITH CHECK OPTION CONSTRAINT emp_dept60_ck;

SELECT * FROM emp_dept60;
rollback;
UPDATE emp_dept60
SET    department_id=10
WHERE  employee_id=105;


CREATE OR REPLACE VIEW emp_dept60
AS SELECT   
     employee_id, first_name, hire_date, salary, department_id
   FROM     emps
   WHERE    department_id=60
WITH READ ONLY;

DELETE FROM emp_dept60
WHERE  employee_id=105;
