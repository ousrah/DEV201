#La programmation procédurale sous MySql

#la notion du block
#un block peut être une fonction, une procedure stockée, un trigger....
/*
create block
begin
instructions
 sous block
 begin
 
 
 end
end
*/

hellouse notes;
#exemple d'une fonction sans argument hello
drop function if exists hello;
delimiter $$
create function hello()
returns varchar(50)
deterministic
begin
	return ("hello world");
end $$
delimiter ;

select hello() as salutation;


#exemple d'une fonction avec arguments somme

drop function if exists somme;
delimiter $$
create function somme(a int, b int)
returns bigint
deterministic
begin
	return a+b;
end $$
delimiter ;

select somme(3,5) as addition;
select somme(somme(1,2),5) as addition;

#exemple d'une procedure stockée sans arguments hello

drop procedure if exists ps_hello;
delimiter $$
create procedure ps_hello()
begin
	select "hello world" as salutation;
end $$
delimiter ;

call ps_hello();

#exemple d'une procedure stockée sans arguments hello

drop procedure if exists ps_somme;
delimiter $$
create procedure ps_somme(in a int, in b int)
begin
	select a+b as addition;
end $$
delimiter ;

call ps_somme(3,2);

#les instructions de controles
# la declaration

# declare a int;
# declare a int default 3;


drop function if exists somme;
delimiter $$
create function somme(a int, b int)
returns bigint
deterministic
begin
	declare c bigint default a+b;
	return c;
end $$
delimiter ;

select somme(3,5);




# l'affectation

# set x = 3;
# select 3 into x;


drop function if exists somme;
delimiter $$
create function somme(a int, b int)
returns bigint
deterministic
begin
	declare c bigint;
    # set c = a+b;
    select a+b into c;
	return c;
end $$
delimiter ;

select somme(3,5);

#les conditions
	#if
    drop function if exists get_phone_type;
    delimiter $$
    create function get_phone_type(phone varchar(50))
	returns varchar(20)
    DETERMINISTIC
    begin
		declare phone_type varchar(20) default "fixe";
        
        #if phone like "06%" or phone like "07%" then
        if left(phone,2) in ("06","07") then
			set phone_type = "portable";
        end if;
        return phone_type;
    end $$
    delimiter ;
    select get_phone_type("06125487")


    drop function if exists get_phone_type;
    delimiter $$
    create function get_phone_type(phone varchar(50))
	returns varchar(20)
    DETERMINISTIC
    begin
		declare phone_type varchar(20);
        if left(phone,2) in ("06","07") then
			set phone_type = "portable";
		else
        	set phone_type = "fixe";
        end if;
        return phone_type;
    end $$
    delimiter ;
    select get_phone_type("06125487");

    

    drop function if exists get_phone_type;
    delimiter $$
    create function get_phone_type(phone varchar(50))
	returns varchar(20)
    DETERMINISTIC
    begin
		declare phone_type varchar(20);
        if left(phone,2) in ("06","07") then
			set phone_type = "portable";
		elseif left(phone,2) ="05" then
        	set phone_type = "fixe";
		else
			set phone_type = "erreur";
        end if;
        return phone_type;
    end $$
    delimiter ;
    select get_phone_type("01125487");
    
    #case
    
    drop function if exists mention;
    delimiter $$
    create function mention(note float)
    returns varchar(20)
    deterministic
    begin
		declare mention varchar(50);
        case 
			when note >=18 then set mention="Excellent";
			when note >=16 then set mention="T bien";
			when note >=14 then set mention="Bien";
			when note >=12 then set mention="Assez bien";
			when note >=10 then set mention="passable";
			when note >=8 then set mention="faible";
            else
            set mention="insufisant";
        end case;
		return mention;
    end $$
    delimiter ;
    
    select mention(15);
    
    drop function if exists get_day_name;
    delimiter $$
    create function get_day_name(day int)
    returns varchar(20)
    deterministic
    begin
		declare name_day varchar(20);
        case day
         when 1 then set name_day = "Dimanche";
         when 2 then set name_day = "Lundi";
         when 3 then set name_day = "Mardi";
         when 4 then set name_day = "Mercredi";
         when 5 then set name_day = "Jeudi";
         when 6 then set name_day = "Vendredi";
         else
			set name_day = "samdi";
		end case;
        return name_day;
    end $$
    delimiter ;
    
    select get_day_name(5)
    
#les boucles
	#while
    #repeat
    #loop

#les fonctions


#les procedures stockées