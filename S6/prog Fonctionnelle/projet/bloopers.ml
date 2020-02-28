(************************* PARCOURS PREFIXE et non pas infixe *******************************)
(* parcours en profondeur *)
let parcours_profondeur graphe =
	let rec parcours_interne sommet dejaVisite pasEncoreVisite =
		if (pasEncoreVisite = [])
		then []
		else match sommet with
			(num,succs) -> 	if(List.mem num pasEncoreVisite) (* si le sommet n'est pas encore visité*)
							then num::parcours_interne
								(List.hd(retirer (succs@pasEncoreVisite) dejaVisite),successeurs graphe (List.hd(retirer (succs@pasEncoreVisite) dejaVisite))) (*on visite le prochain element de pas encore visité *)
								(num::dejaVisite) (*on ajoute le sommet actuel dans la liste de ceux déjà visités*)
								(retirer (succs@pasEncoreVisite) (num::dejaVisite))	(* alors on ajoute ses successeurs qui ne sont pas dans " déjà visité " dans " pas encore visité "*)
								(*on retire le sommet actuel de ceux pasEncoreVisités*)
							else parcours_interne
								(List.hd(retirer pasEncoreVisite dejaVisite),successeurs graphe (List.hd(retirer pasEncoreVisite dejaVisite)))
								dejaVisite
								(retirer pasEncoreVisite dejaVisite)
	in parcours_interne (racine graphe) [] [numSommet (racine graphe)]
;;
(******************************************premiet jet parcours suffixe********************************)

(*3 fonctions :
    1 parcours_profondeur graphe -> effectue un parcours en profondeur sur le graphe
    2 parcours_suffixe dejaTraite,pasEncoreVisite -> parcours suffixe tq tous les sommets de graphe ne sont pas traite
    3 traiter sommet,dejaTraite,graphe -> traite le sommet s'il n'est pas dans dejaTraite
*)
(*malheureusement, on n'a pas conservé le "traiter" correspondant *)
let parcours_profondeur graphe =
	let rec parcours_suffixe dejaTraite=
	    (* on a fini une fois que tous les sommets ont été visités*)
	    if((retirer (liste_sommets graphe) dejaTraite)=[])
	    then []
	   (*sinon, on traite la composante connexe suivante *)
	    else parcours_suffixe (traiter (retourne_sommet( (* on cherche dans le graphe le sommet associé au numero du sommet à traiter*)
	                                        	sec (retirer (liste_sommets graphe) dejaTraite)) (* récupére le numero du prochain sommet à traiter*)
									   			graphe
	                              		)
										(* on prends le résultat du parcours suivant comme étant la liste traitée*)
										parcours_suffixe(traiter (retourne_sommet(
									                                   List.hd(retirer (liste_sommets graphe) dejaTraite))
									                                   graphe
									                             )
														dejaTraite
														graphe
														)
										graphe
								)
	in parcours_suffixe []
;;


(********************************** AUTRE TENTATIVE , ON APPROCHE DU BUT mais il manquait 1 argument ***********************)
(*effectue un parcours en profondeur suffixe à partir du sommet saisi en paramètre*)
(*val traiter : 'a * 'a list -> 'a list -> ('a * 'a list) list -> 'a list = <fun>*)
let rec traiter (num,succs) dejaTraite graphe =
    if not(List.mem num dejaTraite)
    then List.fold_left(fun resultat numSommet -> (traiter (retourne_sommet numSommet graphe) (num::resultat) graphe ))
	                    dejaTraite
	                    succs
    else dejaTraite
;;

(*val parcours_profondeurBis : ('a * 'a list) list -> 'a list = <fun>  *)
let parcours_profondeurBis graphe =
		List.fold_left (fun liDejaTraite sommet -> traiter sommet liDejaTraite graphe)
		                []
		                graphe
;;
