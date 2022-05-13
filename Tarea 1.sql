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

-------Ejercicios - Tarea 1 continuación

--Reporte de edades para seguros de gastos medicos menores
select e.first_name, e.last_name, age(e.birth_date) 
from employees e;

--Orden más reciente por cliente 
select c.contact_name, max(o.order_date) 
from orders o join customers c on (c.customer_id = o.customer_id)
group by c.contact_name;

--de nuestros clientes, ¿qué función desempeñan y cuántos son?
select c.contact_title, count(c.contact_title) 
from customers c 
group by c.contact_title;

--¿Cuántos productos tenemos de cada categoría?
select c.category_name, count(p.category_id)
from products p join categories c on(c.category_id = p.category_id)
group by c.category_name;

--¿Cómo podemos generar el reporte de reorder?

select product_id, product_name, units_in_stock, reorder_level 
from products p 
where (units_in_stock<reorder_level);

--¿A donde va nuestro envío más voluminoso?
select o.ship_country, od.quantity
from order_details od join orders o on (od.order_id = o.order_id)
order by od.quantity desc limit 1;

--¿Cómo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
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

--¿Qué colaboradores chambearon durante las fiestas de navidad?
select e.first_name, e.last_name 
from orders o join employees e on (o.employee_id = e.employee_id)
where extract(month from o.shipped_date) = 12 and (extract(day from o.shipped_date) = 25 or extract(day from o.shipped_date) = 24);

--¿Qué productos mandamos en navidad?
select p.product_name 
from products p join order_details od on (p.product_id = od.product_id) join orders o on (od.order_id = o.order_id)
where extract(month from o.shipped_date) = 12 and extract(day from o.shipped_date) = 25;

--¿Qué país recibe el mayor volumen de producto?
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
--¿Cómo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campaña?
select c.first_name || ' ' || c.last_name full_name, c.email, c3.country 
from customer c join address a using(address_id)
join city c2 using(city_id)
join country c3 using (country_id)
where c3.country = 'Canada';

--¿Qué cliente ha rentado más de nuestra sección de adultos?
select c.first_name || ' ' || c.last_name as full_name, count(*)
from customer c join rental r using(customer_id)
join inventory i using (inventory_id)
join film f using (film_id)
where f.rating = 'NC-17'
group by c.customer_id
order by 2 desc;


--¿Qué películas son las más rentadas en todas nuestras stores?
select distinct on(i.store_id) i.store_id, c.city, f.title, count(f.film_id)
from film f join inventory i using(film_id)
join rental r using(inventory_id)
join store s using (store_id)
join address a using (address_id)
join city c using (city_id)
group by i.store_id, c.city, f.film_id 
order by i.store_id, count(f.film_id) desc;

--¿Cuál es nuestro revenue por store?
select s.store_id, c.city,  sum(p.amount)
from city c join address a using (city_id)
join store s using (address_id)
join inventory i using(store_id)
join rental r using(inventory_id)
join payment p using(rental_id)
group by s.store_id, c.city;

