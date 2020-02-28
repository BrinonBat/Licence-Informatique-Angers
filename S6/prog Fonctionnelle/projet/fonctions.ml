(* graphe de l'énoncé qui sera utilisé pour l'exemple *)
(* val graphe1 : (int * int list) list*)
let graphe1 = [
	(1, [6;7;8]);
	(2, [1;4]);
	(3, [2]);
	(4, [3;5]);
	(5, [1]);
	(6, [5;7]);
	(7, []);
	(8, [6;7])
];;

(*retourne la liste des sommets*)
(* val liste_sommets : ('a * 'b) list -> 'a list = <fun> *)
let rec liste_sommets graphe =
	match graphe with
	| ((num,_)::suite) -> num::(liste_sommets suite)
	| ([])             -> []
;;
	(*cas du dernier sommet*)

(* retourne le premier sommet du graphe*)
(* val racine : ('a * 'b) list -> 'a * 'b = <fun> *)
let rec racine graphe =
	match graphe with
	| ((num,succs)::_) -> (num,succs)
	| []               -> failwith "graphe vide"
;;

(* retourne le numero du sommet *)
(* val numSommet : 'a * 'b -> 'a = <fun> *)
let numSommet sommet =
	match sommet with
	| (num,succs) -> num
;;

(*retourne la liste des successeurs de sommet dans graphe*)
(* val successeurs : ('a * 'b) list -> 'a -> 'b = <fun> *)
let rec successeurs graphe sommet =
	match graphe with
	| ((x, s)::r) -> if x = sommet then s else (successeurs r sommet)
	| []          -> failwith "Ce sommet n'appartient pas au graphe"
;;
(*successeurs graphe1 3;;*)

(*retourne le 2eme element de la liste*)
(*val sec : 'a list list -> 'a list = <fun> *)
let sec liste=
	match liste with
		[x;y;_]	-> y
		|[x]	-> []
		|_      -> failwith "liste invalide"
;;

(*retire les elements de l2 à l1*)
(* val retirer : 'a list -> 'a list -> 'a list = <fun> *)
let rec retirer l1 l2 =
	match l1 with
	(x::r) 	-> 	if List.mem x l2
				then retirer r l2
				else x::retirer r l2
	| []   	-> []
;;
(*retourne le sommet correspond au numero de sommet en paramètre*)
(*val retourne_sommet : 'a -> ('a * 'b) list -> 'a * 'b = <fun> *)
let rec retourne_sommet numSommet graphe=
	match graphe with
		((num,listSucc)::reste)	-> if (numSommet=num) then (num,listSucc) else retourne_sommet numSommet reste
		|_						-> failwith " sommet non existant dans le graphe"
;;
(* PARCOURS PREFIXE
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
FIN PARCOURS PREFIXE *)
(*
3 fonctions :
    1 parcours_profondeur graphe -> effectue un parcours en profondeur sur le graphe
    2 parcours_suffixe dejaTraite,pasEncoreVisite -> parcours suffixe tq tous les sommets de graphe ne sont pas traite
    3 traiter sommet,dejaTraite,graphe -> traite le sommet s'il n'est pas dans dejaTraite
*)

(* PARCOURS FACTORISE MAIS QUI COMPILE PAS
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
*)
(* AUTRE TENTATIVE , ON APPROCHE DU BUT
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
*)

(*effectue un parcours en profondeur suffixe à partir du sommet saisi en paramètre*)
let rec traiter (num,succs) (liLock,resultat) graphe =
    if not(List.mem num liLock)
    then List.fold_left(fun (liLock,resultat) numSommet -> (traiter
                                                        (retourne_sommet numSommet graphe)
                                                        (liLock,(num::resultat))
                                                        graphe)
                        )
	                    (num::liLock,resultat)
	                    succs
    else (liLock,resultat)
;;

let parcours_profondeur graphe =
		List.fold_left (fun (liLock,resultat) sommet -> traiter sommet (liLock,resultat) graphe)
		                ([],[])
		                graphe
;;

parcours_profondeur graphe1;;
(*parcours_profondeur graphe1 doit retourner - : int list = [2; 4; 3; 1; 8; 6; 7; 5]*)
