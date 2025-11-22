create table luyentap6.accounts
(
    account_id   serial primary key,
    account_name varchar(50),
    balance      numeric
);

create or replace procedure luyentap6.funds_tranfer(
    acc_no_sender varchar(50),
    acc_no_receive varchar(50),
    amount numeric
)
    language plpgsql
as
$$
declare
    p_balance numeric;
    cnt_acc int;
begin
    --Kiem tra tai khoan dung hay khong
    select count(account_name) into cnt_acc from luyentap6.accounts acc where account_name in (acc_no_sender, acc_no_receive);
    if cnt_acc != 2 then
        raise exception 'Tai khoan khong chinh xac';
    end if;

    --Kiem tra so du
    select balance into p_balance from luyentap6.accounts where account_name = acc_no_sender;
    if p_balance < amount then
        raise exception 'So du khong du';
    end if;

    --Tru tien tai khoan gui
    update luyentap6.accounts set balance = balance - amount where accounts.account_name = acc_no_sender;
    --Cong tien tai khoan nhan
    update luyentap6.accounts set balance = balance + amount where accounts.account_name = acc_no_receive;

exception
    when others then
        rollback;
        raise;
end;
$$;

call luyentap6.funds_tranfer('123456','567890',10000);