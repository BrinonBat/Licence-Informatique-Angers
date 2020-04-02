-- reinitialisation
DROP TABLE IF EXISTS PRODUIT;
DROP TABLE IF EXISTS PRODUIT2;
---------------------- creation et remplissage des tables ----------------------
CREATE TABLE PRODUIT (
	NumProd int,
	primary key(NumProd),
	Designation varchar(50),
	Prix float
);

CREATE TABLE PRODUIT2 (
	NumProd int,
	primary key(NumProd),
	Designation varchar(50),
	Prix int
);

INSERT INTO PRODUIT VALUES
	(1,'une bonne moyenne',100),
	(2,'alibaba',NULL);

-------------------------------- fonctions -------------------------------------

/* fonction créant la table PRODUIT2 à partir de PRODUIT */
CREATE OR REPLACE FUNCTION construProd2() returns void AS $$
	DECLARE
		cursdate cursor for SELECT * FROM PRODUIT;
	BEGIN
		IF EXISTS(SELECT * FROM PRODUIT) THEN
				FOR val in cursdate LOOP
					IF val.Prix IS NULL
						THEN val.Prix=0;
					END IF;
					INSERT INTO PRODUIT2 VALUES(
						val.NumProd,
						UPPER(val.Designation),
						ROUND(val.Prix*(1/6.55957))
					);
				END LOOP;

		 ELSE
			INSERT INTO PRODUIT2 VALUES (0,'Pas de PRODUIT',NULL);
		 END IF;
	END;
$$ LANGUAGE 'plpgsql';
