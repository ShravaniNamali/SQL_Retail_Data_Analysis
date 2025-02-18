--DATA PREPARATION
--1
Select count(*) as Count_Of_Rows from CUSTOMER
union
Select count(*) from TRANSACTIONS
union
Select count(*) from PROD_CAT_INFO

--2
Select count(Transaction_ID) as Return_Count from TRANSACTIONS
where QTY<0

--3
Select CONVERT(date,TRAN_DATE,105) as TRAN_DATE from TRANSACTIONS

--4
select Datediff(Day,Min(CONVERT(date,TRAN_DATE,105)),Max(CONVERT(date,TRAN_DATE,105))) as No_Of_Days,
Datediff(Month,Min(CONVERT(date,TRAN_DATE,105)),Max(CONVERT(date,TRAN_DATE,105))) as [Months],
Datediff(year,Min(CONVERT(date,TRAN_DATE,105)),Max(CONVERT(date,TRAN_DATE,105))) as [Years]
from TRANSACTIONS

--5
Select PROD_CAT from PROD_CAT_INFO
where PROD_SUBCAT = 'DIY'

--DATA ANALYSIS
--1
Select STORE_TYPE,count(*) as Channel from TRANSACTIONS
group by STORE_TYPE
order by Channel desc

--2
select GENDER,count(*) as [Count] from CUSTOMER
where GENDER in('M','F')
group by Gender

--3
select TOP 1 CITY_CODE,count(*) as Customer_Count from CUSTOMER
group by CITY_CODE
order by Customer_Count desc

--4
select distinct PROD_CAT,count(PROD_SUBCAT) as SUBCAT_COUNT from PROD_CAT_INFO
where PROD_CAT = 'Books'
Group by PROD_CAT

--5
select PROD_CAT,MAX(QTY) as MAX_QTY from TRANSACTIONS T
LEFT JOIN PROD_CAT_INFO P
ON T.PROD_CAT_CODE=P.PROD_CAT_CODE
group by PROD_CAT

--6
Select PROD_CAT,SUM(TOTAL_AMT) AS NET_REVENUE from Transactions T
left join PROD_CAT_INFO P
on T.PROD_CAT_CODE=P.PROD_CAT_CODE AND T.PROD_SUBCAT_CODE=P.PROD_SUB_CAT_CODE
where PROD_CAT in('Electronics','Books')
group by PROD_CAT


--7
select CUST_ID,COUNT(TRANSACTION_ID) AS TRANSACTIONS from TRANSACTIONS
where QTY>0
Group by CUST_ID
Having count(TRANSACTION_ID)>10

--8
Select SUM(TOTAL_AMT) AS Combined_REVENUE from Transactions T
left join PROD_CAT_INFO P
on T.PROD_CAT_CODE=P.PROD_CAT_CODE AND T.PROD_SUBCAT_CODE=P.PROD_SUB_CAT_CODE
where PROD_CAT in('Electronics','Clothing') AND STORE_TYPE='Flagship store'


--9
select PROD_SUBCAT,SUM(TOTAL_AMT) AS TOTAL_REVENUE from Transactions T
left join PROD_CAT_INFO P
on T.PROD_CAT_CODE=P.PROD_CAT_CODE AND T.PROD_SUBCAT_CODE=P.PROD_SUB_CAT_CODE
left join CUSTOMER C
on T.CUST_ID=C.CUSTOMER_ID
where PROD_CAT in('Electronics') AND GENDER='M'
GROUP BY PROD_SUBCAT


--10
select TOP 5 PROD_SUBCAT, (SUM(TOTAL_AMT)/(SELECT SUM(TOTAL_AMT) as [PERCENT] from Transactions T WHERE QTY>0)) AS SALES_BY_PERCENT
FROM TRANSACTIONS T
left join PROD_CAT_INFO P
on T.PROD_CAT_CODE=P.PROD_CAT_CODE AND T.PROD_SUBCAT_CODE=P.PROD_SUB_CAT_CODE
WHERE QTY>0
GROUP BY PROD_SUBCAT
ORDER BY SALES_BY_PERCENT DESC



--11
SELECT CUST_ID,CONVERT(DATE,TRAN_DATE,105) AS TRAN_DATE,SUM(TOTAL_AMT) AS NET_TOTAL_REVENUE,DOB,DATEDIFF(YEAR,MIN(CONVERT(DATE,DOB,105)),MAX(CONVERT(DATE,TRAN_DATE,105))) AS AGE
FROM CUSTOMER C
LEFT JOIN TRANSACTIONS T
ON C.CUSTOMER_ID = T.CUST_ID
WHERE QTY >0
GROUP BY CUST_ID,DOB,CONVERT(DATE,TRAN_DATE,105)
HAVING DATEDIFF(YEAR,MIN(CONVERT(DATE,DOB,105)),MAX(CONVERT(DATE,TRAN_DATE,105))) BETWEEN 25 AND 35 
ORDER BY CONVERT(DATE,TRAN_DATE,105) DESC

--12
select TOP 1 PROD_CAT, convert(Date,TRAN_DATE,105) as Month_of_TRAN_DATE,SUM(QTY) as [RETURNS] from TRANSACTIONS T
left join PROD_CAT_INFO P
on T.PROD_CAT_CODE = P.PROD_CAT_CODE 
where QTY<0
group by PROD_CAT,convert(Date,TRAN_DATE,105)
having convert(Date,TRAN_DATE,105) >= (select DATEADD(MONTH,-3,MAX(convert(Date,TRAN_DATE,105))) as M from TRANSACTIONS)
order by [RETURNS]       

--13
select TOP 1 Store_Type,SUM(Total_Amt) as SALES_AMT,SUM(QTY) as QUANTITY_SOLD from TRANSACTIONS
where QTY>0
group by STORE_TYPE
Order by QUANTITY_SOLD desc

--14
select PROD_CAT,AVG(TOTAL_AMT) as AVG_REVENUE from TRANSACTIONS T
left join PROD_CAT_INFO P
on T.PROD_CAT_CODE = P.PROD_CAT_CODE
where QTY>0
Group by PROD_CAT 
having AVG(TOTAL_AMT) > (select AVG(TOTAL_AMT) as REVENUE from TRANSACTIONS T where QTY>0)

--15
select PROD_SUBCAT_CODE,AVG(TOTAL_AMT) as Average,SUM(TOTAL_AMT) as Total_Revenue from TRANSACTIONS 
where QTY>0 AND PROD_CAT_CODE in (select Top 5 PROD_CAT_CODE from TRANSACTIONS
                              where QTY>0 
							  group by PROD_CAT_CODE
                              order by SUM(QTY) desc)
Group by PROD_SUBCAT_CODE
