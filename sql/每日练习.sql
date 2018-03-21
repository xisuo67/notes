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
 insert into students values('3','李强1',24,'女');
 insert into students values('4','李强2',28,'女');
 insert into students values('6','李强3',29,'男');
 insert into students values('2','刘丽',22,'女');  
 insert into students values('5','张友',22,'男');  

 create table course  
 (  
     CNO varchar(20) primary key,  
     CNAME varchar(20) ,  
     TEACHER varchar(20),  
 );  
insert into course values('K1','C语言','王华');  
insert into course values('K2','C++语言','王强'); 
insert into course values('K3','Java语言','王宝强')
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
   
   --检索不学"编译原理"的学生信息
   select * from students
   where students.SNO not in 
   (
	  select sc.sno from sc,course  
      where course.cno=sc.cno and course.CNAME='编译原理'
   )
   
   --查询“程军”老师所教授的所有课程
   select * from course
   where course.TEACHER='程军'
   
   --查询“张友”同学所有课程的成绩
--方法一:
select a.SCORE,a.CNO,b.CNAME from sc  a
left join course b 
on b.CNO=a.CNO
left join students c
on  c.SNO=a.SNO where c.SNAME='张友' 
--方法二:

select a.SCORE,a.CNO,b.CNAME from course b
left join 
(select Score,sc.CNO from students,sc
where students.SNAME='张友' and students.SNO=sc.SNO) a
on a.CNO=b.CNO

--方法三:

select Score,sc.CNO,course.CNAME from students,sc,course
where students.SNO=sc.SNO and students.SNAME='张友' and course.CNO=sc.CNO

--查询课程名为“C语言”的平均成绩
--方法一:
select avg(sc.SCORE) as score from sc,course
where course.CNAME='C语言' and course.CNO=sc.CNO
--方法二:
select course.CNAME, AVG(sc.SCORE) as score from sc,course
where course.CNO=sc.CNO and course.CNAME='C语言' group by course.CNAME

--查询选修了所有课程的同学信息

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
--检索王老师所授课程的课程号和课程名

select * from course where TEACHER like '王%'
--检索年龄大于23岁的男学生的学号和姓名

select students.SNO,students.SNAME from students where SEX='男' and AGE>=23

--检索至少选修王老师所授课程中一门课程的女学生姓名

select students.SNAME from students
where students.SEX='女' and students.SNO in 
(
	select distinct sc.SNO from sc,course
	where sc.CNO=course.CNO and course.TEACHER like '王%'
)
delete from students where SNO in (3,4,6)
--检索李同学不学的课程的课程号
select cno,course.CNAME from course
where CNO not in 
(
	select CNO from students,sc
	where students.SNO=sc.SNO
	and students.SNAME like '李%'
)
--检索至少选修两门课程的学生学号
select sc.sno from sc group by sc.sno
having( count(*)>=2)

--检索全部学生都选修的课程的课程号与课程名
select course.CNO,course.CNAME from course
where course.CNO in (
	select sc.CNO from sc
	group by CNO having count(*)=(select COUNT(*) from students)
)
--检索选修课程包含王老师所授课的学生学号
--方法一
select students.SNAME,students.SNO from students
where students.SNO in(
	select sc.SNO from sc,course where sc.CNO=course.CNO
	and course.TEACHER like '王%'
)
--方法二:
 SELECT DISTINCT sno FROM sc  
 WHERE cno IN  
 (  
      SELECT cno FROM course  
     WHERE teacher LIKE '王%'  
);  

--统计有学生选修的课程门数
--方法一
select COUNT(*) Number from 
(
	select distinct sc.CNO from sc
	group by sc.CNO
) as bb
--方法二
select COUNT(*) as number from(select distinct sc.CNO from sc
group by sc.CNO) a
--求选修K1课程的学生的平均年龄。
--方法一
select AVG(students.AGE) as avgAge from students,sc
where students.SNO=sc.SNO and sc.CNO='K1'
--方法二
select AVG(students.AGE) as avgAge from students
where students.SNO in(
	select SNO from sc 
	where CNO='K1'
)
--方法三
select AVG(students.AGE) as AvgAge from students
left join sc on sc.SNO=students.SNO and sc.CNO='K1'

--方法四
select AVG(students.AGE) as avgAge from students
left join sc on sc.SNO=students.SNO where sc.CNO='K1'

--求王老师所授课程的每门课程的学生平均成绩。
use test
select * from students
select * from sc
select * from course
--方法一


--方法二
select a.AvgScore,a.CNO,course.CNAME from course,(
select sc.CNO,AVG(sc.SCORE) as AvgScore from sc
where sc.CNO in 
(
	select course.CNO from course
	where course.TEACHER='王华'
)
group by sc.CNO) a where a.CNO=course.CNO