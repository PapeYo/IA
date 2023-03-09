%*******************************************************************************
%                                    AETOILE
%*******************************************************************************

/*
Rappels sur l'algorithme

- structures de donnees principales = 2 ensembles : P (etat pendants) et Q (etats clos)
- P est dedouble en 2 arbres binaires de recherche equilibres (AVL) : Pf et Pu

   Pf est l'ensemble des etats pendants (pending states), ordonnes selon
   f croissante (h croissante en cas d'egalite de f). Il permet de trouver
   rapidement le prochain etat a developper (celui qui a f(U) minimum).

   Pu est le meme ensemble mais ordonne lexicographiquement (selon la donnee de
   l'etat). Il permet de retrouver facilement n'importe quel etat pendant

   On gere les 2 ensembles de fa�on synchronisee : chaque fois qu'on modifie
   (ajout ou retrait d'un etat dans Pf) on fait la meme chose dans Pu.

   Q est l'ensemble des etats deja developpes. Comme Pu, il permet de retrouver
   facilement un etat par la donnee de sa situation.
   Q est modelise par un seul arbre binaire de recherche equilibre.

Predicat principal de l'algorithme :

   aetoile(Pf,Pu,Q)

   - reussit si Pf est vide ou bien contient un etat minimum terminal
   - sinon on prend un etat minimum U, on genere chaque successeur S et les valeurs g(S) et h(S)
	 et pour chacun
		si S appartient a Q, on l'oublie
		si S appartient a Pu (etat deja rencontre), on compare
			g(S)+h(S) avec la valeur deja calculee pour f(S)
			si g(S)+h(S) < f(S) on reclasse S dans Pf avec les nouvelles valeurs
				g et f
			sinon on ne touche pas a Pf
		si S est entierement nouveau on l'insere dans Pf et dans Pu
	- appelle recursivement etoile avec les nouvelles valeurs NewPF, NewPu, NewQ

*/

%*******************************************************************************

:- ['avl.pl'].       % predicats pour gerer des arbres bin. de recherche
:- ['taquin.pl'].    % predicats definissant le systeme a etudier

%*******************************************************************************

main :-
	initial_state(S0),
	heuristique2(S0,H0),
	G0 is 0,
	F0 is H0+G0,
	% initialisations Pf, Pu et Q
	empty(Pf),
	empty(Pu),
	empty(Q),
	insert([[F0,H0,G0],S0],Pf,NewPf),
	insert([S0,[F0,H0,G0],nil,nil],Pu,NewPu),
	% lancement de Aetoile
	aetoile(NewPf,NewPu,Q).

% ************************************************************************
expand([[_F,_H,G],Etat],Successors) :-
	findall([V,[Fv,Hv,Gv],Etat,Av],(rule(Av,Kev,Etat,V),
				     heuristique(V,Hv),
				     Gv is G+Kev,
				     Fv is Hv + Gv), Successors).

% *************************************************************************
loop_successors([],Pu,Pf,_,Pu,Pf).
loop_successors([S1|Rest],Pu,Pf,Q,Pu_New,Pf_New):-
    process_one_successor(S1,Pu,Pf,Q,Pu_aux,Pf_aux),
    loop_successors(Rest,Pu_aux,Pf_aux,Q,Pu_New,Pf_New).

process_one_successor([U,FGH1,P1,A1],Pu,Pf,Q,Pf_aux,Pu_aux) :-
	(belongs([U,_,_,_],Q) ->
		Pu_aux = Pu,
		Pf_aux = Pf
	;
		((suppress([U,FGH2,_,_],Pu,Pu1)),
		suppress_min([FGH2,U],Pf,Pf1) ->
			(FGH1 @< FGH2 ->
				insert([U,FGH1,P1,A1],Pu1,Pu_aux),
				insert([FGH1,U],Pf1,Pf_aux)
			;
				Pf_aux = Pf,
				Pu_aux = Pu)
		;
			insert([U,FGH1,P1,A1],Pu,Pu_aux),
			insert([FGH1,U],Pf,Pf_aux))
	).
%*************************************************************************
affiche_solution(_,nil).
affiche_solution(Q,Etat) :-
	belongs([Etat,_,Pere,Action],Q),
	affiche_solution(Q,Pere),
	(Action=nil ->
		write('Start'),
		writeln(' -> '),
		initial_state(Etat_I),
		write_state(Etat_I),
	        writeln("")
	;
		write(Action),
		writeln(' -> '),
		write_state(Etat),
		writeln("")).

%*******************************************************************************
aetoile([],[],_) :-
	writeln("PAS DE SOLUTION ! L'ETAT FINAL N'EST PAS ATTEIGNABLE !").

aetoile(Pf, Pu, Q) :-
	final_state(F),
	suppress_min([[_,_,G],U],Pf,Pf2),
	(U=F ->
		suppress([U,FGH,P,A],Pu,_),
		insert([U,FGH,P,A],Q,Q_new),
		affiche_solution(Q_new,U)
	;
		suppress([U,FHG,P,A],Pu,Pu2),
		expand([[_,_,G],U],Succ),
		loop_successors(Succ,Pu2,Pf2,Q,Pu_New,Pf_New),
		insert([U,FHG,P,A], Q, Q_New),
		aetoile(Pf_New,Pu_New,Q_New)
	).
