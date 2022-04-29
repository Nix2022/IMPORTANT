--Exercise 1--
select *
from ssdx_tmp.countrylanguage;
select *
from ssdx_tmp.country;
select *
from ssdx_tmp.city c ;
--1--
select name,countrycode,cities
from(
select distinct(s.name), c.countrycode, count(c.countrycode) cities
from ssdx_tmp.country s, ssdx_tmp.city c
where s.code=c.countrycode
group by s.name,c.countrycode) p  
order by cities desc;

--2--
select n.governmentform,cities
from(
select distinct(s.governmentform), count(c.countrycode) cities
from ssdx_tmp.country s, ssdx_tmp.city c
where s.code=c.countrycode
group by s.governmentform ) n
order by cities desc;

--3--
select c.name,c.population
from SSDX_TMP.country c
where c.population>(
select avg( c.population)
from SSDX_TMP.country c);

--4--
select c.name
from SSDX_TMP.country c
where  c.name  like 'A%' 
or 
c.name like 'B%'
and 
length(c.name) >7 ;

--5--
select c.name,cl.language,c.gnp
from SSDX_TMP.countrylanguage cl , SSDX_TMP.country c
where cl.language like 'French' and c.gnp>10000;

--6--
insert into SSDX_TMP.countrylanguage c values('USA','Thai','F',0.3);

select *
from ssdx_tmp.countrylanguage c
where c.countrycode like 'USA';
--7--
select *
from ssdx_tmp.country c
where c.GNP<c.GNPOLD;

--8-- not completed
select s.language, c.name
from ssdx_tmp.country c , ssdx_tmp.countrylanguage s
where c.code=s.countrycode
and s.percentage >50 ;
--9--
select count(c.isofficial) Official_English
from ssdx_tmp.countrylanguage c
where c.isofficial like'F' and c.language like 'English' ;

select count(c.isofficial) Spoken_English
from ssdx_tmp.countrylanguage c
where c.isofficial like'T' and c.language like 'English' ;
--10--
select c.name ,DENSE_RANK()OVER( order by c.population ) population_rank ,DENSE_RANK()OVER( order by c.lifeexpectancy ) life_expectancy_rank , (DENSE_RANK()OVER( order by c.population ) +DENSE_RANK()OVER( order by c.lifeexpectancy )) overall_score
from SSDX_TMP.country c ;


--11--
select  FIRST_VALUE(name) over(order by population desc) second , population
from(
select c.population,c.name
from ssdx_tmp.country c
where c.population<(
select max(c.population)
from ssdx_tmp.country c)
order by c.population desc)
fetch first 1 row only;
--12--
select name,surfacearea, c.nix 
from(
select c.name,c.surfacearea,(c.population/c.surfacearea) nix , row_number() over(order by (c.population/c.surfacearea)) Rownumber
from SSDX_TMP.country c
order by nix ) c
where Rownumber<=10;

--
--select *
--from(
--select c.all, row_number() over(order by c.surfacearea desc) Rownumber
--from SSDX_TMP.country c
--order by c.surfacearea desc ) c
--where Rownumber<=3
--
--
--select c.code,c.name,c.continent,c.region,c.surfacearea,c.lifeexpectancy,c.gnp.
--from  SSDX_TMP.country c



--Exerceise 2:

select *
from SSDX_TMP.employees;
select*
from ssdx_tmp.products;
select*
from ssdx_tmp.orders;
SELECT *
FROM SSDX_TMP.OFFICES;
select *
from SSDX_TMP.orderdetails;
select *
from ssdx_tmp.productlines;
select *
from ssdx_tmp.customers;
--1--


select e.firstname,e.lastname,e.jobtitle
from ssdx_tmp.employees e
where e.jobtitle like 'Sales Rep';

--2--
select p.productcode,p.productname,p.quantityinstock
from ssdx_tmp.products p
where p.buyprice>(
select avg(buyprice)
from ssdx_tmp.products p);


--3--

select cast(avg(o.requireddate-o.shippeddate)as decimal(10,2)) 
from ssdx_tmp.orders o;
--4-

select e.firstname
from SSDX_TMP.employees  e
where e.firstname like 'D%' or  e.firstname like 'M%' or  e.firstname like 'J%';
--5-
SELECT DISTINCT(o.country)
FROM SSDX_TMP.OFFICES O, SSDX_TMP.EMPLOYEES E
WHERE o.officecode=e.officecode;


SELECT o.country
FROM SSDX_TMP.OFFICES O, SSDX_TMP.EMPLOYEES E
WHERE o.officecode=e.officecode
GROUP BY O.COUNTRY;


SELECT o.country
FROM SSDX_TMP.OFFICES O JOIN SSDX_TMP.EMPLOYEES E
ON o.officecode=e.officecode
GROUP BY O.COUNTRY;

SELECT DISTINCT(COUNTRY)
FROM ( SELECT country
FROM SSDX_TMP.OFFICES O, SSDX_TMP.EMPLOYEES E) 
;

--6--
SELECT *
FROM SSDX_TMP.ORDERS O
WHERE O.COMMENTS LIKE UPPER('DIFFICULT');

SELECT *
FROM SSDX_TMP.ORDERS O
WHERE O.COMMENTS LIKE 'difficult';

--7--
SELECT p.productvendor, p.quantityinstock 
FROM ssdx_tmp.products p
order by p.quantityinstock desc;

--8--
select ordernumber , products 
from(
select o.ordernumber , count(p.productcode) products
from ssdx_tmp.orders o, ssdx_tmp.products p ,ssdx_tmp.orderdetails od
where o.ordernumber=od.ordernumber and od.productcode=p.productcode
group by o.ordernumber)
where products=1;

--9--
select count(productcode) count, productline
from(
select p.productline, p.productcode
from ssdx_tmp.orders o, ssdx_tmp.products p ,ssdx_tmp.orderdetails od
where o.ordernumber=od.ordernumber and p.productcode=od.productcode
group by p.productline,p.productcode
)
group by productline;

--10--
select (e1.firstname || ' report to ' || Upper(e2.firstname)) employee1
from SSDX_TMP.employees e1  inner join ssdx_tmp.employees e2
on e1.reportsto=e2.employeenumber;

--11--

--12--
select *
from ssdx_tmp.customers;

select*
from ssdx_tmp.payments;


select cu.customername
from ssdx_tmp.customers cu,ssdx_tmp.payments p
where cu.customernumber=p.customernumber and p.amount>100000;

--13--
select *
from ssdx_tmp.payments p ,ssdx_tmp.orders o
where p.customernumber=o.customernumber
and p.amount >60000
order by p.amount desc;

--14--
--revenue = (sellprice-buyprice)
select p.productname, p.productdescription pd,p.productline,(o.priceeach-p.buyprice) revenue
from ssdx_tmp.products p, SSDX_TMP.orderdetails o
where p.productcode=o.productcode
order by revenue desc
fetch first 1 row only;

--15--
select o.firstname,o.lastname,o.customernumber,o.ordernumber,o.status
from 
(
select e.firstname,e.lastname,c.customernumber,o.ordernumber,o.status
from SSDX_TMP.employees e,SSDX_TMP.customers c, SSDX_TMP.orders o
where e.employeenumber=c.salesrepemployeenumber and c.customernumber=o.customernumber) o
where o.status ='not shipped' or o.status ='Cancelled' or o.status ='Resolved' ;


--16--

select distinct(e.firstname), e.email
from ssdx_tmp.employees e, ssdx_tmp.customers c,ssdx_tmp.orders o, ssdx_tmp.orderdetails od,ssdx_tmp.products p
where e.employeenumber=c.salesrepemployeenumber and c.customernumber= o.customernumber and o.ordernumber=od.ordernumber and od.productcode=p.productcode 
and p.productname like '%Harley%' ;
--17--
select c.customername,c.contactfirstname||' '||c.contactlastname name,c.country
from ssdx_tmp.customers c
where c.country like 'France' or c.country like 'USA'
order by name;

--18--

select e.employeenumber , count(o.ordernumber) orders
from ssdx_tmp.employees e,ssdx_tmp.offices o, ssdx_tmp.customers c,ssdx_tmp.orders o
where e.officecode=o.officecode and e.employeenumber=c.salesrepemployeenumber and c.customernumber= o.customernumber
group by e.employeenumber;

select employeenumber, count(employeenumber) "employee in office" 
from(
select e.employeenumber ,o.officecode
from ssdx_tmp.employees e,ssdx_tmp.offices o
group by o.officecode, e.employeenumber)
group by employeenumber;


--19--

select c.customernumber,(select count(o.status) 
from ssdx_tmp.orders o where o.status like 'Shipped') Shipped ,
(select count(o.status) 
from ssdx_tmp.orders o where o.status like 'In Process') In_Process ,
(select count(o.status) 
from ssdx_tmp.orders o where o.status like 'Disputed') Disputed,
(select count(o.status) 
from ssdx_tmp.orders o where o.status like 'Resolved') Resolved,
(select count(o.status) 
from ssdx_tmp.orders o where o.status like 'On Hold') On_Hold
from ssdx_tmp.customers c , ssdx_tmp.orders o
where c.customernumber = o.customernumber 
group by c.customernumber 
;

--21--
select distinct(e.firstname||' '||e.lastname) name1 , count(c.customernumber) customers
from ssdx_tmp.employees e, ssdx_tmp.customers c
where e.employeenumber = c.salesrepemployeenumber
group by (e.firstname||' '||e.lastname);


--22--

insert into employees(email)
values ('dmurphy.classicmodelcars.co');

insert into employees(email)
values ('dmu.rphy@classicmodelcars.co');

insert into employees(email)
values ('d@murphy@classicmodelcars.co');

insert into ssdx_tmp.employees(email)
values ('dmur@phy@classicmodelcars.co');


--23--
delete
from ssdx_tmp.employees e
where e.email !='%.com';



coomit;


