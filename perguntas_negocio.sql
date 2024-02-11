-- Qual modelo de máquina apresenta mais falhas.
select
m.machine_id ,
m2.model,
count(*) as failure_count
from  final.failures f 
left join "final".machine m  on f.machineid  = m.machine_id 
left join final.models m2 on m.model_id = m2.model_id 
group  by m.machine_id, m2.model 
order by failure_count desc
limit 1
 

-- Qual a quantidade de falhas por idade da máquina.
select
age,
count(*) as f_count
from final.failures f 
left join final.machine m on f.machineid = m.machine_id 
group by age
order by age asc


-- Qual componente apresenta maior quantidade de falhas por máquina.

select
distinct 
m.machine_id ,
c.component_name ,
count(*) as failure_count
from "final".failures f 
left join final.components c on f.component_key = c.component_key 
left join final.machine m on f.machineid  = m.machine_id 
group by m.machine_id, c.component_name 
order by failure_count desc



WITH ranked AS (
    SELECT
        m.machine_id,
        c.component_name,
        COUNT(*) AS failure_count,
        ROW_NUMBER() OVER (PARTITION BY m.machine_id ORDER BY COUNT(*) DESC) AS rank
    FROM
        final.failures f
    LEFT JOIN
        final.components c ON f.component_key = c.component_key
    LEFT JOIN
        final.machine m ON f.machineid = m.machine_id
    GROUP BY
        m.machine_id,
        c.component_name
)
SELECT
    machine_id,
    component_name,
    failure_count
FROM
    ranked
where rank = 1
ORDER BY
    machine_id;

-- A média da idade das máquinas por modelo
select
m2.model,
avg(m.age)
from final.machine m 
left join final.models m2 on m.model_id  = m2.model_id 
group by m2.model
