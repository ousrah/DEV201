drop database if exists cc1v2;
create database cc1v2 collate utf8_general_ci;
use cc1v2;

create table  VILLE (CodePostal int auto_increment primary key, NomVille varchar(50) );
create table    CINEMA (NumCine int auto_increment primary key, NomCine varchar(50) , Adresse varchar(50) , nbTicketsVendus int, grade varchar(50) ,  CodePostal  int, foreign key(codepostal) references ville(CodePostal));
create table    SALLE (NumSalle int auto_increment primary key, Capacite int, NumCine int, foreign key (numcine) references cinema(numcine));
create table    FILM (NumExploit int auto_increment primary key, Titre  varchar(50) , Duree int)  ;
create table    PROJECTION (NumExploit int, NumSalle int, NumSemaine int, Nbentrees int,foreign key (NumExploit) references film(NumExploit),foreign key (NumSalle) references salle(NumSalle) );

insert into ville values (1,'tetouan'),(2,'tanger'),(3,'larache');
insert into CINEMA values (1,'cine1','a',0,'',1),(2,'cine2','a',0,'',2),(3,'cine3','a',0,'',3);
insert into salle values (1,300,1),(2,400,2),(3,500,3);
insert into film values (1,'f1',100),(2,'f2',120),(3,'f3',90);
insert into projection values
					(1,1,1,60),
					(1,2,1,55),
					(1,3,1,80),
					(2,1,1,160),
					(2,2,1,60),
					(3,1,1,90),
					(3,2,2,120),
					(3,2,2,80),
					(3,3,3,140),
					(3,3,3,55);

1.	Donnez une vue qui affiche le nombre des cinémas qui ont réalisés plus 
que 500 Entrées durant le mois janvier 2021: (3 pt)
create view q1 as 
select count(numcine) as nb from (
select numcine, sum(nbentrees)
from salle s inner join projection p on s.numsalle = p.numsalle
where numsemaine between 1 and 4
group by numcine
having sum(nbentrees) >500)t1;

select * from q1;
2.	Ajouter une vue qui permet d’afficher pour chaque Cinéma la liste des 
différents films projetés durant la période allant du 1er janvier jusqu’à 7 janvier 2021  (2pt)
create view q2 as 
select nomcine, titre
from cinema c inner join salle s on c.numcine = s.numcine
              inner join projection p on s.numsalle = p.numsalle
              inner join film f on p.numexploit = f.numexploit
where numsemaine =1
order by nomcine;


3.	Donnez la fonction qui calcule le nombre d’entrés d’un cinéma donnée (3pts)

drop function if exists q3;
delimiter $$
create function q3(c int)
returns  int
deterministic
begin
	declare nb int;
	select  sum(nbentrees) into nb
	from salle s inner join projection p on s.numsalle = p.numsalle
	where numcine = c;
	return nb;
end$$
delimiter ;

select q3(1);



4.	Ecrivez une procédure stockée qui supprime toutes les projections relatives à une ville donnée (3 pts)

drop procedure if exists q4;
delimiter $$
create procedure q4(n int)
begin
delete from projection where numsalle in 
				(select numsalle from salle where numcine in
						(select numcine from cinema where codepostal = n));
end$$
delimiter ;

call q4(1)
                        
                 
                        
5.	Ajoutez une règle sur le champ nbentrees de la table projection de tel sorte qu’il soit toujours supérieur à 50. 
Et créer une procédure stockée qui accepte comme paramètres le numéro d’exploitation du film, le numéro de la salle, le numéro de la semaine et le nombre d’entrées. Cette procédure réalise deux actions :
a.	elle augmente le nombre des tickets vendus du cinéma.
b.	Et elle ajoute un enregistrement dans la table projection.
c.	Ajoutez une transaction qui permet de s’assurer que les deux actions sont réalisées ou les deux actions ne sont pas réalisé, (on ne peut pas réaliser juste une seule action des deux). (3 pts)

alter table projection add check (nbentrees >50)

drop procedure if exists q5;
delimiter $$
create procedure q5(nexp int, nsal int, nsem int, nbent int)
begin
    # update cinema set  nbTicketsVendus = nbTicketsVendus+nbent where numcine in (select numcine from salle where numsalle = nsal);
  
	declare ncin int;
    declare exit handler for sqlexception 
    begin
		rollback;
        select("transation annulée");
    end;
    select numcine into ncin from salle where numsalle = nsal;
    start transaction;
    update cinema set nbTicketsVendus = nbTicketsVendus+nbent where numcine = ncin;
    insert into projection values (nexp, nsal, nsem, nbent);
    commit;
	select ("transaction effectuée");
end$$
delimiter ;

call q5(1,1,1,30)
select * from cinema;
select * from projection;

6.	Ecrivez un curseur qui permet d’afficher pour chaque salle les informations sous cette forme : (3 pts)
La salle  Avenida à projeté les films suivants :
(Semaine (1) Avatar -> 344 Entrée)
(Semaine (2) Mission impossible -> 549 Entrée)
…
Le nombre total des entrées est 5398 Entrée


alter table projection add check (nbentrees >50)

drop procedure if exists q6;
delimiter $$
create procedure q6()
begin
	declare nbtotal int default 0;
	declare nsal int;
	declare flag boolean default true;
	declare c1 cursor for select numsalle from salle;
    declare continue handler for not found set flag = false;
    open c1;
    b1: loop
		fetch c1 into nsal;
        if not flag then
			leave b1;
        end if;
		select concat("la salle ", nsal , " a projeté les films suivants");
        begin
				declare tit varchar(100);
                declare sem int;
                declare  totalEntrees int;
				declare flag2 boolean default true;
            
					declare c2 cursor for 	select NumSemaine, titre, sum(nbentrees) from projection p inner join film f on p.numexploit = f.numexploit
											where numsalle = nsal
											group by NumSemaine, titre;
				declare continue handler for not found set flag2 = false;
                open c2;
                b2: loop
					fetch c2 into sem, tit, totalEntrees;
                    if not flag2 then
						leave b2;
                    end if;
                    set nbtotal = nbtotal + totalEntrees;
					select concat("(Semaine  (",sem,") ",tit," -> ",totalEntrees," Entrée)");
                end loop b2;
				close c2;
        
        end;
    end loop b1;
    close c1;
    select concat("le nombre totale des entrées est ",nbtotal);
end$$
delimiter ;

call q6;




1.	Question au choix
a.	En souhaite écrire un déclencheur sur l’insertion dans la table cinéma qui ajoute automatiquement une salle dans le cinéma inséré, cette salle porte le nom ‘[Num du cinéma] – salle 1’. (3 pts)


drop trigger if exists q7a;
delimiter $$
create trigger q7a after insert on cinema for each row
begin
	insert into salle (numcine) values  (new.numcine);
end$$
delimiter ;

insert into cinema  (nomcine) values ('avenida');

select * from cinema
select * from salle

b.	Ajoutez une procédure stockée qui calcule le nombre de places disponibles  de chaque cinéma et qui lui change le grade  selon le tableau suivant :(3 pts)
Capacité totale	grade
< 300	C
Entre 300 et 500	B
>500	A






drop procedure if exists q7b;
delimiter $$
create procedure q7b()
begin
	declare ncine int ;
	declare cap int;
	declare flag boolean default true;
    declare vgrade varchar(1);
	declare c1 cursor for select  numcine, sum(capacite) from salle group by numcine;
    declare continue handler for not found set flag = false;

    open c1;
    b1: loop
		fetch c1 into ncine, cap;
        if not flag then
			leave b1;
        end if;
		
        case
        
			when cap <300 or cap is null then  set vgrade = 'C';
			when cap between 300 and 500 then  set vgrade = 'B';
			else
				set vgrade = 'A';
			
        end case;
        update cinema set grade = vgrade where numcine = ncine;
     
    end loop b1;
    close c1;
   
end$$
delimiter ;

call q7b;

select * from cinema




