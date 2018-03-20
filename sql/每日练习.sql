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
 insert into students values('3','��ǿ1',24,'Ů');
 insert into students values('4','��ǿ2',28,'Ů');
 insert into students values('6','��ǿ3',29,'��');
 insert into students values('2','����',22,'Ů');  
 insert into students values('5','����',22,'��');  

 create table course  
 (  
     CNO varchar(20) primary key,  
     CNAME varchar(20) ,  
     TEACHER varchar(20),  
 );  
insert into course values('K1','C����','����');  
insert into course values('K2','C++����','��ǿ'); 
insert into course values('K3','Java����','����ǿ')
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
   
   --������ѧ"����ԭ��"��ѧ����Ϣ
   select * from students
   where students.SNO not in 
   (
	  select sc.sno from sc,course  
      where course.cno=sc.cno and course.CNAME='����ԭ��'
   )
   
   --��ѯ���̾�����ʦ�����ڵ����пγ�
   select * from course
   where course.TEACHER='�̾�'
   
   --��ѯ�����ѡ�ͬѧ���пγ̵ĳɼ�
--����һ:
select a.SCORE,a.CNO,b.CNAME from sc  a
left join course b 
on b.CNO=a.CNO
left join students c
on  c.SNO=a.SNO where c.SNAME='����' 
--������:

select a.SCORE,a.CNO,b.CNAME from course b
left join 
(select Score,sc.CNO from students,sc
where students.SNAME='����' and students.SNO=sc.SNO) a
on a.CNO=b.CNO

--������:

select Score,sc.CNO,course.CNAME from students,sc,course
where students.SNO=sc.SNO and students.SNAME='����' and course.CNO=sc.CNO

--��ѯ�γ���Ϊ��C���ԡ���ƽ���ɼ�
--����һ:
select avg(sc.SCORE) as score from sc,course
where course.CNAME='C����' and course.CNO=sc.CNO
--������:
select course.CNAME, AVG(sc.SCORE) as score from sc,course
where course.CNO=sc.CNO and course.CNAME='C����' group by course.CNAME

--��ѯѡ�������пγ̵�ͬѧ��Ϣ

select * from students
where not exists
(
	select * from course
	where not exists
	(
		select * from sc
		where course.CNO=sc.CNO and students.SNO=sc.SNO
	)
)
--��������ʦ���ڿγ̵Ŀγ̺źͿγ���

select * from course where TEACHER like '��%'
--�����������23�����ѧ����ѧ�ź�����

select students.SNO,students.SNAME from students where SEX='��' and AGE>=23

--��������ѡ������ʦ���ڿγ���һ�ſγ̵�Ůѧ������

select students.SNAME from students
where students.SEX='Ů' and students.SNO in 
(
	select distinct sc.SNO from sc,course
	where sc.CNO=course.CNO and course.TEACHER like '��%'
)
select * from students
select * from sc
select * from course
delete from students where SNO in (3,4,6)
--������ͬѧ��ѧ�Ŀγ̵Ŀγ̺�
select cno,course.CNAME from course
where CNO not in 
(
	select CNO from students,sc
	where students.SNO=sc.SNO
	and students.SNAME like '��%'
)
--��������ѡ�����ſγ̵�ѧ��ѧ��
select sc.sno from sc group by sc.sno
having( count(*)>=2)

--����ȫ��ѧ����ѡ�޵Ŀγ̵Ŀγ̺���γ���