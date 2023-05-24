--------------------------------
--4�� �׷��Լ��� �̿��� ������ ����
--------------------------------
--1 �׷��Լ�
--1.1. SUM, AVG, MIN, MAX, SUM
SELECT  AVG(salary), MAX(salary), MIN(salary), SUM(salary)
FROM    employees
WHERE   job_id LIKE 'SA%';

SELECT   MIN(hire_date), MAX(hire_date)
FROM     employees;

SELECT MIN(first_name), MAX(last_name)
FROM   employees;

--1.2. COUNT
--��� ����� ���� ����϶�
SELECT COUNT(*) FROM employees;

SELECT COUNT(commission_pct) 
FROM employees; -- Ŀ�̼��� �޴� ����� ���� ���

--���� ū �޿�����?
SELECT MAX(salary) FROM employees;
--���� ���� �޿��� �޴� ����� �̸���? --> ���������� �ذ��ؾ� ��.

--1.3. STDDEV, VARIANCE �Լ�
--������� �޿��� ����, ��հ� ǥ������, �׸��� �л��� ���ϼ���. �Ҽ��� ���� �� ��° �ڸ������� ǥ���ϼ���.
SELECT SUM(salary) AS �հ�, 
       ROUND(AVG(salary), 2) AS ���, --,2�� �Ҽ��� �� ��° �ڸ����� �ݿø�
       ROUND(STDDEV(salary), 2) AS ǥ������,
       ROUND(VARIANCE(salary), 2) AS �л�
FROM employees;

--1.4. �׷� �Լ��� NULL��
SELECT AVG(NVL(salary*commission_pct,0))
FROM   employees;

SELECT ROUND(AVG(salary*commission_pct), 2) AS avg_bonus
FROM employees; --Ŀ�̼� ���, null�� ���꿡�� ���ܵȴ�.

SELECT 
  ROUND(SUM(salary*commission_pct), 2) sum_bonus, 
  COUNT(*) count, 
  ROUND(AVG(salary*commission_pct), 2) avg_bonus1, 
  ROUND(SUM(salary*commission_pct)/count(*), 2) avg_bonus2
FROM employees; --NULL�� ���꿡�� ���ܵȴ�.

--2. GROUP BY
--2.1. GROUP BY ���
SELECT    department_id,  AVG(salary)
FROM      employees
GROUP BY  department_id;

--2.2. �ϳ� �̻��� ���� �׷�ȭ
SELECT    department_id, job_id, SUM(salary)
FROM      employees
GROUP BY  department_id, job_id;

--2.3. �׷� �Լ��� �߸� ����� ����
SELECT  department_id, COUNT(first_name)
FROM    employees;

SELECT  department_id, COUNT(first_name)
FROM    employees
GROUP BY department_id;

SELECT    department_id, AVG(salary)
FROM      employees
WHERE     AVG(salary) > 2000
GROUP BY  department_id;

--3. HAVING
SELECT   department_id, ROUND(AVG(salary), 2)
FROM     employees
GROUP BY department_id
HAVING   AVG(salary) >= 8000;

SELECT   job_id, AVG(salary) PAYROLL
FROM     employees
WHERE    job_id NOT LIKE 'SA%'
GROUP BY job_id
HAVING   AVG(salary) > 8000
ORDER BY AVG(salary);

--4. GROUPING SETS
SELECT   department_id, job_id, manager_id, ROUND(AVG(salary), 2) AS avg_sal
FROM     employees
GROUP BY 
GROUPING SETS ((department_id, job_id), (job_id, manager_id))
ORDER BY department_id, job_id, manager_id;

--GROUPING SETS�� ���� ����� ��� UNION ALL ����
SELECT department_id, job_id, NULL AS manager_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id, job_id
UNION ALL
SELECT NULL AS department_id, job_id, manager_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY job_id, manager_id;

SELECT DECODE(GROUPING(department_id), 1, '��� �μ�', department_id) AS �μ���,
       DECODE(GROUPING(job_id), 1, '��� ����', job_id) AS ������,
       COUNT(*) AS �����,
       SUM(salary) AS �ѱ޿���
FROM employees
GROUP BY GROUPING SETS (department_id, job_id)
ORDER BY �μ���, ������;

--5. ROLLUP, CUBE
--5.1. ROLLUP, CUBE ���
--�μ���, ������ �޿��� ��հ� ����� ���� ����϶�.
SELECT department_id, job_id, ROUND(AVG(salary),2), COUNT(*) 
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

--���� ����� �� �μ��� ��հ�, ����� ���� ����ϰ� �ͽ��ϴ�.
--��ü ���, ��ü ����� ���� ����ϰ� �ͽ��ϴ�.
SELECT department_id, job_id, ROUND(AVG(salary),2), COUNT(*) 
FROM employees
GROUP BY ROLLUP(department_id, job_id) --ROLLUP�� ������ ���踦 ����Ѵ�.
ORDER BY department_id, job_id;

--���� ����� ������ �޿���հ� ����� ���� ����ϰ� �ͽ��ϴ�.
SELECT department_id, job_id, ROUND(AVG(salary),2), COUNT(*) 
FROM employees 
GROUP BY CUBE(department_id, job_id) --CUBE�� ������ �������� ���踦 ����Ѵ�.
ORDER BY department_id, job_id;

--6. GROUPING
SELECT 
  NVL2(department_id, department_id||'', 
                      DECODE(GROUPING(department_id), 1, '�Ұ�')) AS �μ�, 
  NVL(job_id, DECODE(GROUPING(job_id), 1, '�Ұ�')) AS ����,
  ROUND(AVG(salary),2) AS ���, 
  COUNT(*) AS ����Ǽ�
FROM 
  employees
GROUP BY 
  CUBE(department_id, job_id)
ORDER BY 
  �μ�, ����;

--7. GROUPING_ID
SELECT 
  NVL2(department_id, 
       department_id||'', 
       decode(GROUPING_ID(department_id, job_id), 2, '�Ұ�',
                                        3, '�հ�')) AS �μ���ȣ,
  NVL(job_id, 
      decode(GROUPING_ID(department_id, job_id), 1, '�Ұ�',
                                       3, '�հ�')) AS ����,
  GROUPING_ID(department_id, job_id) AS GID,
  ROUND(AVG(salary),2) AS ���, 
  COUNT(*) AS ����Ǽ�
FROM 
  employees
GROUP BY CUBE(department_id, job_id)
ORDER BY �μ�, ����;

--��������
--1
SELECT job_id, round(avg(salary),2) AS average 
FROM employees 
GROUP BY job_id;

--2
SELECT department_id, count(*) 
FROM employees
GROUP BY department_id;

--3
SELECT department_id, job_id, count(*) 
FROM employees 
GROUP BY department_id, job_id;

--4
SELECT 
  department_id, 
  round(STDDEV(salary), 2) 
FROM employees
GROUP BY department_id;

--5
SELECT department_id, count(*) 
FROM employees 
GROUP BY department_id 
HAVING count(*) >= 4;

--6
SELECT department_id, count(*) 
FROM employees 
GROUP BY department_id 
HAVING count(*) >= 4;

--7
SELECT job_id, count(*) 
FROM employees 
WHERE department_id=50 
GROUP BY job_id 
HAVING count(*) <= 10;

--8
SELECT 
    TO_CHAR(hire_date, 'YYYY') AS �Ի�⵵,
    ROUND(AVG(salary)) AS �޿����,
    COUNT(*) AS �����
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY 1;

--9
SELECT 
    TO_CHAR(hire_date, 'YYYY') AS �Ի�⵵,
    TO_CHAR(hire_date, 'MM') AS �Ի��,
    ROUND(AVG(salary)) AS �޿����,
    COUNT(*) AS �����
FROM employees
GROUP BY 
    ROLLUP(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY �Ի�⵵, �Ի��;

--10
SELECT 
  DECODE(GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), 
                     TO_CHAR(hire_date, 'MM')),  
         2, '����', 
         3, '�հ�', 
         TO_CHAR(hire_date, 'YYYY')) AS �Ի�⵵,
  DECODE(GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), 
                     TO_CHAR(hire_date, 'MM')), 
         1, '���', 
         3, '�հ�', 
         TO_CHAR(hire_date, 'MM')) AS �Ի��,
  ROUND(AVG(salary)) AS �޿����,
  COUNT(*) AS �����,
  GROUPING_ID(TO_CHAR(hire_date, 'YYYY'),TO_CHAR(hire_date, 'MM')) 
    AS GID
FROM employees
GROUP BY CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY �Ի�⵵, �Ի��;

SELECT 
  NVL(TO_CHAR(hire_date, 'YYYY'), 
      DECODE(GROUPING(TO_CHAR(hire_date, 'YYYY')), 1, '����'))
    AS �Ի�⵵,
  NVL(TO_CHAR(hire_date, 'MM'), 
      DECODE(GROUPING(TO_CHAR(hire_date, 'MM')), 1, '���')) 
    AS �Ի��,
  GROUPING_ID(TO_CHAR(hire_date, 'YYYY'),TO_CHAR(hire_date, 'MM')) 
    AS GID,
  ROUND(AVG(salary)) AS �޿����,
  COUNT(*) AS �����
FROM employees
GROUP BY 
  CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY �Ի�⵵, �Ի��;
