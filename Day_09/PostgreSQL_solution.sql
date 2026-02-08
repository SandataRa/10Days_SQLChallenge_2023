
with cte_dept as (
	select *
	from (
		select cast(count(id) as float) as number_of_employees, department_id 
		from employees 
		group by department_id
		having count(id) >= 10 
	) td
	order by number_of_employees desc
	limit 3
), 

cte_sal as (
	select cast(count(id) as float) as top_employees, 
	department_id 
	from employees e
	where salary > 100000 
	and department_id IN (select department_id from cte_dept)
	group by department_id
)

select 
d.name as department_name, 
cd.number_of_employees ,
(top_employees/cd.number_of_employees) as percentage_over_100k
from cte_sal s
inner join departments d on s.department_id = d.id
inner join cte_dept cd on s.department_id = cd.department_id 
order by (top_employees/cd.number_of_employees) asc
