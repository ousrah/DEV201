Create database location ;
use location ;

drop table if exists contrat;
drop table if exists bien;
drop table if exists client;
drop table if exists quartier;
drop table if exists type_bien;
drop table if exists ville;



create table type_bien(
	id int auto_increment not null,
	libelle varchar(15),
	constraint pk_type_bien primary key (id)
) ;


create table ville(
	id int auto_increment not null,
	libelle varchar(15),
	constraint pk_ville primary key (id)
) ;



 create table quartier(
	id int auto_increment not null,
	libelle varchar(15),
	constraint pk_quartier primary key (id),
	id_ville int, 
   constraint fk_quartier_ville foreign key (id_ville) references ville(id)
);

 create table client(
	cin varchar(15) primary key,
	nom varchar(15),
	prenom varchar(15),
	telephone varchar(10),
	adresse varchar(50)
) ;

 create table bien(
	reference int auto_increment primary key,
	supeficie float,
	nbr_pieces int,
	loyer float,
	adresse varchar(250),
	cin varchar(15),
	id_type_bien int,
 	id_quartier int,
	constraint fk_bien_client foreign key (cin) references client(cin),
	constraint fk_bien_type foreign key (id_type_bien) references type_bien(id),
	constraint fk_bien_quartier foreign key (id_quartier) references quartier(id)
) ;

 create table contrat(
	date_creation date,
	date_entree date,
	date_sortie date ,
	loyer float,
	charges float ,
	cin varchar (15), 
 	reference int,
   constraint fk_contrat_client foreign key (cin) references client(cin),
   constraint fk_contrat_bien foreign key  (reference) references bien (reference),
	constraint pk_contrat primary key (cin, reference)
);




