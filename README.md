# Compte Rendu des TPs d'IA

Yohan JARNAC - Pascal ANDRAWS  
4IR I B1

## TP n°1 : Algorithme A* appliqué au Taquin

### 1. Familiarisation avec le problème du Taquin 3x3

#### 1.2.a) Quelle clause Prolog permettrait de représenter la situation finale du Taquin 4x4 ?
```
final_state([1,  2,  3,  4],
            [5,  6,  7,  8],
            [9,  10, 11, 12],
            [13, 14, 15, vide]).
```

#### 1.2.b) A quelles questions permettent de répondre les requêtes suivantes ?
```
?- initial_state(Ini), nth1(L,Ini,Ligne), nth1(C,Ligne,d).
```
Cette requête renvoie les coordonnées __(L,C)__ de __d__ dans la matrice __Ini__.  

```
?- final_state(Fin), nth1(3,Fin,Ligne), nth1(2,Ligne,P).
```
Cette requête renvoie __P__ qui est l'élément présent aux coordonnées __(3,2)__ dans la matrice __Fin__.  

#### 1.2.c) Quelle requête Prolog permettrait de savoir si une pièce donnée P est bien placée dans U0 (par rapport à F) ?
###### Pour P = a qui n'est pas bien placée
```
initial_state(U0),
final_state(F),
nth1(L,U0,Ligne),
nth1(C,Ligne,a),
nth1(L,F,LigneF),
nth1(C,LigneF,a).
```
Swi-Prolog renvoie alors :
```
false
```
###### Pour P = c qui est bien placée
```
initial_state(U0),
final_state(F),
nth1(L,U0,Ligne),
nth1(C,Ligne,c),
nth1(L,F,LigneF),
nth1(C,LigneF,c).
```
Swi-Prolog renvoie alors :
```
U0 = [[b, h, c], [a, f, d], [g, vide, e]],
F = [[a, b, c], [h, vide, d], [g, f, e]],
L0 = 1,
Ligne = [b, h, c],
C0 = 3,
LigneF = [a, b, c]
```
On obtient en plus les coordonnées de C *qui sont (1,3)*.

#### 1.2.d) Quelle requête permet de trouver une situation suivante de l'état initial du Taquin 3x3 ? *(3 sont possibles)*
```
?- initial_state(Ini), rule(R,1,Ini,Suivant).
```

#### 1.2.e) Quelle requête permet d'avoir ces 3 réponses regroupées dans une liste ? 
```
?- initial_state(Ini), findall(Suivant, rule(R,1,Ini,Suivant), L).
```

#### 1.2.f) Quelle requête permet d'avoir la liste de tous les couples [A,S] tels que S est la situation qui résulte de l'action A en U0 ?
```
?- initial_state(Ini), findall([A,S], rule(A,1,Ini,S), L).
```
