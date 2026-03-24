/*_____Ejercicios NBA Parte 3: Operaciones SELECT
_______multitabla. Uso avanzado.__________________*/

-- ____Estudiante: Mariana Nieto


--_______________________________________________ NIVEL 1: JOINS Y CRUCES

/* INNER JOIN:
   Obtiene un listado de todos los jugadores junto con:
   - su nombre
   - su procedencia
   - la división del equipo al que pertenecen
   Solo aparecen jugadores que tienen equipo asociado */
   
SELECT j.NOMBRE,          -- Nombre del jugador
       j.PROCEDENCIA,    -- Lugar de procedencia
       e.DIVISION        -- División del equipo
FROM JUGADORES j
INNER JOIN EQUIPOS e
    ON j.NOMBRE_EQUIPO = e.NOMBRE;  -- Relación entre jugador y su equipo
    

/* LEFT OUTER JOIN:
   Muestra TODOS los jugadores, aunque no tengan estadísticas.
   Si no jugaron en la temporada '04/05', los puntos serán NULL */
   
SELECT j.NOMBRE,                -- Nombre del jugador
       e.PUNTOS_POR_PARTIDO    -- Promedio de puntos
FROM JUGADORES j
LEFT OUTER JOIN ESTADISTICAS e
    ON j.CODIGO = e.JUGADOR           -- Relación jugador-estadísticas
    AND e.TEMPORADA = '04/05';        -- Filtro de temporada dentro del JOIN
    

/* RIGHT OUTER JOIN:
   Muestra TODOS los equipos, incluso si no tienen jugadores.
   Se usa RIGHT JOIN porque la tabla principal es EQUIPOS */
   
SELECT e.NOMBRE,    -- Nombre del equipo
       e.CIUDAD     -- Ciudad del equipo
FROM JUGADORES j
RIGHT OUTER JOIN EQUIPOS e
    ON j.NOMBRE_EQUIPO = e.NOMBRE;  -- Relación con jugadores
    

/* CROSS JOIN:
   Genera todas las combinaciones posibles entre:
   - equipos
   - conferencias ('East' y 'West')
   Esto es un producto cartesiano */
   
SELECT e.NOMBRE AS EQUIPO,       -- Nombre del equipo
       c.CONFERENCIA AS CONFERENCIA  -- Conferencia asignada
FROM EQUIPOS e
CROSS JOIN (
    SELECT 'East' AS CONFERENCIA FROM DUAL
    UNION
    SELECT 'West' FROM DUAL
) c;


/* FULL OUTER JOIN:
   Muestra TODOS los jugadores y TODOS los equipos:
   - Jugadores sin equipo
   - Equipos sin jugadores
   No se pierde información de ninguna tabla */
   
SELECT j.NOMBRE AS JUGADOR,  -- Nombre del jugador
       e.NOMBRE AS EQUIPO    -- Nombre del equipo
FROM JUGADORES j
FULL OUTER JOIN EQUIPOS e
ON j.NOMBRE_EQUIPO = e.NOMBRE;


-- 
--_________________________________________NIVEL 2: LÓGICA AVANZADA
-- 

/* FILTRADO DE NULOS:
   Encuentra equipos que NO tienen jugadores asociados.
   Se detecta cuando el JOIN no encuentra coincidencia (NULL) */
   
SELECT e.NOMBRE AS EQUIPO_SIN_JUGADORES
FROM EQUIPOS e
LEFT JOIN JUGADORES j
ON e.NOMBRE = j.NOMBRE_EQUIPO
WHERE j.NOMBRE_EQUIPO IS NULL;  -- Indica que no hay jugadores


/* SELF-JOIN (simulado con dos alias):
   Muestra partidos con:
   - equipo local
   - puntos local
   - puntos visitante
   - equipo visitante */
   
SELECT el.NOMBRE AS EQUIPO_LOCAL,     -- Equipo que juega en casa
       p.PUNTOS_LOCAL,               -- Puntos del equipo local
       p.PUNTOS_VISITANTE,           -- Puntos del visitante
       ev.NOMBRE AS EQUIPO_VISITANTE -- Equipo visitante
FROM PARTIDOS p
JOIN EQUIPOS el ON p.EQUIPO_LOCAL = el.NOMBRE   -- Relación equipo local
JOIN EQUIPOS ev ON p.EQUIPO_VISITANTE = ev.NOMBRE -- Relación equipo visitante
WHERE p.TEMPORADA = '07/08';  -- Filtro por temporada


/* SUBCONSULTA CON IN:
   Selecciona jugadores cuyos equipos pertenecen a:
   - división Pacific
   - división Atlantic */
   
SELECT NOMBRE
FROM JUGADORES
WHERE NOMBRE_EQUIPO IN (
    SELECT NOMBRE
    FROM EQUIPOS
    WHERE DIVISION IN ('Pacific', 'Atlantic')  -- Filtro de divisiones
);


/* OPERADOR ALL:
   Obtiene jugadores más altos que TODOS los jugadores
   de 'Dallas Mavericks' */
   
SELECT NOMBRE, ALTURA
FROM JUGADORES
WHERE ALTURA > ALL (
    SELECT ALTURA
    FROM JUGADORES
    WHERE NOMBRE_EQUIPO = 'Dallas Mavericks'
);


/* SUBCONSULTA CORRELACIONADA:
   Muestra jugadores que:
   - están en la temporada '04/05'
   - tienen más puntos que la media de su propio equipo */
   
SELECT j.NOMBRE, s.PUNTOS_POR_PARTIDO
FROM JUGADORES j
JOIN ESTADISTICAS s ON j.CODIGO = s.JUGADOR
WHERE s.TEMPORADA = '04/05'
  AND s.PUNTOS_POR_PARTIDO > (
      SELECT AVG(s2.PUNTOS_POR_PARTIDO)  -- Media del equipo
      FROM ESTADISTICAS s2
      JOIN JUGADORES j2 ON s2.JUGADOR = j2.CODIGO
      WHERE s2.TEMPORADA = '04/05'
        AND j2.NOMBRE_EQUIPO = j.NOMBRE_EQUIPO  -- Comparación con su equipo
  );
