--СКРИПТ ЗАГРУЗКИ ИНКРЕМЕНТА

--0. перед запуском скрипта нужно очистить stg
delete from de7.mshv_stg_accounts_load;

--1. Захватываем новые и измененные записи (insert, update) из источника в STG (если в мете нет строки с датой, подставляем 01.01.1900).
insert into de7.mshv_stg_accounts_load (
select
    *
from BARATIN.accounts ba
where ba.create_dt > 
    coalesce ( (select m.max_create_dt max_create_dt from de7.mshv_meta_accounts_load m 
                where database_name = 'DE7'
                and table_name = 'MSHV_DWH_ACCOUNTS_LOAD'), 
    to_date('1900-01-01','YYYY-MM-DD'))
or ba.update_dt > 
    (select m.max_create_dt max_create_dt from de7.mshv_meta_accounts_load m 
                where database_name = 'DE7'
                and table_name = 'MSHV_DWH_ACCOUNTS_LOAD')
);

-- 2. Укладываем insert (join STG vs DWH) в таблицу DWH
MERGE INTO de7.mshv_dwh_accounts_load dwh
USING de7.mshv_stg_accounts_load stg
ON ( dwh.account_id = stg.account_id )
WHEN MATCHED THEN UPDATE SET 
	dwh.value = stg.value, 
	dwh.client=stg.client, 
	dwh.manager=stg.manager, 
	dwh.create_dt=stg.create_dt, 
	dwh.update_dt=stg.update_dt
WHEN NOT MATCHED THEN INSERT ( 
	account_id, 
	value,
	client, 
	manager, 
	create_dt, 
	update_dt 
) 
VALUES ( 
	stg.account_id, 
	stg.value,
	stg.client,
	stg.manager, 
	stg.create_dt, 
	stg.update_dt 
);

-- 3. Удаляем удалившиеся строки (найти строки, удалившиеся в таблице-исходнике)
delete from de7.mshv_dwh_accounts_load
where account_id in (
    select dwh.account_id 
    from de7.mshv_dwh_accounts_load dwh
    left join BARATIN.accounts ba
    on dwh.account_id = ba.account_id
    where ba.account_id is null
);

--4. проверяем наличие данных в таблице метаданных, если пусто - вставлется строка с датой 01.01.1900, если не пусто - вставляем текущую дату
MERGE INTO de7.mshv_meta_accounts_load m
USING (
select 
	'DE7' as database_name,
	'MSHV_DWH_ACCOUNTS_LOAD' as table_name,
	to_date ('1900-01-01', 'YYYY-MM-DD') as max_create_dt
	from dual
) t
ON ( m.table_name = t.table_name )
WHEN MATCHED THEN UPDATE SET 
	m.database_name = t.database_name, 
	m.max_create_dt=sysdate
WHEN NOT MATCHED THEN INSERT (
	m.database_name, 
	m.table_name, 
	m.max_create_dt
) 
VALUES (
	t.database_name, 
	t.table_name, 
	t.max_create_dt
);

commit;

select * from BARATIN.accounts;
select * from de7.mshv_dwh_accounts_load; --хранилище данных
SELECT * FROM de7.mshv_meta_accounts_load; --таблица метаданных
select * from de7.mshv_stg_accounts_load; -- промежуточная таблица stg