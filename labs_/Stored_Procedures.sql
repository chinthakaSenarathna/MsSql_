select * from client
select * from product
select * from Sales_Order
select * from Sales_Order_Details
select * from Items_to_Order



--01
select *
from product
where productNo = 'P003'

Go -- this means, above and below are separeted parts...
   -- it means firstly execute above part and get result
   -- then execute below part and get result


-- alter -> ealier created proc Now -> modify

alter proc myProc01(@prdNo varchar(6))
as
begin
select *
from product
where productNo = @prdNo
end

execute myProc01 'P002'

drop proc myProc01




--02
select re_order_level
from product
where productNo = 'P001'

alter proc myProc02(@prdNo varchar(6))
as
begin
declare @reOrderLevel int
select @reOrderLevel = re_order_level
from product
where productNo = @prdNo
return @reOrderLevel
end

declare @ans int
execute @ans=myProc02 'P002'
print @ans




--03
select description1, qty_available
from product
where productNo = 'P002'

create proc myProc03
@pNo varchar(6),
@desc varchar(50) out,
@qty int out
as
begin
select @desc=description1, @qty=qty_available
from product
where productNo = @pNo
end

declare @desc varchar(50)
declare @qty int
execute myProc03 'P002', @desc out, @qty out

--print(@desc)
--print(@qty)
print(@desc + ' has ' + cast(@qty as varchar(5)) +' quantities.')




--04
select * from product

update product set selling_price = $1200 where productNo = 'P001'

alter proc myProc04
@pNo varchar(6),
@sellPrice money
as
begin
	declare @itemCost money
	select @itemCost=item_cost
	from product
	where productNo = @pNo
	if(@itemCost < @sellPrice)
		begin
		update product set selling_price = @sellPrice where productNo = @pNo
		end
	else
		begin
		print('can not allowed')
		end
end

execute myProc04 'P001',$130



--05
select * from Sales_Order

create proc myProc05
@Sales_Order_No int,
@Sales_Order_Date date,
@Order_Taken_By varchar(20),
@ClientNo varchar(6),
@Delivery_Address varchar(255)
as
begin
	insert into Sales_Order values
	(@Sales_Order_No,@Sales_Order_Date,@Order_Taken_By,@ClientNo,@Delivery_Address)
end

execute myProc05 '12','2010-08-20','parami','C001','xyz'



--06
create proc myProc06
@Sales_Order_No int,
@Sales_Order_Date date,
@Order_Taken_By varchar(20),
@ClientNo varchar(6),
@Delivery_Address varchar(255),
@ProductNo varchar(6),
@Quantity int
as
begin
	insert into Sales_Order values
	(@Sales_Order_No,@Sales_Order_Date,@Order_Taken_By,@ClientNo,@Delivery_Address)

	insert into Sales_Order_Details values
	(@Sales_Order_No,@ProductNo,@Quantity)
end

execute myProc06 '13','2010-08-30','chinthaka','C003','abc','P002',10

select * from Sales_Order
select * from Sales_Order_Details



--07
alter proc myProc07
@ClientNo varchar(6),
@Name varchar(20),
@City varchar(20),
@Date_Joined date,
@Balance_Due money,
@Sales_Order_No int,
@Sales_Order_Date date,
@Order_Taken_By varchar(20),
@Delivery_Address varchar(255),
@ProductNo varchar(6),
@Quantity int
as
begin
	declare @clientNo_ varchar(6)
	select @ClientNo_=clientNo
	from client
	
	if(@ClientNo != @clientNo_)
	begin
	insert into client values
		(@ClientNo,@Name,@City,@Date_Joined,@Balance_Due)
	end
	else
	begin
		print('client already exit')
	end

	insert into Sales_Order values
	(@Sales_Order_No,@Sales_Order_Date,@Order_Taken_By,@ClientNo,@Delivery_Address)

	insert into Sales_Order_Details values
	(@Sales_Order_No,@ProductNo,@Quantity)
end

execute myProc07 'C010','nilanthi','Kandy','2017-10-02',$30000,'15','2010-09-30','lahiru','abc','P002',120

select * from client


create proc myProc08
@ClientNo varchar(6),
@Name varchar(20),
@City varchar(20),
@Date_Joined date,
@Balance_Due money,
@Sales_Order_No int,
@Sales_Order_Date date,
@Order_Taken_By varchar(20),
@Delivery_Address varchar(255),
@ProductNo varchar(6),
@Quantity int
as
begin
	if exists (select * from client where clientNo = @ClientNo)
	begin
		insert into Sales_Order values(@Sales_Order_No,@Sales_Order_Date,@Order_Taken_By,@ClientNo,@Delivery_Address)
		insert into Sales_Order_Details values (@Sales_Order_No,@ProductNo,@Quantity)
	end
	else
	begin
		insert into client values (@ClientNo,@Name,@City,@Date_Joined,@Balance_Due)
		insert into Sales_Order values (@Sales_Order_No,@Sales_Order_Date,@Order_Taken_By,@ClientNo,@Delivery_Address)
		insert into Sales_Order_Details values (@Sales_Order_No,@ProductNo,@Quantity)
	end
end

execute myProc08 'C010','nilanthi','Kandy','2017-10-02',$30000,'16','2010-09-30','lahiru','abc','P002',120