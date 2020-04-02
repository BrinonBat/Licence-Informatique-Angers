/* calcul de la moyenne de toute l'université */
CREATE OR REPLACE FUNCTION moyNote() RETURNS int AS $$
	DECLARE
		noteTot int=0;
		coefTot int=0;
		moy float;
		coef int;
		cursdate cursor for SELECT * FROM TABNOTE;
	BEGIN
		FOR val in cursdate LOOP
			coef=(SELECT M.Coef FROM MATIERE M where M.NomMat=val.NomMat);
			noteTot=noteTot+(val.Note*coef);
			coefTot=coefTot+coef;
		END LOOP;
		moy = noteTot/coefTot;
		RETURN moy;
	END;
$$ LANGUAGE 'plpgsql';

/* calcul de la moyenne de la formation entrée en paramètre*/
CREATE OR REPLACE FUNCTION MoyFormat(formation varchar(20)) RETURNS float AS $$
	DECLARE
		noteTot int=0;
		coefTot int=0;
		moy float=NULL;
		coef int;
		cursdate cursor for SELECT * FROM TABNOTE;
	BEGIN
		IF EXISTS (SELECT * FROM TABNOTE WHERE nomForm=formation) THEN
			FOR val in cursdate LOOP
				coef=(SELECT M.Coef FROM MATIERE M WHERE val.NomForm=formation and M.NomMat=val.NomMat);
				noteTot=noteTot+(val.Note*coef);
				coefTot=coefTot+coef;
			END LOOP;
			moy = noteTot/coefTot;
		END IF;
		RETURN moy;
	END;
$$ LANGUAGE 'plpgsql';

/* remplissage de la table de stats */
CREATE OR REPLACE FUNCTION stat_form() RETURNS void AS $$
	DECLARE
		cursNotes cursor for SELECT * FROM TABNOTE;
		cursFormation cursor for SELECT * FROM FORMATION;
		Nom_Form varchar(20);
		Moy_Gene float;
		Nbr_Recu int = 0;
		Nbr_Etd_Pres int = 0;
		Note_Max int;
		Note_Min int;
		noteActu int = 0;
	BEGIN
		DELETE FROM STAT_RESULTAT; -- on vide STAT_RESULTAT au cas ou on aurait fait des tests dessus
		FOR form in cursFormation LOOP
			/* on réinitialise pour chaque formation*/
			Note_Max=NULL;
			Note_Min=NULL;
			/* puis on calcule*/
			Nom_Form=form.NomForm;
			Moy_Gene=MoyFormat(Nom_Form);
			Nbr_Recu=count(distinct E.NumEt) FROM ETUDIANT E join TABNOTE T ON E.NumEt=T.NumEtud WHERE T.note>10 and T.NomForm=Nom_Form;
			Nbr_Etd_Pres=count(distinct E.NumEt) FROM ETUDIANT E join TABNOTE T ON E.NumEt=T.NumEtud WHERE T.NomForm=Nom_Form;
			FOR NotEtu in cursNotes LOOP
				IF NotEtu.NomForm=Nom_Form THEN
					noteActu=NotEtu.note;
					IF noteActu>COALESCE(Note_Max,0) THEN
						Note_Max=noteActu;
					END IF;
					IF noteActu<COALESCE(Note_Min,20) THEN
						Note_Min=noteActu;
					END IF;
				END IF;
			END LOOP;
			INSERT INTO STAT_RESULTAT values (Nom_Form,Moy_Gene,Nbr_Recu,Nbr_Etd_Pres,Note_Max,Note_Min);
		END LOOP;
	END;
$$ LANGUAGE 'plpgsql';

/* matiere et formations suivies par l'etudiant*/
CREATE OR REPLACE FUNCTION MatForm(numEtudiant int) RETURNS SETOF varchar AS $$
	DECLARE
		bulletin cursor for select * from TABNOTE;
	BEGIN
		FOR bull in bulletin LOOP
			IF bull.NumEtud=numEtudiant THEN
				RETURN NEXT bull.NomMat;
				RETURN NEXT bull.NomForm;
			END IF;
		END LOOP;
	END;
$$ LANGUAGE 'plpgsql';

/*Collègues de l'enseignant pris en paramètre*/
CREATE OR REPLACE FUNCTION Collegues(NumeroEns int) RETURNS TABLE(nomE varchar(20),prenomE varchar(20)) AS $$
	BEGIN
		RETURN QUERY(
			SELECT DISTINCT E.NomEns,E.PrenomEns
			FROM (ENSEIGNANT E LEFT OUTER JOIN MATIERE M ON E.NumEns=M.NumEns)
			WHERE NomForm=(SELECT F.NomForm FROM MATIERE F WHERE F.NumEns=NumeroEns) and E.NumEns <> NumeroEns
		);
	END;
$$LANGUAGE 'plpgsql';

/*affiche les enseignants de l'étudiant pris en paramètre*/
CREATE OR REPLACE FUNCTION EnseigEtudiant(numeroEtu int) RETURNS void AS $$
	DECLARE
		liProfs cursor for SELECT * FROM ENSEIGNANT;
	BEGIN
		FOR prof in liProfs LOOP
			IF EXISTS(SELECT * FROM TABNOTE T NATURAL JOIN MATIERE M WHERE T.NumEtud=numeroEtu and M.NumEns=prof.NumEns)
				THEN RAISE NOTICE '% %',prof.PrenomEns,prof.NomEns;
			END IF;
		END LOOP;
	END;
$$LANGUAGE 'plpgsql';
------------------------------------- tests ------------------------------------
--Q3
SELECT E.Nom,E.Prenom,T.Note FROM ETUDIANT E,TABNOTE T WHERE E.NumEt=T.NumEtud and T.Note > moyNote();

SELECT stat_form();
SELECT * FROM STAT_RESULTAT;

SELECT MatForm(1); -- problèmes de doublon.

SELECT * FROM Collegues(1); -- resultat attendu : "Bruno Jacob" et "Petigro Decra"

SELECT EnseigEtudiant(1); -- résultat attendu : "Bruno Jacob","Petigro Decra" et "Jean_Michel Richer"
