; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp 

    ; incarcam adresa argumentului functiei
    mov esi, [ebp+8]
    xor edi, edi

start_loop:
    xor al, al
    ; curat registrii inainte sa incepem sa procesam sirul de caractere
    mov al, [esi]
    ; incarcam in registru caracterul curent    

    test al, al
    jz end_loop
    ; daca am ajuns la sfarsitul sirului de caractere, iesim din bucla          

    jmp compare_paranthesis
    ; daca nu , sarim la compararea caracterului curent cu parantezele

compare_paranthesis:
    ; comparam caracterul curent cu parantezele
    ; pentru a decide daca trebuie sa adaugam sau sa eliminam un caracter din stiva
    cmp al, '('
    je push_left_paren

    cmp al, '{'
    je push_left_curly

    cmp al, '['
    je push_left_square

    ; parantezele deschise sunt adaugate in stiva
    ; parantezele inchise sunt eliminate din stiva

    cmp al, ')'
    je pop_right_paren

    cmp al, '}'
    je pop_right_curly

    cmp al, ']'
    je pop_right_square

    jmp continue_loop

push_left_paren:
    mov eax, ebp
    ; consider offsetul 64, ales suficient de mare pentru a nu suprascrie alte date
    sub eax, 64
    add eax, edi
    ; adaugam edi la adresa ebp-64 pentru a scrie caracterul '('

    mov dl, '('
    ; incarcam in dl caracterul '('

    mov [eax], dl
    ; scriem caracterul '(' la adresa calculata

    inc edi
    ; trecem la urmatorul caracter
    jmp continue_loop

push_left_curly:
    mov eax, ebp
    ; iteram prin sirul de caractere
    sub eax, 64
    add eax, edi
    mov byte [eax], '{'
    ; adaugam caracterul '{' in stiva

    inc edi
    ; trecem la urmatorul caracter
    jmp continue_loop

push_left_square:
    mov eax, ebp
    ; trecem la adresa ebp-64
    sub eax, 64
    add eax, edi
    mov byte [eax], '['   
    ; adaugam caracterul '[' in stiva

    inc edi              
    jmp continue_loop   


pop_right_paren:
    dec edi          

    mov eax, ebp   
    ; aflu adresa ebp-64 pentru a verifica daca caracterul este '('     
    sub eax, 64           
    add eax, edi          
    cmp byte [eax], '('
    ; compar caracterul de la adresa calculata cu '('

    je continue_loop
    jmp mismatch

pop_right_curly:
    dec edi  
    ; decrementam edi pantru a elimina caracterul din stiva             
    mov eax, ebp  
    ; aflu adresa ebp-64 pentur a verifica daca caracterul este '{'        
    sub eax, 64           
    add eax, edi         
    cmp byte [eax], '{'
    ; compar caracterul de la adresa calculata cu '{'

    je continue_loop
    jmp mismatch

pop_right_square:

    dec edi
    ; decrementam edi       
    mov eax, ebp
    ; aflu adresa ebp-64 pentru a verifica daca caracterul este '['  
    sub eax, 64          
    add eax, edi  
    ; compar caracterul de la adresa calculata cu '['       
    cmp byte [eax], '['
    je continue_loop
    ; daca sunt egale, continuam bucla
    jmp mismatch
    ; daca nu, iesim din bucla

continue_loop:
    inc esi
    ; trecem la urmatorul caracter
    jmp start_loop

end_loop:
    test edi, edi
    ; verificam daca stiva este goala
    jz match 
    ; daca stiva este goala, parantezele sunt inchise corect       

mismatch:
    ; return 1 pentru parantezele neinchise corect
    mov eax, 1
    ; daca stiva nu este goala, inseamna ca parantezele nu sunt inchise corect
    jmp end

match:
    xor eax, eax
    ; return 0 pentru parantezele inchise corect

end:

    leave
    ret
