drop database if exists ccv1;
create database ccv1 collate utf8_general_ci;
use ccv1;
create table Chambre (Num_Chambre int auto_increment primary key, Prix float, Nbr_Lits int );
create table Client (Num_Client int auto_increment primary key, Nom varchar(50), Prenom varchar(50), Adresse varchar(50), points int);
create table Reservation ( Num_Client int, Num_Chambre int , Date_Arr date , Date_Dep date, foreign key (Num_Client) references client(Num_Client),foreign key (Num_Chambre) references chambre(Num_Chambre) );

insert into chambre values (1,200,2), (2,300,2),(3,500,3);
insert into client values (1,'c1','c1','a1',12),(2,'c2','c2','a2',22),(3,'c3','c3','a3',32);
insert into reservation values (1,1,'2022/10/10','2022/10/12'),(2,2,'2022/10/10','2022/10/13'),(3,3,'2022/10/10','2022/10/14');

#1.	Créez une fonction qui retourne le nombre des clients qui ont réalisé plus que 5 réservations avec une durée totale qui dépasse n jours. (Le nombre de jours est un paramètre de la fonction) : (3 pt)

drop function if exists q1;
delimiter $$
create function q1 (n int)
returns int
deterministic
begin
	declare nb int;
	select count(*) into nb from (
	select distinct num_client from (
	select num_client, count(*) , datediff(date_dep, date_arr)
	from reservation 
	where datediff(date_dep, date_arr)>n
	group by num_client , datediff(date_dep, date_arr)
	having count(*) >5)t1)t2;

	return nb;

end$$
delimiter ;

select q1(4);



2.	Donnez la vue qui permet d’afficher les noms des clients qui ont réservé la même chambre que « marchoud ali » durant janvier 2020 : (2 pt)
create view v2 as 
select * from client where nom!='marchoud' and prenom!='ali' and  num_client in (
select num_client from reservation where num_chambre in (
select distinct num_chambre 
from reservation 
where num_client in(select num_client from client where nom = 'marchoud' and prenom='ali')
and month(date_arr) = 1 and year(date_arr)=2020
))


select * from v2;
#3.	Donnez la fonction qui calcule la durée totale des réservations 
#d’un client dans un mois donné. (Le numéro du client et le mois/année sont passés comme paramètres) (3 pts)


drop function if exists q3;
delimiter $$
create function q3 (cli int, mois int, annee int)
returns int
deterministic
begin
	declare total int;
	select sum(abs(datediff(date_arr,date_dep)))  into total from reservation
	where num_client = cli
	and month(date_arr)=mois  and year(date_arr)=annee;
	return total;
end$$
delimiter ;




4.	Ecrivez une procédure stockée qui supprime les réservations effectuées par un client donnée dans une période donnée. (Date début, date fin) : (3 pts)

drop procedure if exists q4;
delimiter $$
create procedure q4 (in cli int, in dd date, in df date)
begin
delete from reservation where num_client = cli and date_arr between dd and df;

end $$
delimiter ;

call q4 (2,'2022/01/01','2022/12/31')



5.	Ecrivez une procédure stockée qui retourne le(les) nom du premier client qui a fait la réservation d’une année passée en entrée.  (3 pts)
#reponse acceptée

drop procedure if exists q5;
delimiter $$
create procedure q5(in annee int)
begin
select * from client where num_client in (
select num_client from reservation where year(date_arr) = annee order by date_arr asc
) limit 1;
end$$
delimiter ;
#methode plus correcte
drop procedure if exists q5;
delimiter $$
create procedure q5 (in annee int)
begin
select * from client where num_client in (
select distinct num_client from reservation where date_arr in (
select min(date_arr) from reservation where year(date_arr) = annee));
end$$
delimiter ;



6.	Ecrivez un curseur qui permet d’afficher pour cheque client la liste de ces réservations avec le prix totale sous cette forme : (3 pts)

drop procedure if exists q6;
delimiter $$
create procedure q6 ()
begin
	declare nomcli varchar(50);
    declare prenomcli varchar(50);
    declare numcli int;
	declare flag boolean default true;
    declare c1 cursor for select num_client, nom, prenom from client;    
    declare continue handler for not found set flag = false;

    open c1;
    b1: loop
		fetch c1 into numcli, nomcli, prenomcli;
        if not flag then
			leave b1;
        end if;
        select concat("le client " , nomcli, " ", prenomcli  , " à réaliser les réservations suivantes : ");
		begin
			declare prixTotal float default 0;
            declare prixchambre int;
			declare numchambre int;
            declare da date;
            declare dd date;
			declare flag2 boolean default true;
			declare c2 cursor for select r.num_chambre, date_arr, date_dep, prix from reservation r inner join chambre c on r.num_chambre = c.num_chambre where num_client = numcli;    
			declare continue handler for not found set flag2 = false;
			open c2;
            b2: loop
				fetch c2 into numchambre, da, dd, prixchambre;
				if not flag2 then
					leave b2;
				end if;
				select concat ("(du" , da ," jusqu’à ",dd," la chambre ",numchambre,")");
                set prixtotal = prixtotal + (abs(datediff(dd,da)) * prixchambre);
            end loop b2;
            close c2;
            select concat("le prix total des reservations est ", prixtotal);
		end;
   
   
   
   end loop b1;
    close c1;
end$$
delimiter ;

call q6;

Le client Marchoud ali à réaliser les réservations suivantes :
(du 1/1/2021 jusqu’à 3/1/2021 la chambre 3)…
Le montant totale de toutes les réservations est 5400 Dh.

7.	Question au choix
a.	En souhaite écrire un déclencheur sur l’insertion dans la table réservation qui ajoute les points au client selon le nombre des jours qu’ils ont réservé (3 pts)
Nb jours	Nb points
< 3 	1 points
Entre 3 et 10	2 points
>10	3 points

drop trigger if exists q7a;
delimiter $$
create trigger q7a after insert on reservation for each row
begin
	declare nbjours int;
    declare nbpoints int;
    set nbjours = abs(datediff(new.date_arr, new.date_dep));
    case
    when nbjours <3 then set nbpoints = 1;
    when nbjours between 3 and 10  then set nbpoints = 2;
    else
		set nbpoints = 3;
    
    
    end case;
	update client set points = points + nbpoints where num_client = new.num_client;

end$$
delimiter ;
select *  from client;
insert into reservation values (1,1,'2022/10/10', '2022/10/19');



b.	Ajoutez une procedure stockée qui calcule le nombre de jour total de reservation de chaque client et qui lui change le nombre des points selon le tableau suivant :(3 pts)
Nb jours	Nb points
< 30	10 points
Entre 30 et 100	20 points
>100	30 points




drop procedure if exists q7b;
delimiter $$
create procedure q7b ()
begin
	declare np int;
    declare nj int;
    declare numcli int;
	declare flag boolean default true;
    declare c1 cursor for 
	select num_client, sum(datediff(date_dep, date_arr)) from reservation group by num_client;     
    declare continue handler for not found set flag = false;

    open c1;
    b1: loop
		fetch c1 into numcli, nj;
        if not flag then
			leave b1;
        end if;
         case
    when nj <30 then set np = 10;
    when nj between 30 and 100  then set np = 20;
    else
		set np = 30;
    end case;
	update client set points = np where num_client = numcli;
   
   end loop b1;
    close c1;
end$$
delimiter ;


call q7b;
update client set points = 0;
select * from client