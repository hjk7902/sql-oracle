------------------------
--6장 조인을 이용한 다중 테이블 검색
------------------------
SELECT * FROM employees;
SELECT * FROM departments;
--2. 오라클 조인
--2.1. CARTESIAN PRODUCT
SELECT first_name, department_name
FROM employees, departments
;

SELECT first_name, employees.department_id, department_name
FROM employees, departments; 

SELECT e.first_name, e.department_id, d.department_name
FROM employees e, departments d;

--2.2. EQUI JOIN
SELECT e.first_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id; 

--2.3. SELF JOIN
SELECT e.first_name AS employee_name, m.first_name AS manager_name
FROM employees e, employees m --e는 사원 테이블, m은 manager 테이블
WHERE e.manager_id = m.employee_id AND e.employee_id=103;

--2.4. NON-EQUI JOIN
SELECT * FROM jobs;

SELECT  e.first_name, e.salary, j.job_title
FROM    employees e, jobs j
WHERE   e.salary
BETWEEN j.min_salary AND j.max_salary
ORDER BY first_name;

--2.5. OUTER JOIN
SELECT e.employee_id, e.first_name, e.department_id, d.department_name
FROM   employees e, departments d
WHERE  e.department_id(+) = d.department_id
ORDER BY e.employee_id; 

--모든 사원을 조회하는데 있어서 직책 변동 기록이 있는 사원이 있다면 그 변동내역까지 조회하는 쿼리를 작성.
SELECT e.employee_id, e.first_name, e.hire_date,
       j.start_date, j.end_date, j.job_id, j.department_id
FROM   employees e, job_history j
WHERE  e.employee_id = j.employee_id
ORDER BY j.employee_id;

SELECT e.employee_id, e.first_name, e.hire_date,
       j.start_date, j.end_date, j.job_id, j.department_id
FROM   employees e, job_history j
WHERE  e.employee_id = j.employee_id(+)
ORDER BY j.employee_id;

--3. ANSI JOIN
--3.1. CROSS JOIN
SELECT employee_id, department_name
FROM  employees 
CROSS JOIN departments;

SELECT * FROM departments;
SELECT * FROM locations;
SELECT * FROM employees;

--3.2. NATURAL JOIN
SELECT employee_id, first_name, department_id, department_name
FROM employees 
NATURAL JOIN departments;


--CREATE TABLE emp2 AS select employee_id, first_name, department_id from employees;
--3.3. USING JOIN
SELECT first_name, department_name
FROM   employees 
JOIN   departments 
USING (department_id);

--3.4. ON JOIN
SELECT first_name, department_name
FROM employees e 
JOIN departments d 
ON (e.department_id=d.department_id);

--여러 테이블 조인
--모든 사원의 이름과 부서이름, 부서의 주소를 출력하세요.
SELECT e.first_name AS name,
       d.department_name AS department, 
       l.street_address || ', ' || l.city || ', ' || l.state_province AS address
FROM  employees e 
JOIN  departments d 
ON    e.department_id=d.department_id
JOIN  locations l 
ON    d.location_id=l.location_id;

--WHERE 절과의 혼용
SELECT e.first_name AS name,
       d.department_name AS department
FROM  employees e 
JOIN  departments d 
ON    e.department_id=d.department_id
WHERE employee_id = 103;

--ON 절에 WHERE 절의 조건 추가
SELECT e.first_name AS name,
       d.department_name AS department
FROM  employees e 
JOIN  departments d 
ON    e.department_id=d.department_id AND employee_id = 103;

SELECT e.first_name AS name,
       d.department_name AS department, 
       l.street_address || ', ' || l.city || ', ' || l.state_province AS address
FROM  employees e 
JOIN  departments d 
ON    e.department_id=d.department_id AND employee_id = 103
JOIN  locations l 
ON    d.location_id=l.location_id;

SELECT e.first_name AS name,
       d.department_name AS department, 
       l.street_address || ', ' || l.city || ', ' || l.state_province AS address
FROM  employees e 
JOIN  departments d 
ON    e.department_id=d.department_id
JOIN  locations l 
ON    d.location_id=l.location_id AND employee_id = 103;

--3.5. OUTER JOIN
SELECT first_name, department_name
FROM employees e 
JOIN departments d 
ON   e.department_id=d.department_id; --106개 행 인출

SELECT first_name, department_name
FROM   employees e 
LEFT JOIN   departments d 
ON     e.department_id=d.department_id
WHERE  e.department_id IS NULL;

SELECT first_name, department_name
FROM   employees e 
LEFT JOIN   departments d 
ON     e.department_id=d.department_id
WHERE  e.department_id IS NULL;

SELECT e.employee_id, e.first_name, e.hire_date,
       j.start_date, j.end_date, j.job_id, j.department_id
FROM   employees e
LEFT JOIN job_history j
ON       e.employee_id = j.employee_id
ORDER BY j.employee_id;

SELECT e.employee_id, e.first_name, e.hire_date,
       j.start_date, j.end_date, j.job_id, j.department_id
FROM   job_history j
FULL JOIN employees e
ON       e.employee_id = j.employee_id
ORDER BY j.employee_id;

--연습문제
--1
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE first_name='John'
  AND e.department_id=d.department_id
  AND d.location_id=l.location_id;
  
SELECT e.first_name, d.department_name, l.city
FROM employees e
  JOIN departments d ON e.department_id=d.department_id
    JOIN locations l ON d.location_id=l.location_id
WHERE first_name='John';

--2
SELECT e.employee_id, e.first_name, e.salary, m.first_name, d.department_name
FROM employees e
  JOIN employees m ON e.manager_id=m.employee_id
    JOIN departments d ON m.department_id=d.department_id
WHERE e.employee_id=103;

--3
SELECT e.employee_id, e.first_name, e.salary, 
       m.first_name, m.salary, d.department_name
FROM  employees e, employees m, departments d 
WHERE e.manager_id=m.employee_id(+)
  AND m.department_id=d.department_id(+)
  AND e.department_id=90;

SELECT e.employee_id, e.first_name, e.salary, 
       m.first_name, m.salary, d.department_name
FROM employees e
  LEFT JOIN employees m ON e.manager_id=m.employee_id
    LEFT JOIN departments d ON m.department_id=d.department_id
WHERE e.department_id=90;

--4
SELECT e.employee_id, l.city
FROM employees e
  JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE e.employee_id=103;

--5
SELECT 
	l.city as "Department Location", j.job_title as "Manager's Job"
FROM employees e
  JOIN departments d ON e.department_id=d.department_id
    JOIN locations l ON d.location_id=l.location_id
      JOIN employees m ON e.manager_id=m.employee_id
        JOIN jobs j ON m.job_id=j.job_id
WHERE e.employee_id=103;

--6
SELECT e.employee_id, e.first_name, e.last_name, e.email,
       e.phone_number, e.hire_date, j.job_title, e.salary, 
       e.commission_pct, 
       m.first_name as manager_first_name, 
       m.last_name as manager_last_name, 
       d.department_name 
FROM employees e 
  LEFT JOIN departments d on e.department_id=d.department_id 
    JOIN jobs j ON e.job_id=j.job_id 
      LEFT JOIN employees m ON e.manager_id=m.employee_id;

--7
--2라인


