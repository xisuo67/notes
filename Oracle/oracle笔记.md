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
* [从列表中随机返回多条记录](#从列表中随机返回多条记录)
* [模糊查询](#模糊查询)
* [字符替换](#字符替换)
* [按数字和字母混合字符串中的字母排序](#按数字和字母混合字符串中的字母排序)
* [处理排序空值](#处理排序空值)
* [根据条件取不同列中的值来排序](#根据条件取不同列中的值来排序)
* [多表连接解析](#多表连接解析)
    * [内连的特点](#内连的特点)
    * [左连的特点](#左连的特点)  
    * [右连的特点](#右连的特点)  
    * [全连接的特点](#全连接的特点)  
    * [外连接中的条件不要乱放](#外连接中的条件不要乱放)
 * [插入更新与删除](#插入更新与删除)
     * [阻止对某几列插入](#阻止对某几列插入)
     * [复制表的定义及数据](#复制表的定义及数据)
     * [限制数据录入](#限制数据录入)  
     * [多表插入语句](#多表插入语句)  
 * [遍历字符串](#遍历字符串)
     * [字符串文字中包含引号](#字符串文字中包含引号)
-------------------------------------------------------
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
 
------------------------------------------------------
### 拼接列
 拼接列可以使用字符串连接字符“||”来把各列拼接到一起。
```
 select ename || '的工作是' || job as msg from emp where departno=10;
 Msg
 ----------------------------------------------
 Chark 的工作是Manager
```
------------------------------------------------
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
--------------------------------------------------------
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
---------------------------------------------
### 从列表中随机返回多条记录
使用dbms_random 可以对数据进行随机排序。如下：
```
select empno,ename from (
 select empno,ename from emp order by dbms_random.value()
) where rownum<=3;
```
-------------------------------------------
### 模糊查询
 先建立如下视图：
```
 create or replace view v as 
 select 'ABCDEF' as vname from dual
 union all 
 select '_BCEFG' as vname from dual
 union all 
 select '_BCEDF' as vname from dual
 union all
 select '_\BCEDF' as vname from dual
 union all
 select 'XYCEG' as vname from dual;
```
 要求一：查出vname 中包含的字符串“CED”。
 方法比较简单，select * from v where vname like '%CED%'
 要求二：查出vname中包含字符串"_BCE"的。
 ```
 select * from v where vname like '_BCE%';
 --------------------------------------------
 ABCEDF
 _BCEFG
 _BCEDF
 3 rows selected
 ```
 
  发现多了一个ABCEDF。因为在like子句中有两个通配符："%"（代替一个或多个字符）、"_"(代替一个或多个字符)。
在这里，"_"被当作通配符了，怎么办呢？莫急，我们可以用转义字符：  
```
 select * from v where vname like '\_BCE%' escape '\'
-----------------------------------------------------------------
_BCEFG
_BCEDF
2 rows selected
```

  escape把'\'标识为转义字符，而'\'把'_'转义为字符，而非通配符。
  或许有人注意到其中有一行值为'_\BCEDF'。那么加上了escape'\' 后怎么返回这一行数据呢？
  没错，双写转义字符即可：
  
```
select * from v where vname like '_\\BCE%' escape '\';
-------------------------------------------------------------
_\BCEDF
1 rows selected
```

 对于字符串中包含"%"的情况，上面处理方法一样。
 
 --------------------------------------------------------------------
 ### 字符替换
  Translate,语法格式：Translate(expr,from_string,to_string)
  示例如下：
  
 ```
  select Translate('ab 你好 bcadefg','abcdefg','1234567') as new_str from dual;
 ----------------------------------------------------------------------------------
 12 你好 2314567
 1 row selected
 ```
 
  from_string与to_string 以字符为单位，对应字符一一替换  
  如果to_stirng为空值，则返回空值。
  
```
 select translate('ab 你好 bcadefg','abcdefg','') as new_str from dual;
-----------------------------------------------------------------------------------
null
1 row selected
```

 如果to_string对应的位置没有字符，删除from_string中对应的列出的字符将会被消掉
```
 select translate('ab 你好 bcadefg','labcdefg','1') as new_str from dual;
-----------------------------------------------------------------------------------
你好
1 row selected
```
---------------------------------------------------------
### 按数字和字母混合字符串中的字母排序
 首先创建View如下：
 ```
  Create or Replace View v
  as 
  Select empno || ' ' || ename as data from emp;
 ```
 ```
  select * from v;
  --------------------
  7369 smith
  7449 allen
  ...  ...
  7990 james
  7902 ford
  7934 miller
  14 rows selected
 ```
  这个需求就难一点了，看原来的ename列，要求按期中的字母列ename排序
  那么就要先去出其中的字母才行，我们可以用translate的替换功能，把数字与空格都替换为空：
 ```
  select data,translate(data,'- 0123456789','-') as name
  2 from v
  3 order by 2;
  
  data              ename
  ------------------------
  7876 adms         adams
  7499 allen        allen
  7698 blake        blake
  ...  ....
  7369 smith        smith
  7844 turner       turner
  7521 ward         ward
  14 rows selected
 ```
 --------------------------------------------------------------------------------------
### 处理排序空值
 oracle 默认排序空值在后面，如果想把空值（如 emp.comm）显示在前面怎么办，用Nvl(comm,-1)吗？
 ```
  select ename,sal,comm,nvl(comm,-1) order_col from emp order by 4;
  ename        sal        comm      order_col
  -------------------------------------------------
  smith        800                    -1
  ...     ....
  martin       1250      1400        1400
  14 rows selected
 ```
 也许很多人都是用这种方法，但这种方法需要对列类型及保存的数据有所了解才行，而且保存的数据如果有变化，该语句就要重新维护。
 其实可以使用关键字 **nulls first** 和 **nulls last**
 空值在前面
 ```
  select ename,sal,comm from emp order by 3 nulls first;
  ename     sal     comm
  ------------------------------
  smith     800
  ...       ...
  martin    1250    1400
 ```
 空值在后面
 ```
  select ename,sal,comm from emp order by 3 nulls last;
    ename     sal     comm
  ------------------------------
  martin    1250    1400
  ...       ...
  smith     800
 ```
 是不是方便得多？
 
 -------------------------------------------------------------------

### 根据条件取不同列中的值来排序
 有时排序的要求会比较复杂，比如：领导对工资在1000-2000之间的员工更感兴趣，于是要求工资在这个范围的员工要排在前面，以便优先查看。
 对于这种需求，我们可以再查询中新生成一列，用多列排序的方法处理：
 ```
  select empno as 编码,
         ename as 姓名,
         case when sal>=1000 and sal<2000 then 1 else 2 as 级别,
         sal as 工资
  from emp
  where deptno=30
  order by 3,4
 ```
 
 
 |编码| 姓名  |级别|工资|
  |--|--|--|--|
 |7654|martin|  1 |1250
 |7521|ward|1|1250
 |7844|turner|1|1500
 |7499|allen|1|1600
 |7900|james|2|950
 |7698|blake|2|2850

 可以看到，950与2850都排在了后面，也可以不显示级别，直接把case when 放在order by 中：
 ```
  select empno as 编码,
   ename as 姓名,
   sal as 工资
   from emp
   where deptno=30
   order by case when sal>=1000 and sal<2000 then 1 esle 2 end,3;
 ```
  |编码| 姓名|工资|
  |--|--|--|
 |7654|martin|1250
 |7521|ward|1250
 |7844|turner|1500
 |7499|allen|1600
 |7900|james|950
 |7698|blake|2850
 
 ------------------------------------------
 ### 多表连接解析
  关于Inner Join、Left Join、Right Join和Full Join解析。很多人对于这几种连接方式，特别是Left Join与Rigth Join分不清楚，下面通过案例解析一下。方便大家直观学习。
  首先建立两个测试表
  ```
   Drop table L PurGe;
   Drop table R PurGe;
   /*左表*/
   Create Table L as
   Select 'Left_1' as str,'1' as V from dual Union All
   select 'Left_2','2' as V from dual union all
   select 'Left_3','3' as V from dual Union all
   select 'Left_4','4' as V from dual;
   /*右表*/
   Create Table R as
   Select 'right_3' as str,'3' as v,1 as status from dual Union all
   Select 'rigth_4' as str,'4' as v,0 as status from dual Union all
   Select 'right_5' as str,'5' as v,0 as status from dual Union all
   Select 'right_6' as str,'6' as v,0 as status from dual;
  ```
  ----------------------------------------------------------------
  ### 内连的特点
   Inner Join的特点，该方式放回两表相匹配的数据，左表的“1、2”，以及右表的“5、6”都没有显示。
 ```
   select l.str as left_str,r.str as right_str
   from l
   inner join r on l.v=r.v
   order by 1,2;
   
 ``` 
 
  |Left_str|Rigth_str|
 |--|--|
 | left_3 | rigth_3 |
 | left_4 | left_4 | 
 
 --------------------------------------------------------------
 ### 左连的特点
 left join的特点，该方式以左表为主表，左表返回所有数据，右表中只返回与左表匹配的数据，“5、6”都没有显示。
 ```
   select l.str as left_str,r.str as right_str
      from l
      left join r on l.v=r.v
      order by 1,2;
 ```
   |Left_str|Rigth_str|
 |--|--|
 | left_1 ||
 | left_2 ||
 |left_3|rigth_3
 |left_4|rigth_4
 
 加（+）后的写法：
 ```
   select l.str as left_str,r.str as right_str
      from l,r
      where l.v=r.v(+)
      order by 1,2;
 ```
 ----------------------------------------------------------------
 
  ### 右连的特点
   rigth join的特点，该方式以右表为主，左表中只返回与右表匹配的数据“3、4”，而“1、2”都没有显示，右表返回所有的数据
```
select l.str as left_str,r.str as right_str
   from l 
   right join r on l.v=r.v
   order by 1,2;
```
   |Left_str|Rigth_str|
 |--|--|
 |left_3|rigth_3
 |left_4|rigth_4
 ||right_5
 ||right_6
 
 加（+）后的写法
 ```
   select l.str as left_str,r.str as right_str
      from l,r
      where l.v(+)=r.v
      order by 1,2;
 ```
 
----------------------------------------------------------------------
### 全连接的特点
 full join的特点；该方式的左右表均返回所有的数据，但只有相匹配的数据显示在同一行，非匹配的行只显示一个表的数据。
 ```
   select l.str as left_str,r.str as rigth_str
      from l
      full join r on r.v=l.v
      order by 1,2;
 ```
   |Left_str|Rigth_str|
 |--|--|
 |left_1|
 |left_2|
 |left_3|rigth_3
 |left_4|rigth_4
 ||right_5
 ||right_6
 
 **注意：** full join无（+）的写法
 
-------------------------------------------------------------------------

### 外连接中的条件不要乱放
```
   select l.str as left_str,r.str as right_str,r.status
      from l 
      left join r on l.v=r.v
      order by 1,2;
```
   |Left_str|Rigth_str|Status
 |--|--|--|
 | left_1 ||
 | left_2 ||
 |left_3|rigth_3|1
 |left_4|rigth_4|0
 
   对于其中的L表，四条数据都返回了。而对于R表，我们只需要显示其中的status=1的部分，也就是r.v=4的部分
   结果应为：
   ```
   Left_str          Right_str
   ----------------------------------------
   Left_1
   Left_2
   Left_3            right_3
   Left_4
   
   4 row selected
   ```
   对于这种需求，会有人直接在上面的语句中加入条件status=1，写出如下语句：
   ```
      select l.str as left_str,r.str as right_str,r.status
         from l 
         left join r on l.v=r.v
         where r.status=1
         order by 1,2;
   ```
   （+）用法：
   ```
      select l.str as left_str,r.str as right_str,r.status
      from l,r
      where l.v=r.v(+)
      and r.status=1
      order by 1,2;
   ```
   这样的查询结果为：
  ```
   Left_str          Right_str            Status
   -------------------------------------------------
   left_3            right_3                 1
   1 row selected
  ```
   很明显，与我们期望得到的结果不一致，这是很多人在写查询语句或更改查询时遇到的一种错误。问题就在于所加的条件的位置及写法，正确的写法分别如下：
   ```
      select l.str as left_str,r.str as right_str,r.status
         from l 
         left join r on (l.v=r.v and r.status=1)
         order by 1,2;
   ```
   (+)用法：
   ```
      select l.str as left_str,r.str as right_str,r.status
         from l,r
         where l.v=r.v(+)
         and r.status(+)=1
         order by 1,2;
   ```
   以上两种写法中，join的方式明显更容易辨别，这也是本人建议使用join的原因。语句也可以像下面这样写，先过滤，再用join，这样写会更加清晰。
   ```
      select l.str as left_str,r.str as right_str,r.status
         from l
         left join r (select * from r where r.status=1) r on (l.v=r.v)
         order by 1,2;
   ```
   
------------------------------------------------------------------------
### 插入更新与删除
 插入新记录
 我们先建立测试表，各列都有默认值。

```
   create table test(
      c1 varchar2(10) defalut '默认1',
      c2 varchar2(10) defalut '默认2',
      c3 varchar2(10) defalut '默认3',
      c4 Date delfault SysDate,
   );
```
新增数据如下：
```
   insert into testt(c1,c2,c3) values(default,null,'手动赋值');
   select * from test;
   C1       C2       C3       C4
   ----------------------------------
   默认1              手动赋值   2018-09-22
   1 row selected
   
```
   注意以下几点：
   
   1、如果insert语句中没有含默认值的列，则会添加默认值，如C4列。 
   
   2、如果包含有默认值的列，需要使用default关键字，才会添加默认值，如C1列。
   
   3、如果已显示设定了NULL或者其他值，则不会再生成默认值，如C2、C3列。
   
--------------------------------------------------------------------------
### 阻止对某几列插入
   我们建立表中C4列默认值为sysDate，这种列一般是为了记录数据生成时间，不允许手动录入。我们可以建立一个不包含C4列的view,新增数据时通过这个view就可以了。
```
   Create or Replace view v_test as select c1,c2,c3 from test;
   insert into v_test(c1,c2,c3) Values('手输C1',Null,'不能改C4');
   select * from test;
      C1       C2       C3       C4
   ----------------------------------
   默认1              手动赋值   2018-09-22
   手输C1             不能改C4   2018-09-22
   2 row selected
```
**注意，通过view新增数据，不能再使用关键字default。**

----------------------------------------------------------------------------
### 复制表的定义及数据
   我们可以通过以下语句复制表test;
   ```
      create table test2 as select * from test;
   ```
   也可以先复制表的定义，再新增数据；
   ```
      create table test2 as select * from test where 1=2;
   ```
   **注意：复制的表不包含默认值等约束信息，使用这种方式复制表后，需要重新默认值索引和约束等信息。**

----------------------------------------------------------------------------------------------
### 限制数据录入
   用With Check Option限制数据录入。当约束条件比较简单的时候，可以直接加在表中，如工资必须大于0：
   ```
   alert table emp add constraints ch_sal(sal>0);
   ```
   但有些复杂或特殊的约束条件是不能这样放在表里的，如雇佣日期大于当前日期：
   ```
   alert table emp add constraints ch_hiredate check(hiredate>=sysdate);
   ora-02436:日期或系统变量在check约束条件中指定错误
   ```
   这时我们可以使用加了with check option关键字的view来达到目的。
   下面的示例中，我们限制了不符合内联视图条件的数据（sysdate+1）:
   ```
   insert into
   (select empno,ename,hiredate
      from emp
      where hiredate<=sysdate with check option)
    Values
      (9999,'test',sysdate+1);
    insert into
    (select empno,ename,hiredate
      from emp
      where hiredate<=sysdate with check option)
     Values
      (9999,'test',sysdate+1);
     
    ora-01402:视图 with check option where 子句违规
   ```
   语句（select empno,ename,hiredate from emp where hiredate<=sysdate with check option）被当做一个视图处理。
   
   因为里面有关键字“with check option”,所以insert的数据不符合其中的条件（hiredate<=sysdate）时，就不允许利用insert。
   
   当跪着较复杂，无法用约束实现时，这种限制方式就比较有用了。
   
--------------------------------------------------------------------------------------------------
### 多表插入语句
多表插入语句分为以下四种：           
1、无条件insert          
2、有条件insert all               
3、转置insert              
4、有条件insert first          

首先建立两个测试用表：
```
   create table emp1 as select empno,ename,job from emp where 1=2;
   create table emp2 as select empno,ename,deptno from emp where 1=2;
```
**无条件insert：**
```
insert all
   into emp1(empno,ename,job) values (empno,ename,job)
   into emp2(empno,ename,deptno) values (empno,ename,deptno)
select empno,ename,job,deptno from emp where deptno in (10,20);

select * from emp1;
      empno          ename          job
    -------------------------------------
      7396           smith          clerk
      7566           jones          manager
      7782           clark          manager
      7788           scott          analyst
      7839           king           president
      7876           adams          clerk
      7902           ford           analyst
      7934           miller         clerk
      
 8 rows selected
 

select * from emp2;
      empno          ename          deptno
    -------------------------------------
      7396           smith          20
      7566           jones          20
      7782           clark          10
      7788           scott          20
      7839           king           10
      7876           adams          20
      7902           ford           20
      7934           miller         10
      
      8 rows selected
```
   因为没有加条件，所以会同时向两个表中插入数据，且两个表中插入的条数一样。
   
**有条件insert all：**
```
   delete emp1;
   delete emp2;
   insert all
      when job in ('salesman','manager') then
      into emp1(empno,ename,job) values (empno,ename,job)
      when deptno in ('20','30') then
      into emp2(empno,ename,deptno) values (empno,ename,deptno)
   select empno,ename,job,deptno from emp;
   
   
   select * from emp1;
   
   empno       ename       job
  --------------------------------
   7499        allen       salesman
   7521        ward        salesman
   7566        jones       manager
   7654        martin      salesman
   7698        blake       manager
   7782        clark       manager
   7844        turner      salesman
   
  7 rows selected
  
  select * from emp2;
   empno       ename       deptno
  --------------------------------
   7369        smith       20
   7499        allen       30
   7521        ward        30
   7566        jones       20
   7654        martin      30
   7698        blake       30
   7788        scott       20
   7844        turner      30
   7876        adams       20
   7900        jaems       30
   7902        ford        20
   
   11 rows selected
```
   当增加条件后，就会按条件插入。如empno=1654等数据在两个表中都有
   
**insert first就不一样：**
```
   delete emp1;
   delete emp2;
   /*有条件insert first*/
   insert first
      when job in ('salesman','manager') then
      into emp1(empno,ename,job) values (empno,ename,job)
      when deptno in ('20','30') then
      into emp2(empno,ename,deptno) values (empno,ename,deptno)
   select empno,ename,job,deptno from emp;
   
   select * from emp1;
   
   empno          ename          job
  -----------------------------------------
   7499           allen          salesman
   7521           ward           salesman
   7566           jones          manager
   7654           martin         salesman
   7698           blake          manager
   7782           clark          manager
   7844           turner         salesman
   
   7 rows selected
   
   
   select * from emp2;
   
   empno          ename          deptno
  -----------------------------------------
   7369           smith          20
   7788           scott          20
   7876           adams          20
   7900           james          30
   7902           ford           20
   
   5 row selected
```
  

insert first语句中，当第一个表符合条件后，第二个表将不再插入对应的行，表mep2中不再有表emp1相同的数据‘empno=7654’，这就是insert first与insert all的不同之处。

转置insert与其说是一个分类，不如说是insert all的一个用法。
```
   drop table t1;
   drop table t2;
   create table t2 (d varchar2(10),des varchar2(50));
   create table t1 as
   select '熊样,精神不佳' as d1,
   '猫样，温驯听话' as d2,
   '狗样，神气活现' as d3,
   '鸟样，向往明天' as d4,
   '花样，愿你快乐像花儿一样' as d5
   from dual;
   /*转置 insert*/
   insert all
   into t2(d,des) values('周一',d1)
   into t2(d,des) values('周二',d2)
   into t2(d,des) values('周三',d3)
   into t2(d,des) values('周四',d4)
   into t2(d,des) values('周五',d5)
   select d1,d2,d3,d4,d5 from t1;
   
   
   select * from t2;
    d          des          
  -------------------------
   周一        熊样,精神不佳         
   周二        猫样，温驯听话   
   周三        狗样，神气活现
   周四        鸟样，向往明天
   周五        花样，愿你快乐像花儿一样
   
   5 rows selected
```
可以看到，转置insert的实现就是把不同列的数据插入到筒仪表的不同行中，转置insert的等价语句如下：
```
insert into t2(d,des)
select '周一' d1 from t1 union all
select '周二' d2 from t1 union all
select '周三' d3 from t1 union all
select '周四' d4 from t1 union all
select '周五' d5 from t1;
```
  
--------------------------------------------------------------------------------------------------

### 遍历字符串
有时候会要求把字符串才氛围单个字符，如：
```
create or reaplace view v as
select '天天向上' as 汉字,'TTXS' as 首拼 from dual;
```
为了核对表中保存的“首拼”是否正确，需要把字符串才氛围下面的样式：

  |汉字|          首拼 |         
  |--|--
  |天|T
  |天|T
  |向|X
  |上|S
  
  在拆分之前，我们先看一个connect by 子句：
  ```
   select level from dual connect by level <=4;
   
   level
---------------------
   1
   2
   3
   4
   
4 rows selected
  ```
其中，connect by 是树形查询中的一个子句，后面的level是一个“伪列”，表示树形中的级别层次，通过level<=4循环4次，就生成4行上面所显示的数据了。
那么我们就可以通过connect by子句把v循环显示4行，并给出定位标识level；
```
select v.汉字,v.首拼,level from v connect by level<=length(v.汉字);

汉字          首拼             level
天天向上      TTXS              1
天天向上      TTXS              2
天天向上      TTXS              3
天天向上      TTXS              4

4 rows selected
```
根据上面的数据，可以通过函数substr(v.汉字,level,?)得到需要的结果：
```
select v.汉字,
   v.首拼,
   levecl,
   substr(v.汉字,level,1) as 汉字拆分,
   substr(v.首拼,level,1) as 首拼拆分,
   'substr(''' || v.汉字||''','||level||',1)' as fun
   from v
   connect by level<=length(v.汉字);
```
|汉字|首拼|level|汉字拆分|首拼拆分|fun|
|--|--|--|--|--|--|
天天向上|TTXS|1|天|T|substr('天天向上',1,1)
天天向上|TTXS|2|天|T|substr('天天向上',2,1)
天天向上|TTXS|3|向|X|substr('天天向上',3,1)
天天向上|TTXS|4|上|S|substr('天天向上',4,1)

----------------------------------------------------------------------------------------------------
### 字符串文字中包含引号
   常常有人写SQL时不知道在字符串内的单引号怎么写，其实只要把一个单引号换成两个单引号表示就可以了。
```
   select 'g'' day mate' qmarks from dual union all
   2 select 'beavers''teeth' from dual union all
   3 select ''''   from dual;
    
   qmarks
-------------------------
   g'day mate
   beavers' teeth
   '
   3 rows selected

```
   
------------------------------------------------------------------------------------------------------

[回到顶部](#oracle总结笔记)
