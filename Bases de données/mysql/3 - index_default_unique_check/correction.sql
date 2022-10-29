/*Série 1 : Les Contraintes d’intégrités

Exercice 1 :

Soit le modèle relationnel suivant relatif à la gestion des notes annuelles d'une promotion d’étudiants :
ETUDIANT (NEtudiant, Nom, Prénom)
MATIERE (CodeMat, LibelleMat, CoeffMat)
EVALUER (NEtudiant, CodeMat, DateExamen, Note)
Questions :*/
#1.	Créer la base de données avec le nom « Ecole »;
create database if not exists ecole collate utf8_general_ci;
use ecole;
#2.	Créer les tables avec les clés primaires sans spécifier les clés étrangères ;

create table ETUDIANT (NEtudiant int auto_increment primary key,
					 Nom varchar(50),
					 Prénom varchar(50));
                     
create table MATIERE (CodeMat int auto_increment primary key, 
					LibelleMat varchar(50), 
					CoeffMat int);
                    
create table EVALUER (NEtudiant int , 
				CodeMat int,
				 DateExamen date,
				 Note float,
				 primary key (NEtudiant, codeMat));



#3.	Ajouter les clés étrangères à la table EVALUER ; 

alter table evaluer
add constraint fk_eva_etu foreign key(NEtudiant) references ETUDIANT(NEtudiant) on delete cascade on update cascade;

alter table evaluer
add constraint fk_eva_mat foreign key(codeMat) references MATIERE(codeMat) on delete cascade on update cascade;

#4.	Ajouter la colonne Groupe dans la table ETUDIANT: Groupe NOT NULL ; 
alter table ETUDIANT 
	add Groupe varchar(50) not null;
#erreur parceque le groupe est obligatoire
insert into etudiant (nom, prénom) values ('a','a');
insert into etudiant (nom, prénom, groupe) values ('a','a','tdi201');

#on a modifier le chanps groupe pour qu'il devienne optionnel
alter table ETUDIANT 
	modify Groupe varchar(50);
    
insert into etudiant (nom, prénom) values ('b','b');



#5.	Ajouter la contrainte unique pour l’attribut (LibelleMat) ; 

alter table matiere 
add constraint un_lib
unique(libellemat);


#6.	Ajouter une colonne Age à la table ETUDIANT, avec la contrainte (age >16) ;
alter table etudiant
add age int check (age>16); 

#le check accept les valeurs nuls
insert into etudiant (nom, prénom) values ('c','c');

#le check n'accept pas les valeur inférieur ou égale à 16 pour la colonne age
insert into etudiant (nom, prénom, age) values ('c','c',10);

select * from etudiant;

#on souhaite ne pas autoriser les valeurs null, on test avec enforced
alter table etudiant
modify age int check (age>16) enforced; 
#l'insertion avec l'age null fonctionne tjr
insert into etudiant (nom, prénom) values ('c','c');

#on ajout une condition is not null sur l'age

alter table etudiant
modify age int check (age>16 and age is not null) enforced; 
update etudiant set age = 18;

#l'insertion des valeurs null est non autorisée maintenant
insert into etudiant (nom, prénom) values ('c','c');


#7.	Ajouter une contrainte sur la note pour qu’elle soit dans l’intervalle (0-20) ; 

alter table evaluer
add constraint evaluer_note 
check (note between 0 and 20);

#8.	Remplir les tables par les données ;



/*Exercice 2 :

Soit le schéma relationnel suivant :

  AVION ( NumAv, TypeAv, CapAv, VilleAv)
  PILOTE (NumPil, NomPil,titre, VillePil) 
  VOL (NumVol, VilleD, VilleA, DateD, DateA, NumPil#,NumAv#)

Travail à réaliser :

  À l'aide de script SQL: 
*/
#1.	Créer la base de données sans préciser les contraintes de clés.
create database if not exists vols collate utf8_general_ci;
use vols;
create table  AVION ( NumAv int auto_increment unique, 
TypeAv varchar(50), 
CapAv int,
 VilleAv varchar(50));
 
create table   PILOTE (NumPil int auto_increment unique,
 NomPil varchar(50),
 titre varchar(50), 
 VillePil varchar(50)) ;
 
create table   VOL (NumVol int auto_increment unique,
 VilleD varchar(50), 
 VilleA varchar(50), 
 DateD date,
 DateA date , 
 NumPil int not null,
 NumAv int not null);



#2.	Ajouter les contraintes de clés aux tables de la base.

alter table avion add constraint pk_avion primary key (numav);
alter table pilote add constraint pk_pilote primary key (numpil);
alter table vol add constraint pk_vol primary key (numvol);

alter table vol add constraint fk_vol_avion foreign key (numav) references avion(numav) on delete cascade on update cascade;
alter table vol add constraint fk_vol_pilote foreign key (numpil) references pilote(numpil) on delete cascade on update cascade;


#3.	Ajouter des contraintes qui correspondent aux règles de gestion suivantes
#	Le titre de courtoisie doit appartenir à la liste de constantes suivantes :
#M, Melle, Mme.
alter table pilote
add constraint ch_np check(titre in('M', 'Melle', 'Mme'));

#	Les valeurs noms, ville doivent être renseignées.

alter table pilote
add constraint chk_npl3 check(nompil +villepil is not null  );

alter table pilote
modify column nompil varchar(50) not null;

alter table pilote
modify column villepil varchar(50) not null;

use librairie;
select *,teled+langue from editeur;


#	La capacité d’un avion doit être entre 50 et 100.
use vols;
alter table Avion add constraint check_cap check( CapAv between 50 and 100);
#4.	Ajouter la  colonne ‘date de naissance’ du pilote : DateN 
alter table pilote
add daten date;


#5.	Ajouter une contrainte qui vérifie que la date de départ d’un vol est toujours inférieure ou égale à sa date d’arrivée.
alter table vol 
add constraint ch_d check (datea>= dated);
#6.	Supprimer la colonne VilleAv

alter table avion drop  VilleAv;
#7.	Supprimer la table PILOTE

alter table vol 
drop constraint fk_vol_pilote;
drop table pilote;


#8.	Remplir la base de données pour vérifier les contraintes appliquées.



 
