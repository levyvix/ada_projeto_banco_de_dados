-- Qual modelo de máquina apresenta mais falhas.
select
m.machine_id ,
m2.model,
count(*)
from  final.failures f 
left join "final".machine m  on f.machineid  = m.machine_id 
left join final.models m2 on m.model_id = m2.model_id 
group  by m.machine_id, m2.model 
order by count(*) desc
limit 1
 

-- Qual a quantidade de falhas por idade da máquina.
select
age,
count(*) as f_count
from final.failures f 
left join final.machine m on f.machineid = m.machine_id 
group by age
order by f_count desc


-- Qual componente apresenta maior quantidade de falhas por máquina.
select
c.component_name,
count(*) as f_count
from final.failures f 
left join final.components c on f.component_key = c.component_key 
group by c.component_name 
order by f_count desc
limit 1

-- A média da idade das máquinas por modelo
select
m2.model,
avg(m.age)
from final.machine m 
left join final.models m2 on m.model_id  = m2.model_id 
group by m2.model
