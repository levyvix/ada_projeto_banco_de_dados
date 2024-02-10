drop schema if exists final cascade;

create schema if not exists final;


-- components
create table final.components (
	component_key serial primary key,
	component_name varchar(10)
);

insert into final.components (component_name)
select distinct failure from kaggle.failures order by failure;

-- component-failure
create table final.failures as (
select 
failure_id,
datetime,
machineid,
c.component_key
from kaggle.failures f 
left join final.components c
on f.failure = c.component_name
);

alter table final.failures 
add constraint pk_failure_id
primary key(failure_id);

alter table final.failures 
add constraint fk_component_key
foreign key (component_key)
references final.components(component_key);

-- component-maint
create table final.maint as (
select 
maint_id,
datetime,
machineid as machine_id,
c.component_key 
from maint m 
left join kaggle.components c 
	on c.component_name = m.component 
);

alter table final.maint 
add constraint pk_maint_id
primary key(maint_id);

alter table final.maint 
add constraint fk_component_key
foreign key (component_key)
references final.components(component_key);

-- errors
create table final.error (
	error_key serial primary key,
	error_id varchar(10)
);

insert into final.error (error_id)
select distinct errorid  from kaggle.errors_machine order by errorid;



-- error-machine
create table final.error_machine as (
select 
em.error_id as error_machine_id,
em.datetime,
em.machineid as machine_id,
e.error_key
from kaggle.errors_machine em 
left join kaggle.errors e 
	on em.errorid  = e.error_id 
);

alter table final.error_machine 
add constraint pk_error_machine_id
primary key(error_machine_id);

alter table final.error_machine 
add constraint fk_error_key
foreign key (error_key)
references final.error(error_key);


-- models

create table final.models (
	model_id serial primary key,
	model varchar(10)
);


insert into final.models (model)
select distinct model from kaggle.machines order by model;



create table final.machine  as (
select 
m.machineid as machine_id,
mds.model_id,
m.age
from kaggle.machines m 
left join final.models mds
	on mds.model = m.model
);

alter table final.machine 
add constraint pk_machine_id
primary key (machine_id);

alter table final.machine
add constraint fk_model_id
foreign key (model_id)
references final.models(model_id);

alter table final.maint 
add constraint fk_machine_id
foreign key (machine_id)
references final.machine(machine_id);

alter table final.failures 
add constraint fk_machine_id
foreign key (machineid)
references final.machine(machine_id);

alter table final.error_machine 
add constraint fk_machine_id
foreign key (machine_id)
references final.machine(machine_id);

-- telemetry

CREATE TABLE final.telemetry (
    telemetry_id SERIAL PRIMARY KEY,
    machine_id INTEGER,
    datetime TIMESTAMP,
    volt FLOAT,
    rotate FLOAT,
    pressure FLOAT,
    vibration FLOAT
);

INSERT INTO final.telemetry (machine_id, datetime, volt, rotate, pressure, vibration)
SELECT
    machineid,
    datetime,
    volt,
    rotate,
    pressure,
    vibration
FROM
    kaggle.telemetry;


alter table final.telemetry
add constraint fk_machine_id
foreign key (machine_id)
references final.machine(machine_id);









