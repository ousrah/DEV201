use notes;

drop table if exists test;
create table test (id int auto_increment primary key, nom varchar(50) not null unique);

insert into test(nom) values ('iam');
insert into test(nom) values ('meditel');
insert into test(nom) values ('iam');
insert into test(nom) values (null);

drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare exit handler for 1062 select "erreur de doublons";
    declare exit handler for 1048 select "le nom ne peut pas être null";
	insert into test(nom) values (v_name);
    select "insertion effectuée avec succés";
end$$
delimiter ;




drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare flag boolean default true;
    begin
		declare exit handler for 1062 set flag = false;
		declare exit handler for 1048 set flag = false;
		insert into test(nom) values (v_name);
		select "insertion effectuée avec succés";
    end;
    if not flag then
		select ("erreur d'insertion");
    end if;
end$$
delimiter ;





drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare msg varchar(50) default "";
    begin
		declare exit handler for 1062 set msg = "erreur de doublons";
		declare exit handler for 1048 set msg = "le nom ne peut pas être null";
		insert into test(nom) values (v_name);
		select "insertion effectuée avec succés";
    end;
    if msg!="" then
		select msg;
    end if;
end$$
delimiter ;



drop procedure if exists insert_test;
delimiter $$
create procedure insert_test(v_name varchar(50))
begin
	declare flag boolean default true;
    declare v_errno int;
    declare v_msg varchar(200);
    declare v_sqlstate varchar(5);
    begin
		declare exit handler for sqlexception
        begin
			get diagnostics  condition 1 v_sqlstate = RETURNED_SQLSTATE, 
            v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
 			set flag = false;
        end;
		insert into test(nom) values (v_name);
		select "insertion effectuée avec succés";
    end;
    if not flag then
    case v_errno
		when 1062 then select ("erreur de doublons");
		when 1048 then select ("le nom ne peut pas être null");
		else select ("erreur d'insertion");
    end case;
	
    end if;
end$$
delimiter ;





drop procedure if exists get_name_by_id;
delimiter $$
create procedure get_name_by_id(in v_id int, out v_name varchar(50))
begin
	declare flag boolean default true;
    declare v_errno int;
    declare v_msg varchar(200);
    declare v_sqlstate varchar(5);
    begin
		declare exit handler for not found
        begin
			get diagnostics  condition 1 v_sqlstate = RETURNED_SQLSTATE, 
            v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
 			set flag = false;
        end;
		select nom into v_name from test where id = v_id;
    end;
    if not flag then
		set v_name = "introuvable";
     end if;
end$$
delimiter ;





drop procedure if exists set_text;
delimiter $$
create procedure set_text( txt varchar(50))
begin
	declare flag boolean default true;
    declare var int;
    
    declare v_errno int;
    declare v_msg varchar(200);
    declare v_sqlstate varchar(5);
    begin
		declare exit handler for sqlstate 'HY000'
        begin
			get diagnostics  condition 1 v_sqlstate = RETURNED_SQLSTATE,  v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
 			set flag = false;
        end;
		set var = txt;
    end;
    if not flag then
		select "erreur de convertion";
     end if;
end$$
delimiter ;





drop procedure if exists insert_multiple;
delimiter $$
create procedure insert_multiple()
begin
	declare flag boolean default true;
    declare var int;
    
    declare v_errno int;
    declare v_msg varchar(200);
    declare v_sqlstate varchar(5);
    begin
		declare continue handler for  sqlexception
        begin
			get diagnostics  condition 1 v_sqlstate = RETURNED_SQLSTATE,  v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
 			set flag = false;
        end;
		insert into test(id, nom) values (110,'test110');
        insert into test(id, nom) values (120,'test120');
        insert into test(id, nom) values (130,'test130');
     end;
    if not flag then
		select "operation terminée avec erreurs";
	else
		select "operation terminée sans erreurs";
    
     end if;
end$$
delimiter ;



drop procedure if exists division;
delimiter $$
create procedure division(a int, b int)
begin
    declare r float;
	if b=0 then
		signal SQLSTATE '23000' SET MESSAGE_TEXT = 'division par zero non autorisée';
	else
		set r = a/b;
	end if;
	select r;
end$$
delimiter ;




drop procedure if exists division;
delimiter $$
create procedure division(a int, b int)
begin
	declare flag boolean default true;
    declare r float;
    begin
		declare exit handler for  sqlexception set flag = false;
        if b=0 then
			signal SQLSTATE '23000' SET MESSAGE_TEXT = 'division par zero non autorisée';
        else
			set r = a/b;
        end if;
        select r;
     end;
    if not flag then
		select "erreur de division";
     end if;
end$$
delimiter ;


call division (2,0);

drop procedure if exists divide;
DELIMITER $$
CREATE PROCEDURE Divide(IN numerator INT,	IN denominator INT,	OUT result double)
BEGIN
	DECLARE division_by_zero CONDITION FOR SQLSTATE '22012' ;
	DECLARE CONTINUE HANDLER FOR division_by_zero
	RESIGNAL SET MESSAGE_TEXT = 'Division by zero / Denominator cannot bezero';
	IF denominator = 0 THEN
		SIGNAL division_by_zero;
	ELSE
		SET result = numerator / denominator;
	END IF ;
END$$
delimiter ;

call Divide(5,0,@r);
select @r;

