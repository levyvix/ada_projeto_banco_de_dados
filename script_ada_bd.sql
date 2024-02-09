create schema if not exists kaggle;


create table kaggle.machines (
	machineID int primary key,
	model varchar(10),
	age int
);

create table kaggle.errors (
	error_id serial primary key,
	datetime timestamp,
	machineID int references kaggle.machines(machineID),
	errorID varchar
);

create table kaggle.failures(
	failure_id serial primary key,
	datetime timestamp,
	machineID int references kaggle.machines(machineID),
	failure varchar(10)
);

create table kaggle.maint(
	maint_id serial primary key,
	datetime timestamp,
	machineID int references kaggle.machines(machineID),
	component varchar(10)
);

create table kaggle.telemetry(
	datetime timestamp,
	machineID int references kaggle.machines(machineID),
	volt float,
	rotate float,
	pressure float,
	vibration float,
	primary key (machineID, datetime)
);



-- Copy data from a file into a table
COPY kaggle.machines FROM 'C:\Users\levyv\Desktop\Banco de Dados I - Pasta Geral\dados\PdM_machines.csv' DELIMITER ',' CSV HEADER;
COPY kaggle.errors (datetime, machineID, errorID) FROM 'C:\Users\levyv\Desktop\Banco de Dados I - Pasta Geral\dados\PdM_errors.csv' DELIMITER ',' CSV HEADER;
COPY kaggle.failures (datetime, machineID, failure) FROM 'C:\Users\levyv\Desktop\Banco de Dados I - Pasta Geral\dados\PdM_failures.csv' DELIMITER ',' CSV HEADER;
COPY kaggle.maint (datetime, machineID, component) FROM 'C:\Users\levyv\Desktop\Banco de Dados I - Pasta Geral\dados\PdM_maint.csv' DELIMITER ',' CSV HEADER;
COPY kaggle.telemetry  FROM 'C:\Users\levyv\Desktop\Banco de Dados I - Pasta Geral\dados\PdM_telemetry.csv' DELIMITER ',' CSV HEADER;

COPY PdM_errors FROM 'C:\Users\levyv\Desktop\Banco de Dados I - Pasta Geral\dados\PdM_errors.csv' DELIMITER ',' CSV HEADER;

COPY PdM_errors FROM 'C:\Users\levyv\Desktop\Banco de Dados I - Pasta Geral\dados\PdM_errors.csv' DELIMITER ',' CSV HEADER;
