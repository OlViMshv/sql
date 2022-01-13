select 
    ba.account_id, 
    coalesce(sum (l.value) over (partition by ba.account_id order by l.create_dt),0) balance,
    coalesce (l.create_dt,to_date('1900-01-01', 'yyyy-mm-dd'))  effective_from,
    lead (l.create_dt,1,to_date('9999-12-31', 'yyyy-mm-dd')) over (partition by ba.account_id order by l.create_dt)- (1/24/60/60) effective_to
from BARATIN.accounts ba
left join BARATIN.phones p
on ba.account_id=p.account
left JOIN BARATIN.payment_logs l
on p.phone_num=l.phone;