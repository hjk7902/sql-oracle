--------------------------------
--4장 그룹함수를 이용한 데이터 집계
--------------------------------
--1 그룹함수
--1.1. SUM, AVG, MIN, MAX, SUM
SELECT  AVG(salary), MAX(salary), MIN(salary), SUM(salary)
FROM    employees
WHERE   job_id LIKE 'SA%';

SELECT   MIN(hire_date), MAX(hire_date)
FROM     employees;

SELECT MIN(first_name), MAX(last_name)
FROM   employees;

--1.2. COUNT
--모든 사원의 수를 출력하라
SELECT COUNT(*) FROM employees;

SELECT COUNT(commission_pct) 
FROM employees; -- 커미션을 받는 사원의 수를 출력

--가장 큰 급여액은?
SELECT MAX(salary) FROM employees;
--가장 많은 급여를 받는 사원의 이름은? --> 서브쿼리로 해결해야 함.

--1.3. STDDEV, VARIANCE 함수
--사원들의 급여의 총합, 평균과 표준편차, 그리고 분산을 구하세요. 소수점 이하 두 번째 자리까지만 표현하세요.
SELECT SUM(salary) AS 합계, 
       ROUND(AVG(salary), 2) AS 평균, --,2는 소수점 두 번째 자리까지 반올림
       ROUND(STDDEV(salary), 2) AS 표준편차,
       ROUND(VARIANCE(salary), 2) AS 분산
FROM employees;

--1.4. 그룹 함수와 NULL값
SELECT AVG(NVL(salary*commission_pct,0))
FROM   employees;

SELECT ROUND(AVG(salary*commission_pct), 2) AS avg_bonus
FROM employees; --커미션 평균, null은 연산에서 제외된다.

SELECT 
  ROUND(SUM(salary*commission_pct), 2) sum_bonus, 
  COUNT(*) count, 
  ROUND(AVG(salary*commission_pct), 2) avg_bonus1, 
  ROUND(SUM(salary*commission_pct)/count(*), 2) avg_bonus2
FROM employees; --NULL은 연산에서 제외된다.

--2. GROUP BY
--2.1. GROUP BY 사용
SELECT    department_id,  AVG(salary)
FROM      employees
GROUP BY  department_id;

--2.2. 하나 이상의 열로 그룹화
SELECT    department_id, job_id, SUM(salary)
FROM      employees
GROUP BY  department_id, job_id;

--2.3. 그룹 함수를 잘못 사용한 질의
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

--GROUPING SETS와 같은 결과를 얻는 UNION ALL 구문
SELECT department_id, job_id, NULL AS manager_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id, job_id
UNION ALL
SELECT NULL AS department_id, job_id, manager_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY job_id, manager_id;

SELECT DECODE(GROUPING(department_id), 1, '모든 부서', department_id) AS 부서명,
       DECODE(GROUPING(job_id), 1, '모든 업무', job_id) AS 업무명,
       COUNT(*) AS 사원수,
       SUM(salary) AS 총급여액
FROM employees
GROUP BY GROUPING SETS (department_id, job_id)
ORDER BY 부서명, 업무명;

--5. ROLLUP, CUBE
--5.1. ROLLUP, CUBE 사용
--부서별, 직무별 급여의 평균과 사원의 수를 출력하라.
SELECT department_id, job_id, ROUND(AVG(salary),2), COUNT(*) 
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

--위의 결과에 각 부서별 평균과, 사원의 수도 출력하고 싶습니다.
--전체 평균, 전체 사원의 수를 출력하고 싶습니다.
SELECT department_id, job_id, ROUND(AVG(salary),2), COUNT(*) 
FROM employees
GROUP BY ROLLUP(department_id, job_id) --ROLLUP은 레벨별 집계를 출력한다.
ORDER BY department_id, job_id;

--위의 결과에 직무별 급여평균과 사원의 수도 출력하고 싶습니다.
SELECT department_id, job_id, ROUND(AVG(salary),2), COUNT(*) 
FROM employees 
GROUP BY CUBE(department_id, job_id) --CUBE는 가능한 조합으로 집계를 출력한다.
ORDER BY department_id, job_id;

--6. GROUPING
SELECT 
  NVL2(department_id, department_id||'', 
                      DECODE(GROUPING(department_id), 1, '소계')) AS 부서, 
  NVL(job_id, DECODE(GROUPING(job_id), 1, '소계')) AS 직무,
  ROUND(AVG(salary),2) AS 평균, 
  COUNT(*) AS 사원의수
FROM 
  employees
GROUP BY 
  CUBE(department_id, job_id)
ORDER BY 
  부서, 직무;

--7. GROUPING_ID
SELECT 
  NVL2(department_id, 
       department_id||'', 
       decode(GROUPING_ID(department_id, job_id), 2, '소계',
                                        3, '합계')) AS 부서번호,
  NVL(job_id, 
      decode(GROUPING_ID(department_id, job_id), 1, '소계',
                                       3, '합계')) AS 직무,
  GROUPING_ID(department_id, job_id) AS GID,
  ROUND(AVG(salary),2) AS 평균, 
  COUNT(*) AS 사원의수
FROM 
  employees
GROUP BY CUBE(department_id, job_id)
ORDER BY 부서, 직무;

--연습문제
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
    TO_CHAR(hire_date, 'YYYY') AS 입사년도,
    ROUND(AVG(salary)) AS 급여평균,
    COUNT(*) AS 사원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY')
ORDER BY 1;

--9
SELECT 
    TO_CHAR(hire_date, 'YYYY') AS 입사년도,
    TO_CHAR(hire_date, 'MM') AS 입사월,
    ROUND(AVG(salary)) AS 급여평균,
    COUNT(*) AS 사원수
FROM employees
GROUP BY 
    ROLLUP(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY 입사년도, 입사월;

--10
SELECT 
  DECODE(GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), 
                     TO_CHAR(hire_date, 'MM')),  
         2, '월계', 
         3, '합계', 
         TO_CHAR(hire_date, 'YYYY')) AS 입사년도,
  DECODE(GROUPING_ID(TO_CHAR(hire_date, 'YYYY'), 
                     TO_CHAR(hire_date, 'MM')), 
         1, '년계', 
         3, '합계', 
         TO_CHAR(hire_date, 'MM')) AS 입사월,
  ROUND(AVG(salary)) AS 급여평균,
  COUNT(*) AS 사원수,
  GROUPING_ID(TO_CHAR(hire_date, 'YYYY'),TO_CHAR(hire_date, 'MM')) 
    AS GID
FROM employees
GROUP BY CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY 입사년도, 입사월;

SELECT 
  NVL(TO_CHAR(hire_date, 'YYYY'), 
      DECODE(GROUPING(TO_CHAR(hire_date, 'YYYY')), 1, '월계'))
    AS 입사년도,
  NVL(TO_CHAR(hire_date, 'MM'), 
      DECODE(GROUPING(TO_CHAR(hire_date, 'MM')), 1, '년계')) 
    AS 입사월,
  GROUPING_ID(TO_CHAR(hire_date, 'YYYY'),TO_CHAR(hire_date, 'MM')) 
    AS GID,
  ROUND(AVG(salary)) AS 급여평균,
  COUNT(*) AS 사원수
FROM employees
GROUP BY 
  CUBE(TO_CHAR(hire_date, 'YYYY'), TO_CHAR(hire_date, 'MM'))
ORDER BY 입사년도, 입사월;
