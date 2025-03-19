# Memoria de la Base de Datos Cassandra para el videojuego

Este documento describe el diseño, implementación y consideraciones realizadas para la migración del modelo relacional a una base de datos NoSQL (Cassandra) destinada a la gestión de estadísticas y registros en un videojuego.

### Quick start

1. **Iniciar el Clúster:**
   - Levantar la base de datos con 3 nodos:
     ```bash
     docker compose up -d
     ```

2. **Preparar Archivos:**
   - Copiar el archivo `creacion.cql` y la carpeta `resultados` en la carpeta `tmp/cassandra1`:
     ```bash
     cp creacion.cql tmp/cassandra1/
     cp -r Query_sql/resultados tmp/cassandra1/
     ```

3. **Cargar los Datos en Cassandra:**
   - Ingresar al contenedor:
     ```bash
     docker exec -it cassandra1 cqlsh
     ```
   - Ejecutar en `cqlsh`:
     ```cql
     SOURCE '/var/lib/cassandra/creacion.cql';
     ```

4. **Ejecución de Consultas:**
   - Las queries se pueden ejecutar desde `cqlsh` o utilizando funciones en Python.

## Diseño del Modelo de Datos

### Uso del Email como Identificador

- Se utiliza el campo **Email** como equivalente al **UserID** del modelo relacional.

### Tabla Hall_of_fame

- **Clustering Key:** Se emplea el campo **Email** para distinguir casos en los que dos usuarios del mismo país completan la misma mazmorra con el mismo tiempo.
- **Nombre de la Mazmorra:** Es un campo estático, ya que cada partición (definida por la *mazmorra id*) corresponde siempre al mismo nombre.
- **Orden de Tiempos:** Los tiempos se ordenan de forma ascendente para facilitar la selección de los 5 mejores registros.

### Tabla Statistic
- **Clave de Partición:** Se ha utilizado como clave de partición los valores de **Email** y **mazmorra_id** para almacenar de forma conjunta las estadísticas de cada jugador sobre cada mazmorra.
- **Clustering Key:** Hemos usado **Tiempo** para ordenar de menor a mayor los tiempos de finalización de cada mazmorra junto con **Fecha** para evitar que si un jugador completa la misma mazmorra dos veces con el mismo tiempo, se pierda información sobre sus estadísticas.

### Tabla Top_horde

- **Clave de Partición:** Se utiliza la combinación de **evento_id** y **País**, puesto que el mismo evento se repite en distintos países.
- **Clustering Key:** Se utiliza **N_killed** (número de enemigos derrotados) en orden descendente para priorizar a los jugadores que hayan eliminado a más enemigos.
  - Aunque se consideró no usar **N_killed** como clave de clustering para facilitar las actualizaciones, se decidió mantenerlo para optimizar la velocidad de lectura. Esto implica que, para actualizar el valor, se debe realizar un **delete/insert**, operación más costosa en escritura.
  - Para disminuir las probabilidades de que se lea entre el borrado y la inserción, se realizan ambas operaciones juntas en un *batch*.

### Tabla Usuarios

- Se creó la tabla **Usuarios** para facilitar las operaciones de inserción, ya que algunas solicitudes incluyen datos adicionales (como el nombre de usuario) que no siempre se encuentran en la consulta original.

### Niveles de Consistencia y Escritura

- **Consultas Hall_of_fame y User Statistics:** Requieren alta consistencia, por lo que se configuró el nivel de consistencia a **ALL**.
- **Consulta Top_horde:** Se prioriza la velocidad de lectura, utilizando el nivel de consistencia **LOCAL_ONE**.
- **Escrituras:** Se utiliza el nivel **ANY** para que la escritura se considere exitosa tan pronto un nodo confirme la operación. Además, al completar una horda se activa una función que elimina y reescribe el número de monstruos eliminados.

### Diagramas

#### Entidad Relación

![Entidad_relación](docs/er_cutted.svg)

#### Chebotko Diagram

![Diagrama_Chebotko](docs/diagrama.png)



## Implementación

### Importación de Datos

- Los datos se importaron desde archivos CSV generados a partir del modelo relacional.
- El archivo `query_sql.ipynb` se encarga de crear las tablas CSV y posteriormente copiar los datos a Cassandra.
- Se han eliminado las filas con tiempos iguales a 0 para evitar errores, ya que en la tabla **Top_horde** solo se almacenan 5 usuarios por cada mazmorra en cada país.

### Creación cluster local

- Para crear el cluster local se ha usado un docker compose `compose.yaml`, que crea los 3 nodos en 3 contenedores.

Hemos creado también `creacion.cql`, donde se implementa el diseño de las 3 tablas diseñadas dentro del keyspace videojuego en cql.

### Queries 

Hemos creado `queries.cql` con ejemplo de las queries que utilizaríamos para realizar los ejercicios solicitados, pero también hemos creado `escritura.ipynb` y `lectura.iypnb`, para simular de manera más realista como el videojuego haría las peticiones a la base de datos mediante triggers o llamadas a funciones. Estos cuadernos jupyter funcionan una vez la base de datos ha sido creada .

---