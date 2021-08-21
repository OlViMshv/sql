--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task12 (lesson4) не доделали на уроке
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)

create table ships_without_n as
select * from ships where name not like 'N%';

select * from ships_without_n;

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select p.model, maker, p2.type from pc p 
join product p2 
on p.model = p2.model
union all 
select pr.model, maker, p2.type from printer pr 
join product p2 
on pr.model = p2.model
union all
select l.model, maker, p2.type from laptop l 
join product p2 
on l.model = p2.model;

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case
when price > (select avg(price) from pc) then 1
else 0
end price_pc
from printer p ;

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select a1.name from (
select name from ships s 
union all
select ship from outcomes o 
) a1
left join ships s2 
on a1.name = s2.name
where class is null;

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select name
from battles
where extract (year from date) not in
     (select launched
      from ships
      where launched is not null );
     
--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
     
select 
battle 
from ships s 
join 
outcomes o 
on s.name = o.ship
where class = 'Kongo';

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300 as 
select *,
	case 
	when price > 300 then 1
	else 0
	end flag
from (
	select model, price from pc
	union all
	select model, price from printer
	union all
	select model, price from laptop
) a;

select * from all_products_flag_300;

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 
select *,
	case 
	when price > (	select avg(price) 
					from (
						select model, price from pc
						union all
						select model, price from printer
						union all
						select model, price from laptop) a
				 ) 
	then 1
	else 0
	end flag
from (
	select model, price from pc
	union all
	select model, price from printer
	union all
	select model, price from laptop
) a;

select * from all_products_flag_avg_price;

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select p.model 
from printer pr 
join product p
on pr.model = p.model
where maker = 'A'
and price > (	select avg(price) 
				from (	select price 
						from printer pr 
						join product p
						on pr.model = p.model
						where maker = 'D' 
						union all
						select price 
						from printer pr 
						join product p
						on pr.model = p.model
						where maker = 'C'
					) pp
			);

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
			
select distinct model 
from (
	select p.model,p.type, maker, price 
	from printer pr 
	join product p
	on pr.model = p.model
	where maker = 'A'
	union all
	select p.model,p.type, maker, price  
	from pc p1 
	join product p
	on p1.model = p.model
	where maker = 'A'
	union all
	select p.model,p.type, maker, price   
	from laptop l 
	join product p
	on l.model = p.model
	where maker = 'A'
)aa
where price > (	select avg(price) 
				from (	select price 
						from printer pr 
						join product p
						on pr.model = p.model
						where maker = 'D' 
						union all
						select price 
						from printer pr 
						join product p
						on pr.model = p.model
						where maker = 'C'
					) pp
			);
			
--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
			
select model, avg(price)
from (
	select p.model, price 
	from printer pr 
	join product p
	on pr.model = p.model
	where maker = 'A'
	union
	select p.model, price  
	from pc p1 
	join product p
	on p1.model = p.model
	where maker = 'A'
	union
	select p.model, price   
	from laptop l 
	join product p
	on l.model = p.model
	where maker = 'A'
	)aa
group by model;

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
select maker, count(model)
from (
	select p.model, maker from pc p 
	join product p2 
	on p.model = p2.model
	union all 
	select pr.model, maker from printer pr 
	join product p2 
	on pr.model = p2.model
	union all
	select l.model, maker from laptop l 
	join product p2 
	on l.model = p2.model
)a
group by maker;

select * from count_products_by_makers;

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
select 
maker,
count as count_maker
from count_products_by_makers
order by count_maker;

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
create table printer_updated as 
select * from printer;

delete from printer_updated
where model in (
select pu.model from printer_updated pu 
join product p2 
on pu.model = p2.model
where maker = 'D'
);

select * from printer_updated;

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_with_makers as
select pu.*, maker 
from printer_updated pu 
join product p2 
on pu.model = p2.model;

select * from printer_updated_with_makers;

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
--+
create view sunk_ships_by_classes as
select 
coalesce (class, '0') as class_, 
count(*) as count_class
from outcomes o 
left join ships s 
on o.ship = s.name
where result = 'sunk'
group by class_;


select 
class as class_, 
count as count_class
from sunk_ships_by_classes;
--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
---
select class, count from sunk_ships_by_classes;

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
create table classes_with_flag as
select * from classes;

select 
* ,
case 
when numguns >= 9 then 1
else 0
end flag
from classes_with_flag;
--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

select 
country,
count(class) as count_class
from classes c 
group by country;

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select 
count(name) 
from ships s 
where name like 'O%' 
or name like 'M%';

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select 
count(name) 
from ships s 
where name like '% %';
--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

select
count(name) as count_name,
launched
from ships
group by launched 
order by launched; 
