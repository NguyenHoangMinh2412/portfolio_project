--Ex1: Từ bảng Customer, lấy ra danh sách khách hàng có Country là Germany
--Ex2: Từ bảng Supplier, lấy ra danh sách nhà cung cấp đến từ USA hoặc Japan hoặc Singapore.
--Ex3: Từ bảng Product, lấy ra những sản phẩm có giá lớn hơn 600 của Supplier_ID = 4
--Ex4: Từ bảng Order, lọc ra những đơn hàng mua trong tháng 4 năm 2013


SELECT * FROM Customer
WHERE Country LIKE 'Germany';

SELECT * FROM Supplier
WHERE Country IN('USA','Japan','Singapore') 
ORDER BY Country ASC;

SELECT * FROM Product
WHERE SupplierId = 4 ;

SELECT * FROM [dbo].[Order]
WHERE MONTH(OrderDate) = 4 AND YEAR(OrderDate)= 2013;




--Ex1: Tính tổng số Quantity trong bảng OrderItem
--Ex2: Cho biết đơn hàng nào có giá trị lớn nhất và nhỏ nhất, tổng số đơn hàng trong bảng Order
--Ex3: Hãy tính tổng số tiền, số đơn mà mỗi khách đã mua trong cửa hàng. Từ số tiền và số đơn, tính thêm 1 cột AOV (giá trị trung bình cho mỗi đơn hàng) theo từng khách, dựa vào bảng Order
--Ex4: Từ bảng OrderItem, lọc ra top 10 đơn hàng có tổng số quantity nhiều nhất. Cho biết tổng số sản phẩm được mua cho những đơn hàng này. (gợi ý: tổng số sản phẩm → count product_id)

Select SUM(Quantity) AS Quantity FROM OrderItem

Select MAX(TotalAmount) , MIN(TotalAmount) FROM [dbo].[Order]
Select * FROM [dbo].[Order]
ORDER BY TotalAmount ASC;
--3
SELECT SUM(TotalAmount) AS Sotien, COUNT(OrderNumber) AS SoDon,CustomerID , ROUND(SUM(TotalAmount)/COUNT(OrderNumber), 2) AS AVO
FROM [dbo].[Order]
GROUP BY CustomerId
ORDER BY COUNT(OrderNumber);

Select * FROM [dbo].[Order]
WHERE CustomerId = 43;

--4
SELECT * FROM [dbo].[OrderItem]
WHERE OrderId = 648
SELECT TOP 10 SUM(Quantity) ,OrderId, COUNT(ProductID)
FROM [dbo].[OrderItem]
GROUP BY OrderId
ORDER BY SUM(Quantity) DESC;


--Ex1: Hãy cho biết danh sách sản phẩm của Supplier = Tokyo Traders.
--Ex2: Hãy tính tổng lượng sales, tổng số đơn theo từng sản phẩm trong năm 2014.
--Ex3: Tính tổng lượng sales, tổng số đơn hàng, tổng số quantity và tổng số lượng khách mua theo từng supplier và từng sản phẩm
--Ex4: Tính tổng số đơn hàng, tổng số sales,tổng số khách hàng, giá trị trung bình của đơn hàng, giá trị trung bình của mỗi khách hàng, mua hàng trong 3 tháng cuối năm 2013 theo từng country và city. Gợi ý: Giá trị trung bình đơn hàng = Sales/Number of orders, Giá trị trung bình của mỗi khách hàng = Sales/Total Customers. Country và City lấy từ bảng Customers.

SELECT * FROM Product p
INNER JOIN Supplier s ON p.SupplierId = s.Id
WHERE CompanyName = 'Tokyo Traders'

--2
SELECT ProductId,OrderId FROM [dbo].[Order] , OrderItem 
WHERE OrderDate ='2014' AND ProductId='23'
GROUP BY ProductId , OrderId

SELECT * FROM OrderItem

SELECT COUNT(OrderId) AS OrderID, ProductId , SUM(UnitPrice) FROM OrderItem o1
INNER JOIN [dbo].[Order] o2 ON o1.OrderId=o2.Id
GROUP BY ProductId  ,YEAR(OrderDate) 
HAVING YEAR(OrderDate)= 2014
ORDER BY ProductId;

select count(t2.id),ProductId from [dbo].[Orderitem] t1
join [dbo].[Order] t2 on t1.orderID=t2.Id
where ProductId='46'
group by t1.ProductId,t2.OrderDate,t1.OrderId
having year(OrderDate) = '2014'


--Ex3: Tính tổng lượng sales, tổng số đơn hàng, tổng số quantity và tổng số lượng khách mua theo từng supplier và từng sản phẩm

SELECT * FROM OrderItem
SELECT * FROM [dbo].[Order]
SELECT * FROM [dbo].[Customer]
SELECT * FROM [dbo].[Product]
SELECT * FROM [dbo].[Supplier]

	SELECT COUNT(OrderId) AS TongDonHang, ProductId ,TotalAmount= SUM(Quantity * o1.UnitPrice) ,SUM(Quantity) AS Quantity, COUNT(CustomerId) AS Tongsoluongkhachang , SupplierId
	FROM OrderItem o1 
	INNER JOIN [dbo].[Order] o2  ON o1.OrderId=o2.Id
	INNER JOIN Product p1 ON o1.ProductId = p1.Id
	GROUP BY ProductId   , SupplierId 
	ORDER BY ProductId   , SupplierId ;

SELECT COUNT(CustomerId) , SupplierId , ProductId
FROM OrderItem o1
INNER JOIN [dbo].[Order] o2  ON o1.OrderId=o2.Id
INNER JOIN Product p1 ON o1.ProductId = p1.Id
GROUP BY ProductId , SupplierId 


select count(o.CustomerId),ProductId,SupplierId from dbo.[Order] o	
join OrderItem a on o.Id =a.OrderId
join Product p on p.id = a.ProductId
group by ProductId,SupplierId

--Ex4: Tính tổng số đơn hàng, tổng số sales,tổng số khách hàng, giá trị trung bình của đơn hàng, giá trị trung bình của mỗi khách hàng, 
--mua hàng trong 3 tháng cuối năm 2013 theo từng --country và city 
--Gợi ý: Giá trị trung bình đơn hàng = Sales/Number of orders, Giá trị trung bình của mỗi khách hàng = Sales/Total Customers. 
--Country và City lấy từ bảng Customers.

SELECT * FROM OrderItem
SELECT * FROM [dbo].[Order]
where CustomerId = '69'
SELECT * FROM [dbo].[Customer]
SELECT * FROM [dbo].[Product]
SELECT * FROM [dbo].[Supplier]


	SELECT distinct COUNT(o2.id) AS TongDonHang ,TotalAmount= SUM(Quantity * o1.UnitPrice),COUNT(CustomerId) AS Tongsoluongkhachang,SUM(Quantity * o1.UnitPrice)/COUNT(OrderId),SUM(Quantity * o1.UnitPrice)/COUNT(CustomerId),c1.City,c1.Country,YEAR(OrderDate) , MONTH(OrderDate)
	FROM OrderItem o1 
	INNER JOIN [dbo].[Order] o2  ON o1.OrderId=o2.Id
	INNER JOIN Product p1 ON o1.ProductId = p1.Id
	INNER JOIN Customer c1 ON o2.CustomerId=c1.Id
	WHERE YEAR(OrderDate)=2013 and MONTH(OrderDate) IN(10,11,12)
	group by YEAR(OrderDate) , MONTH(OrderDate),c1.City,c1.Country,CustomerId

	select count(o.id),count(CustomerId) ,city,country,sum(TotalAmount), sum(TotalAmount)/count(o.id ),sum(TotalAmount)/count(CustomerId) from dbo.[Order] o
	INNER JOIN Customer c1 ON o.CustomerId=c1.Id
	WHERE YEAR(OrderDate)=2013 and MONTH(OrderDate) IN(10,11,12) 
	group by YEAR(OrderDate) , MONTH(OrderDate),city,country
	


--Ex1: Từ bảng product, lọc ra những sản phẩm có giá thấp hơn giá trung bình. Gợi ý, dựa vào cột UnitPrice
--Ex2: Từ bảng order_item, hãy tính tổng số quantity, tổng số đơn hàng và tổng số sales theo từng product_id. Sau khi tính, hãy bổ sung thêm thông tin của product_id về tên sản phẩm, nhà cung cấp (dùng subquery và join sau khi group by)
--Ex3: Hãy lọc ra đơn hàng có giá trị lớn thứ 2 trong bảng order
--Ex4: Hãy tính số lượng đơn hàng trung bình hằng ngày bán ra trong từng tháng. Vd, trong tháng 8 - 2013, trung bình mỗi ngày có 5 đơn hàng. 2013

SELECT * FROM OrderItem
SELECT * FROM [dbo].[Order]
SELECT * FROM [dbo].[Customer]
SELECT * FROM [dbo].[Product]
SELECT * FROM [dbo].[Supplier]

--EX1

SELECT ProductName , UnitPrice
FROM Product
WHERE UnitPrice < (Select AVG(UnitPrice) FROM Product);

--EX2 Từ bảng order_item, hãy tính tổng số quantity, tổng số đơn hàng và tổng số sales theo từng product_id.
--	  Sau khi tính, hãy bổ sung thêm thông tin của product_id về tên sản phẩm, nhà cung cấp (dùng subquery và join sau khi group by)

Select SUM(Quantity),SUM(OrderId),SUM(o1.UnitPrice),ProductName , SupplierId
From OrderItem o1 
inner join (select ProductId,ProductName , SupplierId from OrderItem o1 
				 inner join Product p1 On o1.ProductId=p1.Id 
				 group by ProductId,ProductName , SupplierId) p1 On o1.ProductId=p1.ProductId
group by ProductName , SupplierId


--EX3 Hãy lọc ra đơn hàng có giá trị lớn thứ 2 trong bảng order

SELECT * from [dbo].[Order] Order by TotalAmount

SELECT MAX(TotalAmount) AS 'Lon thu 2'
FROM [dbo].[Order]
WHERE TotalAmount < (  SELECT MAX(TotalAmount)
                       FROM [dbo].[Order])


--Ex4: Hãy tính số lượng đơn hàng trung bình hằng ngày bán ra trong từng tháng. 
--     Vd, trong tháng 8 - 2013, trung bình mỗi ngày có 5 đơn hàng. 2013

SELECT * FROM [Order]
SELECT * FROM OrderItem

SELECT MONTH(OrderDate) AS Thang,YEAR(OrderDate) AS Nam, AVG(soLuongDonHang) AS SoLuongDonHangTrungBinh
FROM (SELECT OrderDate, COUNT(*) AS soLuongDonHang
      FROM [Order]
      GROUP BY OrderDate, MONTH(OrderDate),YEAR(OrderDate)) AS T
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
ORDER BY MONTH(OrderDate);



--Ex1: Từ bảng Customer, lấy ra danh sách khách hàng có Country là Germany
--Ex2: Từ bảng Supplier, lấy ra danh sách nhà cung cấp đến từ USA hoặc Japan hoặc Singapore.
--Ex3: Từ bảng Product, lấy ra những sản phẩm có giá lớn hơn 600 của Supplier_ID = 4
--Ex4: Từ bảng Order, lọc ra những đơn hàng mua trong tháng 4 năm 2013


SELECT * FROM Customer
WHERE Country LIKE 'Germany';

SELECT * FROM Supplier
WHERE Country IN('USA','Japan','Singapore') 
ORDER BY Country ASC;

SELECT * FROM Product
WHERE SupplierId = 4 ;

SELECT * FROM [dbo].[Order]
WHERE MONTH(OrderDate) = 4 AND YEAR(OrderDate)= 2013;


---------------------x----------------------------------x---------------------------------------x------------------------------------------------

--Ex1: Tính tổng số Quantity trong bảng OrderItem
--Ex2: Cho biết đơn hàng nào có giá trị lớn nhất và nhỏ nhất, tổng số đơn hàng trong bảng Order
--Ex3: Hãy tính tổng số tiền, số đơn mà mỗi khách đã mua trong cửa hàng. Từ số tiền và số đơn, tính thêm 1 cột AOV (giá trị trung bình cho mỗi đơn hàng) theo từng khách, dựa vào bảng Order
--Ex4: Từ bảng OrderItem, lọc ra top 10 đơn hàng có tổng số quantity nhiều nhất. Cho biết tổng số sản phẩm được mua cho những đơn hàng này. (gợi ý: tổng số sản phẩm → count product_id)

Select SUM(Quantity) AS Quantity FROM OrderItem

Select MAX(TotalAmount) , MIN(TotalAmount) FROM [dbo].[Order]
Select * FROM [dbo].[Order]
ORDER BY TotalAmount ASC;
--3
SELECT SUM(TotalAmount) AS Sotien, COUNT(OrderNumber) AS SoDon,CustomerID , ROUND(SUM(TotalAmount)/COUNT(OrderNumber), 2) AS AVO
FROM [dbo].[Order]
GROUP BY CustomerId
ORDER BY COUNT(OrderNumber);

Select * FROM [dbo].[Order]
WHERE CustomerId = 43;

--4
SELECT * FROM [dbo].[OrderItem]
WHERE OrderId = 648
SELECT TOP 10 SUM(Quantity) ,OrderId, COUNT(ProductID)
FROM [dbo].[OrderItem]
GROUP BY OrderId
ORDER BY SUM(Quantity) DESC;


--Ex1: Hãy cho biết danh sách sản phẩm của Supplier = Tokyo Traders.
--Ex2: Hãy tính tổng lượng sales, tổng số đơn theo từng sản phẩm trong năm 2014.
--Ex3: Tính tổng lượng sales, tổng số đơn hàng, tổng số quantity và tổng số lượng khách mua theo từng supplier và từng sản phẩm
--Ex4: Tính tổng số đơn hàng, tổng số sales,tổng số khách hàng, giá trị trung bình của đơn hàng, giá trị trung bình của mỗi khách hàng, mua hàng trong 3 tháng cuối năm 2013 theo từng country và city. Gợi ý: Giá trị trung bình đơn hàng = Sales/Number of orders, Giá trị trung bình của mỗi khách hàng = Sales/Total Customers. Country và City lấy từ bảng Customers.

SELECT * FROM Product p
INNER JOIN Supplier s ON p.SupplierId = s.Id
WHERE CompanyName = 'Tokyo Traders'

--2
SELECT ProductId,OrderId FROM [dbo].[Order] , OrderItem 
WHERE OrderDate ='2014' AND ProductId='23'
GROUP BY ProductId , OrderId

SELECT * FROM OrderItem

SELECT COUNT(OrderId) AS OrderID, ProductId , SUM(UnitPrice) FROM OrderItem o1
INNER JOIN [dbo].[Order] o2 ON o1.OrderId=o2.Id
GROUP BY ProductId  ,YEAR(OrderDate) 
HAVING YEAR(OrderDate)= 2014
ORDER BY ProductId;

select count(t2.id),ProductId from [dbo].[Orderitem] t1
join [dbo].[Order] t2 on t1.orderID=t2.Id
where ProductId='46'
group by t1.ProductId,t2.OrderDate,t1.OrderId
having year(OrderDate) = '2014'


--Ex3: Tính tổng lượng sales, tổng số đơn hàng, tổng số quantity và tổng số lượng khách mua theo từng supplier và từng sản phẩm

SELECT * FROM OrderItem
SELECT * FROM [dbo].[Order]
SELECT * FROM [dbo].[Customer]
SELECT * FROM [dbo].[Product]
SELECT * FROM [dbo].[Supplier]

	SELECT COUNT(OrderId) AS TongDonHang, ProductId ,TotalAmount= SUM(Quantity * o1.UnitPrice) ,SUM(Quantity) AS Quantity, COUNT(CustomerId) AS Tongsoluongkhachang , SupplierId
	FROM OrderItem o1 
	INNER JOIN [dbo].[Order] o2  ON o1.OrderId=o2.Id
	INNER JOIN Product p1 ON o1.ProductId = p1.Id
	GROUP BY ProductId   , SupplierId 
	ORDER BY ProductId   , SupplierId ;

SELECT COUNT(CustomerId) , SupplierId , ProductId
FROM OrderItem o1
INNER JOIN [dbo].[Order] o2  ON o1.OrderId=o2.Id
INNER JOIN Product p1 ON o1.ProductId = p1.Id
GROUP BY ProductId , SupplierId 


select count(o.CustomerId),ProductId,SupplierId from dbo.[Order] o	
join OrderItem a on o.Id =a.OrderId
join Product p on p.id = a.ProductId
group by ProductId,SupplierId

--Ex4: Tính tổng số đơn hàng, tổng số sales,tổng số khách hàng, giá trị trung bình của đơn hàng, giá trị trung bình của mỗi khách hàng, 
--mua hàng trong 3 tháng cuối năm 2013 theo từng --country và city 
--Gợi ý: Giá trị trung bình đơn hàng = Sales/Number of orders, Giá trị trung bình của mỗi khách hàng = Sales/Total Customers. 
--Country và City lấy từ bảng Customers.

SELECT * FROM OrderItem
SELECT * FROM [dbo].[Order]
where CustomerId = '69'
SELECT * FROM [dbo].[Customer]
SELECT * FROM [dbo].[Product]
SELECT * FROM [dbo].[Supplier]


	SELECT distinct COUNT(o2.id) AS TongDonHang ,TotalAmount= SUM(Quantity * o1.UnitPrice),COUNT(CustomerId) AS Tongsoluongkhachang,SUM(Quantity * o1.UnitPrice)/COUNT(OrderId),SUM(Quantity * o1.UnitPrice)/COUNT(CustomerId),c1.City,c1.Country,YEAR(OrderDate) , MONTH(OrderDate)
	FROM OrderItem o1 
	INNER JOIN [dbo].[Order] o2  ON o1.OrderId=o2.Id
	INNER JOIN Product p1 ON o1.ProductId = p1.Id
	INNER JOIN Customer c1 ON o2.CustomerId=c1.Id
	WHERE YEAR(OrderDate)=2013 and MONTH(OrderDate) IN(10,11,12)
	group by YEAR(OrderDate) , MONTH(OrderDate),c1.City,c1.Country,CustomerId

	select count(o.id),count(CustomerId) ,city,country,sum(TotalAmount), sum(TotalAmount)/count(o.id ),sum(TotalAmount)/count(CustomerId) from dbo.[Order] o
	INNER JOIN Customer c1 ON o.CustomerId=c1.Id
	WHERE YEAR(OrderDate)=2013 and MONTH(OrderDate) IN(10,11,12) 
	group by YEAR(OrderDate) , MONTH(OrderDate),city,country
	


--Ex1: Từ bảng product, lọc ra những sản phẩm có giá thấp hơn giá trung bình. Gợi ý, dựa vào cột UnitPrice
--Ex2: Từ bảng order_item, hãy tính tổng số quantity, tổng số đơn hàng và tổng số sales theo từng product_id. Sau khi tính, hãy bổ sung thêm thông tin của product_id về tên sản phẩm, nhà cung cấp (dùng subquery và join sau khi group by)
--Ex3: Hãy lọc ra đơn hàng có giá trị lớn thứ 2 trong bảng order
--Ex4: Hãy tính số lượng đơn hàng trung bình hằng ngày bán ra trong từng tháng. Vd, trong tháng 8 - 2013, trung bình mỗi ngày có 5 đơn hàng. 2013

SELECT * FROM OrderItem
SELECT * FROM [dbo].[Order]
SELECT * FROM [dbo].[Customer]
SELECT * FROM [dbo].[Product]
SELECT * FROM [dbo].[Supplier]

--EX1

SELECT ProductName , UnitPrice
FROM Product
WHERE UnitPrice < (Select AVG(UnitPrice) FROM Product);

--EX2 Từ bảng order_item, hãy tính tổng số quantity, tổng số đơn hàng và tổng số sales theo từng product_id.
--	  Sau khi tính, hãy bổ sung thêm thông tin của product_id về tên sản phẩm, nhà cung cấp (dùng subquery và join sau khi group by)

Select SUM(Quantity),COUNT(OrderId),SUM(o1.UnitPrice),ProductName , SupplierId
From OrderItem o1 
inner join (select ProductId,ProductName , SupplierId from OrderItem o1 
				 inner join Product p1 On o1.ProductId=p1.Id 
				 group by ProductId,ProductName , SupplierId) p1 On o1.ProductId=p1.ProductId
group by ProductName , SupplierId


--EX3 Hãy lọc ra đơn hàng có giá trị lớn thứ 2 trong bảng order

SELECT * from [dbo].[Order] Order by TotalAmount

SELECT MAX(TotalAmount) AS 'Lon thu 2'
FROM [dbo].[Order]
WHERE TotalAmount < (  SELECT MAX(TotalAmount)
                       FROM [dbo].[Order]      )

select top 2 *

--Ex4: Hãy tính số lượng đơn hàng trung bình hằng ngày bán ra trong từng tháng. 
--     Vd, trong tháng 8 - 2013, trung bình mỗi ngày có 5 đơn hàng. 2013

SELECT day=DATEPART(DAY,OrderDate),
	   month=DATEPART(MONTH,OrderDate),
	   year=DATEPART(YEAR,OrderDate), 
	   Tong_don=COUNT(ID),
	   COUNT(ID) / DAY(OrderDate) as Don_hang_tb_moi_ngay
FROM [Order] 
GROUP BY OrderDate
ORDER BY DATEPART(YEAR,OrderDate)