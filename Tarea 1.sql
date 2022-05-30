-- ejercicios - Tarea 1
-- 1)

select * from suppliers s
where upper(s.contact_title) = upper('Sales Representative');

-- 2)

select * from suppliers s
where upper(s.contact_title) <> upper('marketing manager');

-- 3)

select distinct o.order_id, c.country
from orders o join customers c using(customer_id)
where c.country <> 'USA';

-- 4)

select distinct p.product_id, p.product_name, c.description
from categories c join products p using(category_id)
join order_details od using(product_id)
join orders o using (order_id)
where shipped_date is not null 
and c.description ='Cheeses';


-- 5)

select o.order_id, o.ship_country 
from orders o
where o.ship_country  = 'Belgium' or o.ship_country ='France';

-- 6)

select distinct o.order_id, o.ship_country 
from orders o
where o.ship_country in ('Brazil', 'Venezuela', 'Mexico', 'Argentina');

-- 7)

select distinct o.order_id, o.ship_country 
from orders o
where not (o.ship_country in ('Brazil', 'Venezuela', 'Mexico', 'Argentina'));

-- 8)

select e.first_name || ' ' || e.last_name full_name
from employees e;

-- 9)

select sum(p.unit_price*p.units_in_stock) from products p;

-- 10)

select c.country, count(customer_id) from customers c
group by country;

-------Ejercicios - Tarea 1 continuaci�n

--Reporte de edades para seguros de gastos medicos menores
select e.first_name, e.last_name, age(e.birth_date) 
from employees e;

--Orden m�s reciente por cliente 
select c.contact_name, max(o.order_date) 
from orders o join customers c on (c.customer_id = o.customer_id)
group by c.contact_name;

--de nuestros clientes, �qu� funci�n desempe�an y cu�ntos son?
select c.contact_title, count(c.contact_title) 
from customers c 
group by c.contact_title;

--�Cu�ntos productos tenemos de cada categor�a?
select c.category_name, count(p.category_id)
from products p join categories c on(c.category_id = p.category_id)
group by c.category_name;

--�C�mo podemos generar el reporte de reorder?

select product_id, product_name, units_in_stock, reorder_level 
from products p 
where (units_in_stock<reorder_level);

--�A donde va nuestro env�o m�s voluminoso?
select o.ship_country, od.quantity
from order_details od join orders o on (od.order_id = o.order_id)
order by od.quantity desc limit 1;

--�C�mo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
select t.company_name, t.total,
	case 
		when t.total < 10000 then 'malo'
		when t.total >= 10000 and t.total <100000 then 'regular'
		else 'bueno'
	end as categoria
from (
	select c.company_name,  
		sum(od.unit_price*od.quantity*(1-od.discount))as total  
	from customers c 
		join orders o using (customer_id)
		join order_details od using (order_id)
	group by c.company_name
	order by total
) as t;

--�Qu� colaboradores chambearon durante las fiestas de navidad?
select e.first_name, e.last_name 
from orders o join employees e on (o.employee_id = e.employee_id)
where extract(month from o.shipped_date) = 12 and (extract(day from o.shipped_date) = 25 or extract(day from o.shipped_date) = 24);

--�Qu� productos mandamos en navidad?
select p.product_name 
from products p join order_details od on (p.product_id = od.product_id) join orders o on (od.order_id = o.order_id)
where extract(month from o.shipped_date) = 12 and extract(day from o.shipped_date) = 25;

--�Qu� pa�s recibe el mayor volumen de producto?
select o.ship_country, sum(od.quantity) 
from order_details od join orders o on (od.order_id = o.order_id)
group by o.ship_country 
order by sum(od.quantity) desc limit 1;



------------Tarea 2-------------------------------

create table heroes(
hero_id numeric(4,0) constraint pk_heroes primary key,
nombre varchar(50) not null,
email varchar(80) not null
);

create sequence hero_id_hero_seq start 1 increment 1;
alter table heroes 
alter column hero_id set default nextval('hero_id_hero_seq');

insert into heroes(nombre, email) 
values('Wanda Maximoff', 'wanda.maximoff@avengers.org'),
('Pietro Maximoff', 'pietro@mail.sokovia.ru'),
('Erik Lensherr', 'fuck_you_charles@brotherhood.of.evil.mutants.space'),
('Charles Xavier', 'i.am.secretely.filled.with.hubris@xavier-school-4-gifted-youngste.'),
('Anthony Edward Stark', 'iamironman@avengers.gov'),
('Steve Rogers','americas_ass@anti_avengers'),
('The Vision','vis@westview.sword.gov'),
('Clint Barton', 'bul@lse.ye'),
('Natasja Romanov', 'blackwidow@kgb.ru'),
('Thor', 'god_of_thunder-^_^@royalty.asgard.gov'),
('Logan','wolverine@cyclops_is_a_jerk.com'),
('Ororo Monroe','ororo@weather.co'),
('Scott Summers','o@x'),
('Nathan Summers','cable@xfact.or'),
('Groot','iamgroot@asgardiansofthegalaxyledbythor.quillsux'),
('Nebula','idonthaveelektras@complex.thanos'),
('Gamora','thefiercestwomaninthegalaxy@thanos.'),
('Rocket','shhhhhhhh@darknet.ru');

SELECT * FROM heroes WHERE email NOT LIKE '%@%.%';

-- tarea 3---------------------------------------
--�C�mo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campa�a?
select c.first_name || ' ' || c.last_name full_name, c.email, c3.country 
from customer c join address a using(address_id)
join city c2 using(city_id)
join country c3 using (country_id)
where c3.country = 'Canada';

--�Qu� cliente ha rentado m�s de nuestra secci�n de adultos?
select c.first_name || ' ' || c.last_name as full_name, count(*)
from customer c join rental r using(customer_id)
join inventory i using (inventory_id)
join film f using (film_id)
where f.rating = 'NC-17'
group by c.customer_id
order by 2 desc;


--�Qu� pel�culas son las m�s rentadas en todas nuestras stores?
select distinct on(i.store_id) i.store_id, c.city, f.title, count(f.film_id)
from film f join inventory i using(film_id)
join rental r using(inventory_id)
join store s using (store_id)
join address a using (address_id)
join city c using (city_id)
group by i.store_id, c.city, f.film_id 
order by i.store_id, count(f.film_id) desc;

--�Cu�l es nuestro revenue por store?
select s.store_id, c.city,  sum(p.amount)
from city c join address a using (city_id)
join store s using (address_id)
join inventory i using(store_id)
join rental r using(inventory_id)
join payment p using(rental_id)
group by s.store_id, c.city;




------------------------------tarea 1 funciones
--Una aplicaci�n frecuente de Ciencia de Datos aplicada a la industria del microlending es el de calificaciones
--crediticias (credit scoring). Puede interpretarse de muchas formas: propensi�n a pago, probabilidad de default,
--etc. La intuici�n nos dice que las variables m�s importantes son el saldo o monto del cr�dito,
--y la puntualidad del pago; sin embargo, otra variable que frecuentemente escapa a los analistas es el tiempo 
--entre cada pago. La puntualidad es una p�sima variable para anticipar default o inferir capacidad de pago 
--de micropr�stamos, por su misma naturaleza. Si deseamos examinar la viabilidad de un producto de cr�dito para 
--nuestras videorental stores:

--Cu�l es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
--soluci�n: para saber el promedio s�lo necesito saber la diferencia de tiempo entre el primer pago y el �ltimo
-- y dividirlo entre los n pagos menos 1. 
--(resumido en d�as) porque que flojera estar viendo hasta las horas
--despu�s dividirlo entre la cantidad de pagos
with primer_ultimo_pago as(
	select c.customer_id, count(p.payment_id) as n, min(p.payment_date) as primer_pago, max(p.payment_date) as ultimo_pago
	from customer c join payment p using (customer_id)
	group by c.customer_id
	order by c.customer_id asc
	)
	select c.customer_id, c.first_name || ' ' || c.last_name as full_name, 
	date_trunc('day', age(primer_ultimo_pago.ultimo_pago, primer_ultimo_pago.primer_pago)/(primer_ultimo_pago.n-1)) as promedio_tiempo_entre_pagos
	from customer c join primer_ultimo_pago using (customer_id);

--Sigue una distribuci�n normal?
with promedio as (
	with primer_ultimo_pago as(
		select c.customer_id, count(p.payment_id) as n, min(p.payment_date) as primer_pago, max(p.payment_date) as ultimo_pago
		from customer c join payment p using (customer_id)
		group by c.customer_id
		order by c.customer_id asc
		)
		select c.customer_id, c.first_name || ' ' || c.last_name as full_name, 
		date_trunc('day', age(primer_ultimo_pago.ultimo_pago, primer_ultimo_pago.primer_pago)/(primer_ultimo_pago.n-1)) as promedio_tiempo_entre_pagos
		from customer c join primer_ultimo_pago using (customer_id)
	)

--Qu� tanto difiere ese promedio del tiempo entre rentas por cliente?
--saqu� la desviaci�n est�ndar de la columna de promedios de los clientes de la pregunta 1
with promedio as (
	with primer_ultimo_pago as(
		select c.customer_id, count(p.payment_id) as n, min(p.payment_date) as primer_pago, max(p.payment_date) as ultimo_pago
		from customer c join payment p using (customer_id)
		group by c.customer_id
		order by c.customer_id asc
		)
		select c.customer_id, c.first_name || ' ' || c.last_name as full_name, 
		to_char(date_trunc('day', age(primer_ultimo_pago.ultimo_pago, primer_ultimo_pago.primer_pago)/(primer_ultimo_pago.n-1)), 'DD'):: integer as promedio_tiempo_entre_pagos
		from customer c join primer_ultimo_pago using (customer_id)
	)
	select stddev(promedio.promedio_tiempo_entre_pagos) from promedio;
	
	




------------------------------tarea 2 funciones 
--Parte de la infraestructura es dise�ar contenedores cil�ndricos giratorios para facilitar 
--la colocaci�n y extracci�n de discos por brazos automatizados. 
--Cada cajita de Blu-Ray mide 20cm x 13.5cm x 1.5cm, y para que el brazo pueda manipular 
--adecuadamente cada cajita, debe estar contenida dentro de un arn�s que cambia las medidas a
--30cm x 21cm x 8cm para un espacio total de 5040 cent�metros c�bicos y un peso de 500 gr por pel�cula.

--Se nos ha encargado formular la medida de dichos cilindros de manera tal que quepan todas las copias 
--de los Blu-Rays de cada uno de nuestros stores. 
--Las medidas deben ser est�ndar, es decir, la misma para todas nuestras stores, y en cada store pueden ser instalados m�s de 1 de estos cilindros. 
--Cada cilindro aguanta un peso m�ximo de 50kg como m�ximo. 

--N�mero de pel�culas en las tiendas
with num_peliculas as (
	select s.store_id, count(i.inventory_id) as num_pelis
 	from inventory i join store s using(store_id)
 	group by s.store_id
 ), 
 --Cada cilindro puede contener 50kg, como las pel�culas pesan 500 gr, podemos alamcenar 100 en un cilindro 
 --La altura del cilindro ser� la altura de cada pel�cula con el arn�s 8 cm * 100 = 800 cm
altura_cilindro as (
	select 8 * 100 as altura_cilindro
), 
--El diametro del cilindro debe ser suficiente para almacenar la pel�cula. Con un radio de 16 cm es suficiente 
radio_cilindro as (
	select 16 as radio_cilindro
), 
--Para saber cuantos cilindros necesita cada tienda dividimos el n�mero de pel�culas entre 100
cilindros_tienda as (
	select np.store_id, ceiling(np.num_pelis/100 :: numeric) as num_cilindros
	from num_peliculas np
)

--Cilindros necesarios en cada tienda 
select * 
from cilindros_tienda

--Calculamos el volumen del cilindro 
select altura_cilindro, radio_cilindro, pi()*power(radio_cilindro, 2)*altura_cilindro as volumen_cilindro
from altura_cilindro, radio_cilindro