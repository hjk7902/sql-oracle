--------------------------------
--3장. 함수
--------------------------------
--2. 문자 함수
SELECT * FROM dual;
SELECT sysdate FROM dual;
SELECT initcap('javaspecialist') FROM dual;
SELECT lower('JavaSpecialist') FROM dual;
SELECT upper('JavaSpecialist') FROM dual;
SELECT length('JavaSpecialist') FROM dual;
SELECT length('자바전문가그룹') FROM dual;
SELECT lengthb('자바전문가그룹') FROM dual;
-- 한글 인코딩이 utf-8이면 21, EUC-KR 이면 10
SELECT * FROM NLS_DATABASE_PARAMETERS; -- NLS_CHARACTERSET 행의 값이 인코딩 정보를 제공함
SELECT concat('Java', 'Specialist') FROM dual;
SELECT substr('JavaSpecialist', 5, 7) FROM dual;
SELECT substr('자바전문가그룹', 3, 3) FROM dual;
SELECT substrb('자바전문가그룹', 7, 9) FROM dual;
SELECT instr('JavaSpecialist',  'S') FROM dual;
SELECT instr('JavaSpecialist',  'b') FROM dual;
SELECT instr('자바전문가그룹',  '전') FROM dual;
SELECT instrb('자바전문가그룹',  '전') FROM dual;
SELECT rpad(first_name, 10, '-') AS name, lpad(salary, 10, '*') AS sal FROM employees;
SELECT ltrim('JavaSpecialist', 'Jav') FROM dual;
SELECT ltrim(' JavaSpecialist') FROM dual;
SELECT trim(' JavaSpecialist ') FROM dual;
SELECT replace('JavaSpecialist', 'Java', 'BigData') FROM dual;
SELECT replace('Java Specialist', ' ', '') FROM dual;
SELECT translate('javaspecialist', 'abcdefghijklmnopqrstuvwxyz', 'defghijklmnopqrstuvwxyzabc') FROM dual;

--2.1. LOWER, INITCAP, UPPER
SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM   employees;

SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM   employees
WHERE  last_name='abel';

SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM   employees
WHERE  last_name='Abel';

SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM   employees
WHERE  LOWER(last_name)='abel';

--2.2. LENGTH, INSTR
SELECT first_name, LENGTH(first_name), INSTR(first_name, 'a')
FROM   employees;

--2.3. SUBSTR, CONCAT
SELECT first_name, SUBSTR(first_name, 1, 3), CONCAT(first_name, last_name)
FROM   employees;

--2.4. LPAD, RPAD
SELECT RPAD(first_name, 10, '-') AS name, LPAD(salary, 10, '*') AS sal 
FROM   employees;

--2.5. LTRIM, RTRIM
SELECT LTRIM('JavaSpecialist', 'Jav') FROM dual;
SELECT LTRIM('  JavaSpecialist') FROM dual;
SELECT TRIM('  JavaSpecialist  ') FROM dual;

--2.6. REPLACE, TRANSLATE
SELECT REPLACE('JavaSpecialist', 'Java', 'BigData') FROM dual;
SELECT REPLACE('Java Specialist', ' ', '') FROM dual;
SELECT TRANSLATE('javaspecialist', 'abcdefghijklmnopqrstuvwxyz', 'defghijklmnopqrstuvwxyzabc') FROM dual;

--2.7. 문자열 조작 실전 문제
SELECT 
  RPAD(substr(first_name, 1, 3), LENGTH(first_name), '*') AS name,
  LPAD(salary, 10, '*') AS salary
FROM 
  employees
WHERE
  LOWER(job_id)='it_prog';

--3. 정규표현식 함수

--3.2. 정규표현식 실습을 위한 테이블
CREATE TABLE messages (
	sender 	VARCHAR2(50), 
	receiver	VARCHAR2(50), 
	content 	VARCHAR2(2000)
);

INSERT INTO messages 
VALUES('홍길동', '홍길서', '전화주세요. 010-1234-5678');
INSERT INTO messages 
VALUES('홍길남', '홍길북', 'hello sender@hello.com');
INSERT INTO messages 
VALUES('허진경', '홍길동', 'hjk7902@gmail.com으로 메일주세요.');
INSERT INTO messages 
VALUES('홍길동', '이순신', '반갑습니다.');
INSERT INTO messages 
VALUES('정준수', '허진경', '010 2346 6789 hello@abc.com');
INSERT INTO messages 
VALUES('Eric', 'James', 'Call Me. 010.3456.7890');
COMMIT; 

SELECT * FROM messages;

--3.3. REGEXP_LIKE 함수
SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}-[0-9]{4}-[0-9]{4}');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}-\d{4}-[[:digit:]]{4}');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}.[0-9]{4}.[0-9]{4}');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}\.[0-9]{4}\.[0-9]{4}');


--3.4. REGEXP_INSTR 함수
SELECT content, 
       REGEXP_INSTR(content, '\S+@\S+\.\S+') AS email,
       REGEXP_INSTR(content, '\d{3}[-. ]\d{4}[-. ]\d{4}') AS phone,
       REGEXP_INSTR(content, '\.') AS period,
       REGEXP_INSTR(content, '[가-힣]+') AS kor       
FROM messages;

--3.5. REGEXP_SUBSTR 함수
SELECT content, 
  REGEXP_SUBSTR(content, '[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+') AS email,
  REGEXP_SUBSTR(content, '\d{3}[-. ]\d{4}[-. ]\d{4}') AS phone,
  REGEXP_SUBSTR(content, '[가-힣]+') AS kor
FROM messages;

--3.6. REGEXP_REPLACE 함수
SELECT content, 
REGEXP_REPLACE(content, '\d{3}.\d{4}.\d{4}', '*') AS phone
FROM messages;

--3.7. REGEXP 함수 실전 문제
SELECT first_name, phone_number
FROM employees
WHERE regexp_like (phone_number, '^1\.\d{3}\.\d{3}\.\d{4}$');

SELECT first_name, phone_number
FROM employees
WHERE regexp_like (phone_number, '^1\.[0-9]{3}\.[0-9]{3}\.[0-9]{4}$');

SELECT first_name, 
  regexp_replace(phone_number, '\d{4}$', '****') AS phone,
  regexp_substr(phone_number, '\d{4}$') AS phone2
FROM employees
WHERE regexp_like (phone_number, '^1\.[0-9]{3}\.[0-9]{3}\.[0-9]{4}$');

--4. 숫자 함수
--4.1. ROUND, TRUNC
SELECT ROUND(45.923,2), ROUND(45.923,0), ROUND(45.923,-1) 
FROM   DUAL;

SELECT TRUNC(45.923,2), TRUNC(45.923), TRUNC(45.923,-1) 
FROM   DUAL;


--5. 날짜 함수
SELECT SYSDATE 
FROM DUAL;

SELECT SYSTIMESTAMP 
FROM DUAL;

--5.1. 날짜의 연산
SELECT first_name, (SYSDATE - hire_date)/7 AS "Weeks"
FROM   employees
WHERE  department_id=60;

--5.2. 날짜 함수
--MONTHS_BETWEEN
SELECT first_name, SYSDATE, hire_date, 
       MONTHS_BETWEEN(SYSDATE, hire_date) AS workmonth
FROM employees
WHERE first_name='Diana';

--ADD_MONTHS
SELECT first_name, hire_date, ADD_MONTHS(hire_date, 100)
FROM employees
WHERE first_name='Diana';

--NEXT_DAY
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월') 
FROM dual; 

--LAST_DAY
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM dual;

--ROUND, TRUNC
SELECT SYSDATE, ROUND(SYSDATE), TRUNC(SYSDATE) FROM dual;

SELECT TRUNC(SYSDATE, 'Month') FROM dual;
SELECT TRUNC(SYSDATE, 'Year') FROM dual;

SELECT ROUND(TO_DATE('25/03/19'), 'Month') FROM dual;
SELECT TRUNC(TO_DATE('25/03/19'), 'Month') FROM dual;
SELECT TRUNC(TO_DATE('25/03/19'), 'Day') FROM dual;

--6. 변환 함수
--6.1. 암시적 형 변환
SELECT employee_id, first_name, department_id
FROM   employees
WHERE  department_id='40';

SELECT employee_id, first_name, hire_date
FROM   employees
WHERE  hire_date='13/06/17';

--6.3. 명시적 형 변환
SELECT first_name, TO_CHAR(hire_date, 'MM/YY') AS HiredMonth
FROM   employees
WHERE  first_name='Steven';

--TO_CHAR
SELECT first_name,
  TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"') HIREDATE
FROM   employees;

SELECT first_name,
  TO_CHAR(hire_date, 'fmYYYY"년" MM"월" DD"일"') HIREDATE
FROM   employees;

SELECT first_name, 
  TO_CHAR(hire_date, 
          'fmDdspth "of" Month YYYY fmHH:MI:SS AM', 
          'NLS_DATE_LANGUAGE=english') AS HIREDATE
FROM   employees;

SELECT 
    TO_CHAR(SYSDATE, 'fmYYYY. MM. DD.') AS korea,
    TO_CHAR(SYSDATE, 'MM/DD/YYYY') AS usa1,
    TO_CHAR(SYSDATE, 'fmMonth DD, YYYY', 'NLS_DATE_LANGUAGE=english') AS usa2,
    TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS iso
FROM dual;

--6.4. 숫자를 문자로 변환
SELECT first_name, last_name, TO_CHAR(salary, '$999,999') SALARY
FROM   employees
WHERE  first_name='David';

SELECT TO_CHAR(2000000, '$999,999') SALARY
FROM   dual;

SELECT first_name, last_name, 
       salary*0.123456 SALARY1, 
       TO_CHAR(salary*0.123456, '$999,999.99') SALARY2
FROM   employees
WHERE  first_name='David';

SELECT 
    TO_CHAR(1234567.89, '9G999G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') AS "US/UK/KR/JP",
    TO_CHAR(1234567.89, '9G999G999D99', 'NLS_NUMERIC_CHARACTERS = ''. ,''') AS "Germany",
    TO_CHAR(1234567.89, '9G999G999D99', 'NLS_NUMERIC_CHARACTERS = '' ,''') AS "France",
    TO_CHAR(1234567.89, '9999999.99') AS "ISO Standard"
FROM DUAL;

-- ALTER SESSION SET NLS_TERRITORY = 'GERMANY';
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';
SELECT TO_CHAR(1234567.89, '9G999G999D99') AS formatted_num
FROM DUAL;

--6.5. TO_NUMBER 함수
SELECT '5000' - 4000 FROM dual;

SELECT '$5,500.00' - 4000 FROM dual; --ORA-01722: 수치가 부적합합니다

SELECT to_number('$5,500.00', '$99,999.99') - 4000 FROM dual;

--6.6. TO_DATE 함수
SELECT first_name, hire_date
FROM   employees
WHERE  hire_date=TO_DATE('2013/06/17', 'YYYY/MM/DD');

SELECT first_name, hire_date
FROM   employees
WHERE  hire_date=TO_DATE('2013년6월17일', 'YYYY"년"MM"월"DD"일"');

--6.7. Null 치환 함수 NVL, NVL2, COALESCE
--NVL
SELECT first_name, salary + salary*commission_pct AS ann_sal --잘 못된 구문
FROM employees;

SELECT first_name, salary + salary*nvl(commission_pct,0) AS ann_sal 
FROM employees;

--NVL2
SELECT first_name, 
  nvl2(commission_pct, salary + (salary*commission_pct), salary) AS ann_sal 
FROM employees;

--COLEASCE
SELECT first_name, 
  COALESCE(salary + (salary*commission_pct), salary) AS ann_sal 
FROM employees;

--6.8. 기타 변환 함수
--LNNVL
SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE salary*commission_pct < 650; --4개 행

SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE COALESCE(salary*commission_pct, 0) < 650; --76개 행

SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE LNNVL(salary*commission_pct >= 650); --76개 행

SELECT first_name, COALESCE(salary*commission_pct,0)
FROM employees
WHERE salary*commission_pct < 650
UNION ALL
SELECT first_name, COALESCE(salary*commission_pct,0)
FROM employees
WHERE salary*commission_pct IS NULL;

--DECODE
SELECT  job_id, salary,
        DECODE(job_id, 'IT_PROG',    salary*1.10,
                       'FI_MGR',     salary*1.15,
                       'FI_ACCOUNT', salary*1.20, 
                                     salary)
        AS REVISED_SALARY
FROM    employees;

--CASE WHEN THEN
SELECT job_id, salary,
  CASE job_id WHEN 'IT_PROG'    THEN salary*1.10
              WHEN 'FI_MGE'     THEN salary*1.15
              WHEN 'FI_ACCOUNT' THEN salary*1.20
       ELSE salary
  END AS REVISED_SALARY
FROM   employees;

SELECT job_id, salary,
  CASE WHEN job_id='IT_PROG'    THEN salary*1.10
       WHEN job_id='FI_MGE'     THEN salary*1.15
       WHEN job_id='FI_ACCOUNT' THEN salary*1.20
       ELSE salary
  END AS REVISED_SALARY
FROM   employees;

--6.9. 변환 함수 실전 문제
SELECT 
  TO_CHAR(LAST_DAY(TO_DATE('01', 'MM')), 'dd') AS "1",
  TO_CHAR(LAST_DAY(TO_DATE('02', 'MM')), 'dd') AS "2",
  TO_CHAR(LAST_DAY(TO_DATE('03', 'MM')), 'dd') AS "3",
  TO_CHAR(LAST_DAY(TO_DATE('04', 'MM')), 'dd') AS "4",
  TO_CHAR(LAST_DAY(TO_DATE('05', 'MM')), 'dd') AS "5",
  TO_CHAR(LAST_DAY(TO_DATE('06', 'MM')), 'dd') AS "6",
  TO_CHAR(LAST_DAY(TO_DATE('07', 'MM')), 'dd') AS "7",
  TO_CHAR(LAST_DAY(TO_DATE('08', 'MM')), 'dd') AS "8",
  TO_CHAR(LAST_DAY(TO_DATE('09', 'MM')), 'dd') AS "9",
  TO_CHAR(LAST_DAY(TO_DATE('10', 'MM')), 'dd') AS "10",
  TO_CHAR(LAST_DAY(TO_DATE('11', 'MM')), 'dd') AS "11",
  TO_CHAR(LAST_DAY(TO_DATE('12', 'MM')), 'dd') AS "12"
FROM dual;

--7. 집합연산자
--집합연산자를 사용할 경우 두 SQL구문의 SELECT 절의 열 개수와 타입이 같아야 함

--7.1. UNION
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '14%'
UNION
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;

--7.2. UNION ALL
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '14%'
UNION  ALL
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;

--7.3. INTERSECT
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '14%'
INTERSECT
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;

--7.4. MINUS
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '14%'
MINUS
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;


-- 연습문제
--1.
SELECT * FROM employees
WHERE lower(email) LIKE '%lee%';

--2.
SELECT first_name, salary, job_id 
FROM employees
WHERE manager_id=103;

--3.
SELECT * FROM employees
WHERE (department_id=80 AND job_id='SA_MAN')
  OR  (department_id=20 AND manager_id=100);
  
--4.
SELECT replace(phone_number, '.', '-') AS 전화번호
FROM employees;

--5.
SELECT 
  RPAD(first_name || ' ' || last_name, 20, '*') AS full_name,
  TO_CHAR(COALESCE(salary+salary*commission_pct, salary), '$099,999.00') AS salary,
  TO_CHAR(hire_date, 'yyyy-mm-dd') AS hire_date,
  ROUND(SYSDATE - hire_date) AS work_day
FROM employees
WHERE upper(job_id) = 'IT_PROG' AND salary>5000
ORDER BY full_name;

--6.
SELECT 
  rpad(first_name || ' ' || last_name, 20, '*') AS full_name, 
  to_char(coalesce(salary+salary*commission_pct, salary), '$099,999.00') AS salary,
  to_char(hire_date, 'yyyy"년" mm"월" dd"일') AS hire_date,
  trunc(months_between(sysdate, hire_date)) AS month
FROM employees WHERE department_id=30
ORDER BY salary DESC;

--7.
SELECT 
  rpad(first_name || ' ' || last_name, 17, '*') AS 이름,
  to_char(coalesce(salary+salary*commission_pct, salary),'$09,999.00') AS 급여
FROM employees
WHERE department_id=80 AND salary>10000
ORDER BY 급여 DESC;

--8.
SELECT first_name AS 이름,
  decode(trunc(trunc(months_between(SYSDATE, hire_date)/12)/5), 
      1, '5년차',
      2, '10년차',
      3, '15년차',
      '기타')
  AS 근무년수
FROM employees
WHERE department_id=30;

--9.
SELECT hire_date + 1000 
FROM employees
WHERE first_name = 'Lex';

--10.
SELECT first_name, hire_date 
FROM employees
WHERE to_char(hire_date, 'MM') = '05';

--11.
SELECT first_name, salary, 
  TO_CHAR(hire_date, 'YYYY"년 입사"') AS year,
  TO_CHAR(hire_date, 'day') AS day,
  CASE WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) >= 10
            THEN TO_CHAR(salary*1.10, '$999,999')
       WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) >= 5
            THEN TO_CHAR(salary*1.05, '$999,999')
       ELSE TO_CHAR(salary,'$999,999')
  END AS "INCREASING_SALARY"
FROM employees;

--12.
SELECT 
	first_name, salary, 
	TO_CHAR(hire_date, 'YYYY"년 입사"') AS year,
	DECODE(TO_CHAR(hire_date, 'RR'), '10', salary*1.10,
                                   '05', salary*1.05,
                                         salary)
    AS "INCREASING_SALARY2"
FROM employees;

--13.
SELECT country_id, 
    NVL(state_province, country_id) AS state
FROM locations;