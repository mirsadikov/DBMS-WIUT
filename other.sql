-- CTE
use company
--all employees whom 7839 supervises directly or indirectly
with emp_hierarchy AS (
  select empno, ename, manager, 1 as level
  from emp
  where empno = 7839
  UNION ALL
  select e.empno, e.ename, e.manager, level + 1
  from emp e JOIN emp_hierarchy m ON e.manager = m.empno
)
select * from emp_hierarchy 
where empno <> 7902

--all employees whom BLAKE supervises directly or indirectly
with emp_hierarchy AS (
  select empno, ename, manager, 1 as level
  from emp
  where ename = 'BLAKE'
  UNION ALL
  select e.empno, e.ename, e.manager, level + 1
  from emp e JOIN emp_hierarchy m ON e.manager = m.empno
)
select * from emp_hierarchy 
where ename <> 'BLAKE'

--all supervisors of BLAKE
with emp_hierarchy AS (
  select empno, ename, manager, 1 as level
  from emp
  where ename = 'BLAKE'
  UNION ALL
  select e.empno, e.ename, e.manager, level + 1
  from emp e JOIN emp_hierarchy m 
                      ON m.manager = e.empno
)
select * from emp_hierarchy 
where ename <> 'BLAKE'
