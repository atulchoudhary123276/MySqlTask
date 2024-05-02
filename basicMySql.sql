create table Customers(
     CustId int primary key,
     CustName varchar(100),
     City varchar(100),
     Country varchar(100),
     Pincode varchar(100)
     );
     
drop table emp;
insert into Customers
 values
 (2,'Sohan','Delhi','india','201301'),
 (3,'Mohan','Bijnor','india','246787'),
 (4,'Priya','noida','india','201301'),
 (5,'Swati','Gzb','india','201301');

desc Customers;
select * from Customers;
select distinct City,Country from Customers;
select  distinct count(Country) from Customers;
select * from Customers
 limit 2 offset 1;
 
 insert into Customers
 values
 (6,'rahul','dhampur','india','206725'),
 (7,'amit','paris','UK','11111');
 
 select CustName,City from Customers
  where city='dhampur' or city ='bijnor';
  
  select city, count(City) as 'count Of city' from Customers
         where city in ('dhampur','bijnor');
         
select city, count(city) from Customers
      group by City
      having count(City)>1;
      
      
