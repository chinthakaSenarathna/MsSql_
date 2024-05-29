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
insert into orderDetails values
(1,'P003',2,0.2)


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
create type OrdList
as table
(
	productId char(4),
	qty int,
	discount real
)

go

create proc insertToOrder
@cid char(4),
@cname varchar(50),
@cPhone char(10),
@cCountry varchar(20),
@oid int,
@eid char(4),
@ordDate date,
@reqDate date,
@ordDetails as OrdList readonly
as
begin
	begin transaction

	if not exists(select * from Customers where cid = @cid) and 
	   exists(select * from Employees where eid = @eid) 
	begin
		insert into Customers values(@cid,@cname,@cPhone,@cCountry)
		if @@ROWCOUNT = 0 goto myErrorHandel
		insert into Orders values(@oid,@eid,@cid,@ordDate,@reqDate,null,null)
		if @@ROWCOUNT = 0 goto myErrorHandel

		declare myCursor Cursor
		for
		select productId, qty, discount 
		from @ordDetails

		declare @pid char(4), @qty int, @dis real

		open myCursor
		fetch next from myCursor into @pid, @qty, @dis
		while @@FETCH_STATUS = 0
		begin
			insert into orderDetails values(@oid, @pid, @qty, @dis)
			if @@ROWCOUNT = 0 goto myErrorHandel
			fetch next from myCursor into @pid, @qty, @dis
		end

	end
	else
	begin
		goto myErrorHandel
	end

	commit transaction
	return 0

	myErrorHandel:
		rollback transaction
		print 'transaction failed...'
		return -1

end

declare @list OrdList
insert into @list values
('P001',2,0.1),
('P002',3,0.15)

exec insertToOrder 'C004','Aruni','0778665447','Sri Lanka',2,'E002','12-Aug-2020','15-Aug-2020',@list



select * from Employees
select * from Customers
select * from Orders
select * from orderDetails
select * from Products









-- 05

alter trigger updateCost
on orderDetails
after insert, update
as
begin
	declare @oid int, @cost real
	select @oid=oid from inserted
	--if @oid is null
	--begin
	--	select @oid=oid from deleted
	--end
	exec @cost=calcCost @oid
	update Orders set cost=@cost where oid=@oid

end

create trigger updateCost_
on orderDetails
after delete
as
begin
	declare @oid int, @cost real
	select @oid=oid from deleted
	exec @cost=calcCost @oid
	update Orders set cost=@cost where oid=@oid

end




insert into orderDetails values
(1,'P001',3,0.1)
insert into orderDetails values
(1,'P002',5,0.15)
insert into orderDetails values
(1,'P003',2,0.2)

delete from orderDetails where oid=1

select * from orderDetails
select * from Orders


