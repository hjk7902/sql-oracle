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

--데이터를 조작할 수 있는 경우
CREATE OR REPLACE VIEW emp_dept60
AS SELECT * FROM emps WHERE department_id=60;

SELECT * FROM emp_dept60;
SELECT * FROM emps WHERE employee_id=104;
--104번 사원 Burce의 정보를 삭제합니다.
DELETE FROM emp_dept60 WHERE employee_id=104;
--원본 테이블에서 Burce의 정보를 조회해 봅니다.
SELECT * FROM emps WHERE employee_id=104;


--행 제거가 안 되는 경우 : 그룹함수, GROUP BY, DISTINCT 사용
CREATE OR REPLACE VIEW emp_dept60
AS SELECT DISTINCT * FROM emps WHERE department_id=60;

SELECT * FROM emp_dept60;
SELECT * FROM emps WHERE employee_id=106;
--106번 사원의 정보를 삭제합니다.
DELETE FROM emp_dept60 WHERE employee_id=106;

select * from emp_details_view;


--데이터 수정이 안 되는 경우 : 행 제거 안될 때, 표현식 사용, ROWNUM 사용
CREATE OR REPLACE VIEW emp_dept60
AS SELECT 
     employee_id, 
     first_name || ', ' || last_name AS name, 
     salary*12 AS annual_salary
FROM emps WHERE department_id=60;

SELECT * FROM emp_dept60;
SELECT * FROM emps WHERE employee_id=106;
--106번 사원의 정보를 수정합니다.(실패)
UPDATE emp_dept60 SET annual_salary=annual_salary*1.1 
WHERE employee_id=106;
--106번 사원의 정보를 삭제합니다.(성공)
DELETE FROM emp_dept60 WHERE employee_id=106;


--데이터 입력이 안 되는 경우 : 행 제거 안될 때, 데이터 수정 안될 때, 기본 테이블에 있는 NOT NULL 속성을 갖는 열이 뷰에 의해 선택되지 않을 경우
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
VALUES(500, 'JinKyoung', 'Heo', 'HEOJK', 8000); -- 실패



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
