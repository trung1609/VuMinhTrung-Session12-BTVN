create table luyentap7.products
(
    product_id serial primary key,
    name       varchar(50)    not null,
    price      numeric(10, 2) not null,
    stock      int            not null
);
create table luyentap7.orders
(
    order_id     serial primary key,
    product_id   int references luyentap7.products (product_id),
    quantity     int not null,
    total_amount numeric(10, 2)
);

create table luyentap7.order_log
(
    log_id      serial primary key,
    order_id    int,
    action_time timestamp
);

create or replace procedure luyentap7.order_product(
    p_product_id int,
    p_quantity int
)
    language plpgsql
as
$$
declare
    p_stock    int;
    p_total    numeric(10, 2);
    p_price    numeric(10, 2);
    p_order_id int;
begin

    perform 1 from luyentap7.products where product_id = p_product_id;
    if not FOUND then
        raise exception 'Khong tim thay san pham voi ID la %', p_product_id;
    end if;
    --Kiem tra san pham co con hang hay ko
    select stock, price into p_stock, p_price from luyentap7.products where product_id = p_product_id;
    if p_stock < p_quantity then
        raise exception 'So hang trong kho khong du';
    end if;
    p_total := p_quantity * p_price;
    insert into luyentap7.orders (product_id, quantity, total_amount)
    values (p_product_id, p_quantity, p_total)
    returning order_id into p_order_id;
    update luyentap7.products set stock = p_stock - p_quantity where products.product_id = p_product_id;

    insert into luyentap7.order_log (order_id, action_time) values (p_order_id, now());

exception
    when others then
        rollback;
        raise;
end;
$$;

call luyentap7.order_product(1, 2);