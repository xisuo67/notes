use Test
--����sql������ɰ�����ͳ�Ʋɹ���ϸ�ϼƱ���
create table vp
(
	vid int identity(1,1) primary key not null ,
	vName  varchar(50),
	vCount int,
	vDate datetime,
)
insert vp values('��',200,2014/01/01)

insert vp values('Բ���',235,2014/01/02)
insert vp values('Բ���',275,2014/02/02)
insert vp values('Բ���',355,2014/02/02)
insert vp values('�ʼǱ�',100,2014/03/11)
insert vp values('�ʼǱ�',300,2014/03/22)

select * from vp

select vName, SUM(vCount) as total,YEAR(vDate) as [Year],MONTH(vDate) as [Month] from vp
group by vName,YEAR(vDate),MONTH(vDate)



--==================================================================================================================
--															�½���ѯ
--==================================================================================================================
Create database Student
use Student
create table student
(
sno varchar(3) not null,
sname varchar(4) not null,
ssex varchar(2) not null,
sbirthday datetime,
class varchar(5)
)

create table courses
(
cno varchar(5) not null,
cname varchar(10) not null,
tno varchar(10) not null
)

create table scores
(
	sno varchar(3) not null,
	cno varchar(5) not null,
	degree numeric(10,1) not null
)

create table teachers
(
	tno varchar(3) not null,
	tname varchar(4) not null,
	tsex varchar(2) not null,
	tbirthday datetime not null,
	prof varchar(6),
	depart varchar(10) not null
)

INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (108 ,'����' ,'��' ,'1977-09-01',95033);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (105 ,'����' ,'��' ,'1975-10-02',95031);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (107 ,'����' ,'Ů' ,'1976-01-23',95033);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (101 ,'���' ,'��' ,'1976-02-20',95033);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (109 ,'����' ,'Ů' ,'1975-02-10',95031);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (103 ,'½��' ,'��' ,'1974-06-03',95031);

INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('3-105' ,'���������',825);
INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('3-245' ,'����ϵͳ' ,804);
INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('6-166' ,'���ݵ�·' ,856);
INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('9-888' ,'�ߵ���ѧ' ,100);

INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (103,'3-245',86);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (105,'3-245',75);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (109,'3-245',68);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (103,'3-105',92);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (105,'3-105',88);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (109,'3-105',76);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (101,'3-105',64);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (107,'3-105',91);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (108,'3-105',78);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (101,'6-166',85);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (107,'6-106',79);
INSERT INTO SCORES(SNO,CNO,DEGREE)VALUES (108,'6-166',81);

INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (804,'���','��','1958-12-02','������','�����ϵ');
INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (856,'����','��','1969-03-12','��ʦ','���ӹ���ϵ');
INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (825,'��Ƽ','Ů','1972-05-05','����','�����ϵ');
INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (831,'����','Ů','1977-08-14','����','���ӹ���ϵ');


--1����ѯStudent���е����м�¼��Sname��Ssex��Class��
select sname,ssex,class from student
--2����ѯ��ʦ���еĵ�λ�����ظ���Depart�С�
select depart from teachers group by depart
--3����ѯStudent������м�¼��
select * from student
--4����ѯScore���гɼ���60��80֮������м�¼��
select * from scores where degree between 60 and 80

