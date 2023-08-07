-- Câu 1:  
-- A. Bạn hãy xây dựng đoạn truy vấn đếm tổng số đơn hàng được order
SELECT COUNT(Invoice_ID) AS  Total_Order
FROM supermarket_sales

-- B. Bạn hãy xây dựng đoạn truy vấn tính tổng doanh số theo từng Branch. Kết quả làm tròn đến 2 chữ số thập phân
SELECT Branch , ROUND(SUM(cogs),2) AS  SUM_SALES
FROM supermarket_sales
GROUP BY Branch

-- Câu 2: 
-- A. Bạn hãy xây dựng đoạn truy vấn tính tổng doanh số và lượt order của từng ProductLine
SELECT Product_line , ROUND(SUM(cogs),2) AS  SUM_SALES , COUNT(Invoice_ID) AS  Total_Order
FROM supermarket_sales
GROUP BY Product_line

-- B. Bạn hãy xây dựng đoạn truy vấn tính tổng doanh số, tổng số lượt order của từng loại khách hàng theo từng Productline. (tổng doanh số làm tròn đến 2 chữ số thập phân) 
SELECT Product_line, Customer_type , ROUND(SUM(cogs),2) AS  SUM_SALES , COUNT(Invoice_ID) AS  Total_Order
FROM supermarket_sales
GROUP BY Product_line,Customer_type
ORDER BY Product_line

-- Câu 3: 
-- A. Bạn hãy xây dựng đoạn truy vấn tìm ra những khung giờ có tổng số  lượt 
--order cao hơn số lượt order trung bình theo tất cả khung giờ của tháng có doanh số lớn nhất

SELECT DATEPART(HOUR,[Time]) AS gio , COUNT(Invoice_ID) AS Total_Order , thang=month(date) into #a
FROM supermarket_sales
GROUP BY DATEPART(HOUR,[Time]),month(date)

-----------------------------------------------------

select avg_order=sum(b.avg_order) , totalgio=count(b.gio) , thang into #b  
from
      (select avg_order=COUNT(Invoice_ID) , DATEPART(HOUR,[Time]) as gio , thang=month(date) 
      from supermarket_sales 
      group by month(date) , DATEPART(HOUR,[Time])) b
group by b.thang

-----------------------------------------------------

select a.gio,a.Total_Order 
from #a a 
join #b b on b.thang=a.thang
where a.Total_Order > (b.avg_order/b.totalgio) and a.thang='1' 
order by a.gio

drop table #a
drop table #b

--select (37+36+30+40+29+33+25+27+28+35+32)/11


-- B. Bạn hãy xây dựng đoạn truy vấn, tìm ra sản phẩm có Customer type có tổng số lượt mua ít nhưng lại có doanh số cao hơn loại khách hàng còn lại.
SELECT TOP 1 Product_line, Customer_type , ROUND(SUM(cogs),2) AS  SUM_SALES , COUNT(Invoice_ID) AS  Total_Order
FROM supermarket_sales
GROUP BY Product_line,Customer_type
ORDER BY Total_Order

-- Câu 4: Bạn hãy xây dựng đoạn truy vấn tìm ra tổng doanh số, tổng số đơn hàng theo tháng, tổng doanh số và tổng số đơn hàng của các tháng về trước
SELECT
    MONTH([Date]) AS Thang,
    ROUND(SUM(cogs), 2) AS SUM_SALES,
    COUNT(Invoice_ID) AS Total_Order into #a
    FROM
    supermarket_sales 
    GROUP BY
    MONTH([Date])
    SELECT
    Thang,
    SUM_SALES,
    Total_Order,
    SUM(SUM_SALES) OVER (ORDER BY Thang ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS Cumulative_SUM_SALES,
    SUM(Total_Order) OVER (ORDER BY Thang ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS Cumulative_Total_Order
FROM #a
ORDER BY Thang;

drop table #a
  


with cte1 as(
  SELECT
    MONTH([Date]) AS Thang,
    ROUND(SUM(cogs), 2) AS SUM_SALES,
    COUNT(Invoice_ID) AS Total_Order 

    FROM supermarket_sales 
    GROUP BY MONTH([Date])
),

cte2 as(
          SELECT Thang, SUM_SALES,Total_Order,
          SUM(SUM_SALES) OVER (ORDER BY Thang ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS Cumulative_SUM_SALES,
          SUM(Total_Order) OVER (ORDER BY Thang ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS Cumulative_Total_Order
          FROM cte1
)

select b.Thang,b.SUM_SALES,b.Total_Order,Cumulative_SUM_SALES,Cumulative_Total_Order
FROM cte1 a,cte2 b
ORDER BY b.Thang;