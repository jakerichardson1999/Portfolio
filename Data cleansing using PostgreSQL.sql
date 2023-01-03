select * from newtable;

-- standardize date format

SELECT TO_CHAR(TO_DATE(saledate:: varchar, 'Month DD YYYY'), 'DD-MM-YYYY') AS date
FROM newtable n ;

-- updating the table 

update newtable 
set saledate = TO_CHAR(TO_DATE(saledate:: varchar, 'Month DD YYYY'), 'DD-MM-YYYY') ;
 
select * from newtable
order by saledate;

-- populate the property address data

select "UniqueID ", count(*) 
from newtable
group by "UniqueID " 
having count(*) > 1;

select propertyaddress 
from newtable n 


select 
substring(propertyaddress from (position(',' in propertyaddress) +1 )) as realaddress
from newtable n ;

select propertyaddress,
       substring(propertyaddress from 1 for position(',' in propertyaddress)) as address_before_comma,
       substring(propertyaddress from (position(',' INin propertyaddress) + 1)) as address_after_comma
from newtable n ;

--create two new column 

alter table newtable 
add column address_before_comma text default null;


alter table newtable 
add column address_after_comma text default null;


-- add the relevent data to these columns 

update newtable 
set address_before_comma = substring(propertyaddress from 1 for position(',' in propertyaddress));

update newtable 
set address_after_comma = substring(propertyaddress from (position(',' in propertyaddress) + 1));


select * from newtable n ;

-- remove the final comma 
update newtable 
set address_before_comma  = substring(address_before_comma from 1 for length (address_before_comma)-1)
where length(address_before_comma) >1 ;

select * from newtable n ;

-- the 'split_part' function would have been a far better and more effective way of doing that... u live and u learn :P

select 
split_part(propertyaddress:: text, ',', 1) beforecoma,
split_part(propertyaddress:: text, ',', 2) aftercoma
from newtable n ;

-- lets use the split_address function for the owneraddress column

select
split_part(owneraddress:: text, ',', 1) OwnerHouseRoad,
split_part(owneraddress:: text, ',', 2) OwnerCity,
split_part(owneraddress:: text, ',', 3) OwnerState
from newtable n ;

--making new columns to add this data to

alter table newtable 
add column OwnerHouseRoad text default null;

alter table newtable 
add column OwnerCity text default null;

alter table newtable 
add column OwnerState text default null;

-- updating the data to the table and dropping the then irrelevent column 

update newtable 
set OwnerHouseRoad = split_part(owneraddress:: text, ',', 1);

update newtable 
set OwnerCity = split_part(owneraddress:: text, ',', 2);

update newtable 
set OwnerState = split_part(owneraddress:: text, ',', 3);

select * from newtable n ;

alter table newtable 
drop column owneraddress;

-- now lets look at the soldasvacant column 

select distinct soldasvacant, count(soldasvacant)
from newtable 
group by soldasvacant ;

--lets nomalise this data  

update newtable 
set soldasvacant = 'No' 
where soldasvacant = 'N';

--lets remove some duplicates

select "UniqueID " , parcelid, saledate, ownername, count(*) as total
from newtable
group by "UniqueID ", parcelid, saledate, ownername
having count(*) >1;

-- each row has 12 duplicates 
select *
from newtable;

--I hope this mini project showcases my ability to clean data using Postgresql.




