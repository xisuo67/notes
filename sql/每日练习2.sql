use Test
--请用sql语句生成按年月统计采购明细合计报表
create table vp
(
	vid int identity(1,1) primary key not null ,
	vName  varchar(50),
	vCount int,
	vDate datetime,
)