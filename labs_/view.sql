create database Tutorial04
use Tutorial04

create table client
(
clientNo varchar(6) primary key,
name varchar(20),
city varchar(20),
date_joined datetime,
balance money
)

create table product
(
productNo varchar(6) primary key,
description1 varchar(50),
profit_margin int,
qty_available int,
re_order_level int,
item_cost money,
selling_price money,
constraint chk_Product check(profit_margin >= 0 and profit_margin <= 100)
)

insert into client values
('C001','Sagara','Colombo','2010-12-20',$25000),
('C002','Nisansala','Galle','2014-08-05',$12000),
('C003','Pamith','Piliyandala','2014-01-30',$4500),
('C004','Amila','Moratuwa','2015-06-15',$20000),
('C005','Nayana','Nugegoda','2010-12-18',$16500),
('C006','Krishan','Anuradhapura','2014-03-04',$22000),
('C007','Ruwanthi','Maharagama','2015-05-04',$8500),
('C008','Nalaka','Colombo','2016-05-20',$25000),
('C009','Janaka','Colombo','2016-05-20',$25000)

insert into product values
('P001','Flashrive 8 GB',5,100,30,1000,1050),
('P002','Keyboard',10,25,5,3500,3850),
('P003','Mouse',10,50,15,1200,1320),
('P004','HardDisk 400 GB',15,20,5,10000,11500),
('P005','HardDisk 1 TB',15,35,3,15000,17250),
('P006','Flashrive 32 GB',60,100,25,1100,1155),
('P007','LED Monitor 15"',15,15,5,18000,20700),
('P008','LED Monitor 17"',20,10,2,30000,34500),
('P009','Mouse Pad',50,10,2,30,40)

create table Sales_Order
(
Sales_Order_No int primary key,
Sales_Order_Date date,
Order_Taken_By varchar(20),
ClientNo varchar(6),
Delivery_Address varchar(255),
constraint sales_order_fk foreign key(ClientNo) references client(clientNo)
)

create table Sales_Order_Details
(
Sales_Order_No int primary key,
ProductNo varchar(6),
Quantity int,
constraint order_Details_fk1 foreign key(Sales_Order_No) references Sales_Order(Sales_Order_No),
constraint order_Details_fk2 foreign key(ProductNo) references product(productNo)
)

create table Items_to_Order
(
NoticeNo int primary key,
Product_No varchar(6),
DateNotified date,
constraint Items_to_Order_fk foreign key(Product_No) references product(productNo)
)

insert into Sales_Order values
(1,'2010-01-12','Nuwani','C001','Homagama'),
(2,'2010-02-12','Tharushi','C002','Baddulla'),
(3,'2010-03-12','Sunil','C003','Narahenpita'),
(4,'2010-04-12','Chamari','C004','Piliyandala'),
(5,'2010-05-12','Nimal','C005','Moratuwa'),
(6,'2010-01-12','Hiran','C005','Katibedda'),
(7,'2010-07-12','Tharindu','C007','Kelaniya'),
(8,'2010-08-12','Nishadi','C005','Katibedda'),
(9,'2010-08-12','Chamari','C008','Colobbo'),
(10,'2010-08-12','Sunil','C009','Colobbo'),
(11,'2010-08-12','Sunil','C009','Colobbo')

insert into Sales_Order_Details values
(1,'P001',10),
(2,'P002',20),
(3,'P004',30),
(4,'P003',40),
(5,'P006',50),
(6,'P005',60),
(7,'P006',70),
(8,'P009',20),
(9,'P001',100)

insert into Items_to_Order values
(1,'P007','2015-12-12'),
(2,'P006','2015-11-12'),
(3,'P005','2015-10-12'),
(4,'P004','2015-09-12')


--//////////////////////////////////////////////////////////////////////////////////
-- just only sql statement is saved, but not saved view

--01
-- only saved
create view myView01
as
select *
from Sales_Order
where ClientNo = 'C005'

select *
from myView01
where Delivery_Address = 'Katibedda'

select * from myView01   --execute above sql query


--02
create view myView02
as
select p.description1, sum(sod.Quantity) as totQunt
from product p, Sales_Order_Details sod
where p.productNo = sod.ProductNo
group by p.description1

select * 
from myView02
where totQunt > 50

select * from myView02



--03
create view myView03
as
select so.Order_Taken_By
from product p, Sales_Order_Details sod, Sales_Order so
where p.productNo = sod.ProductNo and so.Sales_Order_No = sod.Sales_Order_No
and p.description1 = 'HardDisk 1 TB'

select * from myView03


--04
-- aggregate function -> datename(retrive, pass)
create view myview04
as
select Sales_Order_No, datename(dw,Sales_Order_Date) as sod_day
from Sales_Order

select *
from myview04
where sod_day = 'friday'

select * from myview04


--05
create view myview05
as
select so.Sales_Order_No, so.ClientNo, so.Delivery_Address, so.Order_Taken_By, so.Sales_Order_Date, datename(dw,so.Sales_Order_Date) as day_of_week
from Sales_Order so

select *
from myview05
where day_of_week = 'Friday'

select * from myview05



--06
create view myview06
as
select sod.Sales_Order_No, (p.selling_price * sod.Quantity) as bill_value
from Sales_Order_Details sod, product p
where sod.ProductNo = p.productNo

select *
from myview06
where Sales_Order_No = 1

select * from myview06








--// updatable view

create table dept
(
did varchar(10) primary key,
dname varchar(30),
budget money
)

create table emp
(
eid int primary key,
ename varchar(50),
salary money,
did varchar(10) references dept(did)
)

insert into dept values
('D1','IT',20000),
('D2','HR',30000),
('D3','CS',20000)

insert into emp values
(1,'saman',$5000,'D2'),
(2,'kamal',$7000,'D2'),
(3,'aruni',$6000,'D1'),
(4,'gayan',$8500,'D3'),
(5,'sathira',$15000,'D1')

delete from emp


create view udView01
as
select *
from emp
where salary > $10000
with check option

select * from udView01
select * from emp

drop view udView01

update emp set salary = $12000 where eid = 1

-- when we update the view but actually update the original table
update udView01 set salary = $11000 where eid = 5

-- when we updated the view but not in data in view, therefore not updated value
-- you can only update included data only
update udView01 set salary = $15000 where eid = 2

-- when you update the value in view table then automatically updated if included data in view
update udView01 set salary = $2000 where eid = 1  -- Not Okay, it is disapier
update udView01 set salary = $20000 where eid = 1 -- Okay, it is not disapier 

-- How to solve this problem -> with check option

-- Now enable the with check option, but you want delete data in view -> you can
-- then delete data in view and original table
delete from udView01 where eid = 1 -- Okay



-- But view based on two table
create view udView02
as
select e.eid, e.ename, e.salary, e.did, d.did as dno, d.dname, d.budget
from emp e, dept d
where e.did = d.did

select * from udView02

-- Only one table data updated --> it is okay
update udView02 set salary = $4000 where eid = 3
update udView02 set ename = 'parami', salary = $4000 where eid = 3

-- Now update two tables data --> Not allowed
update udView02 set salary = $12000, budget = $20000 where eid = 4

-- Now delete data in view which are included in two tables --> Now allwoed
delete from udView02 where eid = 5

-- insertion effect mutiple based table --> Not allowed
insert into udView02 values(6,'Nimal',60000,'D4','D4','AC',80000)

-- insertion effect only one based table --> is okay
insert into udView02(eid,ename,salary,did) values(6,'Nimal',60000,'D1')




--01
create view view_1
as
select *
from Sales_Order
where ClientNo in
(
select clientNo
from client
where date_joined = '2016-05-20'
)

select * from view_1

-- Only based on one table
update view_1 set Delivery_Address = '58, Main Road, Colombo 8'
where Delivery_Address like '%Colobbo%'


--02
create view view_2
as
select product.productNo, product.selling_price, product.selling_price * Sales_Order_Details.Quantity as bill_value
from Sales_Order_Details, product
where Sales_Order_Details.ProductNo = product.productNo and selling_price * Quantity > 1000
with check option

select * from view_2
select * from product

drop view view_2

-- only effected on one base table
update view_2 set selling_price = $500 where selling_price = 1050

-- only effected on one base table --> after not disapear -> with check option
update view_2 set selling_price = $30 where productNo = 'P002'



--03
create view view_3
as
select *
from product
where profit_margin > 10

select * from view_3
select * from product

-- effected only one based table
update view_3 set qty_available = 1500 where profit_margin > 50