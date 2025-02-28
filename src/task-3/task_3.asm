%include "../include/io.mac"

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc

section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
; 
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).
dfs:
    push ebp
    mov ebp, esp

    ; scad 12 pentru a face loc pentru variabile locale
    sub esp, 12

    ; salvez ebx
    push ebx

    ; nodeul
    mov edi, [ebp + 8]
    ; expand function
    mov esi, [ebp + 12]

    mov eax, edi
    ; inmultim nodul cu 4 pentru a obtine indexul in vectorul visited
    shl eax, 2
    mov ebx, visited
    ; adaugam indexul la adresa efectiva
    add ebx, eax

mark_visited:
    ; compar valoarea de la adresa efectiva cu 1
    cmp dword [ebx], 1
    ; daca este 1, inseamna ca nodul a fost vizitat deja
    je already_visited

    ; daca nu, il vizitam
    ; marchez nodul ca vizitat
    mov dword [ebx], 1
    jmp print_node

print_node:
    ; afisez nodul
    push edi
    push fmt_str
    ; apelez printf
    call printf

    ;curat stiva
    add esp, 8
    jmp get_neighbours

get_neighbours:
    push edi
    ; apelez functia expand
    call esi
    ; adaug la ebp 4 pentru a iterat prin structura
    add esp, 4

    ; salvez rezultatul functiei expand
    mov ebx, eax
    mov ecx, [ebx]  
    ; adaug 4 pentru a ajunge la vectorul de vecini
    mov edx, [ebx + 4]   

    ; initializez contorul pentru bucla
    mov dword [ebp - 4], 0

dfs_loop:
    ; scad 4 pentru a ajunge la adresa efectiva a vecinului
    mov eax, [ebp - 4]
    ; compar contorul cu numarul de vecini
    cmp eax, ecx
    ; daca sunt egale, am terminat dfs-ul
    jge already_visited

    ; daca nu sunt egale, continui
    ; obtin vecinul
    mov edi, [edx + eax * 4]

    ; pregatesc apelarea recursiva
    push ecx
    push edx
    push eax

    push esi
    push edi

    ; apelez dfs recursiv
    call dfs

    ; curat stiva
    add esp, 8

    ; pregatesc pentru urmatorul vecin
    pop eax
    pop edx
    pop ecx

    ; incrementez contorul pentru a trece la urmatorul vecin
    inc dword [ebp - 4]
    ; reiau procesul pentru urmatorul vecin
    jmp dfs_loop

already_visited:
    ; restabilesc ebx
    pop ebx
    leave
    ret
