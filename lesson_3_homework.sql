--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)
with name_battles as 
(
select name
from battles
where extract (year from date) not in
     (select launched
      from ships
      where launched is not null )
)

select *
from name_battles

--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select battle from ships s 
join 
outcomes o 
on s.name = o.ship
where class = 'Kongo'


--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select cl.class, count(a.ship) 
from classes cl 
left join 
	(
	select ship, class
	from outcomes o 
	left join ships s 
	on o.ship = s.name
	where o.result = 'sunk'
	) a
on a.class = cl.class
or a.ship = cl.class
group by cl.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select c.class, a.data
from classes c
left join 
	(
	select class, min(launched) as data
	from ships s 
	group by class 
	) a
on c.class = a.class
--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
--здесь не уверена :(
select class, count(name) 
from 
	(
		select a.name, class
		from 
		(
			select name, count(name) as kol
			from (
			select name from ships s 
			union all
			select ship from outcomes o
			) a1
			group by name
			having count (name)>=3
		) a
		left join ships s 
		on a.name = s.name
	) b 
join outcomes o2 
on b.name = o2.ship 
where o2.result = 'sunk'
group by class

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).
--здесь тоже не уверена :(
select * 
from 
	(
	select s.name, c.numguns, c.displacement from ships s join classes c on s.name=c.class or s.class = c.class 
	union
	select o.ship, c.numguns, c.displacement from outcomes o join classes c on o.ship=c.class 
	) d1
join
	(
	select max(numguns) as numguns, displacement
	from (
	select s.name, c.numguns, c.displacement from ships s join classes c on s.name=c.class or s.class = c.class 
	union
	select o.ship, c.numguns, c.displacement from outcomes o join classes c on o.ship=c.class 
	) m
	group by displacement
	)d2
on d1.numguns=d2.numguns
and d1.displacement=d2.displacement

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
--производят ПК с наименьшим объемом RAM


select distinct p.maker 
from product p 
join pc 
on p.model = pc.model 
where pc.ram = (select min(ram) from pc) 
and pc.speed = (select max(speed) from pc
		  		where ram = (select min(ram) from pc)) 
and p.maker in (select maker from product where type = 'printer')

