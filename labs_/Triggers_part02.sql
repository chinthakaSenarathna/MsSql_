create database Tutorial05
use Tutorial05

create table department
(
did varchar(5),
dname varchar(20),
budget money,
mgrid varchar(5),
constraint department_pk primary key(did)
)

create table employee
(
eid varchar(5),
ename varchar(20),
age int,
salary money,
did varchar(5),
supervid varchar(5),
constraint employee_pk primary key(eid),
constraint employee_fk1 foreign key(did) references department(did),
constraint employee_fk2 foreign key(supervid) references employee(eid)
)

-- important
alter table department add constraint department_fk foreign key(mgrid) references employee(eid)

insert into department values('d001','HR',250000,null)
insert into department values('d002','Sales',340000,null)
insert into department values('d003','Accounts',560000,null)
insert into department values('d004','IT',590000,null)

insert into employee values('e001','Saman',23,70000,'d001',null)
insert into employee values('e002','Kamal',31,34000,'d001','e001')
insert into employee values('e003','Nipun',22,56000,'d003','e001')
insert into employee values('e004','Kasun',23,54000,'d002','e003')
insert into employee values('e005','Heshan',31,60000,'d002','e001')
insert into employee values('e006','Aruni',25,47000,'d004','e003')
insert into employee values('e007','Sachini',21,32000,'d002','e004')

update department set mgrid='e002' where did='d001'
update department set mgrid='e001' where did='d002'
update department set mgrid='e001' where did='d003'
update department set mgrid='e003' where did='d004'


select * from department
select * from employee


Go

--01
create Trigger checkSalary
on employee
after insert, update
as
begin
	declare @newSalary money
	declare @suprvId varchar(5)
	declare @suprvSalary money
	select @newSalary=salary, @suprvId=supervid from inserted
	select @suprvSalary=salary from employee where eid=@suprvId

	if(@suprvSalary<@newSalary)
	begin
		Rollback Transaction
	end

end


update employee set salary=80000 where eid='e003'
select * from employee

Go

--02
create view DeptMgr_Details
as
select d.did, d.dname, d.budget, d.mgrid, e.ename as mgrname, e.age, e.salary, e.supervid
from department d, employee e
where d.mgrid = e.eid

select * from DeptMgr_Details


--03
-- views NOT support for the multiple updated base tables
-- only support for one based table

select * from DeptMgr_Details

-- can't updated multiple base tables
insert into DeptMgr_Details values('d005','Credit',600000,'e008','Kamani',32,23000,'e003')

Go

create Trigger MgrInsert
on DeptMgr_Details
instead of insert
as
begin
	 declare @did varchar(5)
	 declare @dname varchar(20)
	 declare @dbudget money
	 declare @mgrid varchar(5)
	 declare @ename varchar(20)
	 declare @age int
	 declare @salary money
	 declare @supervid varchar(5)

	 select @did=did, @dname=dname, @dbudget=budget, @mgrid=mgrid, @ename=mgrname, @age=age, @salary=salary, @supervid=supervid from inserted

	 if not exists(select * from department where did=@did) and not exists(select * from employee where eid=@mgrid) and exists(select * from employee where eid=@supervid)
	 begin
		insert into department values(@did,@dname,@dbudget,null)
		insert into employee values(@mgrid,@ename,@age,@salary,@did,@supervid)
		update department set mgrid=@mgrid where did=@did
	 end
end


insert into DeptMgr_Details values('d005','Credit',600000,'e008','Kamani',32,23000,'e003')

select * from DeptMgr_Details
select * from department
select * from employee

Go

--04
create view Low_budgeted_departments
as
select *
from department
where budget < 500000


select * from Low_budgeted_departments

-- all are write operations
insert into Low_budgeted_departments values('d006','Leasing',400000,'e003')
update Low_budgeted_departments set budget=100000 where did='d001'
delete from Low_budgeted_departments where did='d006'


-- how to write read only view --> instead of Trigger

create Trigger readOnlyBDView
on Low_budgeted_departments
instead of insert, update, delete
as
begin
	print'This is a read only view, can not modifications'
end