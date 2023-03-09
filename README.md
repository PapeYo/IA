# Compte Rendu des TPs d'IA

Yohan JARNAC - Pascal ANDRAWS

4IR I B1

# TP n°1 : Algorithme A* appliqué au Taquin

## 1. Familiarisation avec le problème du Taquin 3x3

#### 1.2.a) Quelle clause Prolog permettrait de représenter la situation finale du Taquin 4x4 ?
`
final_state([1,  2,  3,  4],
            [5,  6,  7,  8],
            [9,  10, 11, 12],
            [13, 14, 15, vide]).
`

### 1.2.b) A quelles questions permettent de répondre les requêtes suivantes ?
`
?- initial_state(Ini), nth1(L,Ini,Ligne), nth1(C,Ligne,d).
`
Cette requête renvoie les coordonnées (L,C) de 'd' dans la matrice 'Ini'.

`
?- final_state(Fin), nth1(3,Fin,Ligne), nth1(2,Ligne,P).
`
Cette requête renvoie 'P' qui est l'élément présent aux coordonnées (3,2) dans la matrice 'Fin'.
