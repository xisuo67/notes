use Test
--����sql������ɰ�����ͳ�Ʋɹ���ϸ�ϼƱ���
create table vp
(
	vid int identity(1,1) primary key not null ,
	vName  varchar(50),
	vCount int,
	vDate datetime,
)