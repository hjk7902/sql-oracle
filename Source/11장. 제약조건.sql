--�����ȣ, �̸�, �޿�, �μ���ȣ�� �����ϴ� ���̺��� �����ؾ� �մϴ�.
--�����ȣ�� PK, �̸��� NN, �޿��� 10000����, �μ���ȣ�� departments ���̺��� �����ؼ� ����
--���̺� �̸� : emp4,
--���̸� : empno, ename, sal, deptno
--Ÿ�� : number(4), varchar2(10), number(7,2), number(2)

--�� ���� �������� ����
CREATE TABLE emp4 ( --emp4 ���̺��� �ִٸ� DROP TABLE emp4; ������� ���̺��� �����ϼ���.
 empno number(4) CONSTRAINT emp4_empno_pk PRIMARY KEY,
 ename varchar2(10) NOT NULL, --NN ���������� ������ �������Ǹ� ���� ����
 sal number(7,2) CONSTRAINT emp4_sal_ck CHECK( sal <= 10000 ),
 deptno number(2) CONSTRAINT emp4_deptno_dept_deptid_fk REFERENCES departments(department_id)
);

--���̺� ���� �������� ����
CREATE TABLE emp5 ( --emp4 ���̺��� �ִٸ� DROP TABLE emp4; ������� ���̺��� �����ϼ���.
  empno number(4),
  ename varchar2(10) NOT NULL, --NN ���������� ������ �������Ǹ� ���� ����
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
--ALTER TABLE ���̺��
--ADD CONSTRAINT ���������̸� ��������(�÷�) [REFERENCES ���̺��(���̸�)];

--emp4 ���̺� nickname varchar2(20) ���� �߰��մϴ�.
ALTER TABLE emp4
ADD (nickname varchar2(20));

--nickname ���� unique ���������� �߰��ϼ���.
SELECT * FROM emp4;
ALTER TABLE emp4
ADD CONSTRAINT emp4_nickname_uk UNIQUE(nickname);

--�ܷ�Ű���.. CONSTRAINT ���������̸� FOREIGN KEY(���̸�) REFERENCES ���̺��(���̸�)
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

--�������� �߰�
ALTER TABLE      emps
  ADD CONSTRAINT emps_mgr_fk
      FOREIGN KEY(mgr) REFERENCES emps(empno);
  
--�������� ��ȸ
--USER_CONSTRAINTS ������ ��ųʸ��� ���� �������� ���� ��ȸ ����
SELECT constraint_name, constraint_type, status 
FROM user_constraints
WHERE table_name='EMPS';

--�������� ����
--ALTER TABLE ���̺��
--DROP CONSTRAINT ���������̸�;
--emp4 ���̺��� nickname ���� �ɷ��ִ� ���������� ����
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
--9999, 'KING', 20000, 10, 'KING' �� �����ؾ� �մϴ�. �ݵ��...
INSERT INTO emp4 VALUES (9999, 'KING', 20000, 10, 'KING'); --check constraint (%s.%s) violated
--sal�� �ɷ��ִ� ���������� Ǯ��� �մϴ�.
--ALTER  TABLE ���̺�� DISABLE [NOVALIDATE | VALIDATE] CONSTRAINT ���������̸�;
--DISABLE NOVALIDATE : ����Ʈ, �ش� ���� �������Ǹ� ������� �ʵ��� �Ѵ�.
--DISABLE VALIDATE : ���̺��� �����͸� ����(insert, update, delete)���� ���ϵ��� �ϴ� ��
--PK, UK�� �ڵ����� �ε����� �����Ǵµ� DISABLE�ϸ� �ε����� �����ȴ�.

ALTER TABLE emp4
DISABLE VALIDATE CONSTRAINT emp4_sal_ck;

UPDATE emp4 SET sal=8000 WHERE empno=1000; --ORA-25128: No insert/update/delete on table with constraint
DELETE FROM emp4 WHERE empno=1000; --ORA-25128
INSERT INTO emp4 VALUES (9999, 'KING', 20000, 10, 'KING'); --ORA-25128

ALTER TABLE emp4
DISABLE CONSTRAINT emp4_sal_ck; --�������� ��� �� ��

INSERT INTO emp4 VALUES (9999, 'KING', 20000, 10, 'KING');
SELECT * FROM emp4;

--ALTER TABLE ���̺�� ENABLE [NOVALIDATE | VALIDATE] CONSTRAINT ���������̸�; 
--ENABLE NOVALIDATE : �̹� ����Ǿ��� �����ʹ� �������� üũ�� ���� �ʴ´�.
--ENABLE VALIDATE : �⺻��, �̹� ����Ǿ��� �����͵� ���������� üũ, �������� ���ϸ� Ȱ��ȭ ����

--emp4_sal_ck ���������� Ȱ��ȭ
ALTER TABLE emp4
ENABLE VALIDATE CONSTRAINT emp4_sal_ck; --check constraint violated

ALTER TABLE emp4
ENABLE VALIDATE CONSTRAINT emp4_sal_ck; --���� ����� �����ʹ� �������� üũ �� ��

