CREATE DATABASE if not EXISTS gestion_Chaises;
use gestion_Chaises;
drop DATABASE gestion_Chaises;
CREATE TABLE if NOT EXISTS Salle (
	NumSalle int AUTO_INCREMENT PRIMARY key ,
	Etage int,
	NombreChaises int ,
    CONSTRAINT check_nb CHECK (NombreChaises>=20 and NombreChaises<=30 )
    );
    
CREATE TABLE if NOT EXISTS Transfert (
	NumSalleOrigine int ,
	NumSalleDestination int ,
	DateTransfert DATE DEFAULT CURRENT_TIMESTAMP ,
	NbChaisesTransférées int ,
    PRIMARY key(NumSalleOrigine,NumSalleDestination,DateTransfert),
    FOREIGN KEY (NumSalleOrigine) references Salle(NumSalle),
	FOREIGN KEY (NumSalleDestination) references Salle(NumSalle)
    );
    
    
    
DROP PROCEDURE if exists tronsact;
delimiter $$
create PROCEDURE tronsact(a int,b int,c int)
begin
	declare EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN
			SELECT "Impossible d’effectuer le transfert des chaises";
			ROLLBACK;
		end;
	START TRANSACTION;
		UPDATE salle set NombreChaises=NombreChaises+c  where NumSalle=b;
		UPDATE salle set NombreChaises=NombreChaises-c  where NumSalle=a;
        
        INSERT into Transfert VALUES (
			a,b,current_date(),c
        );
    commit;
end $$
delimiter ;
CALL tronsact(1,2,2)
    
    
