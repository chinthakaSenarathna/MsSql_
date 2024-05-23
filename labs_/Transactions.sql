create database TransactionTest
use TransactionTest

create table Customer
(
id int primary key,
name char(64),
addr char(256),
dob char(10),
phone char(30),
username char(16) unique,
password char(32)
)

create table Account
(
accNo int primary key,
cId int foreign key references Customer(id),
DateOpened datetime,
Balance money check (Balance >= 0)
)

insert into Customer values
(60201,'Jason L. Gray', '2087 Timberbrook Lane, Gypsum, CO 81637','09/09/1958','970-273-9237', 'jlgray', 'password1'),
(89682,'Mary L. Prieto', '1465 Marion Drive, Tampa, FL 33602','11/20/1961','813-487-4873', 'mlprieto', 'password2'),
(64937,'Roger Hurst', '974 Bingamon Branch Rd, Bensenville, IL 60106','08/22/1973','847-221-4986', 'rhurst', 'password3'),
(31430,'Warren V. Woodson', '3022 Lords Way, Parsons, TN 38363','03/07/1945','731-845-0077', 'wvwoodson', 'password4'),
(79916,'Steven Jensen', '93 Sunny Glen Ln, Garfield Heights, OH 44125','12/14/1968','216-789-6442', 'sjensen', 'password5')


insert into Account values
(100, 31430, '12/04/2012', 10000),
(101, 79916, '06/09/2012', 25000),
(102, 64937, '12/04/2012', 14000),
(103, 60201, '12/04/2012', 36000),
(104, 89682, '12/04/2012', 28000)


select * from Customer
select * from Account



--01
Begin Transaction NewTrans

update Account set Balance = Balance * 1.1

Commit Transaction



--02
Begin Transaction

update Account set Balance = 14000 where accNo = 100
-- only to this step, update data only permenatly saved...
-- can't access another transaction this table because it's lock(isolation)

Commit Transaction		-- if you commit the transaction after the update, the can't Rollback
Rollback Transaction	-- if you Rollback, after the update, then can't Commit



--03
Begin Transaction Trans01

--insert into Account values(1005,60201,'12/04/2012',36000)

update Account set Balance=Balance-20000 where accNo=101

Commit Transaction



--04
-- This is Right One
Begin Transaction Trans02

update Account set Balance=Balance+20000 where accNo=101
update Account set Balance=Balance-20000 where accNo=100
-- Because '@@Error' variable value -> true
if @@ERROR != 0
begin
	Rollback Transaction
	Return
end

Commit Transaction 


-- This is Wrrorng....
Begin Transaction Trans02

update Account set Balance=Balance-20000 where accNo=100
update Account set Balance=Balance+20000 where accNo=101
-- Because '@@Error' variable value -> false
if @@ERROR != 0
begin
	Rollback Transaction
	Return
end

Commit Transaction 


-- How solve this one
Begin Transaction Trans02

declare @err bit = 0
update Account set Balance=Balance-20000 where accNo=100
set @err = @@ERROR
update Account set Balance=Balance+20000 where accNo=101
set @err = @err + @@ERROR
if @err != 0
begin
	Rollback Transaction
	Return
end

Commit Transaction 



Begin Transaction Trans02

update Account set Balance=Balance-20000 where accNo=100
if @@Error != 0
begin
	Rollback Transaction
	Return
end
update Account set Balance=Balance+20000 where accNo=101
if @@Error != 0
begin
	Rollback Transaction
	Return
end

Commit Transaction



Begin Transaction Trans02

update Account set Balance=Balance-20000 where accNo=100
-- goto means -> jump
if @@Error != 0 goto MyErrorHanddler

update Account set Balance=Balance+20000 where accNo=101
if @@Error != 0 goto MyErrorHanddler

Commit Transaction
Return

MyErrorHanddler:
begin
	Rollback Transaction
	Return
end




---------------------------------------------------------------
-- if accNo available or not

Begin Transaction Trans02

update Account set Balance=Balance-1000 where accNo=100
-- goto means -> jump
if @@ROWCOUNT = 0 goto MyErrorHanddler

update Account set Balance=Balance+1000 where accNo=105
-- but '@@Error' not detected accNo = 105
-- @@rowcount, this one capture the Error and RowCounts
if @@ROWCOUNT = 0 goto MyErrorHanddler

Commit Transaction
Return

MyErrorHanddler:
begin
	Rollback Transaction
	Return
end

select * from Account

Go

-- 100 -> 11000
-- 105 -> ?


-- inside the Stored Procedure

alter proc TransferMoney
@fromAcc int,
@toAcc int,
@amount money
as
begin
	Begin Transaction Trans02

	update Account set Balance=Balance-@amount where accNo=@fromAcc
	if @@ROWCOUNT = 0 goto MyErrorHanddler

	update Account set Balance=Balance+@amount where accNo=@toAcc
	if @@ROWCOUNT = 0 goto MyErrorHanddler

	Commit Transaction
	Return 0

	MyErrorHanddler:
	begin
		Rollback Transaction
		Return -1
	end
end


exec TransferMoney 100, 101, 1000