##Les indexes
###################################################

#creation de la table test avec l'index sur le libelle
create table test (id int auto_increment primary key, libelle varchar(50), index (libelle));

#ajout d'un nouveau champs et ajour de son index
alter table test add ville varchar(50);
alter table test add index (ville);

#ajout d'in index avec create index
alter table test add telephone varchar(50);
create index ids_tel on test(telephone);

#insertion et selection
insert into test (libelle,ville,telephone) values ('a','tetouan','0615125487');
select * from test where ville = 'tetouan';

#creation d'un index sur plusieurs champs;
create index idx_telville on test(ville,telephone);

#suppression d'un index
drop index idx_telville on test;


##############################################
##  Default
##############################################


drop table if exists test;

#creation d'une table sans champs avec valeurs par défaut
create table test (id int auto_increment primary key, 
libelle varchar(50), 
ville varchar(50));

insert into test (libelle) values ('a');
select * from test;

#creation d'une table avec un champs qui a une valeur par defaut
drop table if exists test;
create table test (id int auto_increment primary key, libelle varchar(50), ville varchar(50) default 'tetouan');

#insertion sans saisie du champs qui a la valeur par defaut
insert into test (libelle) values ('a');

#insertion avec saisie du champs qui a la valeur par defaut
insert into test (libelle,ville) values ('a','tanger');
select * from test;

#creation d'un nouveau champs
alter table test add pays varchar(50);

#ajout d'une valeur par defaut pour un champs existant
alter table test alter pays set default 'maroc';

#creation d'un nouveau champs avec précision de la valeur par defaut.
alter table test add lanugage varchar(50) default 'arabe';

###############################################
#####  UNIQUE
###########################################

drop table if exists societe;

#creation d'une table avec un champs qui n'accepte pas les doublons

create table societe (id int auto_increment primary key,
raison_sociale varchar(100) unique);
insert into societe (raison_sociale) values ('meditel');
insert into societe (raison_sociale) values ('wana');
insert into societe (raison_sociale) values ('iam');

##erreur
insert into societe (raison_sociale) values ('iam');

#ajout d'un nouveau champs unique
alter table societe add telephone varchar(30) unique;

#ajout d'un champs
alter table societe add email varchar(50);

#ajout d'une constrainte unique
alter table societe add constraint unq_email unique(email);

#ajout d'une contrainte unique sur plusieurs champs en meme temps.
alter table societe add constraint unq_tel_email unique(telephone,email);

###############################################
#####  checks
###########################################

drop table  if exists produit;

#creation d'un table avec une régle de validation sur le prix
create table produit (id int auto_increment primary key,
designation varchar(100) unique, prix double check (prix >0));

#tests d'insertion
insert into produit(designation,prix) values ('pc',3500);
insert into produit(designation,prix) values ('imprimante',-500);

#supprimer la règle de validation
alter table produit drop constraint produit_chk_1;

#ajout d'un régle de validation désactivée
alter table produit add constraint produit_chk_1 check (prix>0) not enforced;

#test d'insertion
insert into produit(designation,prix) values ('imprimante',-500);

select * from produit;

#suppression et ajour d'une règle de validation activée
alter table produit drop constraint produit_chk_1;

#erreur
alter table produit add constraint produit_chk_1 check (prix>0)  enforced;

#reparation des données
update produit set prix = 500 where id = 2;

#ajout d'une règle de validation activée
alter table produit add constraint produit_chk_1 check (prix>0)  enforced;
