create table backuplog
(rowno number,logdata varchar2(1000))

create or replace directory backuplog as '/prepaid1/prepcdr/admin/bdump/'

truncate table alertlog

declare
fcon  varchar2(10000);
filedir varchar2(100);
filename varchar2(100);
fl  UTL_FILE.FILE_TYPE;
rw number(5);
begin
rw :=1;
dbms_output.enable(1000000);
filename:='alert_PREPCDR.log';
fl :=UTL_FILE.FOPEN('LOGPATH',filename,'R');
loop
utl_file.get_line(fl,fcon);
insert into alertlog(logdata,rowno) values(fcon,rw);
rw :=rw + 1;
end loop;
EXCEPTION
when no_data_found then
commit;
end;

select * from dba_directories

create or replace view alertlog_prepcdr
as
select * from alertlog where rowno >= (select min(rowno) from alertlog where upper(logdata) like to_char(trunc(sysdate)-1,'%MON DD%YYYY%'))
and ( upper(logdata) not like '%2009%' and  upper(logdata) not like '%THREAD%' and  upper(logdata) not like '%KUPPRDP%'
and  upper(logdata) not like '%CURRENT%' and upper(logdata) not like '%WORKER%' )



select logdata from alertlog_prepcdr

drop view alertlog_prepcdr

create or replace view alertlog_prepcdr
as
(select * from alertlog where (rowno) in (select rowno from alertlog where rowno >= (select min(rowno) from alertlog where upper(logdata) like to_char(trunc(sysdate)-1,'%MON DD%YYYY%'))
and ( upper(logdata) not like '%2009%' and  upper(logdata) not like '%THREAD%' and  upper(logdata) not like '%KUPPRDP%'
and  upper(logdata) not like '%CURRENT%' and upper(logdata) not like '%WORKER%' ))
union
select * from alertlog where (rowno) in (select rowno-1 from alertlog where rowno >= (select min(rowno) from alertlog where upper(logdata) like to_char(trunc(sysdate)-1,'%MON DD%YYYY%'))
and ( upper(logdata) not like '%2009%' and  upper(logdata) not like '%THREAD%' and  upper(logdata) not like '%KUPPRDP%'
and  upper(logdata) not like '%CURRENT%' and upper(logdata) not like '%WORKER%' )))



select * from sys.X$KRBMSFT



