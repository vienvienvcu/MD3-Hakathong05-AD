create database QUANLYBANHANG;
use  QUANLYBANHANG;
-- 1. Bảng CUSTOMERS
create table customer (
  customer_id  varchar(4) primary key not null,
  name varchar(100) not null,
  email varchar(100) not null,
  phone varchar(25) not null,
  address varchar(255) not null
);
-- 2. Bảng ORDERS 
create table orders(
   order_id varchar(4) primary key not null,
   customer_id varchar(4) not null,
   order_date date not null,
   total_amount double not null,
   constraint FK_customer foreign key (customer_id)references customer(customer_id)
); 
-- 3. Bảng PRODUCTS 
create table product(
   product_id varchar(4) primary key not null,
   name varchar(255) not null,
   description text ,
   price double not null,
   status bit default 1
);
-- 4. Bảng ORDERS_DETAILS 
create table order_detail(
   order_id varchar(4) not null,
   product_id varchar(4) not null,
   quantity int(11) not null,
   price double not null,
   primary key(order_id,product_id),
   constraint FK_order foreign key(order_id) references orders(order_id),
   constraint FK_product foreign key( product_id) references product(product_id)
);
-- Bài 2: Thêm dữ liệu [20 điểm]:
-- Bảng CUSTOMERS [5 điểm] :
select * from customer;
insert into customer(customer_id,name,email,phone,address) values
('C001','Nguyễn Trung Mạnh','manhnt@gmail.com','984756322','Cầu Giấy, Hà Nội'),
('C002','Hồ Hải Nam','namhh@gmail.com','984875926','Ba Vì, Hà Nội'),
('C003','Tố Ngọc Vũ','vunt@gmail.com','904725784','Mộc Châu, Sơn La'),
('C004','Phạm Ngọc Anh','anhpn@gmail.com','984635365','Vinh, Nghệ An'),
('C005','Trương Minh Cường','cuongtm@gmail.com','989735624','Hai Bà Trưng, Hà Nội');

-- Bảng PRODUCTS
select * from product;
insert into product(product_id,name,description,price)values
('P001','Iphone 13 ProMax','Bản 512 BG,xanh lá',22999999),
('P002','Dell Vostrol V3510','Corei5 ,Ram 8GB',14999999),
('P003','Macbook Pro M2','8CPU 10CPU 8GB 256GB',28999999),
('P004','Apple Watch Ultra  ','Titanium Alpine Loop Small',18999999),
('P005','Airpods 2 2022','Spatial Audio',4090000);

-- bảng ORDERS 
select * from orders;
insert into orders(order_id,customer_id,order_date,total_amount) values
('H001','C001','2023-02-22',52999997),
('H002','C001','2023-03-11',80999997),
('H003','C002','2023-01-22',54359998),
('H004','C003','2023-03-14',102999995),
('H005','C003','2023-03-12',80999997),
('H006','C004','2023-02-01',110449994),
('H007','C004','2023-03-29',79999996),
('H008','C005','2023-02-14',29999998),
('H009','C005','2023-01-10',28999999),
('H010','C005','2023-04-01',149999994);
--  bảng Orders_details
select * from order_detail;
insert into order_detail(order_id,product_id,quantity,price)values
('H001','P002',1,14999999),
('H001','P004',2,18999999),
('H002','P001',1,22999999),
('H002','P003',2,28999999),
('H003','P004',2,18999999),
('H003','P005',4,4090000),
('H004','P002',3,14999999),
('H004','P003',2,28999999),
('H005','P001',1,2299999),
('H005','P003',2,28999999),
('H006','P005',5,4090000),
('H006','P002',6,14999999),
('H007','P004',3,18999999),
('H007','P001',1,22999999),
('H008','P002',2,14999999),
('H009','P003',1,28999999),
('H010','P003',2,28999999),
('H010','P001',4,22999999);

-- Bài 3: Truy vấn dữ liệu [30 điểm]:
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .[4 điểm]
select name AS Tên,
email AS Email,
phone AS Số_điện_thoại,
address AS Địa_chỉ
from customer;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng). [4 điểm]
select c.name AS Tên, 
c.phone AS Số_điện_thoại, 
c.address AS Địa_chỉ_khách_hàng, 
o.order_date
from customer c
join orders o on o.customer_id = c.customer_id
where month(o.order_date) = 03 and year(o.order_date) = 2023;

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ). [4 điểm]
select month(order_date) as Tháng , sum(total_amount) as tổng_doanh_thu from orders
where year(order_date) = 2023
group by month(order_date);

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
select c.name,
 c.address as Địa_chỉ,
 c.email AS Email,
 c.phone AS Số_điên_thoại,
 o.order_date 
 from customer c
left join orders o on o.customer_id = c.customer_id and 
year(order_date) = '2023' and month(order_date) = '02'
where  o.order_id is null;

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
 select p.product_id AS Mã_sản_phẩm,
 p.name AS Tên_sản_phẩm  , 
 sum(od.quantity) as so_luong_ban_ra 
 from product p
 join order_detail od on od.product_id = p.product_id
 join orders o on o.order_id = od.order_id
 where year(order_date) = '2023' and month(order_date) = '03'
 group by p.product_id, p.name;
 
 -- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chitiêu 
 -- (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
 select c.customer_id AS Mã_khách_hàng,
 c.name AS Tên_khách_hàng,
 sum(o.total_amount) as Tổng_mức_chi_tiêu 
 from  customer c
 join  orders o on o.customer_id = c.customer_id
 where year(order_date) = '2023'
 group by c.customer_id, c.name
 order by Tổng_mức_chi_tiêu desc;

-- 7, Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên 
-- (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
select c.name AS tên_người_mua  ,
o.total_amount as Tổng_tiền ,
o.order_date as Ngày_tạo_hoá_đơn,
sum(od.quantity) as Tổng_số_lượng_sản_phẩm 
FROM customer c
join orders o on o.customer_id = c.customer_id
join order_detail od on od.order_id = o.order_id
group by  c.name , o.order_id
having sum(od.quantity)>=5;

-- Bài 4: Tạo View, Procedure [30 điểm]:
-- . Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn . [3 điểm]

create  view showOrders as
select c.name as Tên_khách_hàng,
       c.phone as Số_điện_thoại,
       c.address as Địa_chỉ,
       o.total_amount as Tổng_tiền,
       o.order_date as Ngày_tạo_hoá_đơn
from customer c
join orders o on o.customer_id = c.customer_id;

-- Xem dữ liệu từ VIEW 'showOrders'
select * from showOrders;
-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. [3 điểm]
 create view showCustomer as
 select c.name as Tên_khách_hàng ,
 c.phone as Số_điện_thoại,
 c.address as Địa_chỉ,
 count(o.order_id) as Tổng_số_đơn_đã_đặt
 from customer c
 left join orders o on o.customer_id = c.customer_id
 group by c.name,c.phone,c.address;

select * from showCustomer;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.

create view showProducts as
select 
  p.name as Tên_sản_phẩm,
  P.description AS Mô_tả,
  p.price AS Giá,
  sum(od.quantity) AS Tổng_số_lượng_đã_bán_ra
  from product p
  join order_detail od on od.product_id = p.product_id
  group by p.name, P.description,p.price ;
  
  select * from showProducts;
  
  -- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]
  -- Tạo chỉ mục cho trường phone trong bảng customer
create index idx_phone on customer(phone);
-- Tạo chỉ mục cho trường email trong bảng customer
create index idx_email on customer(email);

-- Hiển thị các chỉ mục của bảng customer
show index from customer;

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
delimiter //
create procedure getCustomer(
  in in_customer_id varchar(4)
)
begin
  -- Lấy tất cả thông tin của khách hàng dựa trên mã số khách hàng
  select * from customer
  where customer_id = in_customer_id;
end//
delimiter ;

call  getCustomer('C001');

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
delimiter //
create procedure getAllProduct()
begin
-- lấy thông tin của tất cả sản phẩm
  select * from product;
end//
delimiter ;
-- Gọi PROCEDURE để lấy thông tin của tất cả sản phẩm
call getAllProduct();

-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]

delimiter //
create procedure getListOrders(
  in in_customer_id varchar(4)
)
begin
-- hiển thị danh sách hoá đơn dựa trên mã người dùng
  select * from orders
  where customer_id = in_customer_id;
end//
delimiter ;
-- Gọi PROCEDURE để hiển thị danh sách hóa đơn của khách hàng với mã số 'C001'
call getListOrders('C001');

-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, 
-- tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]

DELIMITER //

CREATE PROCEDURE addNewOrders(
  IN in_customer_id VARCHAR(4),
  IN in_order_date DATE,
  IN in_total_amount DOUBLE
)
BEGIN
    DECLARE new_order_id VARCHAR(4);
    DECLARE max_id INT;

    -- Lấy ID lớn nhất hiện tại và tăng lên 1
    SELECT IFNULL(MAX(CAST(SUBSTRING(order_id, 2) AS UNSIGNED)), 0) + 1 INTO max_id FROM orders;

    -- Tạo order_id mới
    SET new_order_id = CONCAT('H', LPAD(max_id, 3, '0'));

    -- Thêm đơn hàng mới với ID tự động tăng
    INSERT INTO orders(order_id, customer_id, order_date, total_amount) VALUES
    (new_order_id, in_customer_id, in_order_date, in_total_amount);

    -- Hiển thị mã hóa đơn vừa tạo
    SELECT new_order_id AS OrderID;
END //

DELIMITER ;


-- Gọi procedure để thêm mới đơn hàng
call addNewOrders('C002', '2023-07-15', 12345678);

select * from orders;
-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
 -- Đổi delimiter để phân biệt phần kết thúc của PROCEDURE
delimiter //

-- Tạo PROCEDURE để thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể
create procedure getSalesByDateRange(
  in start_date date,
  in end_date date
)
begin
    -- Thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian
    select p.product_id, p.name, sum(od.quantity) as total_quantity_sold
    from product p
    join order_detail od on p.product_id = od.product_id
    join orders o on od.order_id = o.order_id
    where o.order_date between start_date and end_date
    group by p.product_id, p.name
    order by total_quantity_sold desc;
end //


delimiter ;

-- Gọi PROCEDURE để thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian từ '2023-01-01' đến '2023-06-30'
call getSalesByDateRange('2023-01-01', '2023-06-30');


-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]

delimiter //

-- Tạo PROCEDURE để thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó
create procedure getSalesByMonth(
  in month_num int,
  in year_num int
)
begin
    -- Thống kê số lượng bán ra của mỗi sản phẩm theo tháng và năm cụ thể
    select p.product_id, p.name, sum(od.quantity) as total_quantity_sold
    from product p
    join order_detail od on p.product_id = od.product_id
    join orders o on od.order_id = o.order_id
    where month(o.order_date) = month_num and year(o.order_date) = year_num
    group by p.product_id, p.name
    order by total_quantity_sold desc;
end //


delimiter ;

-- Gọi PROCEDURE để thống kê số lượng của mỗi sản phẩm được bán ra theo tháng 3 năm 2023
call getSalesByMonth(3, 2023);






 
 
 
 
 





