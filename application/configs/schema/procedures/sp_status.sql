DELIMITER $$
drop procedure if exists `sp_status` $$
create procedure `sp_status`(dbname varchar(50))
begin
-- Obtaining tables and views
(
    select
     TABLE_NAME as `Table Name`,
     ENGINE as `Engine`,
     TABLE_ROWS as `Rows`,
     concat(
        (format((DATA_LENGTH + INDEX_LENGTH) / power(1024,2),2))
        , ' Mb')
       as `Size`,
     TABLE_COLLATION as `Collation`
    from information_schema.TABLES
    where TABLES.TABLE_SCHEMA = dbname
          and TABLES.TABLE_TYPE = 'BASE TABLE'
)
union
(
    select
     TABLE_NAME as `Table Name`,
     '[VIEW]' as `Engine`,
     '-' as `Rows`,
     '-' `Size`,
     '-' as `Collation`
    from information_schema.TABLES
    where TABLES.TABLE_SCHEMA = dbname
          and TABLES.TABLE_TYPE = 'VIEW'
)
order by 1;
-- Obtaining functions, procedures and triggers
(
    select ROUTINE_NAME as `Routine Name`,
     ROUTINE_TYPE as `Type`,
     '' as `Comment`
    from information_schema.ROUTINES
    where ROUTINE_SCHEMA = dbname
    order by ROUTINES.ROUTINE_TYPE, ROUTINES.ROUTINE_NAME
)
union
(
    select TRIGGER_NAME,'TRIGGER' as `Type`,
    concat('On ',EVENT_MANIPULATION,': ',EVENT_OBJECT_TABLE) as `Comment`
    from information_schema.TRIGGERS
    where EVENT_OBJECT_SCHEMA = dbname
)
order by 2,1;
end$$
DELIMITER ;