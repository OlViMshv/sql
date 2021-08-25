--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц
create view pages_all_products as
select *, 
	case 
	when rn % 2 = 0 then rn/2 
	else rn/2 + 1 
	end  num
from (
		select 
		*,
		row_number(*) over () as rn
		from laptop) a ;

select * from pages_all_products;
--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель,
-- надеюсь я правильно поняла условие
select distinct 
maker, 
CAST(100.0*count_ /count_all_type AS NUMERIC(5,2)) as pr
from (
	select *,
	count (*) over () count_all_type,
	count (type) over (partition by maker) count_
	from product p 
) a ;
--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но у название корабля должно состоять из двух слов

create table ships_two_words as
select *
from ships s 
where name like '% %';

select * from ships_two_words;

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select 
a1.name
from (
	select name from ships s 
	union all
	select ship from outcomes o 
	) a1
left join ships s2 
on a1.name = s2.name
where class is null
and a1.name like 'S%';

--task6 (lesson5)Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
-- Компьютерная фирма: 
-- в таблице нет моделей С, код ничего не выводит
select *
from (
	select *,
	avg(p.price) over (partition by maker) as avg_price,
	row_number(*) over (order by p.price desc) as rn
	from printer p 
	join product p2 
	on p.model = p2.model
	 )a
where maker ='A' 
and price > (
				select distinct avg(price) over (partition by maker) avg_price_E
				from printer p 
				join product p2 
				on p.model = p2.model
				where maker = 'C'
				)
and rn <=3;