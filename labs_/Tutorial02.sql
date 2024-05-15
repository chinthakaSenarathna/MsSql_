create database Tutorial02
use Tutorial02

create table Employee
(
eid integer,
ename varchar(20),
age integer,
salary real,
primary key (eid)
)

create table Dept
(
did varchar(20) primary key,
budget real,
managerid integer default 5,
constraint dept_fk foreign key(managerid) references Employee(eid) on delete cascade on update set default
)

create table Works
(
eid integer,
did varchar(20) default 'Hardware',
patTime integer,
primary key (eid,did),
foreign key (eid) references Employee (eid) on delete no action on update cascade,
foreign key (did) references Dept (did) on delete set default
)

insert into Employee values
(1,'Saman',20,20000.00),
(2,'Amara',23,10000.00),
(3,'Gayan',35,30000.00),
(4,'Ruwan',18,70000.00),
(5,'Nalin',25,8000.00),
(6,'Kalum',27,7000.00)

insert into Dept values
('Hardware',50000.00,3),
('Software',5000.00,3),
('Electronics',11000.00,4),
('IT',1500000.00,5),
('CSE',600000.00,5),
('CM',2000000.00,6)

insert into Works values
(1,'Hardware',8),
(2,'Hardware',5),
(3,'Software',8),
(3,'Hardware',8),
(4,'Electronics',8),
(4,'Hardware',8),
(5,'IT',3),
(5,'CSE',3),
(6,'CM',10)


delete from Employee
drop table Dept
drop database Tutorial02



--/////////////////////////////////////////////////////////////////////////

--01
select w.eid
from Works w
where w.did = 'Hardware'
intersect
(
select w.eid
from Works w
where w.did = 'Software'
)


select w.eid
from Works w
where w.did = 'Hardware' and w.eid in
(
select w.eid
from Works w
where w.did = 'Software'
)


select e.ename,e.age
from Works w
join Employee e on w.eid = e.eid
where w.did = 'Hardware' and w.eid in
(
select w.eid
from Works w
where w.did = 'Software'
)


select e.ename,e.age
from Works w, Employee e
where w.eid = e.eid and w.did = 'Hardware' and w.eid in
(
select w.eid
from Works w
where w.did = 'Software'
)


--02
select e.ename
from Employee e
where e.salary > 
(
select max(d.budget)
from Dept d, Works w
where d.did = w.did and e.eid = w.eid
)

select e.ename
from Employee e
where e.salary > ALL
(
select d.budget
from Dept d, Works w
where d.did = w.did and e.eid = w.eid
)


--03
select d1.managerid
from Dept d1
where 
(
select min(d2.budget)
from Dept d2
where d2.managerid = d1.managerid
) > 1000000


--04
select e.ename
from Employee e, Dept d
where e.eid = d.managerid and d.budget=
(
select max(budget)
from Dept
)


--05
select d.managerid
from Dept d
group by d.managerid
having sum(d.budget) > 1000000


--06
select t1.managerid
from
(
select d.managerid, sum(d.budget) totBudget
from Dept d
group by d.managerid
) t1 --renaming newly created table
where t1.totBudget=
(
select max(t1.totBudget)
from
(
select d.managerid, sum(d.budget) totBudget
from Dept d
group by d.managerid
) t1
)