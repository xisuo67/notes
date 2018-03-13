  use Test
  drop table  students,course,sc
 create table  students  
 (  
    SNO varchar(20) primary key,  
     SNAME varchar(20) ,  
     AGE int,  
     SEX  char(2) check(sex='男' or sex='女') not null   
 );  
 insert into students values('1','李强',23,'男');  
 insert into students values('2','刘丽',22,'女');  
 insert into students values('5','张友',22,'男');  

 create table course  
 (  
     CNO varchar(20) primary key,  
     CNAME varchar(20) ,  
     TEACHER varchar(20),  
 );  
 insert into course values('K1','C语言','王华');  
 insert into course values('K5','数据库原理','程军');  
 insert into course values('K8','编译原理','程军');  
   
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
 
 --检索至少选修＂程军＂老师所授全部课程的学生姓名（SNAME）

select sname from students 
where not exists 
(
select * from course
where TEACHER='程军' and not exists
(
 select * from sc where
 course.CNO=sc.CNO and sc.SNO=students.SNO
)
)

--检索＂李强＂同学不学课程的课程号(CNO)

select cno,course.CNAME from course
 where CNO not in
 (
	select sc.CNO from sc,students
	where students.SNAME='李强' and sc.SNO=students.SNO
 )
 
 --检索选修不少于3门课程的学生学号(SNO)
select sc.SNO  from sc
group by sc.SNO having COUNT(*)>=3

  --检索选修全部课程的学生姓名(SNAME)
  select students.SNAME from students
  where not exists(
	select * from course
	where not exists
	(
		select * from sc
		where course.CNO=sc.CNO and students.SNO=sc.SNO
	)
  )
   