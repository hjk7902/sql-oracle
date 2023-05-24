--------------------------------
--7�� ��������
--------------------------------
--1. ��������
--Nancy�� �޿����� ���� �޿��� �޴� ����� �̸��� �޿��� ����ϼ���.
SELECT salary FROM employees WHERE first_name='Nancy'; --12008
SELECT first_name, salary FROM employees WHERE salary > 12008;

--�������� �̿�
SELECT first_name, salary 
FROM   employees 
WHERE  salary > (SELECT salary
              FROM   employees 
              WHERE  first_name='Nancy');

--2. ������ ��������
SELECT first_name, job_id, hire_date
FROM   employees
WHERE  job_id = (SELECT job_id
                 FROM   employees
                 WHERE  employee_id=103);
                 
--�޿��� ��� �̻� �޴� ����� �̸��� �޿��� ����ϼ���.
SELECT first_name, salary 
FROM   employees 
WHERE  salary >= (SELECT avg(salary)
               FROM   employees);

--3. ������ ��������
SELECT first_name, salary 
FROM   employees 
WHERE  salary > (SELECT salary
              FROM   employees 
              WHERE  first_name='David'); 
              
SELECT salary 
FROM employees 
WHERE first_name='David';


SELECT first_name, salary 
FROM   employees 
WHERE  salary > ANY (SELECT salary
              FROM   employees 
              WHERE  first_name='David'); -- 4800, 6800, 9500


SELECT first_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id 
                 FROM employees 
                 WHERE first_name='David');
                 
                 
--20�� �μ��� �ٹ��ϴ� ����� ��պ��� ���� �޿��� �޴� ����� �̸��� �޿��� ����϶�
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT avg(salary)
             FROM employees
             WHERE department_id=20)
; 

--4. ��ȣ���� ��������
--�ڽ��� ���� �μ��� ��պ��� ���� �޿��� �޴� ����� �̸��� �޿��� ����϶�.
--��ȣ���� Sub Query�� �ۼ��ؾ� ��
--���������� ���̺��� ������������ ����
SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT avg(salary)
             FROM employees b
             WHERE b.department_id=a.department_id)
;

--5. ��Į�� ��������
--SELECT ���� ���������� �� �� �ִ� -> Scalar Sub Query
SELECT first_name, (SELECT department_name
               FROM  departments d
               WHERE d.department_id=e.department_id) department_name
FROM employees e
ORDER BY first_name
;

--Join �� �̿��� ������
SELECT first_name, department_name
FROM employees e JOIN departments d ON (e.department_id=d.department_id)
ORDER BY first_name
;

--6. �ζ��� ��
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) AS row_number
      FROM employees)
WHERE row_number between 1 and 10;

SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) AS row_number
      FROM employees)
WHERE row_number between 11 and 20;


--7. 3�� ������ Top-N ����
SELECT ROWID, ROWNUM, employee_id, first_name
FROM employees;

SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
     )
WHERE rnum between 11 and 20;

SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum between 1 and 10;

SELECT first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum between 11 and 20;

SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
     )
WHERE rnum between 11 and 20;

--8. ������ ����
SELECT employee_id, 
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id=manager_id
;

SELECT employee_id, 
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id=manager_id
ORDER BY first_name
;

SELECT employee_id, 
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id=manager_id
ORDER SIBLINGS BY first_name
;

SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH employee_id = 113
CONNECT BY PRIOR manager_id=employee_id
;
