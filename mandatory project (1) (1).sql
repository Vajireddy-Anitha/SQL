------ INTRODUCTION:
----- IN OUR PROJECT WE USE  SQL  FOR ANSWERING THE BELOW QUESTIONS
------- TAKE GROSVENOR HOTEL  AS DATABASE WHICH IS IN LONDON AND ANSWERING  THE BELOW QUESTIONS 
----- WE CREATE THE DATABASE AND USE THAT DATABASE AND CREATE TABLES AND INSERT THE VALUES
------ AFTER THAT BASED ON QUESTIONS WE WRITE THE QURIES AND SOLVING THE QUESTIONS

CREATE DATABASE Grosvenor;
USE Grosvenor;


create table Hotel(hotel_no char(4) not null, 
                   hotel_name varchar(20) not null, 
                   hotel_address varchar(50) not null,
                   primary key(hotel_no));
                  
create table Room(room_no varchar(4) not null,
                   hotel_no char(4) not null,
				  type char(1) not null,
				  price decimal(5,2) not null,
                  PRIMARY KEY(room_no),
				  foreign key (hotel_no) references hotel(hotel_no));
                  
create table Guest(guest_no char(4) not null,
                   guest_name varchar(20) not null,
                   guest_address varchar(50) not null,
                   primary key (guest_no));

Create table Booking(hotel_no char(4) not null,
                    guest_no char(4) not null,
					date_from DATE not null,
					date_to DATE null,
                    room_no varchar(4) not null,
					foreign key (hotel_no) references hotel(hotel_no),
					foreign key (guest_no) references guest(guest_no),
                    foreign key (room_no) references room(room_no));

insert into hotel values('H111','Grosvenor Hotel','London'),
						('H112','Taj Villas Hotel','India'),
						('H113','Grand Hotel','USA');
insert into room values('H1','H111','S',30.00),('H2','H111','D',50.00),('H3','H111','F',70.00),
                       ('H4','H111','S',35.00),('H5','H111','D',55.00),('H6','H111','F',30.00),
					   ('T1','H112','S',25.00),('T2','H112','D',55.00),('T3','H112','F',60.00),
                       ('T4','H112','S',30.00),('T5','H112','D',60.00),('T6','H112','F',65.00),
                       ('G1','H113','S',50.00),('G2','H113','D',70.00),('G3','H113','F',30.00),
                       ('G4','H113','S',55.00),('G5','H113','D',75.00),('G6','H113','F',100.00);

insert into guest values('G111','John Smith','London'),
                         ('G112',' Rahul Dravid','India'),
                         ('G113','Layla','USA'),
                         ('G114','Peeth','Dubai'),
                         ('G115','Stella','London'),
                         ('G116','Disha','Canada'),
                         ('G117','scralott','UK'),
                         ('G118','Mike','Germany'),
                         ('G119','Jerry Seinfeld','USA'), 
                         ('G120','Shahrukh Khan','India');
insert into guest values('G100','Mohisha patel' ,'Australia'),
						('G101','Susen singh','China');
delete from guest where guest_no in('G100','G101');
drop table room;
                        
insert into booking values('H111','G111','2022-07-01', '2022-07-05','H1'),
                          ('H111','G112','2022-07-6', '2022-07-10','H2'),
                          ('H111','G113','2022-07-11', '2022-07-15','H3'),
                          ('H111','G114','2022-07-16','2022-07-20' ,'H4'),
						  ('H111','G115', '2022-07-23',null,'H5'),
						  ('H111','G116','2022-07-16', '2022-07-23','H6'),
                          ('H111','G117','2022-07-17', '2022-07-25','H2'),
						  ('H111','G118','2022-07-18', '2022-07-27','H3'),
						  ('H111','G119', '2022-08-01','2022-08-10','H1'),
						  ('H111','G120', '2022-08-11','2022-08-15','H2');
insert into booking values ('H111','G100','1999-07-01','1991-07-10','H1'),
                           ('H111','G101','1999-07-07','1999-07-15','H2');

----- SIMPLE QUERIES
---- 1.List full details of all hotels.
select * from hotel;

---- 2.List full details of all hotels in london.
select * from hotel
where hotel_address='London';

 ---- 3.List the names and address of all guests in london,alphabetically orderd by name
 select guest_name,guest_address from guest
 where guest_address='London'
 order by guest_name;
 
 ---- 4. List all double or family rooms with a price below 40.00 per night,in ascending order of price.
 select * from room
 where type in ('D','F')  and price< 40.00 
 order by price;
 
 ------ 5.List the bookings for which no date_to has been specified.
 select * from booking
 where date_to is null;
 
 --------- AGGREGATE FUNCTIONS
 ---- 1.How many hotels are there?
 select count(*) from hotel;
 
 ---- 2.What is the average price of a room?
 select round(avg(price),2) as avgprice from  room;
 
 ---- 3.What is the total revenue per night from all double rooms?
 select sum(price) as total_revenue,type from room 
 where type='D'
 group by type;
 
 ---- 4.How many different guests have made bookings for august?
select  count(distinct( guest_no)) as different_guests from booking
where (date_from>= '2022-08-01' AND date_to <= '2022-08-31');

----- SUBQUERIES AND JOINS
---- 1.List the price and type of all rooms at the grosvenor hotel.
select price,type from room
 join hotel
 on room.hotel_no=Hotel.hotel_no
where hotel_name='grosvenor hotel';

---- 2.List all guests currently staying at the grosvenor hotel.
select guest_name from guest
  join booking
  on guest.guest_no=booking.guest_no
  join hotel
  on booking.hotel_no=hotel.hotel_no
 where (date_from <= getdate() and date_to >=GETDATE()) and(hotel_name='Grosvenor Hotel');

---- 3.List the detials of all rooms at the grocvenor hotel,including the name of guest staying in the room,if the room is occupied.
select * from room 
 left join booking
 on room.room_no=booking.room_no
  inner join guest
 on booking.guest_no=guest.guest_no
 inner join hotel
  on booking.hotel_no=hotel.hotel_no
  where (date_from<= GETDATE() and date_to>=GETDATE()) and (hotel_name='Grosvenor Hotel');
  
 ---- 4.What is the total income from bookings for the grosvenor hotel today.
select sum(price) as total_income,hotel_name,date_from,date_to  from room  r
inner join booking b
 on b.room_no=r.room_no
inner join hotel h
on h.hotel_no=b.hotel_no
where (date_from=getdate()  and hotel_name='Grosvenor Hotel')
group by hotel_name,date_from,date_to

---- 5.List the rooms that are currently unoccupied at the grosvenor hotel.
select  (r.room_no) as rooms from room r
inner join booking b
on r.room_no=b.room_no
inner join hotel h
on h.hotel_no=b.hotel_no
where r.room_no not in(select r.room_no from booking where date_from <= getdate() and date_to >= GETDATE())
and (hotel_name = 'Grosvenor Hotel');  

---- 6.What is the lost income from unoccupied rooms at the grosvenor hotel.
select sum(price) as lost_income from room r
inner join booking b
on b.room_no=r.room_no
inner join hotel h
on h.hotel_no=b.hotel_no
where  r.room_no not in  (select r.room_no from booking where date_from <=getdate()and date_to>=getdate()) 
and hotel_name='Grosvenor Hotel';


---------- GROUPING
------ 1.List the number of rooms in each hotel.
select  hotel_no ,count(room_no) as rooms from room
group by hotel_no;

------ 2.List the number of rooms in each hotel in london.
select h.hotel_no ,hotel_name,count(room_no) as rooms from room r
inner join hotel h
on h.hotel_no=r.hotel_no
where hotel_address='London'
group by h.hotel_no,hotel_name;

------ 3.What is the average number of bookings for each hotel in august.
select avg (price) as avgprice,h.hotel_no,date_from,date_to from room r
inner join booking b
on b.room_no=r.room_no
inner join hotel h
on h.hotel_no=b.hotel_no
where (date_from >= '2022-08-01' and date_to <= '2022-08-31')
group by h.hotel_no,date_from,date_to;

------ 4.What is the most commonly booked room type of each hotel in london.
select  top 1 (count(type)) as max,type from room
join booking
on room.room_no=booking.room_no
 join hotel
 on booking.hotel_no=hotel.hotel_no
where hotel_address='london'
group by type 
order by max desc



------ 5.What is the lost income from unoccupied rooms at each hotel today
select hotel_no,sum(price) as lost_income  from room 
where room_no not in(select room_no from booking ,hotel 
where (date_from<=GETDATE() and date_to >=GETDATE()) and
Booking.hotel_no=Hotel.hotel_no)
group by hotel_no;

------ UPDATING TABLES:
--  Question :- Update the price of all rooms by 5%.
UPDATE Room SET price = (price*1.05);


-- Create a separate table with the same structure as the Booking table to hold archive records. 
-- Using the INSERT statement, copy the records from the Booking table to the archive table relating to bookings before 1st January 2008. 
-- Delete all bookings before 1st January 2000 from the Booking table.

 Create table Booking_Old(hotel_no char(4) not null,
                        guest_no char(4) not null,
					    date_from DATE not null,
					    date_to DATE null,
                        room_no char(4) not null);

DESC Booking_Old;

INSERT INTO Booking_Old(SELECT * FROM booking WHERE date_to < DATE'2000-01-01');
DELETE FROM booking WHERE date_to < '2000-01-01' ;
                        

----- CONCLUSION:
------- In OUR PROJECT WE USED DATA TYPES,CONSTRINTS AGGEGRATE FUNCTIONS,JOINS,SUBQUIRIES,OPERATORS
------- AND SOME FUNCTIONS LIKE GROUP BY,ORDER BY ,LIMIT AND WHERE CLUASE THESE ARE USED  FOR COMPLETION OF OUR PROJECT

select * from hotel
select * from guest
select * from Booking
select * from room

----Date Functions
select DATEDIFF(MM,date_from,getdate()) as date_diff from booking;
select year(date_from) as year from booking
select datepart(YYYY,date_to)  as year from booking
select DATENAME(mm,date_from) as month_name from booking
select SYSDATETIME()
select SYSDATETIMEOFFSET()
select SYSUTCDATETIME()
select GETDATE()
select GETUTCDATE()
select EOMONTH(date_from) from booking
select ISDATe(GETDATE())
select SWITCHOFFSET(GETDATE(),-6)
select TODATETIMEOFFSET(getdate(),-6)

select (GETDATE() -1) as previous_day ---- previous day
select DATeadd(day, -1,GETDATE()) as previous_day
select (GETDATE() -365) as previous_year ---- previous Year
select DATeadd(YEAR, -1,GETDATE()) as previous_year
select (GETDATE() -30) as previous_month ---- previous month
select DATeadd(MONTH, -1,GETDATE()) as previous_month
select (GETDATE()  +1) as next_day ---- next day
select DATeadd(day, 1,GETDATE()) as next_day

----String Functions
select ascii(2)
select CHARindex('t','customer') ---gives the position of string
select concat('anitha', ' ' ,'vajiredy')
select CONCAT_WS(' ','anitha','keerthi')
select ('anitha'+ ' ' +'subbu')
select CONVERT(char,16)
select convert(int,'1')
SELECT FORMAT(123,'#-##');

DECLARE @d DATETIME = '12/01/2018';
SELECT FORMAT (@d, 'd', 'en-US') AS 'US English Result',
               FORMAT (@d, 'd', 'no') AS 'Norwegian Result',
               FORMAT (@d, 'd', 'zu') AS 'Zulu Result';
select rtrim('anitha  ')
select len('sqltutorial')
select DATALENGTH('sqltutorial')
select LEFT('anitha',1)
select right('subbu',2)
select REPLACE('anitha','a',2)
select REVERSE('anitha')
select REPLICATE('a',5)
select SUBSTRING('sqltutorial',1,3)
select trim('   sql ' )
select STUFF('sqltutorial',1,3,'html')
select lower('ANITHA')select PATINDEX('%schools%','w3schools')select DIFFERENCE('june','july')SELECT TRANSLATE('3*[2+1]/{8-4}', '[]{}', '()()');select translate('monday','monday','sunday')select SOUNDEX('jucy')select str(1.25)select NCHAR(1)select cast(1.25 as  int)SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');select isnull(null,'w3schools')
select nullif(12,12)
select iif(500<1000 ,'yes','no')
select SESSION_USER
select SYSTEM_USER
select USER_NAME()








