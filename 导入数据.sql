/*首先创建KDD99数据库*/
### drop database Kdd99;
create database Kdd99; 
use kdd99;  
### show variables like '%secure%';

create table kdd99_accounts (  
    account_id  integer,  
    district_id  integer, 
    frequency  varchar(20),
    date DATE
); 
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/kdd99_accounts.csv' 
     into table kdd99_accounts  
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
     ignore 1 lines;

create table Kdd99_card(  
    card_id  integer,  
    disp_id  integer, 
    issued   DATE,
    type  varchar(10)
); 
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Kdd99_cards.csv' 
     into table Kdd99_card 
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
	 ignore 1 lines;


create table Kdd99_clients(  
    client_id  integer,  
    sex  varchar(2),
    birth_date   DATE,
    district_id  integer
); 
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Kdd99_clients.csv' 
     into table Kdd99_clients
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
      ignore 1 lines;

create table Kdd99_disp(  
    disp_id  integer,  
    client_id integer,
    account_id integer,
    type  varchar(6)
); 
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Kdd99_disp.csv' 
     into table Kdd99_disp
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
      ignore 1 lines;

create table Kdd99_district(  
    A1 integer,GDP long,A4 DOUBLE,A10 DOUBLE,A11 DOUBLE,A12 DOUBLE,A13 DOUBLE,A14 DOUBLE,A15 DOUBLE,a16 DOUBLE
);  
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Kdd99_district.csv' 
     into table Kdd99_district
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
      ignore 1 lines;

create table Kdd99_loans(  
    loan_id integer,account_id integer,date date,amount long,duration integer,payments long,status varchar(2)
);  
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Kdd99_loans.csv' 
     into table Kdd99_loans
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
      ignore 1 lines;

create table Kdd99_order(  
    order_id integer,account_id integer,bank_to varchar(2),account_to integer,amount integer,k_symbol varchar(20)
);  
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Kdd99_orders.csv' 
     into table Kdd99_order
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
      ignore 1 lines;

create table Kdd99_trans(  
    trans_id integer,account_id integer,date date,type  varchar(2),operation  varchar(20),amount long,balance long,k_symbol  varchar(20),bank  varchar(4),account long
);  
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Kdd99_trans.csv' 
     into table Kdd99_trans
     CHARACTER SET gb2312
     fields terminated by ','
     optionally enclosed by '"' escaped by '"'  
	 lines terminated by '\r\n'
      ignore 1 lines;





