--------------------------------
--2�� SELECT���� �̿��� ������ ��ȸ
--------------------------------
--1. SELECT ANSWKD
--1.3. SQL ���� �ۼ�
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES;

--1.4. ��� �� ����
SELECT  *
FROM    departments;

--1.5. Ư�� �� ����
SELECT department_id, department_name, manager_id, location_id
FROM   departments;

--1.6. �⺻ ǥ�� ����
SELECT department_name, location_id
FROM   departments;

--1.7. ��� ǥ����
SELECT location_id, department_name
FROM   departments;

--1.8. ������ �켱����
SELECT first_name, hire_date, salary
FROM   employees;

SELECT first_name, last_name, salary, salary + 300
FROM   employees;

SELECT first_name, last_name, salary, salary + salary * 0.1
FROM   employees;

SELECT first_name, last_name, salary, 12*(salary+100)
FROM   employees;

--1.9. NULL
SELECT first_name, department_id, commission_pct
FROM   employees;

--1.10. �� ��Ī(alias) ����
SELECT  first_name AS �̸�,  salary  �޿�
FROM    employees;

SELECT  first_name "Name",
        salary*12  "Annual Salary"
FROM    employees;

SELECT  first_name "Employee Name", salary*12 "Annual Salary"
FROM    employees;

--1.11. ���ͷ� ���� ��Ʈ���� ���� ������
SELECT  first_name || ' ' || last_name || '""s salary is $' || salary
    AS      "Employee Details"
FROM    employees;

--1.12. �ߺ� ��� DISTINCT
SELECT department_id
FROM   employees;

SELECT DISTINCT department_id
FROM   employees;

--1.13. ROWID, ROWNUM �ǻ翭
SELECT ROWID, ROWNUM, employee_id, first_name
FROM employees;

--2. ������ ����
--2.2. ���õ� �� ����
SELECT first_name, job_id, department_id 
FROM employees
WHERE job_id='IT_PROG';

--2.3. ���ڿ� ��¥
SELECT first_name, last_name, hire_date
FROM employees
WHERE last_name='King';

SELECT first_name, last_name, hire_date
FROM employees
WHERE last_name='king'; --���ϵǴ� ���� ����

--2.4. �� ������
SELECT * 
FROM nls_database_parameters 
WHERE parameter='NLS_DATE_FORMAT'; 

SELECT first_name, salary, hire_date
FROM employees
WHERE salary >= 15000;

SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date='04/01/30';

SELECT first_name, salary, hire_date
FROM employees
WHERE first_name='Steven';

--2.5. BETWEEN ������
SELECT first_name, salary
FROM   employees
WHERE  salary BETWEEN 10000 AND 12000;

--2.6. IN ������
SELECT employee_id, first_name, salary, manager_id
FROM   employees
WHERE  manager_id IN(101, 102, 103);

SELECT first_name, last_name, job_id, department_id
FROM   employees
WHERE  job_id IN('IT_PROG', 'FI_MGR', 'AD_VP');

--2.7. LIKE ������
SELECT first_name, last_name, job_id, department_id
FROM   employees
WHERE  job_id LIKE 'IT%';

SELECT first_name, hire_date
FROM   employees
WHERE  hire_date LIKE '03%';

SELECT first_name, email
FROM   employees
WHERE  email LIKE '_A%';

SELECT first_name, job_id
FROM   employees
WHERE  job_id LIKE 'SA\_M%' ESCAPE '\';

--2.8. IS NULL ������
SELECT first_name, manager_id, job_id
FROM   employees
WHERE  manager_id IS NULL;

SELECT first_name, job_id, commission_pct
FROM   employees
WHERE  commission_pct IS NULL;

SELECT first_name, job_id, commission_pct
FROM   employees
WHERE  commission_pct IS NOT NULL;

--2.9. �� ������
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

--2.10. �� ������ �켱����
SELECT first_name, job_id, salary
FROM   employees
WHERE  job_id='IT_PROG' OR job_id='FI_MGR' AND salary >= 6000;

SELECT first_name, job_id, salary
FROM   employees
WHERE  (job_id='IT_PROG' OR job_id='FI_MGR') AND salary >= 6000;

--3. ������ ����
SELECT   first_name, hire_date
FROM     employees
ORDER BY hire_date;

--3.1. �������� ����
SELECT   first_name, hire_date
FROM     employees
ORDER BY hire_date DESC;

--3.2. �� ��Ī �Ǵ� ���� ������ �̿��� ����
SELECT   first_name, salary*12 AS annsal
FROM     employees
ORDER BY annsal;

SELECT   first_name, salary*12 AS annsal
FROM     employees
ORDER BY 2;

--��������
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
where hire_date between '03/01/01' and '03/12/31';

--9
select first_name, hire_date, salary 
from employees 
where hire_date like '03%';

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
select first_name || ' ' || last_name || ' ����� �޿��� ' || salary || ' �Դϴ�.'
from employees 
where first_name='Steven' and last_name='King';

--14
select first_name, job_id 
from employees 
where job_id like '%MAN';

--15
select first_name, job_id 
from employees 
where job_id like '%MAN' order by job_id;


