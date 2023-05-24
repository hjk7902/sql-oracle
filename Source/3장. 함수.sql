--------------------------------
--3Àå. ÇÔ¼ö
--------------------------------
--2. ¹®ÀÚÇÔ¼ö
SELECT * FROM dual;
SELECT sysdate FROM dual;
SELECT initcap('javaspecialist') FROM dual;
SELECT lower('JavaSpecialist') FROM dual;
SELECT upper('JavaSpecialist') FROM dual;
SELECT length('JavaSpecialist') FROM dual;
SELECT length('ÀÚ¹ÙÀü¹®°¡±×·ì') FROM dual;
SELECT lengthb('ÀÚ¹ÙÀü¹®°¡±×·ì') FROM dual;
-- ÇöÀç ÀÎÄÚµùÀº utf-8ÀÌ±â ¶§¹®¿¡, EUC-KR ÀÎÄÚµùÀ» »ç¿ëÇÏ¸é 10ÀÌ Ãâ·Â
SELECT * FROM NLS_DATABASE_PARAMETERS; --ÇöÀç ÀÎÄÚµù È®ÀÎ
SELECT concat('Java', 'Specialist') FROM dual;
SELECT substr('JavaSpecialist', 5, 7) FROM dual;
SELECT substr('ÀÚ¹ÙÀü¹®°¡±×·ì', 3, 3) FROM dual;
SELECT substrb('ÀÚ¹ÙÀü¹®°¡±×·ì', 7, 9) FROM dual;
SELECT instr('JavaSpecialist',  'S') FROM dual;
SELECT instr('JavaSpecialist',  'b') FROM dual;
SELECT instr('ÀÚ¹ÙÀü¹®°¡±×·ì',  'Àü') FROM dual;
SELECT instrb('ÀÚ¹ÙÀü¹®°¡±×·ì',  'Àü') FROM dual;
SELECT rpad(first_name, 10, '-') AS name, lpad(salary, 10, '*') AS sal FROM employees;
-- ÁÖ¾îÁø ÀÚ¸´¼ö ¸¸Å­ ¿À¸¥ÂÊ(rpad) ¶Ç´Â ¿ÞÂÊ(lpad)¿¡ Ã¤¿î´Ù.
SELECT ltrim('JavaSpecialist', 'Java') FROM dual;
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
WHERE  last_name='austin';

SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM   employees
WHERE  last_name='Austin';

SELECT last_name, LOWER(last_name), INITCAP(last_name), UPPER(last_name)
FROM   employees
WHERE  LOWER(last_name)='austin';

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

--2.7. ¹®ÀÚ¿­ Á¶ÀÛ ½ÇÀü ¹®Á¦
SELECT 
  RPAD(substr(first_name, 1, 3), LENGTH(first_name), '*') AS name,
  LPAD(salary, 10, '*') AS salary
FROM 
  employees
WHERE
  LOWER(job_id)='it_prog';

--3. Á¤±ÔÇ¥Çö½Ä ÇÔ¼ö
CREATE TABLE messages (
	sender 	VARCHAR2(50), 
	receiver	VARCHAR2(50), 
	content 	VARCHAR2(2000)
);

INSERT INTO messages 
VALUES('È«±æµ¿', 'È«±æ¼­', 'ÀüÈ­ÁÖ¼¼¿ä. 010-1234-5678');
INSERT INTO messages 
VALUES('È«±æ³²', 'È«±æºÏ', 'hello sender@hello.com');
INSERT INTO messages 
VALUES('ÇãÁø°æ', 'È«±æµ¿', 'hjk7902@gmail.comÀ¸·Î ¸ÞÀÏÁÖ¼¼¿ä.');
INSERT INTO messages 
VALUES('È«±æµ¿', 'ÀÌ¼ø½Å', '¹Ý°©½À´Ï´Ù.');
INSERT INTO messages 
VALUES('Á¤ÁØ¼ö', 'ÇãÁø°æ', '010 2346 6789 hello@abc.com');
INSERT INTO messages 
VALUES('Eric', 'James', 'Call Me. 010.3456.7890');
COMMIT; 

SELECT * FROM messages;

--3.2. REGEXP_LIKE ÇÔ¼ö
SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}-[0-9]{4}-[0-9]{4}');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}-\d{4}-[[:digit:]]{4}');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}.[0-9]{4}.[0-9]{4}');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[0-9]{3}\.[0-9]{4}\.[0-9]{4}');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '\S+@\S+\.\S+');

SELECT * FROM messages
WHERE REGEXP_LIKE(content, '[°¡-ÆR]+');

--3.3. REGEXP_INSTR ÇÔ¼ö
SELECT content, 
       REGEXP_INSTR(content, '\S+@\S+\.\S+') AS email,
       REGEXP_INSTR(content, '\d{3}.\d{4}.\d{4}') AS phone,
       REGEXP_INSTR(content, '\.') AS period,
       REGEXP_INSTR(content, '[°¡-ÆR]+') AS kor       
FROM messages;

--3.4. REGEXP_SUBSTR ÇÔ¼ö
SELECT content, 
  REGEXP_SUBSTR(content, '[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+') AS email,
  REGEXP_SUBSTR(content, '\d{3}.\d{4}.\d{4}') AS phone,
  REGEXP_SUBSTR(content, '[°¡-ÆR ]+') AS kor
FROM messages;

--3.5. REGEXP_REPLACE ÇÔ¼ö
SELECT content, 
REGEXP_REPLACE(content, '\d{3}.\d{4}.\d{4}', '*') AS phone
FROM messages;

--3.6. REGEXP ÇÔ¼ö ½ÇÀü ¹®Á¦
SELECT first_name, phone_number
FROM employees
WHERE regexp_like (phone_number, '^[0-9]{3}.[0-9]{3}.[0-9]{4}$');

SELECT first_name, phone_number
FROM employees
WHERE regexp_like (phone_number, '^[[:digit:]]{3}.[[:digit:]]{3}.[[:digit:]]{4}$');

SELECT first_name, 
  regexp_replace(phone_number, '[[:digit:]]{4}$', '****') AS phone,
  regexp_substr(phone_number, '[[:digit:]]{4}$') AS phone2
FROM employees
WHERE regexp_like (phone_number, '^[0-9]{3}.[0-9]{3}.[0-9]{4}$');

--4. ¼ýÀÚ ÇÔ¼ö
--4.1. ROUND, TRUNC
SELECT ROUND(45.923,2), ROUND(45.923,0), ROUND(45.923,-1) 
FROM   DUAL;

SELECT TRUNC(45.923,2), TRUNC(45.923), TRUNC(45.923,-1) 
FROM   DUAL;


--5. ³¯Â¥ ÇÔ¼ö
SELECT SYSDATE 
FROM DUAL;

SELECT SYSTIMESTAMP 
FROM DUAL;

--5.1. ³¯Â¥ ¿¬»ê
SELECT first_name, (SYSDATE - hire_date)/7 AS "Weeks"
FROM   employees
WHERE  department_id=60;

--5.2. ³¯Â¥ ÇÔ¼ö
--MONTHS_BETWEEN
SELECT first_name, SYSDATE, hire_date, MONTHS_BETWEEN(SYSDATE, hire_date) AS workmonth
FROM employees
WHERE first_name='Diana'; --±Ù¹« ÇÑ °³¿ù ¼ö¸¦ Ãâ·Â, 

--ADD_MONTHS
SELECT first_name, hire_date, ADD_MONTHS(hire_date, 100)
FROM employees
WHERE first_name='Diana';

--NEXT_DAY, µ¹¾Æ¿À´Â °¡Àå ÃÖ±Ù ¿äÀÏ ³¯Â¥
SELECT SYSDATE, NEXT_DAY(SYSDATE, '¿ù') 
FROM dual; 

--LAST_DAY, ³¯Â¥°¡ Æ÷ÇÔµÈ ¿ùÀÇ ¸¶Áö¸· ³¯Â¥
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM dual;

--ROUND, TRUNC
--½Ã°£¿¡ »ó°ü ¾øÀÌ Ã³¸®ÇÏ°í ½ÍÀ» ¶§ »ç¿ë
SELECT SYSDATE, ROUND(SYSDATE), TRUNC(SYSDATE) FROM dual;

--round¿Í trunc ÇÔ¼ö¿¡ ¹Ý¿Ã¸² ÇÏ°Å³ª Àý»è ÇÒ ´ÜÀ§¸¦ ÁöÁ¤ÇÒ ¼ö ÀÖ´Ù.
SELECT TRUNC(SYSDATE, 'Month') FROM dual; --±× ´ÞÀÇ Ã¹ ¹øÂ° ³¯Â¥
SELECT TRUNC(SYSDATE, 'Year') FROM dual; --±× ÇØÀÇ Ã¹ ¹øÂ° ³¯Â¥

SELECT ROUND(TO_DATE('17/03/16'), 'Month') FROM dual;
SELECT TRUNC(TO_DATE('17/03/16'), 'Month') FROM dual;
SELECT TRUNC(TO_DATE('17/03/16'), 'Day') FROM dual;

--6. º¯È¯ ÇÔ¼ö
--6.1. ¾Ï½ÃÀû Çü º¯È¯
SELECT employee_id, first_name, department_id
FROM   employees
WHERE  department_id='40';

SELECT employee_id, first_name, hire_date
FROM   employees
WHERE  hire_date='03/06/17';

--6.3. ³¯Â¥¸¦ ¹®ÀÚ·Î º¯È¯
SELECT first_name, TO_CHAR(hire_date, 'MM/YY') AS HiredMonth
FROM   employees
WHERE  first_name='Steven';

SELECT first_name,
  TO_CHAR(hire_date, 'YYYY"³â" MM"¿ù" DD"ÀÏ"') HIREDATE
FROM   employees;

SELECT first_name, 
  TO_CHAR(hire_date, 
          'fmDdspth "of" Month YYYY fmHH:MI:SS AM', 
          'NLS_DATE_LANGUAGE=english') AS HIREDATE
FROM   employees;

--6.4. ¼ýÀÚ¸¦ ¹®ÀÚ·Î º¯È¯
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

--6.5. TO_NUMBER ÇÔ¼ö
SELECT '$5,500.00' - 4000 FROM dual; --¿¡·¯

--¼öÁ¤µÈ ¹®ÀåÀº...
SELECT to_number('$5,500.00', '$99,999.99') - 4000 FROM dual;

--6.6. TO_DATE ÇÔ¼ö
SELECT first_name, hire_date
FROM   employees
WHERE  hire_date=TO_DATE('2003/06/17', 'YYYY/MM/DD');

SELECT first_name, hire_date
FROM   employees
WHERE  hire_date=TO_DATE('2003³â06¿ù17ÀÏ', 'YYYY"³â"MM"¿ù"DD"ÀÏ"');

--6.7. Null Ä¡È¯ ÇÔ¼ö NVL, NVL2, COALESCE
--¸ðµç »ç¿øÀÇ º¸³Ê½º¸¦ Æ÷ÇÔÇÑ ±Þ¿©¸¦ Ãâ·Â ÇÕ´Ï´Ù.
--NVL
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

--6.8. ±âÅ¸ º¯È¯ ÇÔ¼ö
--LNNVL
--º¸³Ê½º°¡ 650´Þ·¯ º¸´Ù ÀÛ°Å³ª º¸³Ê½º°¡ ¾ø´Â »ç¿øµé¿¡°Ô »óÇ°±ÇÀ» Áö±ÞÇÏ·Á ÇÕ´Ï´Ù.
--ÇØ´ç »ç¿øµéÀÇ ÀÌ¸§°ú º¸³Ê½º¸¦ Ãâ·ÂÇÏ¼¼¿ä.
SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE salary*commission_pct < 650; --4°³ Çà

SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE COALESCE(salary*commission_pct, 0) < 650; --76°³ Çà

SELECT first_name, COALESCE(salary*commission_pct, 0) AS bonus
FROM employees
WHERE LNNVL(salary*commission_pct >= 650); --76°³ Çà

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

--6.9. º¯È¯ ÇÔ¼ö ½ÇÀü ¹®Á¦
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

--7. ÁýÇÕ¿¬»êÀÚ
--7.1. UNION
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '04%'
UNION
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;

--7.2. UNION ALL
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '04%'
UNION  ALL
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;

--7.3. INTERSECT
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '04%'
INTERSECT
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;

--7.4. MINUS
SELECT employee_id, first_name
FROM   employees
WHERE  hire_date LIKE '04%'
MINUS
SELECT employee_id, first_name
FROM   employees
WHERE  department_id=20;


--¿¬½À¹®Á¦ 11¹ø
SELECT first_name, salary, 
  TO_CHAR(hire_date, 'RRRR"³â ÀÔ»ç"') AS year,
  TO_CHAR(hire_date, 'day') AS day,
  CASE WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) >= 10
            THEN TO_CHAR(salary*1.10, '$999,999')
       WHEN TO_NUMBER(TO_CHAR(hire_date, 'YY')) >= 5
            THEN TO_CHAR(salary*1.05, '$999,999')
       ELSE TO_CHAR(salary,'$999,999')
  END AS "INCREASING_SALARY"
FROM employees;

SELECT first_name, salary, 
  TO_CHAR(hire_date, 'RRRR"³â ÀÔ»ç"') AS year,
  TO_CHAR(hire_date, 'day') AS day,
  CASE WHEN TO_NUMBER(REGEXP_SUBSTR(hire_date, '[0-9]{2}')) >= 10
            THEN TO_CHAR(salary*1.10, '$999,999')
       WHEN TO_DATE(REGEXP_SUBSTR(hire_date, '[0-9]{2}'), 'RR') >= TO_DATE('05', 'RR')    
            THEN TO_CHAR(salary*1.05, '$999,999')
       ELSE TO_CHAR(salary,'$999,999')
  END AS "INCREASING_SALARY"
FROM employees;