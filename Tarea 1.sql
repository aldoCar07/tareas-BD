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

select p.product_name, p.units_in_stock, p.units_on_order, p.reorder_level,
s.company_name, s.contact_name, s.contact_title, p.discontinued
from products p join suppliers s using(supplier_id);

--¿A donde va nuestro envío más voluminoso?
select o.ship_country, od.quantity
from order_details od join orders o on (od.order_id = o.order_id)
order by od.quantity desc limit 1;

--¿Cómo creamos una columna en customers que nos diga si un cliente es bueno, regular, o malo?
alter table customers 
add column calidad varchar(7) default 'regular';

alter table customers
add constraint CK_customers_calidad check (calidad in ('bueno', 'regular', 'malo')); 

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

