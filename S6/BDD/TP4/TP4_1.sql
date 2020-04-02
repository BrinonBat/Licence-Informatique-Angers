-- réinitialisation
DROP TABLE IF EXISTS ELEVEUR;
DROP TABLE IF EXISTS ADRESSE;
DROP TABLE IF EXISTS ELEVAGE;
DROP TYPE IF EXISTS tAdresse;
DROP TYPE IF EXISTS tElevage;
DROP TRIGGER IF EXISTS beforeModificationEleveur ON ELEVEUR;
----------------------- creation des types et tables ---------------------------
CREATE TYPE tAdresse as(
	NRue int,
	Rue varchar(20),
	Ville varchar(15),
	CodePostal int
);

CREATE TYPE tElevage as(
	Animal varchar(20),
	AgeMin int,
	NbrMax int
);

CREATE TABLE ELEVEUR(
	NumLic int,
	primary key(NumLic),
	Elevage tElevage,
	Adresse tAdresse
);

CREATE TABLE ADRESSE of tAdresse (primary key(NRue,Rue,Ville,CodePostal));
CREATE TABLE ELEVAGE of tElevage (primary key(Animal,AgeMin,NbrMax));

--------------------------- remplissage des tables -----------------------------
INSERT INTO ELEVAGE VALUES
	('Volaille',1,30),
	('Ovin',24,30),
	('Porcin',24,20);

INSERT INTO ADRESSE VALUES
	(0,'auMilieuDe','Nullpart',404),
	(666,'auFinFondDes','Enfers',-99999),
	(314,'pi','rond',314),
	(10,'bidule','Paris',33000);

INSERT INTO ELEVEUR VALUES
	(1,ROW('Volaille',1,30),ROW(314,'pi','rond',314)),
	(2,(SELECT E FROM ELEVAGE E WHERE E.Animal='Porcin'),(SELECT A FROM ADRESSE A WHERE A.NRue=666)),
	(42,ROW('Volaille',1,30),(SELECT A FROM ADRESSE A WHERE A.NRue=10)),
	(3,(SELECT E FROM ELEVAGE E WHERE E.Animal='Ovin'),(SELECT A FROM ADRESSE A WHERE A.NRue=0));

----------------------- autres modifications -----------------------------------
UPDATE ELEVEUR
	SET Adresse.Ville='Bordeaux', Adresse.CodePostal=33000
	WHERE (Elevage).Animal='Ovin';

DELETE FROM ELEVEUR WHERE (Adresse).Ville='Paris';

UPDATE ELEVEUR
	SET Elevage.Animal='Volaille' WHERE (Adresse).Ville='Angers';

-- creation d'un Trigger pour appliquer les nouvelles contraintes

CREATE OR REPLACE FUNCTION checkContraintes() RETURNS TRIGGER AS $$
	BEGIN
		IF (NEW.Adresse).Ville='Paris' or ((NEW.Adresse).Ville='Angers' and (NEW.Elevage).Animal<>'Volaille')THEN
			RAISE NOTICE 'INTERDICTION';
			RETURN NULL;
			ELSE RETURN NEW;
		END IF;
	END;
$$LANGUAGE 'plpgsql';

CREATE TRIGGER beforeModificationEleveur BEFORE UPDATE OR INSERT ON ELEVEUR
FOR EACH ROW EXECUTE PROCEDURE checkContraintes();

--test du trigger
INSERT INTO ELEVEUR VALUES (7,ROW('Ovin',2,7),ROW(22,'test','Angers',49000));
