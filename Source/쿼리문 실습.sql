-- 모든 테이블 목록을 보고 싶어요.
SELECT * FROM tab; -- MySQL 은 show tables; 입니다. 이 구문은 표준이 아닙니다.

-- 사원의 수를 조회하세요.
SELECT COUNT(*) FROM employees;

-- 부서정보가 없는 사원의 모든 정보를 조회하세요.
SELECT * FROM employees WHERE department_id IS NULL;

-- 매니저 아이디가 103인 사원들의 이름과 급여, 직무아이디를 출력하세요.
SELECT first_name, salary, job_id
FROM employees
WHERE manager_id = 103;

-- 80부서에 근무하면서 직무가 SA_MAN인 사원의 정보와
-- 20부서에 근무하면서 매니저 아이디가 100인 사원의 정보를 출력하세요.
-- 쿼리문 하나로...
SELECT * 
FROM   employees
WHERE  (department_id=80 AND job_id='SA_MAN')
   OR  (department_id=20 AND manager_id=100);

-- 모든 사원의 전화번호를 ###.###.####이라면 ###-###-####형식으로 출력하세요.
-- replace
SELECT replace(phone_number, '.', '-') AS 전화번호
FROM employees;

-- 보너스를 받을 수 없는 사원의 수를 출력하세요. 보너스가 없는 사원이 아니고...
SELECT COUNT(*)
FROM employees
WHERE commission_pct IS NULL;

-- 모든 사원의 이름과 보너스(salary*commission_pct)를 출력하세요.
SELECT first_name, salary*commission_pct AS 보너스
FROM employees;

--nvl(수식, 널일경우값)
SELECT first_name, salary*NVL(commission_pct, 0) AS 보너스
FROM employees;

-- 모든 사원의 이름과 보너스를 포함한 급여를 출력하세요.
SELECT first_name, salary + salary*commission_pct AS 보너스
FROM employees;
--nvl(수식, 널일경우값)
SELECT first_name, salary + salary*NVL(commission_pct, 0) AS 보너스
FROM employees;
--nvl2(수식, 널이아닐경우, 널일경우)
SELECT first_name, NVL2(commission_pct, salary+salary*commission_pct, salary) AS 보너스
FROM employees;

SELECT first_name, salary + NVL2(commission_pct, salary*commission_pct, 0) AS 보너스
FROM employees;
--coalesce
SELECT first_name, COALESCE(salary+salary*commission_pct, salary) AS 보너스
FROM employees;
SELECT first_name, salary+COALESCE(salary*commission_pct, 0) AS 보너스
FROM employees;

-- 이번 추석명절 직원 격려품을 제공하고 싶습니다. 그러나 회사의 사정상 모두에게 
-- 제공할수는 없습니다. 
-- 그래서 보너스(salary*commission_pct)를 600원보다 적게 받는 사원들에게만 제공하고 싶습니다,.
-- 몇 개의 상품을 주문해야 할까요?
SELECT COUNT(*) 
FROM employees
WHERE salary*commission_pct < 600
    OR commission_pct IS NULL
;
SELECT COUNT(*) 
FROM employees
WHERE LNNVL(salary*commission_pct >= 600)
;

-- 어떤 직무가 평균 급여가 높은지 알고 싶습니다.
SELECT JOB_ID, 평균급여 
FROM(SELECT job_id, MAX(first_name), avg(salary) AS 평균급여
FROM employees
GROUP BY job_id
ORDER BY 평균급여 DESC) 
WHERE ROWNUM BETWEEN 3 AND 5
;
SELECT * FROM jobs WHERE job_id='AD_PRES';

-- 부서별 사원의 수를 출력하세요.
SELECT department_id, count(*)
FROM employees
GROUP BY department_id;

-- 부서별 직무별 사원의 수를 출력하세요.
SELECT department_id, job_id, count(*)
FROM employees
GROUP BY department_id, job_id;

-- 사원의 수가 4명 이상인 부서의 부서아이디와 사원의수를 출력하세요.
SELECT department_id, count(*) 
FROM employees
GROUP BY department_id
HAVING count(*) >= 4;

SELECT department_id, count(*) 
FROM employees
HAVING count(*) >= 4 --GROUP BY 전에 나올 수 있습니다.
GROUP BY department_id;

-- 50번 부서의 직무별 사원의 수를 출력하세요.
SELECT job_id, count(*)
FROM employees
WHERE department_id=50
GROUP BY job_id;

-- 50번 부서에서 같은 직무를 가진 사원이 10명 이하인 직무(아이디)와 사원의 수를 출력하세요.
SELECT job_id, COUNT(*)
FROM employees
WHERE department_id=50
GROUP BY job_id
HAVING COUNT(*) <= 10;

SELECT job_id, COUNT(*)
FROM employees
GROUP BY job_id
HAVING COUNT(*) <= 10 AND job_id='ST_MAN';
--having 절에도 일반 조건이 올 수는 있지만 GROUP BY 절의 열을 이용한 조건만 가능
--그렇지 않을 경우 그룹함수를 사용해야 함

-- 모든 사원의 급여 평균과 표준편차를 출력하세요. 소숫점 두 번째 자리까지 표현
SELECT ROUND(AVG(salary),2) AS 급여평균, ROUND(STDDEV(salary),2) AS 급여표준편차
FROM employees;

-- 부서별 급여 평균과 급여 표준편차를 출력하세요. 소숫점 두 번째 자리까지 표현
SELECT 
    department_id, 
    ROUND(AVG(salary),2) AS 급여평균, 
    ROUND(STDDEV(salary), 2) AS 표준편차
FROM employees
GROUP BY department_id;
-- 가장 최근에 입사한 사원의 이름과 부서번호, 직무, 급여
SELECT *
FROM
    (SELECT first_name, department_id, job_id, hire_date, salary
    FROM employees
    ORDER BY hire_date DESC)
WHERE ROWNUM=1
;
-- 가장 입사한지 오래된 사원의 이름과 직무, 급여
SELECT first_name, job_id, salary, hire_date
FROM employees
ORDER BY hire_date;
-- 60번 부서의 직무 수
SELECT COUNT(DISTINCT job_id)
FROM employees
WHERE department_id=60;
-- 모든 사원이 근무하는 부서의 수
SELECT COUNT(DISTINCT department_id)
FROM employees;

SELECT COUNT(DISTINCT nvl(department_id, 0))
FROM employees;