create database Tutorial06
use Tutorial06

create table Customers
(
cid char(4) primary key,
cname varchar(50),
phone  char(10),
country varchar(20)
)

create table Employees
(
eid char(4) primary key,
ename varchar(50),
phone char(10),
birthdate date
)

create table Products
(
pid char(4) primary key,
pname varchar(15),
unitPrice real,
unitInStock int,
ROL int
)

create table Orders
(
oid int primary key,
eid char(4) references Employees(eid),
cid char(4) references Customers(cid),
orderDate date,
requiredDate date,
shippedDate date,
cost real
)

create table orderDetails
(
oid int,
productId char(4) references Products(pid),
quantity int,
discount real,
constraint orderDetails_pk primary key(oid,productId)
)

insert into Customers values
('C001','Saman','0772446552','Sri Lanka'),
('C002','Jhon','0987665446','USA'),
('C003','Mashato','0927665334','Japan')

insert into Employees values
('E001','Kasun Weerasekara','0702994459','07-Apr-1997'),
('E002','Sathira Wijerathna','0702994459','05-Feb-1996')

insert into Products values
('P001','Hard Disk',12000,80,50),
('P002','Flash Drive',3200,60,20),
('P003','LCD Monitor',24000,35,15)

insert into Orders values
(1,'E001','C001','01-Sep-2020','09-Sep-2020','02-Sep-2020',null)

insert into orderDetails values
(1,'P001',3,0.1)
insert into orderDetails values
(1,'P002',5,0.15)


select * from Employees
select * from Customers
select * from Orders
select * from orderDetails
select * from Products

go

-- 01
-- method 01

create function calcCost
(
@oId int
)
returns real
as
begin
	
	declare @totCoat real
	select @totCoat=sum(p.unitPrice * t.quantity)
	from Products p, getTable(@oId) t
	where p.pid = t.productId
	return @totCoat

end

go

create function getTable
(
@oId int
)
returns table
as
	return
	select *
	from orderDetails od
	where od.oid = @oId


declare @value real
exec @value=calcCost 1
print(@value)

go

-- method 02

alter function calcCost_
(
@oId int
)
returns real
as
begin
	
	declare @totCost real
	select @totCost=sum(p.unitPrice * od.quantity)
	from Products p, orderDetails od
	where p.pid = od.productId and od.oid = @oId
	return @totCost

end

declare @value_ real
exec @value_=calcCost_ 1
print(@value_)




-- 02

create function productsOfOrder
(
@oId int
)
returns table
as
	return
	select p.pname, od.quantity
	from Products p, orderDetails od
	where p.pid = od.productId and od.oid = @oId


-- exec productsOfOrder 1 --> Wrrong....

select *
from productsOfOrder(1)





-- 03
-- Pre-define table

create function productsOfOrder_
(
@oId int
)
returns @myTable table
(
	pName varchar(15),
	qty int
)
as
begin
	insert into @myTable
	select p.pname, od.quantity
	from Products p, orderDetails od
	where p.pid = od.productId and od.oid = @oId
	delete from @myTable where pName not like '%disk%'
	return

end

select *
from productsOfOrder_(1)







-- 04
