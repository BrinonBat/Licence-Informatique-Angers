DROP TABLE IF EXISTS PERSONNE;
DROP TABLE IF EXISTS SOCIETE;
DROP TABLE IF EXISTS SALARIE;
DROP TABLE IF EXISTS ACTION;
DROP TABLE IF EXISTS HISTO_An_ACTIONNAIRE;

CREATE TABLE PERSONNE(
	NumSecu int primary key,
	Nom varchar(20),
	Prenom varchar(40),
	Sexe Varchar(1),
	DateNaiss date
);

CREATE TABLE SOCIETE(
	CodeSoc int primary key,
	NomSoc varchar(40),
	Adresse varchar(100)
)

CREATE TABLE SALARIE(

)
