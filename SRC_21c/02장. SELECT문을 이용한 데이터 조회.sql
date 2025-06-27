--------------------------------
--2장 SELECT문을 이용한 데이터 조회
--------------------------------
--1. SELECT ANSWKD
--1.3. SQL 문장 작성
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES;

--1.4. 모든 열 선택
SELECT  *
FROM    departments;

--1.5. 특정 열 선택
SELECT department_name, location_id
FROM   departments;

SELECT location_id, department_name
FROM   departments;

--1.6. 기본 표시 형식
SELECT first_name, hire_date, salary
FROM   employees;

--1.7. 산술 표현식
SELECT first_name, last_name, salary, salary + 300
FROM   employees;

--1.8. 연산자 우선순위
SELECT first_name, last_name, salary, salary + salary * 0.1
FROM   employees;

--1.9. NULL
SELECT first_name, department_id, commission_pct
FROM   employees;

--1.10. 열 별칭(alias) 정의
SELECT  first_name AS firstName,  hire_date hireDate
FROM    employees;

SELECT  first_name "firstName", salary*12 "Annual Salary"
FROM    employees;

--1.11. 리터럴 문자 스트링과 연결 연산자
SELECT  first_name || ' ' || last_name || '""s salary is $' || salary
    AS      "Employee Details"
FROM    employees;

--1.12. 중복 행과 DISTINCT
SELECT department_id
FROM   employees;

SELECT DISTINCT department_id
FROM   employees;

--1.13. ROWID, ROWNUM 의사열
SELECT ROWID, ROWNUM, employee_id, first_name
FROM employees;

--2. 데이터 제한
--2.2. 선택된 행 제한
SELECT first_name, job_id, department_id 
FROM employees
WHERE job_id='IT_PROG';

--2.3. 문자와 날짜
SELECT first_name, last_name, hire_date
FROM employees
WHERE last_name='King';

SELECT first_name, last_name, hire_date
FROM employees
WHERE last_name='king'; --리턴되는 행이 없음

SELECT * 
FROM nls_database_parameters 
WHERE parameter='NLS_DATE_FORMAT'; 

--2.4. 비교 연산자
SELECT first_name, salary, hire_date
FROM employees
WHERE salary >= 15000;

SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date='14/01/30';

SELECT first_name, salary, hire_date
FROM employees
WHERE first_name='Steven';

--2.5. BETWEEN 연산자
SELECT first_name, salary
FROM   employees
WHERE  salary BETWEEN 10000 AND 12000;

SELECT first_name, salary, hire_date
FROM   employees
WHERE  hire_date BETWEEN '13/01/01' AND '13/12/13';

SELECT first_name, salary, hire_date
FROM   employees
WHERE  first_name BETWEEN 'A' AND 'Bzzzzzzzz';

--2.6. IN 연산자
SELECT employee_id, first_name, salary, manager_id
FROM   employees
WHERE  manager_id IN(101, 102, 103);

SELECT first_name, last_name, job_id, department_id
FROM   employees
WHERE  job_id IN('IT_PROG', 'FI_MGR', 'AD_VP');

--2.7. LIKE 연산자
SELECT first_name, last_name, job_id, department_id
FROM   employees
WHERE  job_id LIKE 'IT%';

SELECT first_name, hire_date
FROM   employees
WHERE  hire_date LIKE '13%';

SELECT first_name, email
FROM   employees
WHERE  email LIKE '_A%';

SELECT first_name, job_id
FROM   employees
WHERE  job_id LIKE 'SA/_M%' ESCAPE '/';

SELECT first_name, job_id
FROM   employees
WHERE  job_id LIKE 'SA\_M%' ESCAPE '\';


--2.8. IS NULL 연산자
SELECT first_name, manager_id, job_id
FROM   employees
WHERE  manager_id IS NULL;

SELECT first_name, job_id, commission_pct
FROM   employees
WHERE  commission_pct IS NULL;

SELECT first_name, job_id, commission_pct
FROM   employees
WHERE  commission_pct IS NOT NULL;

--2.9. 논리 연산자
SELECT first_name, job_id, salary
FROM   employees
WHERE  job_id='IT_PROG' AND salary>=5000;

SELECT first_name, job_id, salary
FROM   employees
WHERE  job_id='IT_PROG' OR salary>=5000;

SELECT first_name, department_id
FROM   employees
WHERE  department_id NOT IN(50, 60, 70, 80, 90, 100);

SELECT first_name, department_id
FROM   employees
WHERE  department_id NOT BETWEEN 50 AND 100;

--2.10. 논리 연산자 우선순위
SELECT first_name, job_id, salary
FROM   employees
WHERE  job_id='IT_PROG' OR job_id='FI_MGR' AND salary >= 6000;

SELECT first_name, job_id, salary
FROM   employees
WHERE  (job_id='IT_PROG' OR job_id='FI_MGR') AND salary >= 6000;

--3. 데이터 정렬
SELECT   first_name, hire_date
FROM     employees
ORDER BY hire_date;

--3.1. 내림차순 정렬
SELECT   first_name, hire_date
FROM     employees
ORDER BY hire_date DESC;

--3.2. 열 별칭 또는 열의 순서를 이용한 정렬
SELECT   first_name, salary*12 AS annsal
FROM     employees
ORDER BY annsal;

SELECT   first_name, salary*12 AS annsal
FROM     employees
ORDER BY 2;

--연습문제
--1
select employee_id, first_name, hire_date, salary 
from employees;

--2
select first_name || ' ' || last_name name 
from employees;

--3
select * 
from employees 
where department_id=50;

--4
select first_name, department_id, job_id 
from employees 
where department_id=50;

--5
select first_name, salary, salary+300 
from employees;

--6
select first_name, salary 
from employees 
where salary>10000;

--7
select first_name, job_id, commission_pct 
from employees 
where commission_pct is not null;

--8
select first_name, hire_date, salary 
from employees 
where hire_date between '13/01/01' and '13/12/31';

--9
select first_name, hire_date, salary 
from employees 
where hire_date like '13%';

--10
select first_name, salary 
from employees 
order by salary desc;

--11
select first_name, salary 
from employees 
where department_id=60 
order by salary desc;

--12
select first_name, job_id 
from employees 
where job_id='IT_PROG' or job_id='SA_MAN';

select first_name, job_id 
from employees 
where job_id in ('IT_PROG', 'SA_MAN');

--13
select first_name || ' ' || last_name || ' 사원의 급여는 ' || salary || ' 입니다.'
from employees 
where first_name='Steven' and last_name='King';

--14
select first_name, job_id 
from employees 
where job_id like '%MAN';

--15
select first_name, job_id 
from employees 
where job_id like '%MAN' 
order by job_id;


