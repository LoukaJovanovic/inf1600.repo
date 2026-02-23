/*
Signature: void applyPhosphor(applyScanline& p, int percent);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
percent : facteur d’assombrissement

Description : Cette fonction applique un facteur d’assombrissement à un pixel en multipliant chacune de ses composantes RGB par un pourcentage donné: nouvelle_valeur = valeur_orignale x percent / 100
*/    
.data 

percent_conversion: 
.int 100

.text 
.globl applyScanline                      

applyScanline:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO
   
    # epilogue
    leave 
    ret   

