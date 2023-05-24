--사원번호, 이름, 급여, 부서번호를 저장하는 테이블을 생성해야 합니다.
--사원번호는 PK, 이름은 NN, 급여는 10000이하, 부서번호는 departments 테이블을 참조해서 저장
--테이블 이름 : emp4,
--열이름 : empno, ename, sal, deptno
--타입 : number(4), varchar2(10), number(7,2), number(2)

--열 단위 제약조건 설정
CREATE TABLE emp4 ( --emp4 테이블이 있다면 DROP TABLE emp4; 명령으로 테이블을 삭제하세요.
 empno number(4) CONSTRAINT emp4_empno_pk PRIMARY KEY,
 ename varchar2(10) NOT NULL, --NN 제약조건은 열단위 제약조건만 설정 가능
 sal number(7,2) CONSTRAINT emp4_sal_ck CHECK( sal <= 10000 ),
 deptno number(2) CONSTRAINT emp4_deptno_dept_deptid_fk REFERENCES departments(department_id)
);

--테이블 단위 제약조건 설정
CREATE TABLE emp5 ( --emp4 테이블이 있다면 DROP TABLE emp4; 명령으로 테이블을 삭제하세요.
  empno number(4),
  ename varchar2(10) NOT NULL, --NN 제약조건은 열단위 제약조건만 설정 가능
  sal number(7,2),
  deptno number(2),
    CONSTRAINT emp5_empno_pk PRIMARY KEY (empno),
    CONSTRAINT emp5_sal_ck CHECK( sal <= 10000 ),
    CONSTRAINT emp5_deptno_dept_deptid_fk 
      FOREIGN KEY (deptno) REFERENCES departments(department_id)
);

SELECT * FROM employees;
SELECT * FROM departments;
DESC EMPLOYEES;
--ALTER TABLE 테이블명
--ADD CONSTRAINT 제약조건이름 제약조건(컬럼) [REFERENCES 테이블명(열이름)];

--emp4 테이블에 nickname varchar2(20) 열을 추가합니다.
ALTER TABLE emp4
ADD (nickname varchar2(20));

--nickname 열에 unique 제약조건을 추가하세요.
SELECT * FROM emp4;
ALTER TABLE emp4
ADD CONSTRAINT emp4_nickname_uk UNIQUE(nickname);

--외래키라면.. CONSTRAINT 제약조건이름 FOREIGN KEY(열이름) REFERENCES 테이블명(열이름)
INSERT INTO emp4
VALUES (1000, 'KILDONG', 20000, 10, NULL); --check constraint (%s.%s) violated
INSERT INTO emp4
VALUES (1000, 'KILDONG', 2000, 10, NULL);
INSERT INTO emp4
VALUES (2000, 'KILSEO', 3000, 99, NULL); --parent key not found
INSERT INTO emp4
VALUES (2000, 'KILSEO', 3000, 20, 'KSEO');

UPDATE emp4 
SET nickname='KSEO' 
WHERE empno=1000; --unique constraint (%s.%s) violated

INSERT INTO emp4
VALUES (3000, 'KEVINSEO', 2500, 10, 'KSEO');


--DROP TABLE depts CASCADE CONSTRAINTS;
CREATE TABLE depts (
  deptno     NUMBER(2),
  dname      VARCHAR2(14),
  loc        VARCHAR2(13),
  CONSTRAINT depts_dname_uk UNIQUE(dname),
  CONSTRAINT depts_deptno_pk PRIMARY KEY(deptno));
DROP TABLE emps;
CREATE TABLE  emps (
     empno     NUMBER(4),
     ename     VARCHAR2(10) NOT NULL,
     job       VARCHAR2(9),
     mgr       NUMBER(4),
     hiredate  DATE,
     sal       NUMBER(7,2),
     comm      NUMBER(7,2),
     deptno    NUMBER(2) NOT NULL,
     CONSTRAINT emps_empno_pk PRIMARY KEY(empno),
     CONSTRAINT emps_depts_deptno_fk FOREIGN KEY (deptno)
         REFERENCES depts(deptno) );

INSERT INTO emp4 VALUES (9999, 'KING', 20000, 10, 'KING');

--제약조건 추가
ALTER TABLE      emps
  ADD CONSTRAINT emps_mgr_fk
      FOREIGN KEY(mgr) REFERENCES emps(empno);
  
--제약조건 조회
--USER_CONSTRAINTS 데이터 딕셔너리를 통해 제약조건 정보 조회 가능
SELECT constraint_name, constraint_type, status 
FROM user_constraints
WHERE table_name='EMPS';

--제약조건 삭제
--ALTER TABLE 테이블명
--DROP CONSTRAINT 제약조건이름;
--emp4 테이블의 nickname 열에 걸려있는 제약조건을 삭제
ALTER TABLE emp4
DROP CONSTRAINT emp4_nickname_uk;

ALTER TABLE     emps
DROP CONSTRAINT emps_mgr_fk;

ALTER TABLE     depts
DROP PRIMARY KEY CASCADE;

SELECT constraint_name, constraint_type, status 
FROM user_constraints
WHERE table_name='EMPS';

select * from emp4;
--9999, 'KING', 20000, 10, 'KING' 을 저장해야 합니다. 반드시...
INSERT INTO emp4 VALUES (9999, 'KING', 20000, 10, 'KING'); --check constraint (%s.%s) violated
--sal에 걸려있는 제약조건을 풀어야 합니다.
--ALTER  TABLE 테이블명 DISABLE [NOVALIDATE | VALIDATE] CONSTRAINT 제약조건이름;
--DISABLE NOVALIDATE : 디폴트, 해당 열의 제약조건만 사용하지 않도록 한다.
--DISABLE VALIDATE : 테이블의 데이터를 수정(insert, update, delete)하지 못하도록 하는 것
--PK, UK는 자동으로 인덱스가 생성되는데 DISABLE하면 인덱스도 삭제된다.

ALTER TABLE emp4
DISABLE VALIDATE CONSTRAINT emp4_sal_ck;

UPDATE emp4 SET sal=8000 WHERE empno=1000; --ORA-25128: No insert/update/delete on table with constraint
DELETE FROM emp4 WHERE empno=1000; --ORA-25128
INSERT INTO emp4 VALUES (9999, 'KING', 20000, 10, 'KING'); --ORA-25128

ALTER TABLE emp4
DISABLE CONSTRAINT emp4_sal_ck; --제약조건 사용 안 함

INSERT INTO emp4 VALUES (9999, 'KING', 20000, 10, 'KING');
SELECT * FROM emp4;

--ALTER TABLE 테이블명 ENABLE [NOVALIDATE | VALIDATE] CONSTRAINT 제약조건이름; 
--ENABLE NOVALIDATE : 이미 저장되었던 데이터는 제약조건 체크를 하지 않는다.
--ENABLE VALIDATE : 기본값, 이미 저장되었던 데이터도 제약조건을 체크, 만족하지 못하면 활성화 실패

--emp4_sal_ck 제약조건을 활성화
ALTER TABLE emp4
ENABLE VALIDATE CONSTRAINT emp4_sal_ck; --check constraint violated

ALTER TABLE emp4
ENABLE VALIDATE CONSTRAINT emp4_sal_ck; --기존 저장된 데이터는 제약조건 체크 안 함

