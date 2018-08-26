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
* 
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
