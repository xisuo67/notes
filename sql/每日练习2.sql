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