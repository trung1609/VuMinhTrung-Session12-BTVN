create table luyentap4.products
                (
                    product_id serial primary key,
                    name       varchar(50),
                    price      numeric
                );
create table luyentap4.orders
(
    order_id     serial primary key,
    product_id   int references luyentap4.products (product_id),
    quantity     int,
    total_amount numeric
);

create or replace function luyentap4.before_insert_orders()
    returns trigger as
$$
declare
    p_price numeric(10, 2);
begin
    select price into p_price from luyentap4.products where product_id = new.product_id;
    new.total_amount := new.quantity * p_price;
    return new;
end;
$$ language plpgsql;
create trigger trg_before_insert_orders
    before insert
    on luyentap4.orders
    for each row
execute function luyentap4.before_insert_orders();

insert into luyentap4.orders (product_id, quantity)
values (1,5);