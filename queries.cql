// LECTURA:

// SELECT DE STATISTICS
SELECT Tiempo, Fecha
FROM Statistic
WHERE Email = 'abag@example.com' AND Mazmorra_id = 0 
ALLOW FILTERING;

// SELECT DE TOP HORDE
SELECT Email, Nombre_usuario, N_killed
FROM Top_horde
WHERE Evento_id = 2 AND Pais = 'ja_JP' 
LIMIT 5;


// SELECT DE HALL OF FAME
SELECT Mazmorra_id, Nombre_mazmorra, Email, Nombre_usuario, Tiempo, Fecha
FROM Hall_of_fame
WHERE Pais = 'ja_JP'
ALLOW FILTERING;


// ESCRITURA (Hay que realizar más de una query por inserción)

// FIN DE DUNGEON

// HALL OF FAME
// 1. OBTENEMOS LOS DATOS FALTANTES
SELECT Pais, Nombre_usuario 
FROM Usuarios 
WHERE Email='aaoki@example.com';
// 2. MIRAMOS MEJORES TIEMPOS POR ESA DUNGEON Y PAÍS
SELECT Email, Tiempo, Nombre_mazmorra 
FROM Hall_of_fame 
WHERE Mazmorra_id=0 AND Pais=%[OBTENIDO EN QUERY 1]%
ALLOW FILTERING;
// 3. DESPUÉS DE COMPROBAR SI EL NUEVO TIENE QUE ENTRAR BORRAMOS AL PEOR DEL TOP
DELETE FROM Hall_of_fame 
WHERE Mazmorra_id=0 AND Email=%[EMAIL A BORRAR]% AND Pais=%[PAÍS DEL USUARIO A BORRAR]% AND Tiempo=%[TIEMPO A BORRAR]%;
// 4. FINALMENTE METEMOS AL NUEVO
INSERT INTO Hall_of_fame (Pais, Mazmorra_id, Email, Nombre_usuario, Tiempo, Fecha, Nombre_mazmorra) 
VALUES (%[OBTENIDO EN QUERY 1]%, 0, 'aaoki@example.com', %[OBTENIDO EN QUERY 1]%, 0.5, '2020-04-18 04:46:20', %[OBTENIDO EN QUERY 2]%);

// STATISTICS
INSERT INTO Statistic (Email, Mazmorra_id, Tiempo, Fecha) VALUES ('aaoki@example.com', 0, 0.5, '2020-04-18 04:46:20');

// MUERTE DE UN MONSTRUO EN HORDA
// 1. OBTENEMOS LOS DATOS FALTANTES
SELECT Pais, Nombre_usuario 
FROM Usuarios 
WHERE Email='ymurakami@example.com';
// 2. COMPROBAMOS SI YA TIENE ALGUNA KILL
SELECT N_killed 
FROM Top_horde 
WHERE Evento_id=2 AND Pais=%[OBTENIDO EN QUERY 1]% AND Email='ymurakami@example.com'
ALLOW FILTERING;
// 3. BORRAR E INSERTAR FILA DEL USUARIO, AUMENTANDO N_killed
DELETE FROM Top_horde 
WHERE Evento_id=0 AND Pais=%[OBTENIDO EN QUERY 1]% AND N_killed= %[OBTENIDO EN QUERY 2]% AND Email='ymurakami@example.com';
INSERT INTO Top_horde (Evento_id, Pais, Email, N_killed, Nombre_usuario) 
VALUES (2, %[OBTENIDO EN QUERY 1]%, 'ymurakami@example.com', %[OBTENIDO EN QUERY 2]% ,%[OBTENIDO EN QUERY 1]%);
// 3. SI NO ESTABA SE AÑADE
INSERT INTO Top_horde (Evento_id, Pais, N_killed, Email, Nombre_usuario) 
VALUES (2, %[OBTENIDO EN QUERY 1]%, %[OBTENIDO EN QUERY 2]% , 'ymurakami@example.com', %[OBTENIDO EN QUERY 1]%);