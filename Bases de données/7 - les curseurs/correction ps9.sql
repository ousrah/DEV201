use cuisine;

select * from recettes;

select * from ingrédients i inner join composition_recette c on i.numing = c.numing and numrec=1;

select sum(qteutilisee*puing) 
from ingrédients i inner join composition_recette c on i.numing = c.numing 
where numrec=3;



drop procedure if exists ps9;
delimiter $$
create procedure ps9()
begin
    declare v_numrec int;
    declare v_nomrec varchar(50);
    declare v_methodepreparation varchar(50);
    declare v_tempspreparation  int;
    declare v_prix int;
    declare flag boolean default true;
	declare c1 cursor for
		select numrec, nomrec, methodepreparation,tempspreparation from recettes;
    open c1;
	begin
		declare exit handler for not found set flag = false;
		loop
			fetch c1 into  v_numrec, v_nomrec, v_methodepreparation,v_tempspreparation;
			select concat("recette (",v_nomrec, ") son temps de preparation est ", v_tempspreparation);
            select noming, QteUtilisee from ingrédients i inner join composition_recette c on i.numing = c.numing where numrec=v_numrec;
			select concat("sa methode de preparation (",v_methodepreparation, ")");
			select sum(qteutilisee*puing) into v_prix
				from ingrédients i inner join composition_recette c on i.numing = c.numing 
				where numrec=v_numrec;
			if v_prix < 50 then
				select("prix interessant");
            end if;
		end loop;
    end;
    close c1;
end$$
delimiter ;
call ps9();

