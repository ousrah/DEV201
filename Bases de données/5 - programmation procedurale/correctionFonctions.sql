select date_format(current_time, "%Y/%M/%d %h:%i:%s %r")

select current_time

select monthname(current_time)



use notes;
drop function if exists get_time_diff;
delimiter $$
create function get_time_diff(intervalle varchar(20),d1 datetime, d2 datetime)
	returns varchar(50)
	deterministic
begin
	declare resultat varchar(50);
	case intervalle
		when "annee" then set resultat= timestampdiff(year,d1,d2);
		when "mois" then set resultat= timestampdiff(month,d1,d2);
		when "jour" then set resultat= timestampdiff(day,d1,d2);
		when "heure" then set resultat= timestampdiff(hour,d1,d2);
		when "minute" then set resultat= timestampdiff(minute,d1,d2);
		when "seconde" then set resultat= timestampdiff(second,d1,d2);
		else
			set resultat="erreur";
    end case;
	return resultat;
end$$
delimiter ;

select get_time_diff("seconde",current_time, "2022/12/31 23:59:59");








create database vols2018 COLLATE "utf8_general_ci";
use vols2018;

create table Pilote(
numpilote int auto_increment primary key,
nom varchar(50),
titre varchar(50),
salaire float,
villepilote varchar(50),
daten date,
datedebut date);

create table Avion(
numav  int auto_increment primary key,
typeav  varchar(50) ,
capav int);

create table Vol(
numvol int auto_increment primary key,
villed varchar(50),
villea varchar(50),
dated date,
datea date, 
numpil int, foreign key(numpil) references pilote(numpilote) ,
numav int, foreign key(numpil) references avion(numav)  );

insert into pilote (nom, titre, salaire, villepilote, daten, datedebut) values 
('said','M.',10000,'tetouan','1970/04/13','1997/11/08'),
('salah','M.',15000,'agadir','1984/1/04','2000/10/09'),
('saad','M.',20000,'casablanca','1981/11/04','2005/3/10');

select * from pilote;

insert into avion (typeav,capav) values 
('hgfhf',300),
('airbus',450),
('caravel',50);

insert into vol(villed, villea, dated, datea, numpil, numav) values 
('tanger','marrakech','2018/10/10','2018/11/10',1,1),
('marrakech','tanger','2018/10/10','2018/11/11',1,2),
('casablanca','agadir','2018/4/10','2018/4/10',1,3),
('agadir','casablanca','2018/5/10','2018/5/10',2,3),
('tanger','casablanca','2018/5/10','2018/6/10',2,1),
('casablanca','marrakech','2018/6/10','2018/6/10',3,2),
('marrakech','fes','2018/7/10','2018/7/10',3,1);

drop function if exists get_nb_pilotes;
delimiter $$
create function get_nb_pilotes(nb int)
returns int
deterministic
begin
	declare r int;
	select count(*) into r from  (
								select  numpil 
								from vol 
								group by numpil 
								having count(*) > nb) t1;
	return r;
end$$
delimiter ;

select get_nb_pilotes(1)
use vols2018;




select * from vol


