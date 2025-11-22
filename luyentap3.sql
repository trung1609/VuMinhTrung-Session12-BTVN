create table luyentap3.products
(
    product_id serial primary key,
    name       varchar(50),
    stock      int
);
create table luyentap3.sales
(
    sale_id    serial primary key,
    product_id int references luyentap3.products (product_id),
    quantity   int
);

create or replace function luyentap3.after_insert_products()
    returns trigger as
$$
declare
    p_stock int;
begin
    select stock into p_stock from luyentap3.products where product_id = new.product_id;
    update luyentap3.products set stock = p_stock - new.quantity where products.product_id = new.product_id;
    return new;
end;
$$ language plpgsql;

create trigger trg_after_insert_products
    after insert
    on luyentap3.sales
    for
        each row
execute function luyentap3.after_insert_products();

insert into luyentap3.sales (product_id, quantity)
values (1, 5);