create table luyentap2.products
(
    product_id serial primary key,
    name       varchar(50),
    stock      int
);
create table luyentap2.sales
(
    sale_id    serial primary key,
    product_id int references luyentap2.products (product_id),
    quantity   int
);

create or replace function luyentap2.before_insert_products()
    returns trigger
as
$$
declare
    p_stock      int;
begin
    select stock into p_stock from luyentap2.products where product_id = new.product_id;
    if new.quantity > p_stock then
        raise exception 'Hang trong kho khong du';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_before_insert_products
    before insert
    on luyentap2.sales
    for each row
execute function luyentap2.before_insert_products();

insert into luyentap2.sales (product_id, quantity)

values (1, 10);
