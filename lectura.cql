-- Crear las tablas

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


-- USAMOS EMAIL TAMBIÉN COMO USERID


CREATE TABLE Statistic (
    Email VARCHAR,
    Mazmorra_id INT,
    Tiempo FLOAT,
    Fecha VARCHAR,
    PRIMARY KEY((Email, Mazmorra_id), Tiempo))
    WITH CLUSTERING ORDER BY (Tiempo ASC)
;


-- USAMOS TAMBIEN EL PAIS COMO CLAVE PARTICIONAL POR QUE LOS EVENT id ESTÁN REPETIDOS EN DISTINTOS PAISES (MISMOS EVENTOS EN OTROS PAÍSES)


CREATE TABLE Top_horde (
    Evento_id INT,
    Pais VARCHAR,
    N_killed INT,
    Email VARCHAR,
    Nombre_usuario VARCHAR,
    PRIMARY KEY((Evento_id, Pais), N_killed))
    wITH CLUSTERING ORDER BY (N_killed DESC)
;
