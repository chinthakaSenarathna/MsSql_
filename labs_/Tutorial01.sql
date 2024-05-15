create database Tutorial01
use Tutorial01

create table client
(
ClientNo varchar(6) primary key,
Name varchar(20),
City varchar(20),
Date_Joined DateTime,
Balance_Due money
--constraint client_pk primary key(ClientNo)
)

create table product
(
ProductNo varchar(6) primary key,
Description varchar(50),
Profit_Margin int,
Qty_Available int,
Re_order_Level int,
Item_Cost money,
Selling_Price money,
constraint chk_product check(Profit_Margin >= 0 and Profit_Margin <= 100)
)

insert into client values('C001','Sagara','Colombo','2010-12-20',$25000);
insert into client(City,Date_Joined,ClientNo,Name,Balance_Due) values('Colombo','2010-08-05','C002','Nisansala',$12000);

insert into client values('C003','Pamith','Piliyandala','2014-01-30',$4500);
insert into client values('C004','Amila','Mortuwa','2015-06-15',$20000);
insert into client values('C005','Nayana','Nugegoda','2011-12-18',$16500);
insert into client values('C006','Krishan','Anuradhapura','2014-03-04',$22000);
insert into client values('C007','Ruwanthi','Maharagama','2015-05-04',$8500);

--bulck records
insert into client values
('C008','Nalaka','Colombo','2016-05-20',$20000),
('C009','Janaka','Colombo','2016-05-15',$25000)


insert into product values
('P001','FlashDrive 8 GB',5,100,30,1000,1050),
('P002','Keybord',10,25,5,3500,3850),
('P003','Mouse',10,50,15,1200,1320),
('P004','HardDisk 400 GB',15,20,5,10000,11000),
('P005','HardDisk 1 TB',15,35,3,15000,17250),
('P006','FlashDrive 32 GB',60,100,25,1100,1155),
('P007','LED Monitor 15"',15,15,5,18000,20700),
('P008','LED Monitor 17"',20,10,2,30000,34500),
('P009','Mouse Pad',50,10,2,30,40)


delete from client
drop table product
drop database Tutorial01


--//////////////////////////////////////////////////////////
-- closures            -> select, from, where, group by, order by, having
-- aggregate functions -> count() , avg()

--01
select Name
from client

--02
select distinct City
from client

--03
select count(*) as No_Of_Customer
from client
where City = 'Colombo'

--04
select *
from client
where Name like 'N%'

select *
from client
where Name like '%N%'

--05
select *
from client
where Date_Joined < '2015-01-01'

--06
select Name,City
from client
where Date_Joined >= '2014-01-01' and Date_Joined < '2015-01-01'

select Name,City
from client
where Date_Joined between '2014-01-01' and '2015-01-01'

select Name,City
from client
where YEAR(Date_Joined) = '2014'

--07
select *
from client
where Balance_Due > $10000

--08
select avg(Profit_Margin) as Avg_Profit_Margin
from product

--09
select *
from product
where Profit_Margin > 10

--10
select Qty_Available * Item_Cost as Total_Value 
from product
where Description = 'Keybord'


