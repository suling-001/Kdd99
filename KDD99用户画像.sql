
use kdd99;
###################################################################################################
#1、获取客户的性别和发卡时的年龄-- 基础标签
select a.*,c.sex,datediff(a.issued,c.birth_date)/365 as age 
from kdd99.kdd99_card a
left join kdd99.kdd99_disp b on a.disp_id=b.disp_id
left join kdd99.kdd99_clients c on b.client_id=c.client_id;

select card_id,count(*)
from var1
group by card_id
having count(*)>1;
###################################################################################################
# 开卡前所有交易的交易日期，时间间隔和账户余额
create table kdd99.balance as 
select a.card_id,c.date as trans_date,datediff(a.issued,c.date) as last_days,c.balance
from kdd99_card a
left join kdd99_disp b on a.disp_id=b.disp_id
left join kdd99_Trans c on b.account_id=c.account_id and a.issued>c.date
order by a.card_id,c.date;

# 每张卡的最后交易日期
select * from kdd99.balance a
 join (select card_id,max(trans_date) as max_date
       from kdd99.balance group by card_id) b on a.card_id=b.card_id and a.trans_date=b.max_date;

#2、开卡前的最后一次交易的交易日期，间隔时间和账户余额
select * 
from(
	select *,row_number()over(partition by card_id) as rk
	from(
		select a.card_id,c.date as trans_date,datediff(a.issued,c.date) as last_days,c.balance 
		from kdd99.kdd99_card a
		left join kdd99.kdd99_disp b on a.disp_id=b.disp_id
		left join kdd99.kdd99_Trans c on b.account_id=c.account_id
		join 
		(select card_id,max(trans_date) as max_date
		from kdd99.balance group by card_id) d on a.card_id=d.card_id and c.date=d.max_date
		order by a.card_id
		)T
)Y
where rk=1;

###################################################################################################


-- "借"代表资金流出，"贷"代表资金流入
# 对kdd99.Trans进行数据清洗，将operation中的"支取现金"对应"借","贷"类型改为"借"，并将数据集保存到新表中
create table trans_new as(
						select *,
                        if(operation='支取现金','借',type) as type_new 
                        from kdd99_trans
                        );
                        
select * from trans_new;

#3、截止到开卡时的交易笔数、半年内总入账、半年内总出账、半年内出/入账比例
select a.card_id,count(trans_id) as trans_count,
sum(if(c.type_new='借',amount,0)) as trans_out_count,
sum(if(c.type_new='贷',amount,0)) as trans_in_count,
sum(if(c.type_new='借',amount,0))/avg(c.balance) as out_ratio,
sum(if(c.type_new='借',amount,0))/sum(if(c.type_new='贷',amount,0)) as out_in_ratio
  from kdd99.kdd99_card a
  left join kdd99.kdd99_disp b on a.disp_id=b.disp_id
  left join kdd99.trans_new c on b.account_id=c.account_id and a.issued>c.date and c.date>date_sub(a.issued,interval 6 month)
  group by a.card_id;
  
###################################################################################################

#以下是创建数据集
create table kdd99.var1 as 
select a.*,c.sex,datediff(a.issued,c.birth_date)/365 as age from 
  kdd99.kdd99_card a
  left join kdd99.kdd99_disp b on a.disp_id=b.disp_id
  left join kdd99.kdd99_clients c on b.client_id=c.client_id;

create table kdd99.var2 as 
select * 
from(
	select *,row_number()over(partition by card_id) as rk
	from(
		select a.card_id,c.date as trans_date,datediff(a.issued,c.date) as last_days,c.balance 
		from kdd99.kdd99_card a
		left join kdd99.kdd99_disp b on a.disp_id=b.disp_id
		left join kdd99.kdd99_Trans c on b.account_id=c.account_id
		join 
		(select card_id,max(trans_date) as max_date
		from kdd99.balance group by card_id) d on a.card_id=d.card_id and c.date=d.max_date
		order by a.card_id
		)T
)Y
where rk=1;
  
create table kdd99.var3 as 
select a.card_id,count(trans_id) as trans_count,
       sum(if(c.type_new='借',amount,0)) as trans_out_amount,
       sum(if(c.type_new='贷',amount,0)) as trans_in_amount,
       sum(if(c.type_new='借',amount,0))/avg(c.balance) as out_ratio,
       sum(if(c.type_new='借',amount,0))/sum(if(c.type_new='贷',amount,0)) as out_in_ratio
  from kdd99.kdd99_card a
  left join kdd99.kdd99_disp b on a.disp_id=b.disp_id
  left join kdd99.trans_new c on b.account_id=c.account_id and a.issued>c.date and c.date>date_sub(a.issued,interval 6 month)
  group by a.card_id;
  

create table kdd99.creditcard as 
  select a.*,b.last_days,b.balance,c.trans_count,c.trans_in_amount,c.trans_out_amount,c.out_ratio,c.out_in_ratio
    from kdd99.var1 as a 
    left join kdd99.var2 as b on a.card_id=b.card_id
    left join kdd99.var3 as c on a.card_id=c.card_id
    order by a.card_id;
    
  select * from kdd99.creditcard;