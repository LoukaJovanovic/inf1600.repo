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

    pushl   %esi
    pushl   %ebx

    movl 8(%ebp), %esi      # adresse du pixel
    movl 12(%ebp), %ecx     # subpixel

############ TEST SUBPIXEL ############

    cmpl $0, %ecx
    je red_case

    cmpl $1, %ecx
    je green_case

    jmp blue_case

############ RED DOMINANT ############

red_case:

# G = G * 70 / 100
    movzbl 1(%esi), %eax
    imull factor, %eax
    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx
    movb %al, 1(%esi)

# B = B * 70 / 100
    movzbl 2(%esi), %eax
    imull factor, %eax
    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx
    movb %al, 2(%esi)

    jmp end_phosphor

############ GREEN DOMINANT ############

green_case:

# R = R * 70 / 100
    movzbl (%esi), %eax
    imull factor, %eax
    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx
    movb %al, (%esi)

# B = B * 70 / 100
    movzbl 2(%esi), %eax
    imull factor, %eax
    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx
    movb %al, 2(%esi)

    jmp end_phosphor

############ BLUE DOMINANT ############

blue_case:

# R = R * 70 / 100
    movzbl (%esi), %eax
    imull factor, %eax
    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx
    movb %al, (%esi)

# G = G * 70 / 100
    movzbl 1(%esi), %eax
    imull factor, %eax
    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx
    movb %al, 1(%esi)

############ FIN ############

end_phosphor:

    popl %ebx
    popl %esi

    leave
    ret