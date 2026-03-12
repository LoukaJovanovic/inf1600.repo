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

    pushl   %esi
    pushl   %ebx

    movl 8(%ebp), %esi      # adresse pixel
    movl 12(%ebp), %ecx     # percent

############ R ############

    movzbl (%esi), %eax # ressort une erreur de segmentation----------------
    imull %ecx, %eax

    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx

    movb %al, (%esi)

############ G ############

    movzbl 1(%esi), %eax
    imull %ecx, %eax

    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx

    movb %al, 1(%esi)

############ B ############

    movzbl 2(%esi), %eax
    imull %ecx, %eax

    movl percent_conversion, %ebx
    xorl %edx, %edx
    divl %ebx

    movb %al, 2(%esi)

############ RESTORE REGISTERS ############

    popl %ebx
    popl %esi

    leave 
    ret