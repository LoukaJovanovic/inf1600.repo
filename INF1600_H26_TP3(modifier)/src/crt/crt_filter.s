/*
Signature : void crtFilter(Image& img, int scanlineSpacing)

Paramètres :
img : la référence vers l’image à modifier (sur place)
scanlineSpacing : espacement entre les lignes que l’on va dessiner sur l’image pour l’effet CRT


Description : Cette fonction applique un filtre global à une image afin de reproduire l’apparence d’un ancien écran CRT. Elle combine les deux fonctions précédentes.
Il faut parcourir TOUS les pixels et appliquer les traitements suivants:
1.	Appeler applyScanline() 
    	Si la ligne y est un multiple de scanlineSpacing on applique un assombrissement de 60 %.

2.	Appler applyPhosphor()
        Le paramètre subpixel est déterminé par la position horizontale du pixel : x % 3

*/
.data   

full_color:
    .int 100

less_color:
    .int 60

max_index:
    .int 3

.text 
.globl crtFilter                      

crtFilter:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp

    pushl   %ebx
    pushl   %esi
    pushl   %edi

    # récupérer Image*
    movl    8(%ebp), %eax
    movl    0(%eax), %ebx      # largeur
    movl    4(%eax), %edx      # hauteur
    movl    8(%eax), %esi      # pixels (Pixel**)

    xorl    %ecx, %ecx         # y = 0

y_loop:
    cmpl    %edx, %ecx
    jge     end_filter

    xorl    %eax, %eax         # x = 0

x_loop:
    cmpl    %ebx, %eax
    jge     next_row

    # adresse du pixel : pixels[y][x]
    movl    (%esi,%ecx,4), %edi
    lea     (%edi,%eax,4), %edi

    # sauvegarder x pour plus tard
    pushl   %eax

############ SCANLINE ############

    movl    %ecx, %eax
    xorl    %edx, %edx
    movl    12(%ebp), %ecx     # scanlineSpacing
    divl    %ecx

    cmpl    $0, %edx
    jne     skip_scan

    pushl   $60
    pushl   %edi
    call    applyScanline
    addl    $8, %esp

skip_scan:

############ PHOSPHOR ############

    popl    %eax               # restaurer x

    xorl    %edx, %edx
    movl    $3, %ecx
    divl    %ecx               # edx = x % 3

    pushl   %edx
    pushl   %edi
    call    applyPhosphor
    addl    $8, %esp

############ NEXT PIXEL ###########

    incl    %eax
    jmp     x_loop

next_row:
    incl    %ecx
    jmp     y_loop

end_filter:
    popl    %edi
    popl    %esi
    popl    %ebx

    leave
    ret