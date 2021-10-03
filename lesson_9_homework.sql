--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct 
city 
from 
station 
where not (
	city like 'A%' 
	or city like 'E%' 
	or city like 'I%' 
	or city like 'O%' 
	or city like 'U%'
);

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct 
city 
from 
station 
where not (
	city like '%a' 
	or city like '%e' 
	or city like '%i' 
	or city like '%o' 
	or city like '%u'
);

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct 
city 
from 
station 
where not (
	(
	city 
	like 'A%' 
	or city like 'E%'
	or city like 'I%' 
	or city like 'O%' 
	or city like 'U%'
	)
and (
	city like '%a' 
	or city like '%e' 
	or city like '%i' 
	or city like '%o' 
	or city like '%u'
	)
);

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct 
city 
from 
station 
where not (
	(
	city 
	like 'A%' 
	or city like 'E%'
	or city like 'I%' 
	or city like 'O%' 
	or city like 'U%'
	)
or (
	city like '%a' 
	or city like '%e' 
	or city like '%i' 
	or city like '%o' 
	or city like '%u'
	)
);

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select 
name 
from 
Employee 
where 
salary > 2000 
and 
months < 10 
order by employee_id ;
--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
--повтор первого задания!
