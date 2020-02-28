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



(*permet de concatener deux couples de liste*)
(*val concaten : 'a list * 'b list -> 'a list * 'b list -> 'a list * 'b list = <fun> *)
let concaten (l1,l2) (l1add,l2add)=((l1@l1add),(l2@l2add));;

(*effectue un parcours en profondeur suffixe du sous-graphe correspondant au sommet saisi en paramètre*)
(*liLock est une liste des sommets parcourus et donc à ne pas re-traiter*)
(*val traiter :  'a * 'a list -> 'a list * 'a list -> ('a * 'a list) list -> 'a list * 'a list = <fun> *)
let rec traiter (num,succs) (liLock,resultat) graphe =
    if not(List.mem num liLock) (*traitement si le sommet n'a pas déjà été traité*)
    then concaten   ([],[num]) (*on ajout le sommet actuel au début de la liste résultat*)
					(*on fait un parcours en profondeur sur les successeurs du sommet actuel*)
                    (List.fold_left(fun (liLock,resultat) numSommet -> (traiter
                                                        (retourne_sommet numSommet graphe) (*selection du sommet à traiter*)
                                                        (liLock,resultat)
                                                        graphe)
                                    )
	                                (liLock@[num],resultat)(*ajout du sommet actuel à ceux traités*)
	                                succs) (*parcours des successeurs*)
    else (liLock,resultat) (*si le sommet à déjà été traité, on l'ignore*)
;;
(* parcours en profondeur suffixe du graphe*)
(*val parcours_profondeur : ('a * 'a list) list -> 'a list = <fun>*)
let parcours_profondeur graphe =
	let retourne_resultat (liLock,resultat)=resultat (* on extrait le résultt du couple obtenu*)
	(*on effecture un parcours en profondeur sur TOUS les sommets. Cette étape permet de traiter les differents sous-graphe*)
	in retourne_resultat (List.fold_left (fun (liLock,resultat) sommet -> traiter sommet (liLock,resultat) graphe)
		                ([],[])
		                graphe)
;;

(*parcours_profondeur graphe1 doit retourner - : int list = [2; 4; 3; 1; 8; 6; 7; 5]*)
parcours_profondeur graphe1;;
