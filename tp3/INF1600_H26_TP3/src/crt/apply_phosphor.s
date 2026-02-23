/*
Signature: void applyPhosphor(Pixel& p, int subpixel);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
subpixel : indice du pixel dominant

Description : Le paramètre subpixel détermine quelle composante reste dominante :
	si subpixel == 0 → le rouge est conservé, le vert et le bleu sont réduits à 70 % de leur valeur initiale.
	si subpixel == 1→ le vert est conservé, le rouge et le bleu sont réduits à 70 % de leur valeur initiale.
	sinon → le bleu est conservé, le rouge et le vert sont réduits à 70 % de leur valeur initiale.

Encore une fois, puisqu’on travaille avec des divisions entières, la réduction se fait avec la formule suivante : nouvelle_valeur = valeur_originale × 70 / 100


*/
.data 

offset:
    .int 3

factor:
    .int 70

percent_conversion: 
    .int 100
        
.text 
.globl applyPhosphor                      

applyPhosphor:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO

    # epilogue
    leave 
    ret   

