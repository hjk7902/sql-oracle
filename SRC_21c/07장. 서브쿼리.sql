--------------------------------
--7장 서브쿼리
--------------------------------
--1. 서브쿼리
--Nancy의 급여보다 많은 급여를 받는 사원의 이름과 급여를 출력하세요.
SELECT salary FROM employees WHERE first_name='Nancy'; --12008
SELECT first_name, salary FROM employees WHERE salary > 12008;

--서브쿼리 이용
SELECT first_name, salary 
FROM   employees 
WHERE  salary > (SELECT salary
              FROM   employees 
              WHERE  first_name='Nancy');

--2. 단일행 서브쿼리
SELECT first_name, job_id, hire_date
FROM   employees
WHERE  job_id = (SELECT job_id
                 FROM   employees
                 WHERE  employee_id=103);
                 
--급여를 평균 이상 받는 사원의 이름과 급여를 출력하세요.
SELECT first_name, salary 
FROM   employees 
WHERE  salary >= (SELECT avg(salary)
               FROM   employees);

--3. 다중행 서브쿼리
SELECT first_name, salary 
FROM   employees 
WHERE  salary > (SELECT salary
              FROM   employees 
              WHERE  first_name='David');  -- 오류
              
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
                 
SELECT first_name, department_id, job_id
FROM   employees e
WHERE  EXISTS (SELECT * 
               FROM   departments d 
               WHERE  d.manager_id=e.employee_id);
                 
SELECT first_name, e.department_id, job_id
FROM departments d
JOIN employees e 
  ON d.manager_id=e.employee_id
ORDER BY e.department_id; 


--4. 상호연관 서브쿼리
--자신이 속한 부서의 평균보다 많은 급여를 받는 사원의 이름과 급여를 출력하라.
--상호연관 Sub Query를 작성해야 함
--메인쿼리의 테이블이 서브쿼리에서 사용됨
SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT avg(salary)
             FROM employees b
             WHERE b.department_id=a.department_id)
;

--5. 스칼라 서브쿼리
--SELECT 절에 서브쿼리가 올 수 있다 -> Scalar Sub Query
SELECT first_name, (SELECT department_name
               FROM  departments d
               WHERE d.department_id=e.department_id) department_name
FROM employees e
ORDER BY first_name
;

--Join 을 이용한 쿼리문
SELECT first_name, department_name
FROM employees e JOIN departments d ON (e.department_id=d.department_id)
ORDER BY first_name
;

--6. 인라인 뷰
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


--7. 3중 쿼리와 Top-N 쿼리
SELECT ROWID, ROWNUM, employee_id, first_name
FROM employees;

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

SELECT row_number, first_name, salary
FROM  (SELECT first_name, salary,
       row_number() OVER (ORDER BY salary DESC) AS row_number
       FROM   employees)
WHERE  row_number BETWEEN 11 AND 20;

--8. OFFSET과 FETCH
SELECT first_name, salary
FROM   employees
ORDER BY salary DESC 
OFFSET 10 ROWS --10개 행을 건너뜀(11번째 행부터 출력)
FETCH FIRST 4 ROWS ONLY;

--9. 계층형 쿼리
CREATE TABLE category (
  category_id   NUMBER PRIMARY KEY,
  category_name VARCHAR2(100),
  parent_id     NUMBER  -- 부모 카테고리 ID (NULL이면 최상위)
);

INSERT INTO category VALUES (10, '전자제품', NULL);
INSERT INTO category VALUES (20, '컴퓨터', 10);
INSERT INTO category VALUES (30, '노트북', 20);
INSERT INTO category VALUES (40, '데스크탑', 20);
INSERT INTO category VALUES (50, '모바일', 10);
INSERT INTO category VALUES (60, '스마트폰', 50);
INSERT INTO category VALUES (70, '태블릿', 50);
INSERT INTO category VALUES (80, '가전', 10);
INSERT INTO category VALUES (90, '냉장고', 80);
INSERT INTO category VALUES (100, '세탁기', 80);
COMMIT;

SELECT category_id, category_name, parent_id, 
       LEVEL,
       CONNECT_BY_ROOT category_name AS root,
       CONNECT_BY_ISLEAF AS is_leaf,
       SYS_CONNECT_BY_PATH(category_name, ' > ') AS path
FROM   category
START WITH parent_id IS NULL
CONNECT BY PRIOR category_id = parent_id;


SELECT category_name,
       LEVEL,
       SYS_CONNECT_BY_PATH(category_name, ' < ' ) AS upward_path
FROM   category
START WITH category_name = '노트북'
CONNECT BY category_id = PRIOR parent_id;

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

--반복을 위한 숫자
SELECT LEVEL AS num 
FROM dual CONNECT BY LEVEL <= 10;


--9. 연습문제
--1.
SELECT * 
FROM employees
WHERE manager_id IN (SELECT DISTINCT manager_id 
                     FROM employees
                     WHERE department_id=20);
--2.
SELECT first_name
FROM employees
WHERE salary = (SELECT max(salary)
                FROM employees);
                
--3.
SELECT rnum, first_name, salary
FROM  (SELECT first_name, salary, rownum AS rnum
       FROM (SELECT first_name, salary
             FROM employees
             ORDER BY salary DESC)
      )
WHERE rnum between 3 and 5;

--4.
SELECT
  department_id, first_name, salary,
  ( SELECT ROUND(AVG(salary)) 
    FROM employees c 
    WHERE c.department_id=a.department_id ) AS avg_sal
FROM employees a
WHERE salary >= (SELECT AVG(salary) 
                 FROM employees b
                 WHERE b.department_id=a.department_id)
ORDER BY department_id;

--instructor note
CREATE TABLE speech (
  speech_text VARCHAR2(4000)
);

INSERT INTO speech VALUES ('만일 다음과 같은 테이블이 있고, 웹에서 수집한 데이터가 텍스트 파일로 저장되어 있다면 SQL Developer에서 [데이터 임포트] 기능을 통해 데이터베이스 테이블에 데이터를 저장시킬 수 있습니다.');
COMMIT; --입력한 내용 저장

WITH numbers AS 
  (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 50)
SELECT word, count(*) AS cnt
FROM (
  SELECT REGEXP_SUBSTR(LOWER(speech_text), '[^ ]+', 1, n) word
  FROM speech, numbers
)
WHERE word IS NOT NULL
GROUP BY word
ORDER BY cnt DESC;
