let graphe1 = [(1,[6;7;8]) ; (2,[1;4]) ; (3, [2]) ; (4, [3;5]) ; (5, [1])
; (6, [5;7]) ; (7, []) ; (8, [6;7])];;


(retourne la liste des sommets dans graphe)
let rec sommets graphe = match graphe with
	((x,_)::r) -> x::(listeSommets r)
	| [] -> [];;
(*sommets graphe1;;*)


(*retourne la liste des successeurs de sommet dans graphe*)
let rec successeurs graphe sommet = match graphe with
	((x, s)::r) -> if x = sommet then s else (successeurs r sommet)
	| [] -> failwith "Ce sommet n'appartient pas au graphe";;
(*successeurs graphe1 3;;*)


(*vrai si e appartient a l*)
let rec contient l e = match l with
	(x::r) -> if x = e 	then true
						else contient r e
	| [] -> false;;


(*retire les elements de l_i de l_ii*)
let rec retirer l1 l2 = match l1 with
	(x::r) -> if contient l2 x 	then retirer r l2
									else x :: retirer r l2
	| [] -> [];;
(*retirer [1;2;3;4;5] [2;4];;*)


(*Pour chaque sommet de graphe, inverser les successeurs*)
let rec inverserSuccesseurs graphe listeSommets =	match graphe with
	(x, s)::r ->  (x, (retirer listeSommets s)) :: inverserSuccesseurs r listeSommets
	| [] -> [];;


(*inverse graphe*)
let inverser graphe = inverserSuccesseurs graphe (liste_sommets graphe);;
(*inverser graphe1;;*)


(*
let rec DFS graphe discovered racine = match graphe with
	(x, (e::r))::g -> if x != racine
*)



(*
let parcours_profondeur graphe =

	let rec parcours_interne sommet visited notVisited =
		if (notVisited = []) 	then []
								else match sommet with
								(num, succ) -> if contient notVisited num 	then num:: (parcours_interne )


*)
