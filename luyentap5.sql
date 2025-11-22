create table luyentap5.employees
(
    emp_id   serial primary key,
    name     varchar(50),
    position varchar(50)
);
create table luyentap5.employee_log
(
    log_id      serial primary key,
    emp_name    varchar(50),
    action_time timestamp
);

create or replace function luyentap5.after_update_employees()
    returns trigger as
$$
begin
    insert into luyentap5.employee_log (emp_name, action_time) values (new.name, now());
    return new;
end;
$$ language plpgsql;

create trigger trg_after_update_employees
    after update
    on luyentap5.employees
    for each row
execute function luyentap5.after_update_employees();

update luyentap5.employees
set position = 'BA'
where employees.emp_id = 2;