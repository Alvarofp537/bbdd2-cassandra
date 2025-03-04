-- Crear el keyspace
CREATE KEYSPACE videojuego
    WITH replciation ={'class': 'NetworkTopologyStrategy', 'replication_factor' :2 };

-- Crear las tablas

// USAMOS EMAIL COMO CLAVE DE CLUSTERING KEY POR QUE PUEDEN EXISITIR 2 USUARIOS DEL MISMO PAIS QUE EN LA MISMA MAZMORRA TENGA EL MISMO TIEMPO

CREATE TABLE Hall_of_fame (
    Pais VARCHAR,
    Mazmorra_id INT,
    Email VARCHAR,
    Tiempo FLOAT,
    Nombre_mazmorra VARCHAR STATIC,
    Nombre_usuario VARCHAR,
    Fecha VARCHAR,
    PRIMARY KEY((Pais, Mazmorra_id), Email, Tiempo))
    WITH CLUSTERING ORDER BY (Tiempo ASC)
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
    PRIMARY KEY((Evento_id, Pais), N_killed))
    WITH CLUSTERING ORDER BY (N_killed DESC)
;


// VAMOS A CREAR LA TABLA USUARIOS PARA FACILITAR LAS ESCRITURAS PARA ADAPTARLOS A LOS DATOS OFRECIDOS EN LAS SOLICITUDES DE ESCRITURAS

CREATE TABLE Usuarios (
    Pais VARCHAR,
    Email VARCHAR,
    Nombre_usuario VARCHAR,
    PRIMARY KEY(Email)
);



-- Copiamos los datos de los csv obtenidos del modelo sql a cassandra

// CORREGIR EL ORDEN DEL COPY SEGUN LAS TABLAS CSV

COPY Hall_of_fame (Pais, Mazmorra_id, Email, Tiempo, Nombre_mazmorra, Nombre_usuario, Fecha) 
FROM 'Query_sql/resultados/hall_of_fame.csv' 
WITH DELIMITER=',' AND HEADER=TRUE;


COPY Statistic (Email, Mazmorra_id, Tiempo, Fecha) 
FROM 'Query_sql/resultados/estadisticas.csv' 
WITH DELIMITER=',' AND HEADER=TRUE;


COPY Top_horde (Nombre_usuario, Email, Pais, Evento_id, N_killed) 
FROM 'Query_sql/resultados/hordas.csv' 
WITH DELIMITER=',' AND HEADER=TRUE;
