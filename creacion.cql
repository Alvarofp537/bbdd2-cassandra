DROP KEYSPACE IF EXISTS videojuego;

-- Crear el keyspace
CREATE KEYSPACE videojuego
WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': 2};

USE videojuego;

-- Crear las tablas

// USAMOS EMAIL COMO CLAVE DE CLUSTERING KEY POR QUE PUEDEN EXISITIR 2 USUARIOS DEL MISMO PAIS QUE EN LA MISMA MAZMORRA TENGA EL MISMO TIEMPO

CREATE TABLE Hall_of_fame (
    Pais VARCHAR,
    Mazmorra_id INT,
    Tiempo FLOAT,
    Email VARCHAR,
    Nombre_mazmorra VARCHAR STATIC,
    Nombre_usuario VARCHAR,
    Fecha VARCHAR,
    PRIMARY KEY((Pais, Email), Tiempo, Mazmorra_id))
    WITH CLUSTERING ORDER BY (Tiempo ASC, Mazmorra_id ASC)
;


// USAMOS EMAIL TAMBIÉN COMO USERID


CREATE TABLE Statistic (
    Email VARCHAR,
    Mazmorra_id INT,
    Tiempo FLOAT,
    Fecha VARCHAR,
    PRIMARY KEY((Email, Mazmorra_id), Tiempo))
    WITH CLUSTERING ORDER BY (Tiempo ASC)
;


// USAMOS TAMBIEN EL PAIS COMO CLAVE PARTICIONAL POR QUE LOS EVENT id ESTÁN REPETIDOS EN DISTINTOS PAISES (MISMOS EVENTOS EN OTROS PAÍSES)


CREATE TABLE Top_horde (
    Evento_id INT,
    Pais VARCHAR,
    N_killed INT,
    Email VARCHAR,
    Nombre_usuario VARCHAR,
    PRIMARY KEY((Evento_id, Pais), N_killed, Email))
    WITH CLUSTERING ORDER BY (N_killed DESC, Email ASC)
;


// VAMOS A CREAR LA TABLA USUARIOS PARA FACILITAR LAS ESCRITURAS PARA ADAPTARLOS A LOS DATOS OFRECIDOS EN LAS SOLICITUDES DE ESCRITURAS

CREATE TABLE Usuarios (
    Email VARCHAR,
    Nombre_usuario VARCHAR,
    Pais VARCHAR,
    PRIMARY KEY(Email)
);


-- Copiamos los datos de los csv obtenidos del modelo sql a cassandra


COPY Hall_of_fame (Nombre_usuario, Email, Pais, Tiempo, Mazmorra_id, Nombre_mazmorra, Fecha) 
FROM '/var/lib/cassandra/resultados/hall_of_fame_top5.csv' 
WITH DELIMITER=',' AND HEADER=TRUE;


COPY Statistic (Email, Mazmorra_id, Tiempo, Fecha) 
FROM '/var/lib/cassandra/resultados/estadisticas.csv' 
WITH DELIMITER=',' AND HEADER=TRUE;


COPY Top_horde (Nombre_usuario, Email, Pais, Evento_id, N_killed) 
FROM '/var/lib/cassandra/resultados/hordas.csv' 
WITH DELIMITER=',' AND HEADER=TRUE;


COPY Usuarios (Email, Nombre_usuario, Pais) 
FROM '/var/lib/cassandra/resultados/usuarios.csv' 
WITH DELIMITER=',' AND HEADER=TRUE;

