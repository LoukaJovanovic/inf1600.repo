/*
    Vous pouvez modifier le liens des images. SVP mettre leur source si pris en ligne.

    Commandes:

	make : compile le projet en générant l’exécutable principal.
	make run : compile le projet (si nécessaire) puis exécute l’application.
	make test : lance la suite de tests prévue pour vérifier le bon fonctionnement des fonctions et filtres implémentés.
	make remise : crée un fichier zip contenant l’ensemble des fichiers nécessaires pour la remise du projet, prêt à être soumis.

*/

.data 

inputCrt: 
    .asciz "images/image.bmp"

outputCrt:
    .asciz "crt.png"

outputSierpinski:
    .asciz "sierpinski.png"


.text 
.globl main                      

main:
    # prologue
    pushl   %ebp
    movl    %esp, %ebp

    # 2 structures Image locales
    # imgCrt        : -12(%ebp)
    # imgSierpinski : -24(%ebp)
    subl    $24, %esp

    #################### Filtre CRT #######################

    # TODO: Charger l'image inputCrt en appelant loadImage()
    # loadImage(inputCrt, imgCrt)
    leal    -12(%ebp), %eax
    pushl   %eax
    pushl   $inputCrt
    call    loadImage
    addl    $8, %esp

    testl   %eax, %eax
    jz      end_main

    # TODO: Appliquer le filtre crtFilter() sur cette image
    # crtFilter(imgCrt, 2)
    pushl   $2
    leal    -12(%ebp), %eax
    pushl   %eax
    call    crtFilter
    addl    $8, %esp

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()
    # saveImage(outputCrt, imgCrt)
    leal    -12(%ebp), %eax
    pushl   %eax
    pushl   $outputCrt
    call    saveImage
    addl    $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    # freeImage(imgCrt)
    leal    -12(%ebp), %eax
    pushl   %eax
    call    freeImage
    addl    $4, %esp

    #################### Triangle de Sierpinski #######################

    # createImage(1024, 1024) -> imgSierpinski
    leal    -24(%ebp), %eax
    pushl   $1024
    pushl   $1024
    pushl   %eax
    call    createImage
    addl    $8, %esp

 
    pushl   $0xFF3BABE3
    leal    -24(%ebp), %eax
    pushl   %eax
    pushl   $1024
    pushl   $0
    pushl   $0
    call    sierpinskiImage
    addl    $20, %esp

    # saveImage(outputSierpinski, imgSierpinski)
    leal    -24(%ebp), %eax
    pushl   %eax
    pushl   $outputSierpinski
    call    saveImage
    addl    $8, %esp

    # freeImage(imgSierpinski)
    leal    -24(%ebp), %eax
    pushl   %eax
    call    freeImage
    addl    $4, %esp

end_main:
    movl    $0, %eax
    leave
    ret