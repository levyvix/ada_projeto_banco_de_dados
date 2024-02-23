-- Qual modelo de máquina apresenta mais falhas.
select
m2.model,
count(*) as failure_count
from  final.failures f 
left join "final".machine m  on f.machineid  = m.machine_id 
left join final.models m2 on m.model_id = m2.model_id 
group  by m2.model 
order by failure_count desc

-- Qual a quantidade de falhas por idade da máquina.
SELECT date_part('year', current_date) - m.manufacture_year  as age,
       count(*) AS f_count
FROM final.failures f
LEFT JOIN final.machine m ON f.machineid = m.machine_id
GROUP BY date_part('year', current_date)- m.manufacture_year 
ORDER BY age asc;


-- Qual componente apresenta maior quantidade de falhas por máquina.
WITH ranked AS(
   SELECT m.machine_id,
          c.component_name,
          COUNT(*) AS failure_count,
          dense_rank() OVER (PARTITION BY m.machine_id
                             ORDER BY COUNT(*) DESC) AS rank
   FROM final.failures f
   LEFT JOIN final.components c ON f.component_key = c.component_key
   LEFT JOIN final.machine m ON f.machineid = m.machine_id
   GROUP BY m.machine_id,
            c.component_name
)

SELECT machine_id,
       component_name,
       failure_count
FROM ranked
WHERE rank = 1
ORDER BY machine_id;


-- A média da idade das máquinas por modelo
SELECT m2.model,
       avg(date_part('year', current_date) - m.manufacture_year) AS average_age
FROM final.machine m
LEFT JOIN final.models m2 ON m.model_id = m2.model_id
GROUP BY m2.model;


-- Quantidade de erro por tipo de erro e modelo da máquina.
SELECT e.error_id,
       m2.model,
       count(*) AS COUNT
FROM final.error_machine em
LEFT JOIN final.error e ON em.error_key = e.error_key
LEFT JOIN final.machine m ON m.machine_id = em.machine_id
LEFT JOIN final.models m2 ON m2.model_id = m.model_id
GROUP BY e.error_id,
         m2.model
ORDER BY COUNT desc;


-- componente entre modelos
select
c.component_name, m2.model , count(*) as failure_count
from failures f 
left join components c on f.component_key = c.component_key 
left join machine m on f.machineid = m.machine_id 
left join models m2 on m2.model_id = m.model_id 
group by c.component_name, m2.model 
order by failure_count desc


