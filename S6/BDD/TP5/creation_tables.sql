-- reinitialisation
DROP TABLE IF EXISTS PERSONNE;
DROP TABLE IF EXISTS SOCIETE;
DROP TABLE IF EXISTS SALARIE;
DROP TABLE IF EXISTS ACTION;
DROP TABLE IF EXISTS HISTO_An_ACTIONNAIRE;
DROP TYPE IF EXISTS tPersonne;
DROP TYPE IF EXISTS tSociete;
DROP TRIGGER IF EXISTS afterChangeAction ON ACTION;
DROP TRIGGER IF EXISTS afterInsertAction ON ACTION;
-- creation des types et tables
CREATE TYPE tPersonne as(
	NumSecu int,
	Nom varchar(20),
	Prenom varchar(40),
	Sexe Varchar(1),
	DateNaiss date
);

CREATE TABLE PERSONNE of tPersonne (primary key(NumSecu));

CREATE TYPE tSociete as(
	CodeSoc int,
	NomSoc varchar(40),
	Adresse varchar(100)
);

CREATE TABLE SOCIETE of tSociete (primary key(CodeSoc));

CREATE TABLE SALARIE(
	Personne tPersonne,
	Societe tSociete,
	Salaire int,
	primary key(Personne,Societe)
);

CREATE TABLE ACTION(
	Personne tPersonne,
	Societe tSociete,
	DateAct DATE,
	NbrAct int,
	typeAct varchar(20),
	primary key(Personne,Societe,DateAct)
);

CREATE TABLE HISTO_An_ACTIONNAIRE(
	Personne tPersonne,
	Societe tSociete,
	Annee int,
	NbrActTotal int,
	NbrAchat int,
	NbrVente int,
	primary key(Personne,Societe,Annee)
);

-- remplissage des tables
INSERT INTO PERSONNE VALUES
	(001,'Nietzsche','Friedrich','h','1844-10-15'),
	(002,'Marx','Karl','h','1818-05-05'),
	(003,'Le Bon','Gustave','h','1841-05-07'),
	(004,'Freud','Sigmond','h','1856-05-06');

INSERT INTO SOCIETE VALUES
	(010,'Les Nouvelles Pensees','30 rue Yalontan'),
	(020,'Le Renouveau Allemand','2 rue ALaiste');

INSERT INTO SALARIE VALUES
	((SELECT P FROM PERSONNE P WHERE P.NumSecu= 001),(SELECT S FROM SOCIETE S WHERE S.NomSoc='Le Renouveau Allemand'),3000),
	((SELECT P FROM PERSONNE P WHERE P.NumSecu= 001),(SELECT S FROM SOCIETE S WHERE S.NomSoc='Les Nouvelles Pensees'),5000),
	((SELECT P FROM PERSONNE P WHERE P.NumSecu= 002),(SELECT S FROM SOCIETE S WHERE S.NomSoc='Le Renouveau Allemand'),3000),
	((SELECT P FROM PERSONNE P WHERE P.NumSecu= 002),(SELECT S FROM SOCIETE S WHERE S.NomSoc='Les Nouvelles Pensees'),5000),
	((SELECT P FROM PERSONNE P WHERE P.NumSecu= 003),(SELECT S FROM SOCIETE S WHERE S.NomSoc='Les Nouvelles Pensees'),5000),
	((SELECT P FROM PERSONNE P WHERE P.NumSecu= 004),(SELECT S FROM SOCIETE S WHERE S.NomSoc='Les Nouvelles Pensees'),5000);


-- creation de triggers
CREATE OR REPLACE FUNCTION majHistoActionnaire() RETURNS TRIGGER AS $$
	BEGIN
		/* creation du nuplet s'il n'est pas present dans la BDD */
		IF NOT EXISTS(SELECT * FROM HISTO_An_ACTIONNAIRE WHERE Societe=NEW.Societe and Personne=NEW.Personne and Annee=EXTRACT(year FROM NEW.DateAct))
			THEN INSERT INTO HISTO_An_ACTIONNAIRE VALUES(NEW.Personne,NEW.Societe,EXTRACT(year FROM NEW.DateAct),0,0,0);
		END IF;
		/* maj du nuplet */
		IF NEW.TypeAct='achat' THEN
			UPDATE HISTO_An_ACTIONNAIRE
				SET NbrActTotal=NbrActTotal+NEW.NbrAct,NbrAchat=NbrAchat+NEW.NbrAct
				WHERE Societe=NEW.Societe and Personne=NEW.Personne and  Annee=EXTRACT(year FROM NEW.DateAct);
		ELSIF NEW.TypeAct='vente'THEN
			UPDATE HISTO_An_ACTIONNAIRE
				SET NbrActTotal=NbrActTotal+NEW.NbrAct, NbrVente=NbrVente+NEW.NbrAct
				WHERE Societe=NEW.Societe and Personne=NEW.Personne and  Annee=EXTRACT(year FROM NEW.DateAct);
		ELSE RAISE NOTICE 'erreur lors de la maj de HISTO_An_ACTIONNAIRE';
		END IF;
		RETURN NEW;
	END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER afterInsertAction AFTER INSERT ON ACTION
FOR EACH ROW EXECUTE PROCEDURE majHistoActionnaire();

CREATE OR REPLACE FUNCTION verifDateEtUpdate() RETURNS TRIGGER AS $$
	DECLARE
		diffDates int=NEW.DateAct-current_date;
	BEGIN
		IF TG_OP='UPDATE' THEN RAISE EXCEPTION 'les updates sont interdits';
		ELSE
			IF (diffDates<0) THEN
				RAISE EXCEPTION 'date non valide %-%=%',NEW.DateAct,current_date,diffDates;
			END IF;
		END IF;
		RETURN NEW;
	END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER beforeChangeAction AFTER INSERT OR UPDATE ON ACTION
FOR EACH ROW EXECUTE PROCEDURE verifDateEtUpdate();

-- tests
INSERT INTO ACTION VALUES
	((SELECT P FROM PERSONNE P WHERE P.NumSecu=001),(SELECT S FROM SOCIETE S WHERE S.NOMSOC='Le Renouveau Allemand'),'1998-05-22',8,'achat'),
	((SELECT P FROM PERSONNE P WHERE P.NumSecu=001),(SELECT S FROM SOCIETE S WHERE S.NOMSOC='Le Renouveau Allemand'),'2027-05-21',4,'achat'),
	((SELECT P FROM PERSONNE P WHERE P.NumSecu=001),(SELECT S FROM SOCIETE S WHERE S.NOMSOC='Le Renouveau Allemand'),'2027-08-10',1,'achat');

SELECT * FROM HISTO_An_ACTIONNAIRE;
