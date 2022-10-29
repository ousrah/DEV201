/*drop database if exists notes;
create database notes collate utf8_general_ci;
use notes;

select * from etudiants;
*/
## Géneration de la table ville
drop table if exists ville;
create table ville (id int auto_increment primary key)
select distinct ville libelle from etudiants;
-- select * from ville;

## Géneration de la table classe
drop table if exists classe;
create table classe (id int auto_increment primary key)
select distinct classe libelle from etudiants;
-- select * from classe;

## Géneration de la table matière
drop table if exists matiere;
create table matiere (id int auto_increment primary key)
select distinct matière libelle from etudiants;
-- select * from matiere;


## Géneration de la table 	appréciation
drop table if exists appreciation;
create table appreciation (id int auto_increment primary key)
select distinct appréciation libelle from etudiants;
-- select * from appreciation;

drop table if exists stagiaire;
create table stagiaire (id int auto_increment primary key)
select distinct  `nom stagiaire` nom, `prénom stagiaire` prenom, 

date(concat(right(`Date naissance`,4),'/',substring(`Date naissance`,4,2),'/',left(`Date naissance`,2))) date_naissance,  

v.id ville_id, c.id classe_id
 from etudiants e inner join ville v on e.ville=v.libelle
                  inner join classe c on e.classe=c.libelle;
 
 -- select * from stagiaire;
 
 drop table if exists evaluation;
create table evaluation 
 select s.id stagiaire_id, m.id matiere_id, a.id appreciation_id, convert(replace(e.note,",","."),double) note from etudiants e
 inner join stagiaire s  on e.`nom stagiaire`=s.nom and e.`prénom stagiaire`=s.prenom 
 inner join matiere m on e.matière = m.libelle
 inner join appreciation a on e.appréciation = a.libelle;
 -- select * from evaluation;
 alter table evaluation add constraint pk_evaluation primary key (stagiaire_id, matiere_id, appreciation_id);
 
 
 alter table stagiaire add constraint fk_stagiaire_ville foreign key (ville_id) references ville(id);
 alter table stagiaire add constraint fk_stagiaire_classe foreign key (classe_id) references classe(id);
 
 alter table evaluation add constraint fk_evaluation_stagiaire foreign key (stagiaire_id) references stagiaire(id);
 alter table evaluation add constraint fk_evaluation_matiere foreign key (matiere_id) references matiere(id);
 alter table evaluation add constraint fk_evaluation_appreciation foreign key (appreciation_id) references appreciation(id);
 
 drop table etudiants;
 
 
