 Oracle总结笔记
===========================
记录oracle的一些总结，用于平时回顾使用。

****
|Author|xisuo67|
|---|---
|E-mail|392706283@qq.com
****

## 目录
* [将空值转化为实际值](#将空值转化为实际值)
* [拼接列](#拼接列)
* [语句中使用逻辑条件](#语句中使用逻辑条件)
* [限制返回的行数](#限制返回的行数)
* [从列表中随机返回多条记录]（#从列表中随机返回多条记录）


### 将空值转化为实际值
 >select **coalesce**(comm,0) from emp;
```
 Create or replace View v as 
 select null as c1,null as c2,1 as c3,null as c4,2 as c5,null as c6 from dual Union all 
 select null as c1,null as c2,null as c3,3 as c4,null as c5, 2 as c6 from dual;
 
 select * from v
```
 |C1|C2|C3|C4|C5|C6|
 |--|--|--|--|--|--|
 |  |  |1 |  |2 |  |
 |  |  |  |3 |  | 2|
 ```
 select Coalese(c1,c2,c3,c4,c5,c6) as c from v;
 ```
  可以看到，相对于nvl来说，**coalesce**支持多个参数，能很方便的返回第一个不为空的值。如果上面的语句改用nvl,就要嵌套很多层。
```
  select nvl(nvl(nvl(nvl(nvl(c1,c2),c3),c4),c5),c6) as c from v;
```
 所以如果要用到空值转化为实际值，最好使用coalesce

### 拼接列
 拼接列可以使用字符串连接字符“||”来把各列拼接到一起。
```
 select ename || '的工作是' || job as msg from emp where departno=10;
 Msg
 ----------------------------------------------
 Chark 的工作是Manager
```
### 语句中使用逻辑条件
 有时为了更清楚的区分返回的信息，需要做如下处理。
 如：当值员工资小于或等于2000时，就返回消息“过低”，大于或等于4000时，返回过高，如果在这两者之间，就返回“OK”。
 类似这种需求也许会经常遇到，处理这样的需求可以用Case When 来判断转化。
```
 select ename,sal,
   case
    when sal<=2000 then '过低'
    when sal>=4000 then '过高'
    else 'Ok'
   end as status
   from emp where deptno=10;
---------------------------------------------------------
ename       sal     status
Clark       2450     Ok
king        5000     过高
M           1300     过低
```
### 限制返回的行数
 在查询时，并不是每次都要返回所有数据，比如，在进行抽查的时候会要求只返回两条数据。
 我们可以使用伪列rownum来过滤，rownum依次对返回的每一条数据做一个标识。
```
 select * from emp where rownum<=2;
```
 如果直接使用rownum=2作为查询条件会出现什么情况呢？
 ```
 select * from emp where rownum=2;
 
 no row selected
 ```
  因为rownum是依次对数据做标识的，就像上学时依据考分排名一样，需要有第一名，后面才会有第二名。所以要先把所有的数据取出来，才能确认第二名。
  正确的取第二行数据的查询应该像下面这样，先生成序号：
```
select * from (
 select rownum as sn.,emp.* from emp where rownum<=2)
) where sn=2;
```
### 从列表中随机返回多条记录
使用dbms_random 可以对数据进行随机排序。如下：
```
select empno,ename from (
 select empno,ename from emp order by dbms_random.value()
) where rownum<=3;
```
