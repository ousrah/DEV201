
create database cuisine
use cuisine
create table Recettes (
NumRec int identity(1,1) primary key, 
NomRec varchar(50), 
MethodePreparation varchar(60), 
TempsPreparation int
)
create table Fournisseur (
NumFou int identity(1,1) primary key, 
RSFou varchar(50), 
AdrFou varchar(100)
)
create table Ingrédients (
NumIng int identity(1,1) primary key,
NomIng varchar(50), 
PUIng money, 
UniteMesureIng varchar(20), 
NumFou int,
   constraint  fkIngrédientsFournisseur foreign key (NumFou) references Fournisseur(NumFou)
)
create table Composition_Recette (
NumRec int not null,
constraint  fkCompo_RecetteRecette foreign key (NumRec) references Recettes(NumRec), 
NumIng int not null ,
  constraint  fkCompo_RecetteIngrédients foreign key (NumIng) references Ingrédients(NumIng),
QteUtilisee int,
constraint  pkRecetteIngrédients primary key (NumIng,NumRec)
)

insert into Recettes  values('gateau','melageprotides' ,30),
							('pizza ','melageglucides' ,15),
							('couscous','melagelipides' ,45);
insert into Fournisseur  values ('meditel','fes'),
								('maroc telecom','casa'),
								('inwi','taza');
insert into Ingrédients values('Tomate', 100,'cl',1),
								('ail', 200,'gr',2),
								('oignon', 300,'verre',3);
							
insert into Composition_Recette values (2,1,10)


