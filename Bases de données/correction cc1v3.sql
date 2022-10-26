drop database if exists cc1v3;
create database cc1v3 collate utf8_general_ci;
use cc1v3;

create table Eleve (
Num_Eleve int auto_increment primary key, 
nom_Eleve varchar(50) , 
prenom_eleve varchar(50) , 
mention varchar(50) );

create table Classe (
Num_Classe int auto_increment primary key, 
Nom_Classe varchar(50) , 
nbInscrits int);

create table inscrit (
 Num_Inscription int auto_increment primary key, 
 Num_Eleve int, 
 Num_Classe int, 
 anneeScolaire int,
 foreign key (Num_Eleve) references Eleve(Num_Eleve),
 foreign key (Num_Classe) references Classe(Num_Classe));
 
create table Matiere (
Num_Matiere int auto_increment primary key, 
Nom_Matiere varchar(50) );

create table Examen (
Num_Examen int auto_increment primary key, 
date_Examen date, 
Num_Matiere int,
foreign key (Num_Matiere) references Matiere(Num_Matiere));


create table note (
Num_Inscription int, 
Num_Examen int, 
note float,
foreign key (Num_Inscription) references Inscrit(Num_Inscription),
foreign key (Num_Examen) references Examen(Num_Examen));



insert into Eleve values (1, 'e1', 'p1', ''),(2, 'e2', 'p2', ''),(3, 'e3', 'p3', '');
insert into Classe values  (1, 'c1', 0), (2, 'c2', 0),  (3, 'c3', 0);
insert into inscrit values  ( 1, 1, 1, 2022),( 2, 2, 2, 2022),( 3,3,3, 2022);
insert into Matiere values  (1, 'm1'),(2, 'm2'),(3, 'm3');
insert into Examen values  (1, '2022/10/12', 1),  (2, '2022/10/13',2),  (3, '2022/10/14', 3);
insert into note values  
(1, 1, 12),
(1, 2, 18),
(1, 3, 5),

(2, 1, 14),
(2, 2, 19),
(2, 3, 11),

(3, 1, 5),
(3, 2, 6),
(3, 3, 17);


Questions : 
1.	Donnez la vue qui affiche le nombre des élèves qui ont réalisé plus que 2 examens 
durant la période allant du 10/10/2022 au 17/10/2022 : (3 pt)

create view q1 as 
select count(*) as nb from (
select num_eleve, count(*)
from inscrit i inner join note n on i.num_inscription = n.num_inscription
			   inner join examen e on n.num_examen = e.num_examen
where date_examen between '2022/10/10' and '2022/10/17'
group by num_eleve
having count(*) > 2)t1;

select * from q1;



2.	Ajouter une vue qui permet d’afficher pour chaque classe sa moyenne générale (2pt)
create view q2 as 
select nom_classe, round(avg(note),2) as moyenne
from classe c inner join inscrit i on c.num_classe = i.num_classe
			  inner join note n on n.num_inscription = i.num_inscription
group by  nom_classe;



3.	Donnez la fonction qui calcule la moyenne des notes d’un élève donné dans une année scolaire donnée. (3pts)

drop function if exists q3;
delimiter $$
create function q3(ne int, annee int)
returns float
deterministic
begin
	declare m float;
  select round(avg(note),2) into m
from inscrit i 
			  inner join note n on n.num_inscription = i.num_inscription
              where num_eleve = ne
              and anneescolaire = annee;  
	return m;
end$$
delimiter ;

select q3(3,2021)


4.	Ecrivez une procédure stockée qui supprime les  inscriptions d’un élève donné ainsi que toutes ces notes. (3 pts)

drop procedure if exists q4;
delimiter $$
create procedure q4(ne int)
begin
	delete from note where num_inscription in (select num_inscription from inscrit where num_eleve = ne);
	delete from inscrit where num_eleve = ne;
end$$
delimiter ;

call q4(1)



5.	Ecrivez un curseur qui permet d’afficher pour chaque élève son bulletin sous cette forme : (3 pts)
L’élève Michoud ali à obtenu les notes suivantes :
(Programmation -> 13.00)
(Bureautique -> 15.50)
…
La moyenne générale est : 14.64.



drop procedure if exists q5;
delimiter $$
create procedure q5()
begin
	declare ne int;
    declare nom , prenom varchar(50);
    declare moy float;
	declare flag boolean default true;
	declare c1 cursor for select num_eleve, nom_eleve, prenom_eleve from eleve;
    declare continue handler for not found set flag = false;
    open c1;
    b1: loop
		fetch c1 into ne,nom,prenom;
        if not flag then
			leave b1;
        end if;
		select concat("l'éleve ",nom, " ", prenom , " a obtenu les notes suivantes ");
        select avg(note) into moy
			from inscrit i 
			  inner join note n on n.num_inscription = i.num_inscription
              where num_eleve = ne;
        begin
			declare n float;
			declare mat varchar(50);
			declare flag2 boolean default true;
			declare c2 cursor for 
				select nom_matiere, note
				from inscrit i inner join note n on i.num_inscription = n.num_inscription
							   inner join examen e on n.num_examen = e.num_examen
							   inner join matiere m on m.num_matiere = e.num_matiere
							   where num_eleve = ne;
                               
			declare continue handler for not found set flag2 = false;
			open c2;
			b2: loop
				fetch c2 into mat,n;
				if not flag2 then
					leave b2;
				end if;
				select concat(mat , " --> ", n);
			end loop b2;
			close c2;
		end;
        select concat("la moyenne générale est : ",round(moy,2));
        
    end loop b1;
    close c1;
end$$
delimiter ;

call q5;

select nom_matiere, note
from inscrit i inner join note n on i.num_inscription = n.num_inscription
			   inner join examen e on n.num_examen = e.num_examen
               inner join matiere m on m.num_matiere = e.num_matiere
               where num_eleve = 2


6.	Ajoutez une règle sur le champ nbinscrits de la table classe de tel sorte qu’il soit toujours entre 0 et 24. Et créer une procédure stockées qui accepte comme paramètres le numéro de la classe,  le numero d’élève et l’année scolaire,  Cette procédure réalise deux actions :
a.	Elle ajoute un enregistrement dans la table inscrit.
b.	Et elle augmente le nombre des inscrits dans la table classe.
c.	Ajoutez une transaction qui permet de s’assurer que les deux actions sont réalisées ou les deux actions ne sont pas réalisé, (on ne peut pas réaliser juste une seule action des deux). (3 pts)



alter table classe add check (nbinscrits between 0 and 24);



drop procedure if exists q6;
delimiter $$
create procedure q6(ne int,nc int,annee int)
begin
	declare exit handler for sqlexception 
	begin
		rollback;
		select("operation annulée");
	end;

	start transaction;
		insert into inscrit (num_eleve, num_classe,anneescolaire) values (ne,nc,annee);
		update classe set nbinscrits = nbinscrits + 1 where num_classe = nc;
	commit;
	select("operation terminée avec succes");
end$$
delimiter ;
update classe set nbinscrits = 23;

call q6(1,1,2024);


7.	Question au choix
a.	En souhaite écrire un déclencheur sur l’insertion dans la table inscrit qui incrémente automatiquement le nombre des inscrits dans la table classe. (3 pts)

drop trigger if exists q7a;
delimiter $$
create trigger q7a after insert on inscrit for each row
begin
	update classe set nbinscrits = nbinscrits+1 where num_classe = new.num_classe;
end$$
delimiter ;
insert into inscrit (num_eleve,num_classe, anneescolaire) values (2,2,2024)


b.	Ajoutez une procédure stockée qui calcule la moyenne de chaque élève et qui lui affecte la mention selon le tableau suivant :(3 pts)
moyenne	mention
<10	Faible
De  10 à 13	Moyen
>13	Très bien


drop procedure if exists q7b;
delimiter $$
create procedure q7b()
begin
	declare ne int;
    declare moy float;
    declare vmention varchar(50);
	declare flag boolean default true;
	declare c1 cursor for select num_eleve from eleve;
    declare continue handler for not found set flag = false;
    open c1;
    b1: loop
		fetch c1 into ne;
        if not flag then
			leave b1;
        end if;
		
        select avg(note) into moy
			from inscrit i 
			  inner join note n on n.num_inscription = i.num_inscription
              where num_eleve = ne;
			case 
				when moy is null then set vmention = null;
				when moy < 10 then set vmention = 'faible';
				when moy between 10 and 13 then set vmention = 'moyen';
				else
					set vmention = "tres bien";
			end case;
			update eleve set mention = vmention where num_eleve = ne;
					select "operation terminée";
        
    end loop b1;
    close c1;
end$$
delimiter ;

call q7b;

select * from eleve



