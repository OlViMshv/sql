--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select 
d.Name as Department, 
a. Name as Employee, 
a. Salary 
from (
    select e.*, 
    dense_rank() over (partition by DepartmentId order by Salary desc) as drn 
    from Employee e 
    ) a 
join Department d
on a.DepartmentId = d.Id 
where drn <=3;

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, 
status, 
SUM(a.c) as costs 
from (
	select *, DATE_FORMAT(date, '%Y') as q, (unit_price * amount) as c from Payments
	join FamilyMembers
	on family_member = member_id
) a
where a.q='2005'
GROUP BY member_name;

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select a.name from (
select name, count(name) as t from Passenger
group by name) a
where a.t>1;

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(a.first_name) as count 
from (
	select first_name from Student
	where first_name =  'Anna'
	) a;

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select 
count(class) as count 
from Schedule
where DATE_FORMAT(date, '%d.%m.%Y') ='02.09.2019';

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select 
count(first_name) as count 
from Student
where first_name = 'Anna';

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

SELECT 
FLOOR(avg(TIMESTAMPDIFF(year,birthday,CURRENT_DATE))) AS age
FROM FamilyMembers;

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select 
good_type_name, 
SUM(a.c) as costs 
from (
select *, DATE_FORMAT(date, '%Y') as q, (unit_price * amount) as c from Payments
join Goods
on Good = good_id
join GoodTypes
on type=good_type_id)a
where a.q='2005'
GROUP BY good_type_name;

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
SELECT 
min(TIMESTAMPDIFF(year,birthday,CURRENT_DATE)) AS year
FROM Student;

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select 
max(TIMESTAMPDIFF(year,birthday,CURRENT_DATE)) AS max_year 
from Class cl
join Student_in_class c
on cl.id=c.class
join Student a
on c.student=a.id
where name like '10%';

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select 
status,
member_name, 
SUM(unit_price*amount) as costs 
from FamilyMembers
join Payments
on member_id=family_member
join Goods
on Good = good_id
join GoodTypes
on type=good_type_id
where good_type_name = 'entertainment'
GROUP BY status, member_name;

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
DELETE FROM Company
WHERE Company.id IN (
    SELECT company FROM Trip
    GROUP BY company
    HAVING COUNT(id) = (
	    SELECT MIN(count) 
	    FROM (
	    	SELECT COUNT(id) AS count 
	    	FROM Trip 
	    	GROUP BY company) 
	    AS min_count)
	    );
--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
	   
SELECT classroom 
FROM Schedule
GROUP BY classroom
HAVING COUNT(classroom) = 
    (SELECT COUNT(classroom) 
     FROM Schedule 
     GROUP BY classroom
     ORDER BY COUNT(classroom) DESC 
     LIMIT 1);
--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
    
SELECT last_name
FROM Teacher
JOIN Schedule
    ON Teacher.id=Schedule.teacher
JOIN Subject
    ON Schedule.subject=Subject.id
WHERE Subject.name = 'Physical Culture'
ORDER BY Teacher.last_name;

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.', LEFT(middle_name, 1), '.') AS name
FROM Student
ORDER BY last_name, first_name;
