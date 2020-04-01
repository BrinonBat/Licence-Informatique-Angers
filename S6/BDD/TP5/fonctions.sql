-------------------------------- fonctions -------------------------------------
--Q5
CREATE OR REPLACE FUNCTION anneesPertes(soci tSociete) RETURNS setof int AS $$
	DECLARE
		annees cursor for SELECT H.Annee FROM  HISTO_An_ACTIONNAIRE H WHERE H.NbrAchat<H.NbrVente and H.Societe=soci;
	BEGIN
		RAISE NOTICE 'le nombre de ventes est supérieur au nombre d achat pour les années :';
		FOR ans in annees LOOP
			RETURN NEXT ans;
		END LOOP;
	END;
$$ LANGUAGE 'plpgsql';

--Q6
CREATE OR REPLACE FUNCTION nonActionnaires() RETURNS int AS $$
	DECLARE
		nbPers int=(SELECT COUNT(NumSecu) FROM PERSONNE);
		nbActio int=(SELECT COUNT(*) FROM (SELECT DISTINCT (H.Personne).NumSecu FROM HISTO_An_ACTIONNAIRE H) AS tmp);
	BEGIN
		RETURN nbPers-nbActio;
	END;
$$ LANGUAGE 'plpgsql';

--Q7
/*
CREATE OR REPLACE FUNCTION actioSalarie() RETURNS TABLE(nom varchar(40),an int) AS $$
	BEGIN
		RETURN QUERY(
			SELECT DISTINCT (H.Societe).NomSoc,H.Annee FROM HISTO_An_ACTIONNAIRE H
		EXCEPT
		(SELECT DISTINCT (R.Societe).NomSoc,R.Annee FROM
		(SELECT * FROM HISTO_An_ACTIONNAIRE H LEFT OUTER JOIN SALARIE S ON H.Societe=S.Societe and H.Personne=S.Personne)R WHERE R.Salaire IS NULL)
		);
	END;
$$LANGUAGE 'plpgsql';
*/
--Q8
CREATE OR REPLACE FUNCTION plusActive(soci tSociete) RETURNS int AS $$
	DECLARE
		liAns cursor FOR SELECT DISTINCT Annee FROM HISTO_An_ACTIONNAIRE WHERE Societe=soci;
		max int=0;
		annee int=NULL;
	BEGIN
		FOR ans in liAns LOOP -- pour chaque annee où l'entreprise à eu des actions
			/* on verifie la quantité de salariés ayant effectué des actions durant l'année*/
			IF(SELECT COUNT(*) FROM HISTO_An_ACTIONNAIRE H INNER JOIN SALARIE S ON H.Societe=S.Societe and H.Personne=S.Personne WHERE H.Annee=ans.Annee)>max THEN
				/*s'il y en a + qu'au max, alors ça devient le nouveau max et cette annee est la nouvelle meilleure*/
				max=(SELECT COUNT(*) FROM HISTO_An_ACTIONNAIRE H INNER JOIN SALARIE S ON H.Societe=S.Societe and H.Personne=S.Personne WHERE H.Annee=ans.Annee);
				annee=ans.Annee;
			END IF;
		END LOOP;
		RETURN annee;
	END;
$$LANGUAGE 'plpgsql';

--Q9
CREATE OR REPLACE FUNCTION meilleurActio(an int) RETURNS setof tPersonne AS $$
	DECLARE
		historique cursor for SELECT * FROM HISTO_An_ACTIONNAIRE WHERE Annee=an;
		gens tPersonne[];
		max int=0;
	BEGIN
		/* on détermine d'abord la plus valeur */
		FOR histo in historique LOOP
			IF ((SELECT SUM(H.NbrActTotal)FROM HISTO_An_ACTIONNAIRE H WHERE H.Personne=histo.Personne and H.Annee=an))>max
			THEN max=(SELECT SUM(H.NbrActTotal)FROM HISTO_An_ACTIONNAIRE H WHERE H.Personne=histo.Personne and H.Annee=an);
			END IF;
		END LOOP;
		/* puis on liste les personnes l'ayant fournie */
		FOR histo in historique LOOP
			IF((SELECT SUM(H.NbrActTotal)FROM HISTO_An_ACTIONNAIRE H WHERE H.Personne=histo.Personne and H.Annee=an))=max
				THEN gens=array_append(gens,histo.Personne);
			END IF;
		END LOOP;
		/* envoi du résultat */
		FOR i in 1..array_length(gens,1) LOOP
			IF NOT(ARRAY[gens[i]] <@ gens[1:i-1]) /* on evite les doublons */
			 	THEN RETURN NEXT gens[i];
			END IF;
		END LOOP;
	END;
$$LANGUAGE 'plpgsql';
------------------------------------- tests ------------------------------------
SELECT anneesPertes((SELECT S FROM SOCIETE S WHERE S.NomSoc='Le Renouveau Allemand')); -- resultat attendu: 2022
SELECT(nonActionnaires()); -- résultat attendu: 1 ( c'est Karl Marx )
SELECT plusActive((SELECT S FROM SOCIETE S WHERE S.NomSoc='Le Renouveau Allemand')); -- resultat attendu: 2027
SELECT meilleurActio(2027); -- résultat attendu: Nietzsche,Gustave le bon, Freud
