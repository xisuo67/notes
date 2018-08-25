# Oracle总结笔记
+ 将空值转化为实际值
 >>select **coalesce**(comm,0) from emp;
```
 Create or replace View v as 
 select null as c1,null as c2,1 as c3,null as c4,2 as c5,null as c6 from dual Union all 
 select null as c1,null as c2,null as c3,3 as c4,null as c5, 2 as c6 from dual;
 
 select * from v
```
