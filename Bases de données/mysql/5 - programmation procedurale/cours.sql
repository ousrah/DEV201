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
    
    select get_day_name(5);

#equation premier degrès
# Ax+B=0



drop function if exists eq1d;
delimiter $$
create function eq1d(a int, b int)
returns varchar(150)
deterministic
begin
	declare result varchar(150) ;
    if a=0 then
		if b=0 then
			set result = "x peut avoir n'importe quelle valeur de l'ensemble R";
		else
			set result = "solution impossible dans R";
		end if;
	else
		select concat("x=",round(-b/a,2)) into result;
    end if;    
    return result;
end $$
delimiter ;

select eq1d(2,3)

#equation 2ème degrès
/*Ax²+Bx+C=0
A=0 B=0 C=0  R
A=0 B=0 C!=0  Vide
A=0 B!=0    x=-c/b
A!=0  
	Delta = b²-4ac
       delta<0 pas de solution dans R
       delta=0 x1=x2=-b/2a
       delta>0 x1=-b-sqrt(delta)/2a   x2=-b+sqrt(delta)/2a
*/
  
  
drop function if exists eq2d;
delimiter $$
create function eq2d(a int, b int, c int)
returns varchar(150)
deterministic
begin
	declare result varchar(150) ;
    declare delta bigint;
    if a=0 then
		if b=0 then
			if c=0 then
				set result = "x peut avoir n'importe quelle valeur de l'ensemble R";
			else
				set result = "solution impossible dans R";
			end if;
		else
			select concat("x=",round(-c/b,2)) into result;
		end if;    
	else
		set delta = pow(b,2)-(4*a*c);
        case
			when delta > 0 then
				set result = concat("x1=",round(-b-sqrt(delta)/(2*a),2), "  et  x2=",round(-b+sqrt(delta)/(2*a),2));
			when delta < 0 then
				set result = "impossible dans R";
			else            
				set result = concat("x=",round(-b/(2*a),2));
        end case;
    
    end if;
    return result;
end $$
delimiter ;

select eq2d(2,3,2);

  
  
  
#les boucles
	#while
    drop function if exists somme;
    delimiter $$
    create function somme(n int)
    returns bigint
    deterministic
    begin
		declare i int default 1;
        declare result bigint default 0;
        while i<=n do
			set result=result+i;
            set i=i+1;
        end while;
		return result;
    end $$
    delimiter ;
    
  select somme(3)  ;
    
    #repeat
    
	drop function if exists somme;
    delimiter $$
    create function somme(n int)
    returns bigint
    deterministic
    begin
		declare i int default 1;
        declare result bigint default 0;
        repeat
			set result=result+i;
            set i=i+1;
        until i>n end repeat;
		return result;
    end $$
    delimiter ;
      select somme(3)  ;
    
    #loop


drop function if exists somme;
    delimiter $$
    create function somme(n int)
    returns bigint
    deterministic
    begin
		declare i int default 1;
        declare result bigint default 0;
        label1: loop
			set result=result+i;
            set i=i+1;
            if i<=n then 
				iterate label1;
            end if;
            leave label1;
        end loop label1;
		return result;
    end $$
    delimiter ;
      select somme(5)  ;
 
#factoriel
 
drop function if exists factoriel;
delimiter $$
create function factoriel(n int)
    returns varchar(50)
    deterministic
begin
		declare i int default 1;
        declare result bigint default 1;	
		if n<0 then
			return "impossible";
		end if;

        repeat
			set result=result*i;
            set i=i+1;
        until i>n end repeat;
		return result;
end $$
delimiter ;
select factoriel(0)  ;
    
#fonction recursive


 drop function if exists factoriel;
    delimiter $$
    create function factoriel(n int)
    returns bigint
    deterministic
    begin
        declare result bigint default 1;
		if (n>2) then 
			set result = n * factoriel(n-1);
        end if;
		return result;
    end $$
    delimiter ;

   select factoriel(5)  ;





drop procedure if exists ps_somme;

delimiter $$
create procedure ps_somme(in a int, in b int, out s int, out m int)
begin
	#set s=a+b;
	select a + b into s;
    select a * b into m;
    
end$$
delimiter ;

set @s=0;
set @m=0;
call  ps_somme(3,5, @s,@m);
select @s;
select @m;



    
    #procedure recursive

 drop procedure if exists ps_factoriel;
    delimiter $$
    create procedure ps_factoriel(inout n bigint)
    begin
        declare result bigint default 1;
        declare x bigint default 1;
		if n>2 then
            set x=n-1;
		    call ps_factoriel(x);
		end if;
		set n =  n*x;
    end $$
    delimiter ;
   
    set max_sp_recursion_depth = 20;
    
    set @n = 13;
	call ps_factoriel(@n)  ;
    select @n;  
    
    #loop


select date_format(current_date(), "%D of %M of %Y");


select abs(datediff("2022/12/31 23:59:59", current_date));

select abs(timestampdiff(hour, "2022/12/31 23:59:59", current_date));


set @d1 = "2022/12/31 23:59:59";
set @d2 = current_date;
select timestampdiff(hour,@d2, @d1);
use notes;
drop procedure if exists somme;
delimiter $$
create procedure somme(in a int, in b int , out c int, out m int)
begin
	set c = a+b;
    set m=a*b;
end$$
delimiter ;

set @vs_a = 5;
set @vs_b = 3;

call somme(@vs_a,@vs_b,@vs_c, @vs_m);
select @vs_a, @vs_b,@vs_c, @vs_m;


select count(*) from stagiaire;

drop function if exists get_nb_stag;
delimiter $$
create function get_nb_stag()
returns int
no sql
begin
	declare nb int;
 	select count(*) into nb from stagiaire;
    
    #set nb = (select count(*) from stagiaire);
	return nb;
end$$

delimiter ;

select get_nb_stag();



drop function if exists get_stats;
delimiter $$
create function get_stats()
returns varchar(50)
no sql
begin
	declare nb int;
    declare moy float;
	select count(*) into nb from stagiaire;
    select avg(note) into moy from evaluation;
 	return concat(nb,";",moy);
end$$
delimiter ;

select get_stats() into @r;
select substring_index(@r,";",1) into @nb;
select substring_index(@r,";",-1) into @moy;
select @nb;
select @moy;

#les fonctions


#les procedures stockées