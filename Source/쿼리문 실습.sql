-- ��� ���̺� ����� ���� �;��.
SELECT * FROM tab; -- MySQL �� show tables; �Դϴ�. �� ������ ǥ���� �ƴմϴ�.

-- ����� ���� ��ȸ�ϼ���.
SELECT COUNT(*) FROM employees;

-- �μ������� ���� ����� ��� ������ ��ȸ�ϼ���.
SELECT * FROM employees WHERE department_id IS NULL;

-- �Ŵ��� ���̵� 103�� ������� �̸��� �޿�, �������̵� ����ϼ���.
SELECT first_name, salary, job_id
FROM employees
WHERE manager_id = 103;

-- 80�μ��� �ٹ��ϸ鼭 ������ SA_MAN�� ����� ������
-- 20�μ��� �ٹ��ϸ鼭 �Ŵ��� ���̵� 100�� ����� ������ ����ϼ���.
-- ������ �ϳ���...
SELECT * 
FROM   employees
WHERE  (department_id=80 AND job_id='SA_MAN')
   OR  (department_id=20 AND manager_id=100);

-- ��� ����� ��ȭ��ȣ�� ###.###.####�̶�� ###-###-####�������� ����ϼ���.
-- replace
SELECT replace(phone_number, '.', '-') AS ��ȭ��ȣ
FROM employees;

-- ���ʽ��� ���� �� ���� ����� ���� ����ϼ���. ���ʽ��� ���� ����� �ƴϰ�...
SELECT COUNT(*)
FROM employees
WHERE commission_pct IS NULL;

-- ��� ����� �̸��� ���ʽ�(salary*commission_pct)�� ����ϼ���.
SELECT first_name, salary*commission_pct AS ���ʽ�
FROM employees;

--nvl(����, ���ϰ�찪)
SELECT first_name, salary*NVL(commission_pct, 0) AS ���ʽ�
FROM employees;

-- ��� ����� �̸��� ���ʽ��� ������ �޿��� ����ϼ���.
SELECT first_name, salary + salary*commission_pct AS ���ʽ�
FROM employees;
--nvl(����, ���ϰ�찪)
SELECT first_name, salary + salary*NVL(commission_pct, 0) AS ���ʽ�
FROM employees;
--nvl2(����, ���̾ƴҰ��, ���ϰ��)
SELECT first_name, NVL2(commission_pct, salary+salary*commission_pct, salary) AS ���ʽ�
FROM employees;

SELECT first_name, salary + NVL2(commission_pct, salary*commission_pct, 0) AS ���ʽ�
FROM employees;
--coalesce
SELECT first_name, COALESCE(salary+salary*commission_pct, salary) AS ���ʽ�
FROM employees;
SELECT first_name, salary+COALESCE(salary*commission_pct, 0) AS ���ʽ�
FROM employees;

-- �̹� �߼����� ���� �ݷ�ǰ�� �����ϰ� �ͽ��ϴ�. �׷��� ȸ���� ������ ��ο��� 
-- �����Ҽ��� �����ϴ�. 
-- �׷��� ���ʽ�(salary*commission_pct)�� 600������ ���� �޴� ����鿡�Ը� �����ϰ� �ͽ��ϴ�,.
-- �� ���� ��ǰ�� �ֹ��ؾ� �ұ��?
SELECT COUNT(*) 
FROM employees
WHERE salary*commission_pct < 600
    OR commission_pct IS NULL
;
SELECT COUNT(*) 
FROM employees
WHERE LNNVL(salary*commission_pct >= 600)
;

-- � ������ ��� �޿��� ������ �˰� �ͽ��ϴ�.
SELECT JOB_ID, ��ձ޿� 
FROM(SELECT job_id, MAX(first_name), avg(salary) AS ��ձ޿�
FROM employees
GROUP BY job_id
ORDER BY ��ձ޿� DESC) 
WHERE ROWNUM BETWEEN 3 AND 5
;
SELECT * FROM jobs WHERE job_id='AD_PRES';

-- �μ��� ����� ���� ����ϼ���.
SELECT department_id, count(*)
FROM employees
GROUP BY department_id;

-- �μ��� ������ ����� ���� ����ϼ���.
SELECT department_id, job_id, count(*)
FROM employees
GROUP BY department_id, job_id;

-- ����� ���� 4�� �̻��� �μ��� �μ����̵�� ����Ǽ��� ����ϼ���.
SELECT department_id, count(*) 
FROM employees
GROUP BY department_id
HAVING count(*) >= 4;

SELECT department_id, count(*) 
FROM employees
HAVING count(*) >= 4 --GROUP BY ���� ���� �� �ֽ��ϴ�.
GROUP BY department_id;

-- 50�� �μ��� ������ ����� ���� ����ϼ���.
SELECT job_id, count(*)
FROM employees
WHERE department_id=50
GROUP BY job_id;

-- 50�� �μ����� ���� ������ ���� ����� 10�� ������ ����(���̵�)�� ����� ���� ����ϼ���.
SELECT job_id, COUNT(*)
FROM employees
WHERE department_id=50
GROUP BY job_id
HAVING COUNT(*) <= 10;

SELECT job_id, COUNT(*)
FROM employees
GROUP BY job_id
HAVING COUNT(*) <= 10 AND job_id='ST_MAN';
--having ������ �Ϲ� ������ �� ���� ������ GROUP BY ���� ���� �̿��� ���Ǹ� ����
--�׷��� ���� ��� �׷��Լ��� ����ؾ� ��

-- ��� ����� �޿� ��հ� ǥ�������� ����ϼ���. �Ҽ��� �� ��° �ڸ����� ǥ��
SELECT ROUND(AVG(salary),2) AS �޿����, ROUND(STDDEV(salary),2) AS �޿�ǥ������
FROM employees;

-- �μ��� �޿� ��հ� �޿� ǥ�������� ����ϼ���. �Ҽ��� �� ��° �ڸ����� ǥ��
SELECT 
    department_id, 
    ROUND(AVG(salary),2) AS �޿����, 
    ROUND(STDDEV(salary), 2) AS ǥ������
FROM employees
GROUP BY department_id;
-- ���� �ֱٿ� �Ի��� ����� �̸��� �μ���ȣ, ����, �޿�
SELECT *
FROM
    (SELECT first_name, department_id, job_id, hire_date, salary
    FROM employees
    ORDER BY hire_date DESC)
WHERE ROWNUM=1
;
-- ���� �Ի����� ������ ����� �̸��� ����, �޿�
SELECT first_name, job_id, salary, hire_date
FROM employees
ORDER BY hire_date;
-- 60�� �μ��� ���� ��
SELECT COUNT(DISTINCT job_id)
FROM employees
WHERE department_id=60;
-- ��� ����� �ٹ��ϴ� �μ��� ��
SELECT COUNT(DISTINCT department_id)
FROM employees;

SELECT COUNT(DISTINCT nvl(department_id, 0))
FROM employees;