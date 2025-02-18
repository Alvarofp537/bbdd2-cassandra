# Práctica 1 BBDD [Cassandra]
### Completar 3 leaderbords:
1 y 2 son querys a una base de datos con los tiempos en sacar mazmorras
1. Hall of Fame por país 
    - Por cada país, por cada mazmorra: Top 5 jugadores más rápido
    - Muestra los tiempos de cada uno
    - Importante consistencia
    - No tan importante la velocidad de actualización


1. Estadísticas jugador
    - Muestra tiempo que ha tardado en completar cada mazmorra ordenado de menor a mayor
    - Importante consistencia
    - No tan importante la velocidad de actualización 

La 3 es otra parte de la base de datos, relacionado con nº de bichos matados en esa horda en específico

3. Hordas:
    - Disponible **solo** para algunos jugadores (todos del mismo país)
    - Muestra N jugadores que más monstruos ha matado
    - Importante velocidad de actualización
    - No tan importante la consistencia

### Pasos a seguir
[x] 0. Crear el readme especificando el problema y como enfocarlo
[] 1. Definir bien las querys a realizar con cada leaderboard
[] 2. Crear las tablas teniendo en cuenta las primery, cluster y static keys (lo que sea eso)
[] 3. Tener en cuenta para cada una el tipo de cassandra según que es más importante
[] 4. Crear las query
