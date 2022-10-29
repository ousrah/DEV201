use vols2018;
select * from vol;
select * from pilote;
select * from avion;

insert into vol () values (),(),()



declare

open

boucle
	fetch

close



drop procedure if exists insert_vols;
delimiter $$
create procedure insert_vols(v_ville varchar(10), v_avion int)
begin
	declare ville_pilote varchar(50);
    declare id_pilote int;
    declare flag boolean default true;
    declare c1 cursor for
		select numpilote,villepilote from pilote;
    declare continue handler for not found set flag = false; 
	open c1;
    b1: loop
		 fetch c1  into id_pilote, ville_pilote;
        if flag = false then
			leave b1;
        end if;
        insert into vol (villed,villea,dated,datea,numpil,numav) values (ville_pilote,v_ville,current_date,current_date,id_pilote,v_avion);
    end loop b1;
    close c1;
    


end$$
delimiter ;

delete from vol;
select * from vol;
 
call insert_vols("casablanca",1);




drop procedure if exists get_pilotes_names;
delimiter $$
create procedure get_pilotes_names(inout v_names varchar(255))
begin
	declare nom_pilote varchar(50);

    declare flag boolean default true;
    declare c1 cursor for
		select nom from pilote;
    declare continue handler for not found set flag = false; 
	open c1;

    b1: loop
		 fetch c1  into nom_pilote;
        if flag = false then
			leave b1;
        end if;
		set v_names = concat(nom_pilote,";",v_names);
	end loop b1;
    close c1;
end$$
delimiter ;

set @a = "";
call get_pilotes_names(@a);
select @a;

