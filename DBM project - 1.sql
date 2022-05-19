------a.Create user for each group member with different privilege-------------
Create user reema identified by r123123;

Create user raseel identified by a123123; 

Create user shahad identified by s123123; 



Grant  ALL PRIVILEGES to reema ; 
Grant dba to shahad ;  
Grant create table , connect to raseel ;  
--======================b.	Show all current users with their privileges=========================--

SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in ('reema','raseel','shahad' );
------------------------c  -----------------------
 drop tablespace Project_Table including contents and datafiles;
 drop tablespace Project_INDX including contents and datafiles;
 create tablespace Project_Table datafile'C:\Users\Surfacepro7\Desktop\datafiles\tbl.dbf' size 500m ;
 create tablespace Project_INDX datafile   'C:\Users\Surfacepro7\Desktop\datafiles\indx.dbf' size 500m ;


 alter user reema default tablespace Project_Table;
 alter user raseel default tablespace Project_Table;
 alter user shahad default tablespace Project_Table;

----------------------------d.Show all tablespaces and datafiles ----------------------------
 
 select t.tablespace_name, d.file_name 
 from dba_tablespaces t join dba_data_files d
 on (t.tablespace_name=d.tablespace_name);

 -------------------------e.Show all users with their default tablespace -------------------------
 select username, default_tablespace from dba_users 
where lower(username) in ('reema','raseel','shahad');

---------------f - g  ------------------------------------------

drop table Customer cascade CONSTRAINT;
drop table Employee cascade CONSTRAINT;
drop table car cascade CONSTRAINT;
drop table Insurance cascade CONSTRAINT;
drop table Accident cascade CONSTRAINT;
drop table Car_accident cascade CONSTRAINT;


CREATE TABLE Customer  (
    ID NUMBER(20) ,
    Name varchar2(255),
    phone VARCHAR2(30),
    DOB date,
    license varchar2(40),
	PRIMARY key (ID)
);

 insert into Customer values (1,'meshal','0500000','03-sep-99','220000');
 insert into Customer values (2,'deema','0500001','05-jan-98','339999');
 insert into Customer values (3,'reem','0510000','05-sep-03','18f838f');
 insert into Customer values (4,'abeer','0512120','03-mar-01','119999');
 insert into Customer values (5,'sara','05303030','05-feb-02','449999');
 insert into Customer values (6,'samar','0599999','03-feb-99','377776');


CREATE TABLE Employee (
    ID number(20) ,
    Name varchar2(255),
	position varchar2(255),
    phone VARCHAR2(30),
    sex varchar2(20),
    supervisor_id number(20),
	PRIMARY key (ID),
	FOREIGN KEY (supervisor_id) REFERENCES Employee(ID)on delete CASCADE
);

 insert into Employee values (1,'nouf',' manager','0593337','m',null);
 insert into Employee values (2,'ameerah','manger','0513347','f',null);
 insert into Employee values (3,'hatoon','accountant','05988887','m',1);
 insert into Employee values (4,'taraf','accountant','05979547','m',1);
 insert into Employee values (5,'hessa','engineer','059426667','f',2);
 insert into Employee values (6,'saleh','accountant','05353567','m',1);

CREATE TABLE car  (
   plate_num number(10),
   customer_id number(20) ,
   model_name varchar2(100),
   yearr  number(4),
   PRIMARY key (plate_num),
   FOREIGN KEY ( customer_id) REFERENCES customer(ID) on delete CASCADE
);


 insert into Car values (333,2,'bmw',2018);
 insert into Car values (155,3,'audi',2022);
 insert into Car values (144,2,'toyota',2019);
 insert into Car values (166,5,'tesla',2020);
 insert into Car values (544,1,'bmw',2019);
 insert into Car values (666,4,'audi',2016);




CREATE TABLE Insurance  (
    policy_number number(30),
    start_date  DATE,
    end_date  DATE ,
    insurance_type  varchar2 (40),
    plate_num number(10),
	employee_Id  number(20),
	PRIMARY key (policy_number ),
    FOREIGN KEY ( plate_num) REFERENCES car (plate_num)on delete CASCADE,
    FOREIGN KEY ( employee_Id ) REFERENCES Employee (id) on delete CASCADE
);

 insert into Insurance values (823,'01-oct-18','01-feb-22','A',333,1);
 insert into Insurance values (824,'01-oct-18','01-feb-20','A',666,3);
 insert into Insurance values (825,'01-oct-18','01-feb-19','P',333,3);
 insert into Insurance values (826,'01-dec-18','01-apr-20','A',144,2);
 insert into Insurance values (827,'01-dec-18','01-apr-22','P',155,4);
 insert into Insurance values (828,'01-Jan-18','01-apr-19','A',544,2);
 


CREATE TABLE Accident (
     reportnum  number(10) ,
     datee  DATE,
     description  varchar2(255),
     location  varchar2(255),
	 PRIMARY key (reportnum )
);

 insert into Accident values (221,'01-may-19','car crash ','riyadh');
 insert into Accident values (222,'01-jan-20','car crash ','Khober');
 insert into Accident values (223,'04-may-19','car crash ','riyadh');
 insert into Accident values (224,'05-dec-19','car crash ','Jaddah');
 insert into Accident values (225,'03-oct-18','car crash ','makkah');
 insert into Accident values (226,'01-may-17','car crash ','riyadh');
 insert into Accident values (229,'01-may-17','car crash ','Jaddah');



set sqlblanklines on;

CREATE TABLE Car_accident (
     reportnum  number (10) ,
	 plate_num number(10) ,
	   primary key (reportnum,plate_num),
    FOREIGN KEY (plate_num) REFERENCES car(plate_num)on delete CASCADE,
    FOREIGN KEY (reportnum) REFERENCES accident(reportnum)on delete CASCADE
);

 insert into Car_accident values (221,333);
 insert into Car_accident values (223,666);
 insert into Car_accident values (222,666);
 insert into Car_accident values (224,155);
 insert into Car_accident values (225,155);
 insert into Car_accident values (226,544);
 
----------------------H ------------------------------------
 
create index insurance_type
on Insurance(start_date)
TABLESPACE Project_INDX;

create index accident_ndx1
on Car_accident(plate_num)
TABLESPACE Project_INDX;


----------------------i ------------------------------------
 
 ----PROCEDURE 1----i.* if you enter the plate number the car model will show up 
   set serveroutput on;
 CREATE OR REPLACE PROCEDURE carmodel(plate_number IN number) IS m varchar2(100);
 begin
 select model_name into m from car where plate_num=plate_number; 
   dbms_output.put_line('car model  '|| m);

  end carmodel;
 /
 
   set serveroutput on;

BEGIN 

carmodel(333);
END;
/
 ----PROCEDURE 2----i.* count number of accedent for the car
 set serveroutput on;
 CREATE OR REPLACE PROCEDURE accedentcounter(plate_number IN number) IS
 allcount number;
 BEGIN
 
 select count(*) into allcount from Car_accident
 where plate_num = plate_number;
 
 dbms_output.put_line('the total number of accedent=' || allcount );
 end accedentcounter;
 /
BEGIN 

accedentcounter(666);
END;
/


-----PROCEDURE 3 -----show the City of  Accedent based on report number------
DROP PROCEDURE cityOfacc; 
   set serveroutput on;
 CREATE OR REPLACE PROCEDURE cityOfacc(repnum IN number) IS  c varchar2(255);
 begin
 select location into c from Accident where reportnum=repnum; 
   dbms_output.put_line('City Of Accedent '|| c );

  end cityOfacc;
 /
 --------------
BEGIN 

cityOfacc(224);
END;
/

--jeddah
----------------------j------------------------------------
----------trigger 1 checks the plate number and if it has an accident then he will not be able to get an insurance
CREATE or replace TRIGGER insconnecturance_policy
    BEFORE insert or update ON Insurance
    FOR EACH ROW 
DECLARE
   c_accCout NUMBER(10);
 
BEGIN
  select count(*) into c_accCout 
from Car_accident 
where plate_num=:new.plate_num;
  
    If c_accCout > 0 Then
        raise_application_error(-20001, 'Driver has accidents');
    End If;

END;
/
  
 insert into Insurance values (487,'01-Jan-18','01-feb-19','P',144,2);
 insert into Insurance values (949,'01-Jan-18','01-feb-19','P',666,2);
 
----------trigger 2 checks the customer age if it's under 18 then he will not be able to get an insurance
CREATE OR REPLACE TRIGGER cus_age
 BEFORE INSERT OR UPDATE ON Customer
 FOR EACH ROW 
 BEGIN
 IF :new.DOB>'1-jan-04' THEN
 raise_application_error(-20001, 'Age should not be greater than 18'); 
 END IF;
  
END;
/

 insert into Customer values (10,'shosho','0500030','03-sep-03','220500');
  insert into Customer values (11,'shosho','0500040','03-sep-05','220900');
  ------a.Create user for each group member with different privilege-------------
Create user reema identified by r123123;

Create user raseel identified by a123123; 

Create user shahad identified by s123123; 



Grant  ALL PRIVILEGES to reema ; 
Grant dba to shahad ;  
Grant create table , connect to raseel ;  
--======================b.	Show all current users with their privileges=========================--

SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in ('reema','raseel','shahad' );
------------------------c  -----------------------
 drop tablespace Project_Table including contents and datafiles;
 drop tablespace Project_INDX including contents and datafiles;
 create tablespace Project_Table datafile'C:\Users\Surfacepro7\Desktop\datafiles\tbl.dbf' size 500m ;
 create tablespace Project_INDX datafile   'C:\Users\Surfacepro7\Desktop\datafiles\indx.dbf' size 500m ;


 alter user reema default tablespace Project_Table;
 alter user raseel default tablespace Project_Table;
 alter user shahad default tablespace Project_Table;

----------------------------d.Show all tablespaces and datafiles ----------------------------
 
 select t.tablespace_name, d.file_name 
 from dba_tablespaces t join dba_data_files d
 on (t.tablespace_name=d.tablespace_name);

 -------------------------e.Show all users with their default tablespace -------------------------
 select username, default_tablespace from dba_users 
where lower(username) in ('reema','raseel','shahad');

---------------f - g  ------------------------------------------

drop table Customer cascade CONSTRAINT;
drop table Employee cascade CONSTRAINT;
drop table car cascade CONSTRAINT;
drop table Insurance cascade CONSTRAINT;
drop table Accident cascade CONSTRAINT;
drop table Car_accident cascade CONSTRAINT;


CREATE TABLE Customer  (
    ID NUMBER(20) ,
    Name varchar2(255),
    phone VARCHAR2(30),
    DOB date,
    license varchar2(40),
	PRIMARY key (ID)
);

 insert into Customer values (1,'meshal','0500000','03-sep-99','220000');
 insert into Customer values (2,'deema','0500001','05-jan-98','339999');
 insert into Customer values (3,'reem','0510000','05-sep-03','18f838f');
 insert into Customer values (4,'abeer','0512120','03-mar-01','119999');
 insert into Customer values (5,'sara','05303030','05-feb-02','449999');
 insert into Customer values (6,'samar','0599999','03-feb-99','377776');


CREATE TABLE Employee (
    ID number(20) ,
    Name varchar2(255),
	position varchar2(255),
    phone VARCHAR2(30),
    sex varchar2(20),
    supervisor_id number(20),
	PRIMARY key (ID),
	FOREIGN KEY (supervisor_id) REFERENCES Employee(ID)on delete CASCADE
);

 insert into Employee values (1,'nouf',' manager','0593337','m',null);
 insert into Employee values (2,'ameerah','manger','0513347','f',null);
 insert into Employee values (3,'hatoon','accountant','05988887','m',1);
 insert into Employee values (4,'taraf','accountant','05979547','m',1);
 insert into Employee values (5,'hessa','engineer','059426667','f',2);
 insert into Employee values (6,'saleh','accountant','05353567','m',1);

CREATE TABLE car  (
   plate_num number(10),
   customer_id number(20) ,
   model_name varchar2(100),
   yearr  number(4),
   PRIMARY key (plate_num),
   FOREIGN KEY ( customer_id) REFERENCES customer(ID) on delete CASCADE
);


 insert into Car values (333,2,'bmw',2018);
 insert into Car values (155,3,'audi',2022);
 insert into Car values (144,2,'toyota',2019);
 insert into Car values (166,5,'tesla',2020);
 insert into Car values (544,1,'bmw',2019);
 insert into Car values (666,4,'audi',2016);




CREATE TABLE Insurance  (
    policy_number number(30),
    start_date  DATE,
    end_date  DATE ,
    insurance_type  varchar2 (40),
    plate_num number(10),
	employee_Id  number(20),
	PRIMARY key (policy_number ),
    FOREIGN KEY ( plate_num) REFERENCES car (plate_num)on delete CASCADE,
    FOREIGN KEY ( employee_Id ) REFERENCES Employee (id) on delete CASCADE
);

 insert into Insurance values (823,'01-oct-18','01-feb-22','A',333,1);
 insert into Insurance values (824,'01-oct-18','01-feb-20','A',666,3);
 insert into Insurance values (825,'01-oct-18','01-feb-19','P',333,3);
 insert into Insurance values (826,'01-dec-18','01-apr-20','A',144,2);
 insert into Insurance values (827,'01-dec-18','01-apr-22','P',155,4);
 insert into Insurance values (828,'01-Jan-18','01-apr-19','A',544,2);
 


CREATE TABLE Accident (
     reportnum  number(10) ,
     datee  DATE,
     description  varchar2(255),
     location  varchar2(255),
	 PRIMARY key (reportnum )
);

 insert into Accident values (221,'01-may-19','car crash ','riyadh');
 insert into Accident values (222,'01-jan-20','car crash ','Khober');
 insert into Accident values (223,'04-may-19','car crash ','riyadh');
 insert into Accident values (224,'05-dec-19','car crash ','Jaddah');
 insert into Accident values (225,'03-oct-18','car crash ','makkah');
 insert into Accident values (226,'01-may-17','car crash ','riyadh');
 insert into Accident values (229,'01-may-17','car crash ','Jaddah');



set sqlblanklines on;

CREATE TABLE Car_accident (
     reportnum  number (10) ,
	 plate_num number(10) ,
	   primary key (reportnum,plate_num),
    FOREIGN KEY (plate_num) REFERENCES car(plate_num)on delete CASCADE,
    FOREIGN KEY (reportnum) REFERENCES accident(reportnum)on delete CASCADE
);

 insert into Car_accident values (221,333);
 insert into Car_accident values (223,666);
 insert into Car_accident values (222,666);
 insert into Car_accident values (224,155);
 insert into Car_accident values (225,155);
 insert into Car_accident values (226,544);
 
----------------------H ------------------------------------
 
create index insurance_type
on Insurance(start_date)
TABLESPACE Project_INDX;

create index accident_ndx1
on Car_accident(plate_num)
TABLESPACE Project_INDX;


----------------------i ------------------------------------
 
 ----PROCEDURE 1----i.* if you enter the plate number the car model will show up 
   set serveroutput on;
 CREATE OR REPLACE PROCEDURE carmodel(plate_number IN number) IS m varchar2(100);
 begin
 select model_name into m from car where plate_num=plate_number; 
   dbms_output.put_line('car model  '|| m);

  end carmodel;
 /
 /*
   set serveroutput on;

BEGIN 

carmodel(333);
END;
/
*/
 ----PROCEDURE 2----i.* count number of accedent for the car
 set serveroutput on;
 CREATE OR REPLACE PROCEDURE accedentcounter(plate_number IN number) IS
 allcount number;
 BEGIN
 
 select count(*) into allcount from Car_accident
 where plate_num = plate_number;
 
 dbms_output.put_line('the total number of accedent=' || allcount );
 end accedentcounter;
 /
 /*
BEGIN 

accedentcounter(666);
END;
/
*/

-----PROCEDURE 3 -----show the City of  Accedent based on report number------
DROP PROCEDURE cityOfacc; 
   set serveroutput on;
 CREATE OR REPLACE PROCEDURE cityOfacc(repnum IN number) IS  c varchar2(255);
 begin
 select location into c from Accident where reportnum=repnum; 
   dbms_output.put_line('City Of Accedent '|| c );

  end cityOfacc;
 /
 --------------
/*BEGIN 

cityOfacc(224);
END;
/
*/

----------------------j------------------------------------
----------trigger 1 checks the plate number and if it has an accident then he will not be able to get an insurance
DROP TRIGGER insurance_policy; 
 CREATE TRIGGER insurance_policy
    BEFORE insert or update ON Insurance
    FOR EACH ROW 
DECLARE
   c_accCout NUMBER(10);
 
BEGIN
  select count(*) into c_accCout 
from Car_accident 
where plate_num=:new.plate_num;
	
    If c_accCout > 0 Then
        raise_application_error(-20001, 'Driver has accidents');
    End If;
	exception
  when others then
    dbms_output.put_line(sqlcode||' '||sqlerrm);

END;
/
  
 --insert into Insurance values (973,'01-Jan-18','01-feb-19','P',144,2);
 --insert into Insurance values (029,'01-Jan-18','01-feb-19','P',666,2);
 
----------trigger 2 checks the customer age if it's under 18 then he will not be able to get an insurance
 DROP TRIGGER cus_age ;
CREATE OR REPLACE TRIGGER cus_age
 BEFORE INSERT OR UPDATE ON Customer
 FOR EACH ROW 
 BEGIN
 IF :new.DOB>'1-jan-04' THEN
 raise_application_error(-20001, 'Age should not be less than 18'); 
 END IF;
	exception
  when others then
    dbms_output.put_line(sqlcode||' '||sqlerrm);
END;
/


-- insert into Customer values (20,'shosho','0500030','03-sep-03','220500');
  --insert into Customer values (16,'shosho','0500040','03-sep-05','220900');
  
  