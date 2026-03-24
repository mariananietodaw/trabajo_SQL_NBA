--Estufiante: Mariana Nieto

--Nivel 1: Composiciones y Cruces de Datos

/*INNER JOIN: Obtén un listado de todos los jugadores que incluya su nombre, su
procedencia y el nombre de la división en la que compite su equipo.*/

SELECT j.NOMBRE,
       j.PROCEDENCIA,
       e.DIVISION
FROM JUGADORES j
INNER JOIN EQUIPOS e
    ON j.NOMBRE_EQUIPO = e.NOMBRE;
    
/*LEFT OUTER JOIN: Muestra el nombre de todos los jugadores de la liga y los puntos
por partido que promediaron en la temporada '04/05'. Es obligatorio que aparezcan
todos los jugadores de la tabla, incluso si no tienen estadísticas en esa temporada
(en ese caso, los puntos aparecerán como NULL).*/

SELECT j.NOMBRE,
       e.PUNTOS_POR_PARTIDO
FROM JUGADORES j
LEFT OUTER JOIN ESTADISTICAS e
    ON j.CODIGO = e.JUGADOR
    AND e.TEMPORADA = '04/05';
    
/*RIGHT OUTER JOIN: Necesitamos un listado de todos los equipos y las ciudades
registradas. Asegúrate de mostrar todos los equipos de la tabla EQUIPOS, incluso si
actualmente no tienen jugadores asignados en la tabla JUGADORES.*/

SELECT e.NOMBRE,
       e.CIUDAD
FROM JUGADORES j
RIGHT OUTER JOIN EQUIPOS e
    ON j.NOMBRE_EQUIPO = e.NOMBRE;
    
/*CROSS JOIN: Por motivos de marketing, la liga quiere combinar cada nombre de
equipo con cada una de las conferencias existentes ('East' y 'West'). Genera este
producto cartesiano.*/

SELECT e.NOMBRE AS EQUIPO, c.CONFERENCIA AS EQUIPO
FROM EQUIPOS e
CROSS JOIN (
    SELECT 'East' AS CONFERENCIA FROM DUAL
    UNION
    SELECT 'West' FROM DUAL
) c;

/*FULL OUTER JOIN: Realiza una auditoría total de la relación entre jugadores y
equipos. El resultado debe mostrar cualquier jugador sin equipo asignado y
cualquier equipo que no tenga jugadores, asegurando que no se pierda ninguna fila
de ninguna de las dos tablas.*/

SELECT j.NOMBRE AS JUGADOR, e.NOMBRE AS EQUIPO
FROM JUGADORES j
FULL OUTER JOIN EQUIPOS e
ON j.NOMBRE_EQUIPO = e.NOMBRE;

//Nivel 2: Lógica Avanzada y Subconsultas

/*FILTRADO DE NULOS: Utilizando un LEFT JOIN, identifica el nombre de aquellos
equipos que actualmente no tienen ningún jugador registrado en la base de datos.*/

SELECT e.NOMBRE AS EQUIPO_SIN_JUGADORES
FROM EQUIPOS e
LEFT JOIN JUGADORES j
ON e.NOMBRE = j.NOMBRE_EQUIPO
WHERE j.NOMBRE_EQUIPO IS NULL;

/*AUTOCONEXIÓN (SELF-JOIN) SIMULADO: Muestra los resultados de los partidos de
la temporada '07/08'. La consulta debe devolver cuatro columnas: EQUIPO_LOCAL,
PUNTOS_LOCAL, PUNTOS_VISITANTE y EQUIPO_VISITANTE*/

SELECT el.NOMBRE AS EQUIPO_LOCAL, 
       p.PUNTOS_LOCAL, 
       p.PUNTOS_VISITANTE, 
       ev.NOMBRE AS EQUIPO_VISITANTE
FROM PARTIDOS p
JOIN EQUIPOS el ON p.EQUIPO_LOCAL = el.NOMBRE
JOIN EQUIPOS ev ON p.EQUIPO_VISITANTE = ev.NOMBRE
WHERE p.TEMPORADA = '07/08';

/*SUBCONSULTA CON "IN": Selecciona el nombre de los jugadores que pertenecen a
equipos de la división 'Pacific' o 'Atlantic'. Debes resolverlo utilizando una
subconsulta sobre la tabla EQUIPOS.*/




