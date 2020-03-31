DROP TABLE IF EXISTS PERSONNE;
DROP TABLE IF EXISTS SOCIETE;
DROP TABLE IF EXISTS SALARIE;
DROP TABLE IF EXISTS ACTION;
DROP TABLE IF EXISTS HISTO_An_ACTIONNAIRE;
DROP TYPE IF EXISTS tPersonne;
DROP TYPE IF EXISTS tSociete;


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
	DateAct date,
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
