USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados:

SELECT DISTINCT title -- Aparecen los mismos nombres que sin usar DISTINCT, no hay repetidos
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13":

SELECT title, rating -- aunque después se elimine "rating", puesto que no se pide, sirve para comprobar
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra 
-- "amazing" en su descripción:

SELECT title, description
FROM film
WHERE description 
	LIKE '%amazing%'; -- con LIKE buscamos patrones, no coincidencias exactas
					 -- con % representamos que hay cualquier cantidad de caracteres
                     -- (incluyendo ninguno) que pueden aparecer antes y después.
                     
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos

SELECT title, length -- "length" solo para comprobar
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores:

SELECT first_name, last_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido:

SELECT first_name, last_name
FROM actor
WHERE last_name 
	LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20:

SELECT first_name, last_name, actor_id -- "actor_id" solo para comprobar
FROM actor
WHERE actor_id 
	BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean 
-- ni "R" ni "PG-13" en cuanto a su clasificación:

SELECT title, rating -- "raging" solo para comprobar
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
-- y muestra la clasificación junto con el recuento:

SELECT COUNT(rating) AS total, rating
FROM film
GROUP BY rating; -- agrupa todas las filas con un mismo valor en la columna rating
				 -- y con COUNT se cuenta cuántas filas hay de ese grupo
                 
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente 
-- y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas

-- En caso de querer contar SOLO quienes hayan alquilado algo (INNER solo devuelve 
-- coincidencias en ambas tablas):

SELECT 
	c.customer_id AS 'Identidad del cliente', 
    c.first_name AS 'Nombre del cliente',
    c.last_name AS 'Apellido del ciente', 
    COUNT(r.rental_id) AS 'Cantidad alquilada' /* ¿Tendría sentido contar por r.customer_id?
												Ambos cuentan lo mismo, pero rental_id cuenta cada uno
												de los alquileres, está orientado a la pregunta. customer_id
                                                únicamente se refiere al cliente */
FROM
	customer AS c
INNER JOIN 
	rental AS r
		ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id, c.first_name, c.last_name;

-- En caso de que queramos ver también quienes no han alquilado nunca (LEFT nos da también esa información).
-- El resultado es el mismo, 599 filas.

SELECT
	c.customer_id AS 'Identidad del cliente', 
    c.first_name AS 'Nombre del cliente',
    c.last_name AS 'Apellido del ciente', 
    COUNT(r.rental_id) AS 'Cantidad alquilada'
FROM
	customer AS c
LEFT JOIN
	rental AS r
     ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id, c.first_name, c.last_name
ORDER BY
	COUNT(r.rental_id);	-- para comprobar cómo nos enseña los que tienen 0 más fácilmente

/* Curiosamente, si ponemos:
ORDER BY
	'Cantidad alquilada'
no funciona, pero tampoco da error. */

-- 11. Encuentra la cantidad total de películas alquiladas por categoría 
-- y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT
	c.name AS 'Nombre categoría', 
    COUNT(r.rental_id) AS 'Total'
FROM
	film_category AS fc
INNER JOIN
	category AS c
		ON fc.category_id = c.category_id
INNER JOIN
	inventory AS i
		ON fc.film_id = i.film_id
INNER JOIN 
	rental AS r
		ON i.inventory_id = r.inventory_id
GROUP BY
	c.category_id;

-- ¿Si quisiera incluir las que no tienen alquileres podría ser aquí un LEFT?

SELECT
	c.name AS 'Nombre categoría', 
    COUNT(r.rental_id) AS 'Total'
FROM
	film_category AS fc
INNER JOIN
	category AS c
		ON fc.category_id = c.category_id
INNER JOIN
	inventory AS i
		ON fc.film_id = i.film_id
LEFT JOIN -- ¿Si quisiera incluir las que no tienen alquileres podría ser aquí un LEFT?
	rental AS r
		ON i.inventory_id = r.inventory_id
GROUP BY
	c.category_id
ORDER BY
	COUNT(r.rental_id) DESC;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film 
-- y muestra la clasificación junto con el promedio de duración:

/* Originalmente había complicado las cosas de más:

SELECT
	AVG(f.length) AS 'Duración',
    f2.rating AS 'Clasificación'
FROM
	film AS f
JOIN
	film AS f2
		ON f.film_id = f2.film_id
GROUP BY
	f2.rating;*/
    
SELECT
	AVG(length) AS 'Duración',
	rating AS 'Clasificación'
FROM
	film
GROUP BY
	rating;
    
-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con título "Indian Love":

SELECT
	a.first_name AS 'Nombre',
    a.last_name AS 'Apellido'
FROM
	actor AS a
INNER JOIN
	film_actor AS fa
		ON a.actor_id = fa.actor_id
INNER JOIN
	film as f
		ON fa.film_id = f.film_id
WHERE
	f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción:

-- Posibilidad con LIKE:

SELECT
	title AS 'Título',
    description AS 'Descripción' -- para comprobar
FROM
	film
WHERE description LIKE '%dog%'
OR description LIKE '%cat%';

-- Posibilidad con REGEXP:

SELECT
	title AS 'Título',
    description AS 'Descripción' -- para comprobar
FROM
	film
WHERE description REGEXP 'dog|cat';

-- 15. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010:

SELECT
	title AS 'Título',
    release_year AS 'Lanzamiento' -- para comprobar
FROM
	film
WHERE release_year BETWEEN 2005 AND 2010;

SELECT * FROM film
ORDER BY release_year; -- Puesto que el resultado solo daba año de lanzamiento 2006,
					   -- se ha hecho esta comprobación para asegurar que no es un error.


-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family":

SELECT
	f.title AS 'Título',
    c.name AS 'Categoría' -- para comprobar
FROM 
	film AS f
INNER JOIN -- en este caso se usa INNER porque el WHERE ya eliminaría las consultas NULL del LEFT
	film_category AS fc
		ON f.film_id = fc.film_id
INNER JOIN
	category AS c
		ON fc.category_id = c.category_id
WHERE
	c.name = 'Family';

-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film:

SELECT
	title AS 'Título',
    length AS 'Duración', -- para comprobar
    rating AS 'Clasificación' -- para comprobar
FROM
	film
WHERE
	length > 120 AND rating = 'R';
    
-- ****************************************************************************************************************************
-- BONUS
-- ****************************************************************************************************************************
    
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas:

SELECT
	a.first_name AS 'Nombre',
    a.last_name AS 'Apellido',
    COUNT(fa.film_id) AS 'Número de películas' -- Para comprobar cuántas películas tiene el actor
FROM
	actor AS a
LEFT JOIN
	film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY
	a.actor_id -- agrupa por ID único del actor
HAVING
	COUNT(fa.film_id) > 10;
    

-- 19. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor:

SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM
	actor AS a
LEFT JOIN
	film_actor AS fa
		ON a.actor_id = fa.actor_id
WHERE
    fa.actor_id IS NULL;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y
-- muestra el nombre de la categoría junto con el promedio de duración:

SELECT
	c.name AS 'Categoría',
    AVG(f.length) AS 'Duración'
FROM
	category AS c
INNER JOIN -- en este caso se usa INNER por el filtrado de HAVING, no es necesario incluir los NULL
	film_category AS fc
		ON c.category_id = fc.category_id
INNER JOIN
	film AS f
		ON f.film_id = fc.film_id
GROUP BY c.name
HAVING
	AVG(f.length) > 120;
  
-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con
-- la cantidad de películas en las que han actuado:

SELECT
	a.first_name AS 'Nombre',
    a.last_name AS 'Apellido',
    COUNT(fa.film_id) AS 'Número de películas' 
FROM
	actor AS a
LEFT JOIN
	film_actor AS fa
		ON a.actor_id = fa.actor_id
GROUP BY
	a.actor_id -- agrupa por ID único del actor
HAVING
	COUNT(fa.film_id) >= 5
ORDER BY
	COUNT(fa.film_id);


-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
-- y luego selecciona las películas correspondientes:


SELECT
	DISTINCT(f.title)
FROM 
	film AS f
JOIN inventory AS i
	ON f.film_id = i.film_id
WHERE i.inventory_id IN (
	SELECT r.rental_id
    FROM rental AS r
    WHERE DATEDIFF(r.return_date, r.rental_date) > 5 -- con DATEDIFF se puede calcular diferencia
													 -- entre dos fechas para obtener días
);


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
-- "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
-- categoría "Horror" y luego exclúyelos de la lista de actores:

SELECT
	a.first_name AS 'Nombre',
	a.last_name AS 'Apellido'
FROM
	actor AS a
WHERE
	a.actor_id NOT IN (
		SELECT fa.actor_id
		FROM film_actor AS fa
		JOIN film_category AS fc
			ON fa.film_id = fc.film_id
		JOIN category AS c
			ON fc.category_id = c.category_id
		WHERE c.name = 'Horror'
	);


-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
-- tabla film:

SELECT
    f.title AS 'Título',
    c.name AS 'Categoría',      -- para comprobar que es "Comedy"
    f.length AS 'Duración'      -- Para comprobar que sea > 180
FROM
    film AS f
INNER JOIN
    film_category AS fc
		ON f.film_id = fc.film_id
INNER JOIN
    category AS c
		ON fc.category_id = c.category_id
WHERE
    c.name = 'Comedy'
    AND f.length > 180;


-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar
-- el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

SELECT
    a1.first_name AS 'Nombre Actor 1',
    a1.last_name AS 'Apellido Actor 1',
    a2.first_name AS 'Nombre Actor 2',
    a2.last_name AS 'Apellido Actor 2',
    COUNT(*) AS 'Número de películas juntos'
FROM
    film_actor AS fa1 -- aquí tenemos al actor 1 con su película
JOIN
    film_actor AS fa2  -- aquí tenemos al actor 2 con su película
		ON fa1.film_id = fa2.film_id 
			AND fa1.actor_id < fa2.actor_id /*con esto se evita que se repitan (no puede aparecer un a2 con ID
											-- mayor) y que se emparejen consigo mismos (un a1 no puede ser igual
											-- a un a2*/
JOIN
    actor AS a1 
		ON fa1.actor_id = a1.actor_id
JOIN
    actor AS a2 
		ON fa2.actor_id = a2.actor_id
GROUP BY
    fa1.actor_id, fa2.actor_id;  

    
    