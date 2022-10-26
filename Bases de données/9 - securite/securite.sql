create user 'khalid'@'localhost' identified by '1234567';

drop user 'khalid'@'localhost' ;

set password for 'khalid'@'localhost' = 'abcdefg'


grant all privileges on ecole.* to 'khalid'@'localhost';


revoke all privileges on ecole.* from 'khalid'@'localhost';


grant all privileges on ecole.transfert to 'khalid'@'localhost';


revoke all privileges on ecole.transfert from 'khalid'@'localhost';

show grants
for 'khalid'@'localhost';

grant select on ecole.salle to 'khalid'@'localhost';

grant insert on ecole.salle to 'khalid'@'localhost';


grant delete on ecole.transfert to 'khalid'@'localhost';


grant select on ecole.salle to khalid@localhost;
grant insert on ecole.salle to khalid@localhost;
grant select, insert,delete, update on ecole.transfert to 'khalid'@'localhost';


show grants for 'khalid'@'localhost';
revoke select on ecole.salle from khalid@localhost;
revoke insert  on ecole.salle from khalid@localhost;

grant select  (etage) on ecole.salle to 'khalid'@'localhost';

flush privileges;






