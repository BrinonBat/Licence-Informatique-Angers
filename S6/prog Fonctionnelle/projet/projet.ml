let graphe1 = [(1,[6;7;8]) ; (2,[1;4]) ; (3, [2]) ; (4, [3;5]) ; (5, [1])
; (6, [5;7]) ; (7, []) ; (8, [6;7])];;


(*fonction qui associe a chaque sommet le plus petit sommet accessible et un index*)
(*ici -1 signifie non defini*)
(*val init_lowlink : ('a * 'b) list -> ('a * int * int * bool) list = <fun> *)
let rec init_lowlink graphe = match graphe with
	(som, _)::reste -> (som, -1, -1, false) :: (init_lowlink reste)
	| [] -> [];;		(*sommet, index, lowlink, onstack*)




(*fonction qui prends la liste lowlink et retourne le plus grand index, pour savoir le plus petit indice qu'on utilise*)
(* val unusedIndex : ('a * int * 'b * 'c) list -> int = <fun>  *)
let rec unusedIndex lowlink =	match lowlink with
	(_, index, _, _)::reste -> let unusedIndexReste = unusedIndex reste in if unusedIndexReste > index then unusedIndexReste else index
	| [] -> -1;;


(*accesseurs et mutateurs de la liste lowlink, les donnees qui sont necessaire pour la fonction tarjan*)
(*val setIndex : ('a * 'b * 'c * 'd) list -> 'a -> 'b -> ('a * 'b * 'c * 'd) list = <fun> *)
let rec setIndex lowlink sommet newIndex = match lowlink with
	(som, index, link, onstack)::reste -> if som = sommet then (som, newIndex, link, onstack)::reste else (som, index, link, onstack):: (setIndex reste sommet newIndex)
	| [] -> failwith "Sommet Invalide setIndex";;


let rec setLink lowlink sommet newLink = match lowlink with
	(som, index, link, onstack)::reste -> if som = sommet then (som, index, newLink, onstack)::reste else (som, index, link, onstack):: (setLink reste sommet newLink)
	| [] -> failwith "Sommet Invalide setLink";;

let rec setOnstack lowlink sommet newOnstack = match lowlink with
	(som, index, link, onstack)::reste -> if som = sommet then (som, index, link, newOnstack)::reste else (som, index, link, onstack):: (setOnstack reste sommet newOnstack)
	| [] -> failwith "Sommet Invalide setOnstack";;

let rec getIndex lowlink sommet = match lowlink with
	(som, index, link, onstack)::reste -> if som = sommet then index else getIndex reste sommet
	| [] -> failwith "Sommet Invalide getIndex";;

let rec getLink lowlink sommet = match lowlink with
	(som, index, link, onstack)::reste -> if som = sommet then link else getLink reste sommet
	| [] -> failwith "Sommet Invalide getLink";;

let rec getOnstack lowlink sommet = match lowlink with
	(som, index, link, onstack)::reste -> if som = sommet then onstack else getOnstack reste sommet
	| [] -> failwith "Sommet Invalide getOnstack";;



let min a b = if a < b then a else b;;



(*retourne la liste des successeurs de sommet dans graphe*)
let rec successeurs graphe sommet = match graphe with
	((x, s)::r) -> if x = sommet then s else (successeurs r sommet)
	| [] -> failwith "Ce sommet n'appartient pas au graphe";;


(*c'est cette fonction qui fait la recursivite de la fonction tarjan et qui mets a jours les donnees au fur a musure*)
(*val strongconnect :  ('a * 'a list) list ->  ('a * int * int * bool) list -> 'a -> 'a list -> ('a * int * int * bool) list = <fun> *)
let rec strongconnect graphe lowlink sommet pile=
	let newIndex = (unusedIndex lowlink) + 1 in
	let lowlink = setIndex lowlink sommet newIndex in
	let lowlink = setLink lowlink sommet newIndex in
	let pile = sommet::pile in
	let lowlink = setOnstack lowlink sommet true in

	let succ = successeurs graphe sommet in


	let rec forSucc succes low = match succes with
		s::r -> if (getIndex low s) = -1 then let low = strongconnect graphe low s pile in
			let low = setLink low s (min (getLink low s) (getLink low sommet)) in forSucc r low
				else if (getOnstack low s) = true then let low = setLink low sommet (min (getLink low sommet) (getIndex low s)) in forSucc r low
					else forSucc r low
		| [] -> low

	in let lowlink = forSucc succ lowlink in lowlink;;


(*cette fonction sert juste a formatter les composantes connexes pour etre comme dans l'enonce*)
(*val postTraitement : ('a * 'b * int * 'c) list -> 'a list list = <fun>*)
let postTraitement lowlink =

	(*fonction qui enleve les informations inutiles*)
	let rec clean low = match low with
		(sommet, _, link, _)::reste -> (sommet, link+1) :: (clean reste)
		| [] -> []

	(*fonction qui determine le nombre de composantes connexes*)
	in let rec nbgroupes links = match links with
		(sommet, link)::reste -> let maxReste = nbgroupes reste in if maxReste > link then maxReste else link
		| [] -> -1

	(*fonction qui ajoute des composantes vides en fonction du nombre de composantes connexes*)
	in let rec addgroup composantes maxgroupes = if maxgroupes = 0 then []::composantes
										else []:: (addgroup composantes (maxgroupes-1))

	(*maintenant les listes des composantes connexes sont pret a etre rempli*)
	in let composantes = addgroup [] (nbgroupes (clean lowlink))

	(*les deux fonctions suivantes sont ceux qui remplissent les listes des composantes connexes*)
	in let rec addcomposante composantes sommet link = match composantes with
		c::r -> if link = 0 then (sommet::c)::r
				else c:: addcomposante r sommet (link-1)
		| [] -> failwith "composante non existant"

	in let rec cfc links composantes = match links with
		(sommet, link)::r -> cfc r (addcomposante composantes sommet link)
		| [] -> composantes

	in cfc (clean lowlink) composantes;;



(*fonction principale de tarjan, initialise les donnees necessaires*)
(*val tarjan : ('a * 'a list) list -> 'a list list = <fun>  *)
let tarjan graphe =
	let lowlink = init_lowlink graphe in
	let pile = [] in

		let rec check low = match low with
			(sommet, index, link, onstack)::reste -> if index = -1 then strongconnect graphe lowlink sommet pile
													else (sommet, index, link, onstack):: check reste
			| [] -> lowlink

	in let lowlink = check lowlink in postTraitement lowlink;;



tarjan graphe1;;
