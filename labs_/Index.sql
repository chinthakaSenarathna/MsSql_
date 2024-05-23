create database TestIndexDB
use TestIndexDB

create table Status
(
code int,
description char(30),
primary key(code)
)

create table Media
(
media_id int,
code int,
primary key(media_id),
foreign key(code) references Status(code)
)

create table Book
(
ISBN char(14),
title CHAR(128),
author CHAR(64),
year int,
dewey int,
price real,
--primary key(ISBN) --> Not create Clustered Index default --> What is the primary key...
)

create table BookMedia
(
media_id int,
ISBN char(14),
primary key(media_id),
foreign key(media_id) references Media(media_id),
--foreign key(ISBN) references Book(ISBN)
)

create table Customer
(
ID int,
name char(64),
addr char(256),
DOB char(10),
phone char(30),
username char(16) unique,
password char(32),
primary key(ID),
)

create table Card
(
num int,
fines real,
ID int,
primary key(num),
foreign key(ID) references Customer(ID)
)

create table checkout
(
media_id int,
num int,
since char(10),
until char(10),
primary key(media_id),
foreign key(media_id) references Media(media_id)
)

create table Location
(
name char(64),
addr char(256),
phone char(30),
primary key(name)
)

create table Hold
(
media_id int,
num int,
name char(64),
until char(10),
queue int,
primary key(media_id,num),
foreign key(name) references Location(name),
foreign key(num) references Card(num),
foreign key(media_id) references Media(media_id)
)

create table Stored_In
(
media_id int,
name char(64),
primary key(media_id),
foreign key(media_id) references Media(media_id) on delete cascade,
foreign key(name) references Location(name)
)

create table Librarian
(
eid int,
ID int not null,
Pay real,
Loc_name char(64) not null,
primary key(eid),
foreign key(ID) references Customer(ID) on delete cascade,
foreign key(Loc_name) references Location(name)
)

create table Video
(
title char(128),
year int,
director char(64),
rating real,
price real,
primary key(title,year)
)

create table VideoMedia
(
media_id int,
title char(128),
year int,
primary key(media_id),
foreign key(media_id) references Media(media_id)
)


-- Populate to Customer table
insert into Customer values
(60201,'Jason L. Gray', '2087 Timberbrook Lane, Gypsum, CO 81637','09/09/1958','970-273-9237', 'jlgray', 'password1'),
(89682,'Mary L. Prieto', '1465 Marion Drive, Tampa, FL 33602','11/20/1961','813-487-4873', 'mlprieto', 'password2'),
(64937,'Roger Hurst', '974 Bingamon Branch Rd, Bensenville, IL 60106','08/22/1973','847-221-4986', 'rhurst', 'password3'),
(31430,'Warren V. Woodson', '3022 Lords Way, Parsons, TN 38363','03/07/1945','731-845-0077', 'wvwoodson', 'password4'),
(79916,'Steven Jensen', '93 Sunny Glen Ln, Garfield Heights, OH 44125','12/14/1968','216-789-6442', 'sjensen', 'password5')
insert into Customer values
(93265,'David Bain', '4356 Pooh Bear Lane, Travelers Rest, SC 29690','08/10/1947','864-610-9558', 'dbain', 'password6'),
(58359,'Ruth P. Alber', '3842 Willow Oaks Lane, Lafayette, LA 70507','03/18/1976','337-316-3161', 'rpalber', 'password7'),
(88564,'Sally J. Schilling', '1894 Wines Lane, Hoaston, TX 77003','03/07/1954','832-366-0035', 'sjechilling', 'password8'),
(57054,'Jhon M. Byler', '279 Raver Drive, La Follette, TN 37768','11/27/1954','423-592-8630', 'jmbyler', 'password9'),
(49312,'Kevin Spruell', '1124 Broadcast Drive, Beltsville, VA 20705','03/04/1984','703-953-1216', 'kspruell', 'password10')


insert into Location values
('Texas Branch','4832 Deercove Drive, Dalles, TX 75208','214-948-7102'),
('Illinois Branch','2888 Oak Avenue, Des Plaines, IL 60016','847-953-8130'),
('Louisiana Branch','2063 Washburn Street, Baton Rouge, LA 70802','255-346-0068')


insert into Card values
(5767052,0.0,60201),
(5532681,0.0,60201),
(2197620,10.0,89682),
(9780749,0.0,64937),
(1521412,0.0,31430),
(3920486,0.0,79916),
(2323953,0.0,93265),
(4387969,0.0,58359),
(4444172,0.0,88564),
(2645634,0.0,57054),
(3688632,0.0,49312)


insert into Status values
(1,'Available'),
(2,'In Transit'),
(3,'Checked Out'),
(4,'On Hold')


insert into Media values
(8733,1),
(9982,1),
(3725,1),
(2150,1),
(4188,1),
(5271,1),
(2220,1),
(7757,1),
(4589,1),
(5748,1),
(1734,1),
(5725,1),
(1716,4),
(8388,1),
(8714,1)



insert into Book values
('978-0743289412','Lisey''s Story','Stephen King',2006,813,10.0),
('978-1596912366','Restless: A Novel', 'William Boya',2006,813,10.0),
('978-0312351588','Beachglass', 'Wendy Blachburn',2006,813,10.0),
('978-0385340229','Sisters', 'Danielle Steel',2006,813,10.0)
insert into Book values
('978-0060583002','The Last Season','Eric Blehm',2006,902,10)


insert into BookMedia values
(8733,'978-0743289412'),
(9982,'978-1596912366'),
(3725,'978-1596912366'),
(2150,'978-0312351588'),
(4188,'978-0156031561'),
(5271,'978-0060583002'),
(2220,'978-0316740401'),
(7757,'978-0316013949'),
(4589,'978-0374105235'),
(5748,'978-0385340229')


insert into checkout values
(2220,9780749,'02/15.2007','03/15/2007')


insert into Video values
('Terminator 2: Judgement Day',1991,'James Cameron',8.3,20.0),
('Raiders of the Lost Ark',1981,'Steven Spielberg',8.7,20.0),
('Aliens',1986,'James Cameron',8.3,20.0),
('Die Hard',1988,'Jhon McTiernan',8.0,20.0)


insert into VideoMedia values
(1734,'Terminator 2: Judgement Day',191),
(5725,'Raiders of the Lost Ark',1981),
(1716,'Aliens',1986),
(8388,'Aliens',1986),
(8714,'Die Hard',1988)


insert into Hold values
(1716,4444172,'Texas Branch','02/20/2008',1)


insert into Librarian values
(2591051,88564,30000.00,'Texas Branch'),
(6190164,64937,30000.00,'Illinois Branch'),
(1810386,58359,30000.00,'Louisiana Branch')


insert into Stored_In values
(8733,'Texas Branch'),
(9982,'Texas Branch'),
(1716,'Texas Branch'),
(1734,'Texas Branch'),
(4589,'Texas Branch'),
(4188,'Illinois Branch'),
(5271,'Illinois Branch'),
(3725,'Illinois Branch'),
(8388,'Illinois Branch'),
(5748,'Illinois Branch'),
(2150,'Louisiana Branch'),
(8714,'Louisiana Branch'),
(7757,'Louisiana Branch'),
(5725,'Louisiana Branch')



--01
select *
from Book
Where ISBN = '978-0312351588'


-- How to Write query for index
-- for Book

-- clustered index
create clustered index idx_ISBN on Book(ISBN)

drop index idx_ISBN on Book

-- non clustered index
create nonclustered index idx_title on Book(title)
create nonclustered index idx_author on Book(author,title)

drop index idx_title on Book

select price
from Book
where author='Eric Blehm' and title='The Last Season'

-------------------------------------------------------------------------------

select *
from sys.indexes
where object_id = (select object_id from sys.objects where name='Book')

--------------------------------------------------------------------------------


select price
from Book
where year=2006


-----------------------------------------------------------------------------------

create clustered index myIndex01 on Book(
ISBN asc,
title desc
)

----------------------------------------------------------------------------


create table Booking
(
ID int identity(1,1),
FlightCode varchar(20),
Price float(53),
DateTransaction datetime
)


create proc insertToBokking
as
set nocount on -- this means not count -> 3 rows effected like that
begin
	declare @fc varchar(20) = 'EK232'
	declare @price int = 50
	declare @count int = 0

	while @count < 200000
		begin
			set @fc = @fc+cast(@count as varchar(20))
			set @price = @price+@count

			insert into Booking values(@fc,@price,getdate())

			set @price = 50
			set @fc = 'EK232'
			set @count += 1

		end
end

exec insertToBokking



--01

set statistics io on

select *
from Booking
where ID = 179023


create clustered index CL_ID on Booking(ID)

drop index CL_ID on Booking



--02

select *
from Booking
where FlightCode like 'EK232908%'
order by Price

create nonclustered index NCL_FC on Booking(FlightCode)