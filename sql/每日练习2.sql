use Test
--请用sql语句生成按年月统计采购明细合计报表
create table vp
(
	vid int identity(1,1) primary key not null ,
	vName  varchar(50),
	vCount int,
	vDate datetime,
)
insert vp values('书',200,2014/01/01)

insert vp values('圆珠笔',235,2014/01/02)
insert vp values('圆珠笔',275,2014/02/02)
insert vp values('圆珠笔',355,2014/02/02)
insert vp values('笔记本',100,2014/03/11)
insert vp values('笔记本',300,2014/03/22)

select * from vp

select vName, SUM(vCount) as total,YEAR(vDate) as [Year],MONTH(vDate) as [Month] from vp
group by vName,YEAR(vDate),MONTH(vDate)



--==================================================================================================================
--															新建查询
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

INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (108 ,'曾华' ,'男' ,'1977-09-01',95033);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (105 ,'匡明' ,'男' ,'1975-10-02',95031);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (107 ,'王丽' ,'女' ,'1976-01-23',95033);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (101 ,'李军' ,'男' ,'1976-02-20',95033);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (109 ,'王芳' ,'女' ,'1975-02-10',95031);
INSERT INTO STUDENT (SNO,SNAME,SSEX,SBIRTHDAY,CLASS) VALUES (103 ,'陆君' ,'男' ,'1974-06-03',95031);

INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('3-105' ,'计算机导论',825);
INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('3-245' ,'操作系统' ,804);
INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('6-166' ,'数据电路' ,856);
INSERT INTO COURSES(CNO,CNAME,TNO)VALUES ('9-888' ,'高等数学' ,100);

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

INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (804,'李诚','男','1958-12-02','副教授','计算机系');
INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (856,'张旭','男','1969-03-12','讲师','电子工程系');
INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (825,'王萍','女','1972-05-05','助教','计算机系');
INSERT INTO TEACHERS(TNO,TNAME,TSEX,TBIRTHDAY,PROF,DEPART) VALUES (831,'刘冰','女','1977-08-14','助教','电子工程系');


--1、查询Student表中的所有记录的Sname、Ssex和Class列
select sname,ssex,class from student
--2、查询教师所有的单位即不重复的Depart列。
select depart from teachers group by depart
--3、查询Student表的所有记录。
select * from student
--4、查询Score表中成绩在60到80之间的所有记录。
select * from scores where degree between 60 and 80

