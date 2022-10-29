insert into ville (libelle) VALUES
	('tetouan'),('tanger'), ('martil'), ('m''diq'),('fnidaq');
    
insert into type_bien (libelle) VALUES
	('appatement'),('villa'), ('garage'), ('maison'),('studio');
    
insert into quartier (libelle,id_ville)VALUES
	('touilaa',1),('saniat r''mel',1), ('bario',1), ('safir',1),('ziana',1);    

INSERT INTO `client`(`cin`, `nom`, `prenom`, `telephone`, `adresse`) VALUES ('L541254','hassan','hassan','065487421','33'),
('L455436','youssef','youssef','045456','34'),
('L78964','khalid','khalid','06464561','35'),
('L8978','hanae','hanae','067898921','36'),
('L45112','karima','karima','06455621','37');

INSERT INTO `bien`(`reference`, `supeficie`, `nbr_pieces`, `loyer`, `adresse`, `cin`, `id_type_bien`, `id_quartier`) VALUES 
('1',85,3,2500,'qlq part','L541254',1,1),
('2',105,4,4500,'qlq part','L455436',2,2),
('3',75,2,1500,'qlq part','L78964',3,3),
('4',55,6,3500,'qlq part','L8978',4,4),
('5',150,4,5500,'qlq part','L45112',5,5);

INSERT INTO `contrat`(`date_creation`, `date_entree`, `date_sortie`, `loyer`, `charges`, `cin`, `reference`) VALUES 
('2021/10/10','2021/10/10','2021/10/10','3500','300','L541254','1'),
('2021/10/10','2021/10/10','2021/10/10','3500','300','L541254','2'),
('2021/10/10','2021/10/10','2021/10/10','3500','300','L541254','3'),
('2021/10/10','2021/10/10','2021/10/10','3500','300','L541254','4'),
('2021/10/10','2021/10/10','2021/10/10','3500','300','L541254','5');