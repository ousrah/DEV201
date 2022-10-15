
create database cuisine;
use cuisine;
create table Recettes (
NumRec int auto_increment primary key, 
NomRec varchar(50), 
MethodePreparation varchar(60), 
TempsPreparation int
);
create table Fournisseur (
NumFou int auto_increment primary key, 
RSFou varchar(50), 
AdrFou varchar(100)
);
create table Ingrédients (
NumIng int auto_increment primary key,
NomIng varchar(50), 
PUIng float, 
UniteMesureIng varchar(20), 
NumFou int,
   constraint  fkIngrédientsFournisseur foreign key (NumFou) references Fournisseur(NumFou)
);
create table Composition_Recette (
NumRec int not null,
constraint  fkCompo_RecetteRecette foreign key (NumRec) references Recettes(NumRec), 
NumIng int not null ,
  constraint  fkCompo_RecetteIngrédients foreign key (NumIng) references Ingrédients(NumIng),
QteUtilisee int,
constraint  pkRecetteIngrédients primary key (NumIng,NumRec)
);

insert into Recettes  values(1,'gateau','melageprotides' ,30),
							(2,'pizza ','melageglucides' ,15),
							(3,'couscous','melagelipides' ,45);
insert into Fournisseur  values (1,'meditel','fes'),
								(2,'maroc telecom','casa'),
								(3,'inwi','taza');
insert into Ingrédients values(1,'Tomate', 100,'cl',1),
								(2,'ail', 200,'gr',2),
								(3,'oignon', 300,'verre',3);
							
insert into Composition_Recette values (1,3,5);
insert into Composition_Recette values (1,1,2);
insert into Composition_Recette values (2,1,10);
