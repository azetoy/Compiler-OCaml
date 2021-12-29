# Pour compiler le projet
```
ocamlbuild -use-menhir test.byte 
```
# Pour lancer un des test deja ecrit
```
./test.byte tests/dec.test
```
# Pour executer le code Mips(asm) generer
```
spim load "mips"  
```
# Mini Description
```
La Boucle While et la condition if() , la Declaration et l'assignation sont implementer  
Les typage est egallement implementer (toute fois seul le type int est actuellement coder)
Actuellement toute les operation mathematique sont implementer (+ - / *)  
Ainsi que les comparateur entre deux expression (> < == !=)
```
