drop database if exists gestionProjets;
create database gestionProjets collate utf8_general_ci;
use gestionProjets;

create table Division (IdDivision int auto_increment primary key, nomDivision varchar(50));
create table Service (IdService int auto_increment primary key, nomService varchar(50), IdDivision int, foreign key (idDivision) references division(IdDivision) );
create table Employe (Mle int auto_increment primary key, Nom varchar(50),  Prenom varchar(50), dateRecrutement date, salaire float, idService int, foreign key (idService) references Service(idService) );
create table Projet (idProjet int auto_increment primary key, titreProjet varchar(50));
create table Tache (idTache int auto_increment primary key, descriptionTache text, idProjet int, foreign key (idProjet) references Projet(idProjet)  );
create table Realise (Mle int, idTache int, dateDebut date, dateFin date, foreign key (Mle) references Employe(Mle)  , foreign key (idTache) references Tache(idTache), primary key (Mle,idTache, dateDebut)  );

insert into division values 
(1,'informatique'),(2,'commercial'),(3,'marketing');

insert into service values 
(1,'s1',1),(2,'s2',2),(3,'s3',3);


insert into employe values 
(1,'e1','e1','2022/10/10',5800,1),
(2,'e2','e2','2022/10/10',6800,1),
(3,'e3','e3','2022/10/10',9800,1);


insert into projet values 
(1,'p1'),(2,'p2'),(3,'p3');

insert into tache values 
(1,'t1',1),(2,'t2',2),(3,'t3',3);

insert into realise values 
(1,1,'2022/10/10', '2022/10/13'),
(1,2,'2022/10/12', '2022/10/13'),
(2,3,'2022/10/14', '2022/10/17'),
(3,2,'2022/10/15', '2022/10/23'),
(3,3,'2022/10/16', '2022/10/29');


#1.	Ecrire la vue qui permet d’afficher la listes des employés  
#qui travaillent dans la division numéro 3 (2 pts)

create view q1 as
	(select e.* 
	from employe  einner join service s on e.idService = s.idService 
	where idDivision = 1 );
    
select * from q1;


#2.	Ecrire une vue qui affiche le(les) employé(s) qui a(ont) le
# plus grand nombre de tâches (2 pts)

insert into realise values (1,1,'2022/11/15','2022/11/16');

with t1 as (select  distinct  e.mle, idTache 
from employe e inner join realise r on e.mle = r.mle),
t2 as (select count(idTache) nb, mle from t1 group by mle),
t3 as(select max(nb) maxnb from t2)

select e.mle, nom,prenom 
from employe e  inner join t1 on t1.mle = e.mle , t3
group by e.mle, nom, prenom,  maxnb
having count(idTache)  = maxnb

Methode 2

select e.mle,nom,prenom , count(idTache) nb from 
employe e inner join
	(select  distinct  e.mle, idTache 
	from employe e inner join realise r on e.mle = r.mle) t4
on e.mle = t4.mle

	group by e.mle, nom, prenom 
    having count(idTache) in 
            (
select max(nb) max from 
		(select mle, count(idTache) nb from 
			(select  distinct  e.mle, idTache 
			from employe e inner join realise r on e.mle = r.mle) t1
		 group by mle) t2
) 

#3.	Ecrire une fonction qui reçoit le numéro d’un
# employé et qui retourne la durée totale de ces tâches (2pts)

delimiter $$
create function q3(v_mle int)
returns int
deterministic
begin
	declare nb int;
    select sum(abs(datediff(datedebut, datefin))) into nb
    from realise where mle = v_mle;
    return nb;
end$$
delimiter ;
select q3(3);

select * from realise;

#4.	Ecrire une procedure qui affiche la liste des tâches qui se trouvent dans le
# projet numéro 3 (2 pts)




#5.	Ecrire une procédure stockée qui affiche les liste des employés
#  qui travaillent sur les même projets que l’employé numéro 3 (2 pts)

select distinct e.*
from employe e inner join realise r  on e.mle = r.mle 
			   inner join tache t on r.idtache = t.idtache 
where e.mle!=3 and idprojet in (
		select distinct idprojet 
        from realise r inner join tache t on r.idtache = t.idtache 
        where mle = 3)


#6.	Ecrire une procédure stockée qui retourne le nombre des employés 
#qui ont durée total des tâches supérieur  à  30 jours (2 pts)



#7.	Ecrire un trigger qui crée la tâche « préparation du projet ‘Nom du projet’ » à chaque fois qu’on ajoute un nouveau projet.
#8.	Ecrire un trigger qui supprime les réalisations d’une tâche si cette tâche est supprimée. (ce trigger va remplacer le fonctionnement de On Delete Cascade )
#9.	Ecrire un trigger qui augmente le salaire de l’employé de 5% à chaque fois qu’il réalise une tâche qui dure plus que 30 jours (2 pts)

#10.	 Ajouter une procédure qui crée pour chaque division trois services qui portent le
# nom « [nom de la division] – service [n] » le nom de la division doit être remplacer
# par le nom de chaque division let service n doit être remplacé par service1, 2 ou 3.
delimiter $$
create procedure q10()
begin
	declare iddiv int;
    declare nomdiv varchar(50);
    declare flag boolean default true;
    declare c1 cursor for select * from division;    
    declare continue handler for not found set flag = false;
    open c1;
    b1: loop
		fetch c1 into iddiv,nomdiv;
        if flag = false then
			leave b1;
		end if ;
        insert into service (nomservice,idDivision)values 
						(concat(nomdiv, " - service 1" ),iddiv),
						(concat(nomdiv, " - service 2" ),iddiv),
						(concat(nomdiv, " - service 3" ),iddiv);
    end loop b1;
    
    close c1;
    


end$$
delimiter ;
select * from service;
call q10;
#11.	Ajouter une contrainte qui  ne permet pas au salaire de dépasser 20000 dh,

alter table employe add check (salaire <=20000);

#12.	Ajouter un curseur qui parcours la liste de tous les employés et qui augmente 
#leurs salaires de 30%. Si l’un des salaires dépasse 20000 dh toutes les modifications
# des salaires doivent être annulées.

select * from employe
drop procedure if exists q12;
delimiter $$
create procedure q12()
begin
	declare idemp int;
    declare flag boolean default true;
    declare txt_message varchar(50);
    declare c1 cursor for select mle from employe;    
    declare continue handler for not found  set flag = false;
    declare exit handler for sqlexception
        begin
         get diagnostics condition 1 txt_message = MESSAGE_TEXT;
         select txt_message;
			select ("operation annulée");
			rollback;
            close c1;
		end;
    open c1;
    start transaction;
    b1: loop
		fetch c1 into idemp;
        if flag = false then
			leave b1;
        end if;
		update employe set salaire = salaire *1.3where mle = idemp;
    end loop b1;
    commit;
    close c1;
    select("operation reussie");
end$$
delimiter ;
select * from employe;
call q12;
