# 1.	Liste des noms des éditeurs situés à Paris triés 
#par ordre alphabétique. 

select * from  editeur 
where villeed = 'paris'
order by nomed asc ;



#2.	Liste des écrivains de (tous les champs)  langue française, triés par ordre alphabétique sur le nom et le prénom.

select nomecr, prenomecr 
from ecrivain 
where LANGUECR  like "francais" 
order by nomecr, prenomecr Asc;

#3.	Liste des titres des ouvrages (NOMOUVR) ayant été
# édités entre (ANNEEPARU) 1986 et 1987.

select nomouvr 
from ouvrage
where  ANNEEPARU between 1986 and 1987;

#4.	Liste des éditeurs dont le n° de téléphone est inconnu
select nomed
from editeur
where teled is null; 
#5.	Liste des auteurs (nom + prénom) dont le nom contient un ‘C’.
select nomecr,prenomecr
from ecrivain
where nomecr like '%C%'; 
#6.	Liste des titres d’ouvrages contenant  le mot "banque" (éditer une liste triée par n° d'ouvrage croissant). 
select nomouvr
from ouvrage
where NOMOUVR like "%banque%"
order by NUMOUVR;
#7.	Liste des dépôts (nom) situés à Grenoble ou à Lyon. 
select nomdep , villedep 
from depot 
where  villedep in ("Grenoble" ,"Lyon");

#8.	Liste des écrivains (nom + prénom) américains
# ou de langue française. 
select nomecr,prenomecr 
from ecrivain 
where LANGUECR="francais" 
or PAYSECR="usa";

#9.	Liste des auteurs (nom + prénom) de langue française 
# dont le nom ou le prénom commence par un ‘H’. 
select PRENOMECR ,NOMECR
from ecrivain 
where LANGUECR='Francais' and 
(NOMECR LIKE 'h%' OR PRENOMECR LIKE 'h%');


#10.	Titres des ouvrages en stock au dépôt n°2. 

select nomouvr 
from ouvrage o
inner join stocker s
on s.numouvr=o.numouvr
where s.numdep=2

#11.	Liste des auteurs (nom + prénom) ayant écrit des livres 
#coûtant au moins 30 € au 1/10/2002. 
select concat(NOMECR , " " , PRENOMECR) as "nom et prenom" 
from ecrivain where NUMECR in
(select numecr from ecrire where NUMOUVR in
(select numouvr from tarifer where datedeb="2002/10/1"
AND prixvente>=30));

select distinct nomecr, prenomecr
from ecrivain e inner join ecrire ec on e.numecr = ec.numecr
inner join tarifer t on ec.numouvr = t.numouvr
where datedeb='2002/10/1'
AND prixvente>=30;

#12.	Ecrivains (nom + prénom) ayant écrit des livres
# sur le thème (LIBRUB) des « finances publiques ». 

select distinct nomecr,prenomecr 
from ecrivain e 
inner join ecrire ecr on e.numecr=ecr.numecr
 inner join ouvrage o on o.numouvr=ecr.numouvr
 inner join classification c on c.numrub=o.numrub
 where librub='finances publiques'

#13.	Idem R12 mais on veut seulement les auteurs dont le nom contient un ‘A’. 


select distinct nomecr,prenomecr 
from ecrivain e 
inner join ecrire ecr on e.numecr=ecr.numecr
 inner join ouvrage o on o.numouvr=ecr.numouvr
 inner join classification c on c.numrub=o.numrub
 where librub='finances publiques' and nomecr like '%a%'

#14.	En supposant l’attribut PRIXVENTE dans TARIFER 
#comme un prix TTC et un taux de TVA égal à 15,5% sur les ouvrages, 
#donner le prix HT de chaque ouvrage. 
select nomouvr,round(PRIXVENTE/1.155,2) AS pht 
from tarifer t inner join ouvrage o on o.numouvr=t.numouvr ;

#15.	Nombre d'écrivains dont la langue est l’anglais 
#ou l’allemand. 


select count(*) 
from ecrivain 
where languecr= 'anglais' OR languecr= 'allemand' 

#16.	Nombre total d'exemplaires d’ouvrages sur la 
#« gestion de portefeuilles » (LIBRUB) stockés dans les 
#dépôts Grenoblois. 

SELECT sum(QTESTOCK)  from STOCKER where NUMOUVR IN(
	select NUMouvr from OUVRAGE where NUMRUB in (
		select NUMRUB from CLASSIFICATION WHERE LIBRUB='gestion de portefeuilles'
    )
    and NUMdep in (
		select numdep from depot where villedep='Grenoble'
    )
)


select sum( qtestock)
from ouvrage o inner join classification c on o.numrub = c.numrub
			   inner join stocker s on o.numouvr = s.numouvr
			   inner join depot d on s.numdep =d.numdep
where LIBRUB='gestion de portefeuilles'
	  and villedep='Grenoble'


#17.	Titre de l’ouvrage ayant le prix le plus élevé - 
-- faire deux requêtes. (réponse: Le Contr ôle de gestion dans la banque.)




#update tarifer set prixvente = 80.828 where numouvr = 1
#methode 1
select nomouvr
from ouvrage join tarifer 
on ouvrage.numouvr=tarifer.numouvr
where prixvente in (
select max(prixvente) from tarifer)

#methode 2
with maxprice as (select max(prixvente) as m from tarifer)

select nomouvr
from ouvrage o
inner join tarifer t on o.numouvr=t.numouvr
inner join maxprice p on p.m=t.prixvente;




#18.	Liste des écrivains avec pour chacun 
# le nombre d’ouvrages qu’il a écrits. 
select e.nomecr , e.prenomecr,  count(*)
from ecrivain e
inner join ecrire ec on e.numecr = ec.numecr
group by e.nomecr, e.prenomecr;


#19.	Liste des rubriques de classification avec, 
#pour chacune, le nombre d'exemplaires en stock dans les 
#dépôts grenoblois. 

select librub , sum(s.qtestock) as "nb_ex" 
from classification c
join ouvrage o on c.numrub=o.numrub
join stocker s on s.numouvr=o.numouvr
join depot d on d.numdep = s.numdep
where villedep like 'grenoble'
group by c.librub


#20.	Liste des rubriques de classification avec leur
# état de stock dans les dépôts grenoblois: ‘élevé’ s’il 
# y a plus de 1000 exemplaires dans cette rubrique, 
# ‘faible’ sinon. (réutiliser la requête 19). 

#methode 1
select librub , sum(s.qtestock) , if(sum(qtestock)>1000,'eleve','faible') as 'etat'
from classification c
join ouvrage o on c.numrub=o.numrub
join stocker s on s.numouvr=o.numouvr
join depot d on d.numdep = s.numdep
where villedep like 'grenoble'
group by c.librub

#methode 2
select librub , sum(s.qtestock) , 
case  
#	when sum(s.qtestock)>6000 then 'excellnt'
#	when sum(s.qtestock)>4000 then 'tres bien'
#	when sum(s.qtestock)>3000 then 'bien'
	when sum(s.qtestock)>1000 then 'eleve'
	else 'faible' 
end as 'etat'
from classification c
join ouvrage o on c.numrub=o.numrub
join stocker s on s.numouvr=o.numouvr
join depot d on d.numdep = s.numdep
where villedep like 'grenoble'
group by c.librub

#21.	Liste des auteurs (nom + prénom) ayant écrit des 
#livres sur le thème (LIBRUB) des « finances publiques » 
#ou bien ayant écrit des livres coûtant au moins 30 € au 1/10/2002 
#- réutiliser les requêtes 11 et 12. 

#methode 1
select distinct nomecr, prenomecr
from ecrivain e inner join ecrire ec on e.numecr = ec.numecr
inner join tarifer t on ec.numouvr = t.numouvr
where datedeb='2002/10/1'
AND prixvente>=30

union # utilisez union all si vous souhaitez garder les doublons

select distinct nomecr,prenomecr 
from ecrivain e 
inner join ecrire ecr on e.numecr=ecr.numecr
 inner join ouvrage o on o.numouvr=ecr.numouvr
 inner join classification c on c.numrub=o.numrub
 where librub='finances publiques'
 
 #methode2
 
with t1 as  ( select distinct nomecr, prenomecr
from ecrivain e inner join ecrire ec on e.numecr = ec.numecr
inner join tarifer t on ec.numouvr = t.numouvr
where datedeb='2002/10/1'
AND prixvente>=30),

  t2  as (select distinct nomecr,prenomecr 
from ecrivain e 
inner join ecrire ecr on e.numecr=ecr.numecr
 inner join ouvrage o on o.numouvr=ecr.numouvr
 inner join classification c on c.numrub=o.numrub
 where librub='finances publiques'
 )
select * from  t1 
union 
select * from t2

#methode 3

create or replace view v1 as ( select distinct nomecr, prenomecr
from ecrivain e inner join ecrire ec on e.numecr = ec.numecr
inner join tarifer t on ec.numouvr = t.numouvr
where datedeb='2002/10/1'
AND prixvente>=30);

create or replace view  v2  as (select distinct nomecr,prenomecr 
from ecrivain e 
inner join ecrire ecr on e.numecr=ecr.numecr
 inner join ouvrage o on o.numouvr=ecr.numouvr
 inner join classification c on c.numrub=o.numrub
 where librub='finances publiques'
 );
select * from  v1 
union 
select * from v2;


# methode 4

create temporary table if not exists tp1  select distinct nomecr, prenomecr
from ecrivain e inner join ecrire ec on e.numecr = ec.numecr
inner join tarifer t on ec.numouvr = t.numouvr
where datedeb='2002/10/1'
AND prixvente>=30 ;

create temporary table if not exists tp2  select distinct nomecr,prenomecr 
from ecrivain e 
inner join ecrire ecr on e.numecr=ecr.numecr
 inner join ouvrage o on o.numouvr=ecr.numouvr
 inner join classification c on c.numrub=o.numrub
 where librub='finances publiques';
 
select * from  tp1 
union 
select * from tp2;



#22.	Liste des écrivains (nom et prénom) n’ayant écrit aucun des 
#ouvrages présents dans la base.

#methode 1 
select nomecr,prenomecr,numecr
from ecrivain
where NUMECR not in (select numecr from ecrire);

#methode 2

select *
from ecrivain e left join ecrire c on e.numecr = c.numecr
where c.NUMECR is null



#23.	Mettre à 0 le stock de l’ouvrage n°6 dans le dépôt Lyon2. 

#methode1

update stocker
set qtestock=0
where numouvr=6 and numdep in (select numdep from depot where nomdep='lyon2')

#methode2


update  stocker s  inner join depot d on s.numdep = d.numdep
set qtestock = 0
where  d.nomdep="LYON2"
and s.numouvr=6

#methode3


update depot,stocker
set qtestock=0
where depot.numdep=stocker.numdep
and depot.nomdep="LYON2"
and stocker.numouvr=6

#24.	Supprimer tous les ouvrages de chez Vuibert de la table OUVRAGE.
delete from ecrire 
where numouvr in (select numouvr 
					from ouvrage 
                    where nomed= 'vuibert');

delete from stocker 
where numouvr in (select numouvr 
					from ouvrage 
                    where nomed= 'vuibert');
                    
delete from tarifer 
where numouvr in (select numouvr 
					from ouvrage 
                    where nomed= 'vuibert');

delete from ouvrage where nomed= 'vuibert';

#25.	créer une table contenant les éditeurs 
#situés à Paris et leur n° de tel.

create table edParis
select nomed, teled 
from editeur 
where villeed = 'paris';


select * from edParis;