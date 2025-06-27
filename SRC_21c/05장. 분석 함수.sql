------------------------
--5장 분석 함수
------------------------
--1. 분석 함수
--1.1. 순위 구하기 함수 - RANK, DENSE_RANK, ROW_NUMBER
SELECT employee_id, department_id, salary,
    RANK()       OVER (ORDER BY salary DESC) sal_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) sal_dense_rank,
    ROW_NUMBER() OVER (ORDER BY salary DESC) sal_number
FROM   employees;

SELECT 
  first_name, salary, 
  RANK() OVER (ORDER BY salary DESC) AS rank,
  DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank,
  ROUND(CUME_DIST() OVER (ORDER BY salary DESC), 5) AS cume_dist,
  ROUND(PERCENT_RANK() OVER (ORDER BY salary DESC), 5) AS pct_rank,
  ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_number,
  ROWNUM
FROM employees;

--1.2. 누적분포와 백분율 순위 - CUME_DIST, PERCENT_RANK
SELECT employee_id, department_id, salary,
    CUME_DIST()    OVER (ORDER BY salary DESC) sal_cume_dist,
    PERCENT_RANK() OVER (ORDER BY commission_pct DESC) sal_pct_rank
FROM   employees;

--COMMISSION_PCT 열의 누적분포와 백분율 순위
SELECT employee_id, department_id, salary,
    CUME_DIST()    OVER (ORDER BY commission_pct DESC) cume_dist,
    PERCENT_RANK() OVER (ORDER BY commission_pct DESC) pct_rank
FROM   employees;

--1.3. 비율 함수 - RATIO_TO_REPORT
SELECT first_name, salary, ROUND(RATIO_TO_REPORT(salary) OVER (), 4) AS salary_ratio
FROM employees
WHERE job_id='IT_PROG';

--1.4. 분배 함수 - NTILE
SELECT employee_id, department_id, salary,
       NTILE(10)  OVER (ORDER BY salary DESC) sal_quart_tile
FROM   employees
WHERE  department_id=50;

--1.5. LAG, LEAD
SELECT employee_id, 
  LAG(salary, 1, 0) OVER (ORDER BY salary) AS lower_sal, 
  salary,
  LEAD(salary, 1, 0) OVER (ORDER BY salary) AS higher_sal 
FROM employees
ORDER BY salary;

--1.6. LISTAGG
SELECT department_id, first_name --에러
FROM   employees
GROUP  BY department_id; 

SELECT department_id,
  LISTAGG(first_name, ',') WITHIN GROUP(ORDER BY hire_date) AS names
FROM employees
GROUP BY department_id;

-- 이름 오름차순으로 출력
SELECT department_id,
  LISTAGG(first_name, ',') WITHIN GROUP(ORDER BY first_name) AS names
FROM employees
GROUP BY department_id;

--2. 윈도우 절
SELECT department_id, first_name, salary,
       SUM(salary) OVER(PARTITION BY department_id 
                        ORDER BY salary
                        ROWS  BETWEEN UNBOUNDED PRECEDING
                              AND CURRENT ROW) AS sum_rows
FROM employees;

--FIRST_VALUE, LAST_VALUE
SELECT employee_id,
  FIRST_VALUE(salary) 
    OVER (ORDER BY salary 
      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) lower_sal,
  salary my_sal,
  LAST_VALUE(salary) 
    OVER (ORDER BY salary 
      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) higher_sal
FROM   employees;

-- 모든 사원의 급여정보를 출력하세요.
-- 여기에 부서별로 가장 작은 급여액과 큰 급여액도 출력하세요.
SELECT employee_id, department_id,
  FIRST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lower_sal,
  salary AS my_sal,
  LAST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS higher_sal
FROM   employees;

SELECT employee_id, department_id,
  FIRST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lower_sal,
  salary AS my_sal,
  LAST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS higher_sal,
  LAST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) - salary AS diff_sal
FROM   employees;


--3. 선형 회귀 함수
--3.1. REGR_AVGX(y,x), REGR_AVGY(y,x)
--salary를 독립변수로 두고 commission_pct를 독리변수로 두었을 때
--모든 사원 급여의 평균과 보너스를 받는 사람의 급여 평균을 출력하세요.
SELECT AVG(salary), REGR_AVGX(commission_pct, salary)
FROM employees;

SELECT AVG(salary)
FROM employees
WHERE commission_pct IS NOT NULL;

SELECT AVG(commission_pct), REGR_AVGY(commission_pct, job_id)
FROM employees;

--3.2. REGR_COUNT(y, x)
SELECT DISTINCT department_id, REGR_COUNT(manager_id, department_id) OVER (partition by department_id) "REGR_COUNT"
FROM employees
ORDER BY department_id;

SELECT department_id, COUNT(*) 
FROM employees
GROUP BY department_id
ORDER BY department_id;

--3.3. REGR_SLOPE(y, x), REGR_INTERCEPT(y, x)
SELECT 
  job_id, 
  employee_id,
  salary,
  ROUND(SYSDATE-hire_date) "WORKING_DAY",
  ROUND(REGR_SLOPE(salary, SYSDATE-hire_date) 
    OVER (PARTITION BY job_id), 2) "REGR_SLOPE",
  ROUND(REGR_INTERCEPT(salary, SYSDATE-hire_date) 
    OVER (PARTITION BY job_id), 2) "REGR_INTERCEPT"
FROM employees
WHERE department_id = 80
ORDER BY job_id, WORKING_DAY;

--3.4. REGR_R2(y, x)
SELECT 
  DISTINCT
  job_id, 
  ROUND(REGR_SLOPE(salary, SYSDATE-hire_date) 
    OVER (PARTITION BY job_id), 2) "REGR_SLOPE",
  ROUND(REGR_INTERCEPT(salary, SYSDATE-hire_date) 
    OVER (PARTITION BY job_id), 2) "REGR_INTERCEPT",
  ROUND(REGR_R2(salary, SYSDATE-hire_date) 
    OVER (PARTITION BY job_id), 2) "REGR_R2"
FROM employees
WHERE department_id = 80;

--4. 피벗 테이블
CREATE TABLE   sales_log(
  employee_id  NUMBER(6),
  week_id      NUMBER(2),
  week_day     VARCHAR2(10),
  quantity     NUMBER(8,2)
); 

INSERT INTO sales_log values(1101, 4, 'SALES_MON', 100);
INSERT INTO sales_log values(1101, 4, 'SALES_TUE', 150);
INSERT INTO sales_log values(1101, 4, 'SALES_WED', 80);
INSERT INTO sales_log values(1101, 4, 'SALES_THU', 60);
INSERT INTO sales_log values(1101, 4, 'SALES_FRI', 120);
INSERT INTO sales_log values(1102, 5, 'SALES_MON', 300);
INSERT INTO sales_log values(1102, 5, 'SALES_TUE', 300);
INSERT INTO sales_log values(1102, 5, 'SALES_WED', 230);
INSERT INTO sales_log values(1102, 5, 'SALES_THU', 120);
INSERT INTO sales_log values(1102, 5, 'SALES_FRI', 150);
COMMIT;
SELECT * FROM sales_log;

SELECT SUM(quantity)
FROM   sales_log
WHERE  week_day='SALES_MON';

--4.2. PIVOT
SELECT * 
FROM   sales_log
PIVOT
(
  sum(quantity)
  FOR week_day IN('SALES_MON' AS sales_mon, 
                  'SALES_TUE' AS sales_tue, 
                  'SALES_WED' AS sales_wed, 
                  'SALES_THU' AS sales_thu, 
                  'SALES_FRI' AS sales_fri)
)
ORDER BY employee_id, week_id;

CREATE OR REPLACE VIEW sales_log_view AS 
    SELECT employee_id, week_day, quantity 
    FROM sales_log;
    
SELECT * 
FROM   sales_log_view
PIVOT
(
  sum(quantity)
  FOR week_day IN('SALES_MON' AS sales_mon, 
                  'SALES_TUE' AS sales_tue, 
                  'SALES_WED' AS sales_wed, 
                  'SALES_THU' AS sales_thu, 
                  'SALES_FRI' AS sales_fri)
)
ORDER BY employee_id;

WITH temp AS (
   SELECT employee_id, week_day, quantity
    FROM sales_log
)
SELECT *
FROM   temp
PIVOT
(
  sum(quantity)
  FOR week_day IN('SALES_MON' AS sales_mon, 
                  'SALES_TUE' AS sales_tue, 
                  'SALES_WED' AS sales_wed, 
                  'SALES_THU' AS sales_thu, 
                  'SALES_FRI' AS sales_fri)
)
ORDER BY employee_id;

--4.3. UNPIVOT
CREATE TABLE sales(
  employee_id  NUMBER(6),
  week_id      NUMBER(2),
  sales_mon    NUMBER(8,2),
  sales_tue    NUMBER(8,2),
  sales_wed    NUMBER(8,2),
  sales_thu    NUMBER(8,2),
  sales_fri    NUMBER(8,2)
);
INSERT INTO sales VALUES(1101, 4, 100, 150, 80,  60,  120);
INSERT INTO sales VALUES(1102, 5, 300, 300, 230, 120, 150);
COMMIT;
SELECT * FROM sales;

SELECT employee_id, week_id, week_day, quantity
FROM   sales
UNPIVOT 
(
  quantity 
  FOR week_day 
  IN(sales_mon, sales_tue, sales_wed, sales_thu, sales_fri)
);

--연습문제
--1
SELECT 
  department_id,
  first_name, 
  salary, 
  RANK() 
    OVER (PARTITION BY department_id
          ORDER BY salary DESC) AS sal_rank,
  LAG(salary, 1, 0) 
    OVER (PARTITION BY department_id
          ORDER BY salary DESC) AS prev_salary,
  FIRST_VALUE(salary) 
    OVER (PARTITION BY department_id
          ORDER BY salary DESC
          ROWS 1 PRECEDING) AS prev_salary2
FROM employees
ORDER BY department_id;

--2
SELECT first_name
FROM employees
WHERE employee_id = (
  SELECT before_id 
  FROM 
    (
    SELECT employee_id,
      LAG(employee_id, 1, 0) OVER (ORDER BY employee_id) AS before_id
    FROM employees
    )
  WHERE employee_id=170
  );
  
--3
SELECT employee_id, department_id,
  FIRST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lower_sal,
  salary AS my_sal,
  LAST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS higher_sal,
  LAST_VALUE(salary) 
    OVER (PARTITION BY department_id 
          ORDER BY salary 
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) - salary AS diff_sal
FROM   employees;