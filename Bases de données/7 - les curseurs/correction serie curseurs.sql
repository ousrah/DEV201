
-- Exercice 1 :
use vols;

drop procedure if exists ps_ex1;
delimiter $$
create procedure ps_ex1(v_ville varchar(50) , v_avion int)
begin
	declare num_pil int;
    declare ville_pil varchar(255);
    declare flag bool default true;
    declare c1 cursor for select numpil , villepil from pilote;
    declare continue handler for not found set flag=false;
    open c1;
		l1:loop
			fetch c1 into num_pil,ville_pil;
            if not flag then leave l1;
            end if ;
		INSERT INTO vol ( VilleD, VilleA, DateD, DateA, NumPil, NumAv) VALUES (ville_pil, v_ville, current_date(), current_date(), num_pil, v_avion);
        end loop l1;
    close c1;
end $$
delimiter ;

call ps_ex1("paris",2);

--  Exercice 2 :

drop procedure if exists ps_ex2;
delimiter $$
create procedure ps_ex2(inout names_pilotes varchar(250))
begin
	declare nom_pil varchar(50);
    declare flag bool default true ;
    declare c1 cursor for select nompil from pilote;
    declare continue handler for not found set flag=false;
    open c1 ;
		l1:loop
			fetch c1 into nom_pil;
            if not flag then leave l1;
            end if ;
            set names_pilotes=concat(nom_pil,"-",names_pilotes);
        end loop l1;
    close c1;
end $$
delimiter ;

set @a="";
call ps_ex2(@a);
select @a ;

 -- Exercice 3 :
 
 use cuisine;
drop procedure if exists ps_ex3;
delimiter $$
create procedure ps_ex3()
begin
	declare nom_recette varchar(50);
	declare nom_ing varchar(50);
	declare qte int ;
	declare pu int ;
    declare prix int default 0;
	declare methode varchar(50);
    declare temp_recette int ;
    declare flag bool default true;
    declare c1 cursor for 
						select nomrec,TempsPreparation,MethodePreparation,i.noming,QteUtilisee,puing from ingrédients i 
						join composition_recette c 
                        on i.numing=c.numing  join recettes r on r.numrec=c.numrec group by noming ;
    declare continue handler for not found set flag=false;
    open c1;
		l1:loop
			fetch c1 into nom_recette,temp_recette,methode,nom_ing,qte,pu;
			if not flag then leave l1;
			end if ;
            select concat("Recette :" ,nom_recette, "temps de préparation : ", temp_recette);
            select concat("Sa méthode de préparation est : ",methode );
            select concat("ingredients : ",nom_ing,"la quantite : ",qte);
            set prix=prix+(pu*qte);
            
        end loop l1;
        if prix >50 then select 'Prix intéressant';
            end if ;
    close c1;
end $$
delimiter ;

call ps_ex3();


-- Serie 1 :

 -- Ex 1 :
 use vols;
 drop procedure if exists ps_q1;
 delimiter $$
 create procedure ps_q1()
 begin
	declare nom varchar(255);
    declare id int ;
    declare s int ;
    declare flag bool default true;
    declare c1 cursor for select numpil,nompil,salaire from pilote;
    declare continue handler for not found set flag=false;
    open c1;
		l1:loop
			fetch c1 into id,nom,s;
			if not flag then leave l1;
            end if;
            select concat("Identifient : ", id ," le nom est : " ,nom," le salaire : ", s);
        end loop l1;
    close c1;
    
 end $$
 delimiter ;
 
 call ps_q1();
 
 
 -- EX 2 :

 
 
 use vols;
 drop procedure if exists ps_q2;
 delimiter $$
 create procedure ps_q2()
 begin
	declare nom varchar(255);
    declare id int ;
    declare va varchar(50) ;
    declare vd varchar(50) ;
    declare flag bool default true;
    declare c1 cursor for select numpil,nompil from pilote;
    declare continue handler for not found set flag=false;
    open c1;
		l1:loop
			fetch c1 into id,nom;
			if not flag then leave l1;
            end if;
            select concat("le pilote : ",nom," est affecté aux vols : ");
            begin
				declare flag2 bool default true;
				declare c2 cursor for select villea,villed from vol where numpil=id;
                declare continue handler for not found set flag2=false;
                open c2;
					l2:loop
						fetch c2 into va,vd;
						if not flag2 then leave l2;
                        end if;
                        select concat("Départ : ",vd ," Arrivée : ",va);
                    end loop l2;
                close c2;
            end;
        end loop l1;
    close c1;
    
 end $$
 delimiter ;
 
 call ps_q2();

 
-- Ex 3 :

use vols;
 drop procedure if exists ps_q3;
 delimiter $$
 create procedure ps_q3()
 begin
	declare nom varchar(255);
    declare id int ;
    declare va varchar(50) ;
    declare vd varchar(50) ;
    declare flag bool default true;
    declare c1 cursor for select numpil,nompil from pilote;
    declare continue handler for not found set flag=false;
    open c1;
		l1:loop
			fetch c1 into id,nom;
			if not flag then leave l1;
            end if;
            select concat("le pilote : ",nom," est affecté aux vols : ");
            begin
				declare flag2 bool default true;
				declare nb int default 0;
				declare s int ;
				declare c2 cursor for select villea,villed from vol where numpil=id;
                declare continue handler for not found set flag2=false;
                open c2;
					l2:loop
						fetch c2 into va,vd;
						if not flag2 then leave l2;
                        end if;
                        select concat("Départ : ",vd ," Arrivée : ",va);
                        set nb=nb+1;
                        
                    end loop l2;
                    if nb=0 then set s= 5000;
						elseif nb between 1 and 3 then set s=7000;
						elseif nb >3 then set s=8000;
						end if ;
                        update pilote set salaire=s where numpil=id ; -- where current of c1 "error"
                        select concat("avec une salaire de ", s);
                close c2;
            end;
			
        end loop l1;
    close c1;
    
 end $$
 delimiter ;
 
 call ps_q3();

 -- Ex 4 :
 create database entreprise_ex4;
 use entreprise_ex4;
 create table employe (
 Matricule varchar(30) primary key,
 nom varchar(30) ,
 prenom varchar(30),
 etat varchar(50)
 );
 create table groupe(
 Matricule varchar(30),
 Groupe varchar(50),
 foreign key (matricule) references employe(matricule)
 );
 
 drop procedure if exists ps_q4;
delimiter $$
create procedure ps_q4()
begin 
	declare mat varchar(50);
    declare groupe varchar (50) default "besoin vacances";
    declare flag bool default true;
    declare c1 cursor for select matricule from employe where etat="fatigue";
    declare continue handler for not found set flag=false;
    open c1 ;
		l1:loop
			fetch c1 into mat;
			if not flag then leave l1;
            end if;
            insert into groupe values(mat,groupe);
        end loop l1;
    close c1;
end $$
delimiter ;
call ps_q4();
select "";

 
 
 
 
 
 
 
 
 
 