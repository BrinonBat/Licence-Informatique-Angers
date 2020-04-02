-- reinitialisation
DROP TABLE IF EXISTS VOL;
DROP TABLE IF EXISTS AVION;
DROP TABLE IF EXISTS PILOTE;
---------------------- creation et remplissage des tables ----------------------

CREATE TABLE AVION (
	AvNum int,
	primary key(AvNum),
	AvNom varchar(20),
	Capacite int,
	Localisation varchar(50)
);

CREATE TABLE PILOTE (
	PINum int,
	primary key(PINum),
	PINom varchar(20),
	PIPrenom varchar(20),
	Ville varchar(20),
	Salaire int
);

CREATE TABLE VOL (
	VolNum int,
	primary key(VolNum),
	PINum int,
	foreign key(PINum) references pilote(PINum),
	AvNum int,
	foreign key(AvNum) references avion(AvNum),
	VilleDep varchar(20),
	VilleArr varchar(20),
	HeureDep time,
	HeureArr time
);

INSERT INTO AVION VALUES -- j'ai mis la marque dans le nom d'avion pour que ce soit plus lisible
	(1,'A300prem',300,'Florence'),
	(2,'A310prem',250,'Naples'),
	(3,'Boeing247prem',200,'Nice'),
	(4,'A300sec',300,'Bruxelles'),
	(5,'ConcordePrem',128,'Lyon'),
	(6,'Boeing247sec',200,'Londres'),
	(7,'ConcordeSec',128,'Marseille'),
	(8,'A310sec',250,'Paris');

INSERT INTO PILOTE VALUES
	(1,'Martinez','Rodrigue','Naples',3500),
	(2,'Earhart','Amelia','Florence',3500),
	(3,'Boucher','Hélène','Nice',3500),
	(4,'De La Poype','Roland','Bruxelles',3500),
	(5,'Navarre','Jean','Paris',3500),
	(6,'Clostermann','Pierre','Lyon',3500);

INSERT INTO VOL VALUES
	(1,1,2,'Naples','Marseille','08:00:00','09:20:00'),
	(2,2,1,'Florence','Londres','08:30:00','10:00:00'),
	(3,4,4,'Bruxelles','Florence','14:00:00','14:50:00'),
	(4,5,8,'Paris','Bruxelles','14:20:00','14:50:00'),
	(5,1,7,'Marseille','Naples','15:00:00','16:30:00'),
	(6,2,1,'Londres','Nice','19:00:00','20:20:00');

-------------------------------- fonctions -------------------------------------

CREATE OR REPLACE FUNCTION changeVit(numAvions int, multipl float) RETURNS void AS $$
	DECLARE
		liVols cursor for SELECT * FROM VOL;
	BEGIN
		FOR vols in liVols LOOP
			IF vols.AvNum=numAvions THEN
				UPDATE VOL
					SET HeureArr=HeureArr+multipl*(HeureArr-HeureDep)
					WHERE VolNum=vols.VolNum;
			END IF;
		END LOOP;
	END;
$$LANGUAGE 'plpgsql';

-- application pour résoudre l'exercice
SELECT changeVit(1,-0.10),changeVit(4,-0.10), changeVit(2,-0.15),changeVit(8,-0.15);
