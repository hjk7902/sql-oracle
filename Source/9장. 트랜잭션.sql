SET AUTOCOMMIT ON
SHOW AUTOCOMMIT
SET AUTOCOMMIT OFF
SHOW AUTOCOMMIT

CREATE TABLE emps AS SELECT * FROM employees;
DELETE FROM emps WHERE department_id=10;
SAVEPOINT delete_10;
DELETE FROM emps WHERE department_id=20;
SAVEPOINT delete_20;
DELETE FROM emps WHERE department_id=30;
ROLLBACK TO SAVEPOINT delete_20; 

CREATE TABLE emp AS 
SELECT employee_id AS empno, first_name AS ename, 
       salary AS sal, department_id AS deptno
FROM employees;

