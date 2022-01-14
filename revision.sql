--#################### REVISION
use company
--1
select CONCAT(upper(ename), 's salary is ', sal, '$')
from EMP
where sal + coalesce(comm, 0) >1500

--2
select *
from EMP
where job in('clerk', 'manager') and (ename like '_____' or ename like '__R%')

--3
select d.dname, count(e.deptno) "Count"
	, min(e.sal) "MIN sal"
	, max(e.sal) "MAX sal"
	, avg(e.sal) "AVG sal"
from EMP e
	join DEPT d
	on e.deptno = d.deptno
group by d.dname
having count(e.deptno) > 2
order by d.dname

--4
select d.dname, count(e.deptno) "EMP Count"
	, min(e.sal) "MIN sal"
	, max(e.sal) "MAX sal"
	, avg(e.sal) "AVG sal"
from EMP e
	right join DEPT d
	on e.deptno = d.deptno
group by d.dname
having count(e.empno) > 2 or count(e.empno)=0
order by d.dname

--5 
select e.ename 'Name'
	, d.dname 'Department'
	, s.grade 'Salary grade'
	, m.ename 'Manager name'
from EMP e
	join DEPT d
	on e.deptno = d.deptno
	join SALGRADE s
	on e.sal between s.losal and s.hisal
	left join EMP m
	on e.manager = m.empno

-- 6
select d.*
from DEPT d
	left join EMP e on d.deptno = e.deptno
where e.deptno is null

-- 7
select *
	, (select m.ename from emp m where m.empno = e.manager) "Manager name"
from EMP e


--8 
select empno, ename, (select count(*) from emp e where e.manager = m.empno) [Num of emps managed directly]
from EMP m


--9
select job
from EMP e
where (sal + coalesce(comm, 0))  = (select max(sal + coalesce(comm, 0))  from EMP)

--10
select hisal, 'High'
from SALGRADE
union
select losal, 'Low'
from SALGRADE
order by 1 desc

--11
select e.ename from EMP e 
join DEPT d on e.deptno = d.deptno
where d.dname = 'Accounting'
union select loc from DEPT
order by 1

--12
select e.*
from EMP m
right join EMP e
on m.manager = e.empno
where m.ename is null

--same
select *
from emp nm
where nm.empno not in (select coalesce(e.manager, 0) from EMP e)

select * 
from emp
where empno in (select empno from emp
			    except
			    select manager from emp) 

--same
with t as 
(select empno from emp
 except
 select manager from emp)
select * 
from emp
where empno in (select empno from t)

--13
create table Product (
 Id integer not null,
 Name nvarchar(100) not null,
 DateManufactured datetime not null DEFAULT getdate(),
 Price decimal(10,2),
 IsAvailable bit,
 CategoryId integer,
 constraint pk_product_id primary key(id),
 constraint ck_product_price check(Price between 0 and 1000)
);

create table Category (
  Id integer not null,
  Name nvarchar(200) not null,
  Description nvarchar(1000),
  constraint uq_category_name UNIQUE(Name),
  constraint pk_category_id primary key(Id)
);

alter table Product add constraint fk_product_categoryid foreign key(categoryid) references category(Id) on delete set null;

--20
set identity_insert category on
insert into Category(id, name, description) 
values (1, 'Food', 'various food items')
	 , (2, 'Electronics', 'all kinds of electronic devices')
set identity_insert category off

insert into product(name, DateManufactured, Price, IsAvailable, CategoryId)
values('Milk', '2021-11-01', 1.01, 1, 1)
, ('Monitor', '2020-11-01', 300.55, 0, 2)

--21
select * into product_backup from product

--22 
delete from category where id = 1

--23
alter table product drop constraint fk_product_categoryid

alter table Product add constraint fk_product_categoryid foreign key(categoryid) references category(Id) on delete set null;

--24
alter table product add "Description" varchar(1000)

--25
alter table product drop column IsAvailable
