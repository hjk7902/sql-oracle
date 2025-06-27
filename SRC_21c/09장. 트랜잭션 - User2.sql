--User 2
-- 2
SELECT empno, ename, sal FROM emp
WHERE deptno=30;

-- 5
SELECT empno, ename, sal FROM emp
WHERE deptno=30;

-- 6
UPDATE emp SET sal=sal+500
WHERE deptno=30;