select * from product
select * from client
select * from Sales_Order
select * from Sales_Order_Details
select * from Items_to_Order


--01
alter trigger myTrigger01
on product
after update
as
begin
	declare @qty_available int
	declare @re_order_level int
	declare @productNo varchar(6)
	select @qty_available=qty_available, @re_order_level=re_order_level, @productNo=productNo from inserted

	if(@qty_available < @re_order_level)
	begin
		declare @maxNoticeNo int
		select @maxNoticeNo=max(NoticeNo) from Items_to_Order
		set @maxNoticeNo = @maxNoticeNo + 1
		insert into Items_to_Order values (@maxNoticeNo,@productNo,getdate())
	end
end

drop trigger myTrigger01

select * from product
select * from Items_to_Order

update product set qty_available=20 where productNo = 'P001'




--02
alter trigger myTrigger02
on Sales_Order_Details
after insert
as
begin
	declare @ProductNo varchar(6)
	declare @Quantity int
	select @ProductNo=ProductNo, @Quantity=Quantity from inserted

	update product set qty_available=qty_available - @Quantity where productNo = @ProductNo

end

insert into Sales_Order_Details values (18,'P002',12)

insert into Sales_Order values (17,'2010-10-20','sadakalum','C004','xyz')
insert into Sales_Order values (18,'2010-11-20','sadakama','C002','xyz')