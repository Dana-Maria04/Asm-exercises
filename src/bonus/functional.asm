; Interpret as 64 bits code
[bits 64]

; nu uitati sa scrieti in feedback ca voiati
; assembly pe 64 de biti

section .text
global map
global reduce
map: 
    ; look at these fancy registers
    ; initializare
    push rbp
    mov rbp, rsp

    ; verificare daca n este 0, pentru a iesi din executie
    test rdx, rdx
    jle end_map_loop

    push rdi
    ; salvam pe stiva valorile pe care le vom folosi
    push r8
    ; salvam r8 pe stiva pentru a-l restabili la sfarsit
    mov r9, rdi
    xor rbx, rbx
    ; fac xor cu rbx pentru a-l initializa cu 0

map_loop:
    mov r8, rbx
    ; r8 = rbx * 8
    ; shiftez la stanga cu 3 pentru a inmulti cu 8
    shl r8, 3

    ; calculam adresa elementului
    ; rsi + rbx * 8
    add r8, rsi
    ; încarcam valoarea de la adresa calculată în rdi
    mov rdi, [r8]

   ; apelam functia de map
    call rcx

    ; salvam valoarea returnata de functie in rax
    mov r8, rbx
    ; realizez operatia r8 = rbx * 8
    shl r8, 3
    ; r8 = adresa de stocare = r9 + rbx * 8
    add r8, r9
    mov [r8], rax
    ; incrementam rbx pentru a trece la urmatorul element
    add rbx, 1

    ; comparam rbx cu rdx pentru a iesi din bucla
    cmp rdx, rbx
    jne map_loop

end_map_loop:
    ; cleanup
    leave
    ret


; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    ; look at these fancy registers
    ; initializare
    push rbp
    mov rbp, rsp

    ; verificare daca n este 0, pentru a iesi din executie
    test rdx, rdx
    jle end_reduce_loop

    ; salvam pe stiva valorile pe care le vom folosi
    push r14
    push r13
    push r12
    push rbp
    push rbx
    ; salvam r12 pe stiva pentru a-l restabili la sfarsit
    ; dst
    mov r12, rdi
    ; acc_init
    mov rdi, rcx
    ; src
    mov r14, rsi
    ; n
    mov rbp, rdx 
    ; functia f   
    mov r13, r8

    xor rbx, rbx
reduce_loop:
    ; salvez r15 pe stiva
    push r15

    ; calculez adresa elementului curent
    mov r15, rbx
    ; rax = rbx * 8
    imul r15, 8
    lea rax, [r15]

    ;rax = r14 + rbx * 8
    ; adaug r14 la rax pentru a obtine adresa elementului curent
    add rax, r14
    ; incarc valoarea de la adresa calculata in rsi
    mov rsi, [rax]
    ; incrementez pentru a trece la urmatorul element
    inc rbx

    ; restauram r15 de pe stiva
    pop r15

    ; apelam functia f
    call r13

    mov rdi, rax
    ; verificam daca am ajuns la finalul vectorului
    cmp rbp, rbx
    ; daca nu am ajuns la final, continuam
    jne reduce_loop

end_reduce_loop:
    ; salvez rdi pe stiva
    push rdi
    ; salvez rezultatul final in dst
    pop rax
    push rax
    ; dau pop qword deoarece r12 este de tip qword (unsigned int pe 64-bit)
    pop qword [r12]

    ; cleanup
    ; restauram registrele de pe stiva
    pop rbx
    pop rbp
    pop r12
    pop r13
    pop r14

    leave
    ret
