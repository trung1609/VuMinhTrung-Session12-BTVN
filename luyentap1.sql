create table luyentap1.customers
(
    customer_id serial primary key,
    name        varchar(50),
    email       varchar(50)
);
create table luyentap1.customer_log
(
    log_id        serial primary key,
    customer_name varchar(50),
    action_time   timestamp
);

create or replace function luyentap1.after_insert_customers()
    returns trigger as
$$
begin
    insert into luyentap1.customer_log (customer_name, action_time) values (new.name, now());
    return new;
end;
$$ language plpgsql;

create trigger trg_after_insert_customers
    after insert
    on luyentap1.customers
    for each row
execute function luyentap1.after_insert_customers();

insert into luyentap1.customers (name, email)
values ('Trung', 'trung@gmail.com'),
       ('Hung', 'hung@gmail.com'),
       ('Dung','dung@gmail.com');