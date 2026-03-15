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

    subl    $4, %esp              # variable locale: y

    movl    $0, -4(%ebp)          # y = 0

y_loop:
    /* if (y >= img.hauteur) end */
    movl    8(%ebp), %eax         # &img
    movl    -4(%ebp), %ecx        # y
    cmpl    4(%eax), %ecx         # comparer y avec hauteur
    jge     end_crt

    movl    $0, %edi              # x = 0

x_loop: # if (x >= img.largeur) prochaine ligne
    movl    8(%ebp), %eax         # &img
    cmpl    0(%eax), %edi         # comparer x avec largeur
    jge     next_row

    # récupérer l'adresse du pixel img.pixels[y][x]
    movl    8(%eax), %ebx         # ebx = img.pixels (Pixel**)
    movl    -4(%ebp), %ecx        # ecx = y
    movl    (%ebx,%ecx,4), %esi   # esi = img.pixels[y] (Pixel*)
    leal    (%esi,%edi,4), %esi   # esi = &img.pixels[y][x]

    # si y % scanlineSpacing == 0 => applyScanline(pixel, 60)
    movl    -4(%ebp), %eax        # eax = y
    xorl    %edx, %edx
    movl    12(%ebp), %ecx        # ecx = scanlineSpacing
    divl    %ecx                  # reste dans edx
    cmpl    $0, %edx
    jne     skip_scanline

    pushl   less_color            # 60
    pushl   %esi                  # &pixel
    call    applyScanline
    addl    $8, %esp

skip_scanline:
    # applyPhosphor(pixel, x % 3)
    movl    %edi, %eax            # eax = x
    xorl    %edx, %edx
    movl    max_index, %ecx       # ecx = 3
    divl    %ecx                  # reste dans edx = x % 3

    pushl   %edx                  # subpixel
    pushl   %esi                  # &pixel
    call    applyPhosphor
    addl    $8, %esp

    incl    %edi                  # x++
    jmp     x_loop

next_row:
    incl    -4(%ebp)              # y++
    jmp     y_loop

end_crt:
    addl    $4, %esp              # enlever variable locale

    popl    %edi
    popl    %esi
    popl    %ebx
   
    # epilogue
    leave 
    ret 