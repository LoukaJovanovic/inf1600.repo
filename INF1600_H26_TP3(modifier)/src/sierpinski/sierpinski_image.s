/*
Implementation en C:
void sierpinskiImage(uint32_t x, uint32_t y, uint32_t size, Image& img, Pixel color) {
    // vérifier les bornes
    if (x >= img.largeur || y >= img.hauteur) return;

    // Cas de base: dessiner un seul pixel
    if (size == 1) {
        img.pixels[y][x] = color;
        return;
    }

    uint32_t half = size / 2;

    // Triangle en bas à gauche
    sierpinskiImage(x, y + half, half, img, color);
    // Triangle en bas à droite
    sierpinskiImage(x + half, y + half, half, img, color);
    // Triangle du haut
    sierpinskiImage(x + half / 2, y, half, img, color);
}

L’algorithme fonctionne mieux avec des tailles puissances de 2.
L’appel de la fonction dans le main sera ainsi : sierpinskiImage(0, 0, 1024, img, color);
*/

.data 

.text 
.globl sierpinskiImage                      

sierpinskiImage:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp

    pushl   %ebx
    pushl   %esi
    pushl   %edi

    # Paramètres :
    # 8(%ebp)  = x
    # 12(%ebp) = y
    # 16(%ebp) = size
    # 20(%ebp) = &img
    # 24(%ebp) = color (Pixel sur 4 octets)

    ############################
    # Vérifier les bornes
    ############################

    movl    20(%ebp), %eax         # eax = &img

    movl    8(%ebp), %ecx          # ecx = x
    cmpl    0(%eax), %ecx          
    jge     end_sierpinski

    movl    12(%ebp), %ecx         # ecx = y
    cmpl    4(%eax), %ecx          
    jge     end_sierpinski

    ############################
    # Cas de base : size == 1
    ############################

    cmpl    $1, 16(%ebp)
    jne     recursive_case

    # img.pixels[y][x] = color
    movl    8(%eax), %ebx          
    movl    12(%ebp), %ecx         
    movl    (%ebx,%ecx,4), %esi    
    movl    8(%ebp), %edx         
    leal    (%esi,%edx,4), %edi    

    movl    24(%ebp), %ecx        
    movl    %ecx, (%edi)           

    jmp     end_sierpinski

recursive_case:
    ############################
    # half = size / 2
    ############################
    movl    16(%ebp), %ebx
    shrl    $1, %ebx            

    ############################
    # 1) bas gauche
    # sierpinskiImage(x, y + half, half, img, color)
    ############################
    pushl   24(%ebp)             
    pushl   20(%ebp)             

    pushl   %ebx                   

    movl    12(%ebp), %eax        
    addl    %ebx, %eax             
    pushl   %eax

    pushl   8(%ebp)                
    call    sierpinskiImage
    addl    $20, %esp

    ############################
    # 2) bas droite
    # sierpinskiImage(x + half, y + half, half, img, color)
    ############################
    pushl   24(%ebp)               
    pushl   20(%ebp)               

    pushl   %ebx                   

    movl    12(%ebp), %eax       
    addl    %ebx, %eax             
    pushl   %eax

    movl    8(%ebp), %eax         
    addl    %ebx, %eax           
    pushl   %eax

    call    sierpinskiImage
    addl    $20, %esp

    ############################
    # 3) haut
    # sierpinskiImage(x + half/2, y, half, img, color)
    ############################
    pushl   24(%ebp)      
    pushl   20(%ebp)               

    pushl   %ebx                   

    pushl   12(%ebp)             

    movl    %ebx, %eax          
    shrl    $1, %eax              
    addl    8(%ebp), %eax          
    pushl   %eax

    call    sierpinskiImage
    addl    $20, %esp

end_sierpinski:
    popl    %edi
    popl    %esi
    popl    %ebx

    # epilogue
    leave 
    ret
