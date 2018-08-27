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







[回到顶部](#oracle总结笔记)
