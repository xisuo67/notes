  use Test
  drop table  students,course,sc
 create table  students  
 (  
    SNO varchar(20) primary key,  
     SNAME varchar(20) ,  
     AGE int,  
     SEX  char(2) check(sex='��' or sex='Ů') not null   
 );  
 insert into students values('1','��ǿ',23,'��');  
 insert into students values('2','����',22,'Ů');  
 insert into students values('5','����',22,'��');  

 create table course  
 (  
     CNO varchar(20) primary key,  
     CNAME varchar(20) ,  
     TEACHER varchar(20),  
 );  
 insert into course values('K1','C����','����');  
 insert into course values('K5','���ݿ�ԭ��','�̾�');  
 insert into course values('K8','����ԭ��','�̾�');  
   
 create table  sc  
 (  
     SNO varchar(20) NOT NULL,  
     CNO varchar(20) NOT NULL,  
     SCORE int NOT NULL,  
     primary key (SNO,CNO),  
 );  
 insert into sc values('1','K1',83);  
 insert into sc values('2','K1',85);  
 insert into sc values('5','K1',92);  
 insert into sc values('2','K5',90);  
 insert into sc values('5','K5',84);  
 insert into sc values('5','K8',80); 
 
 --��������ѡ�ޣ��̾�����ʦ����ȫ���γ̵�ѧ��������SNAME��

select sname from students 
where not exists 
(
select * from course
where TEACHER='�̾�' and not exists
(
 select * from sc where
 course.CNO=sc.CNO and sc.SNO=students.SNO
)
)

--��������ǿ��ͬѧ��ѧ�γ̵Ŀγ̺�(CNO)

select cno,course.CNAME from course
 where CNO not in
 (
	select sc.CNO from sc,students
	where students.SNAME='��ǿ' and sc.SNO=students.SNO
 )
 
 --����ѡ�޲�����3�ſγ̵�ѧ��ѧ��(SNO)
select sc.SNO  from sc
group by sc.SNO having COUNT(*)>=3

  --����ѡ��ȫ���γ̵�ѧ������(SNAME)
  select students.SNAME from students
  where not exists(
	select * from course
	where not exists
	(
		select * from sc
		where course.CNO=sc.CNO and students.SNO=sc.SNO
	)
  )
   