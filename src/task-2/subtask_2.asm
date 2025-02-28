;  subtask 2 - bsearch

section .text
    global binary_search
    ;; no extern functions allowed

binary_search:
    ; initializare stack frame
    enter 0, 0
    ; salvez registrii
    push esi
    push edi
    push ebx

    ; pregatim registrii
    xor esi, esi
    xor edi, edi
    ; incarc argumentele
    ; start index
    mov esi, [esp + 20]
    ; end index
    mov edi, [esp + 24]

    ; daca start > end, elementul nu exista
    cmp esi, edi
    jg not_found

    ; calculam elementul de pe indexul din mijloc
    xor ebx , ebx

    push esi
    add ebx, esi

    push edi
    ; ebx = (start + end) / 2
    add ebx, edi

    ; shiftez cu 1 la dreapta pentru a realiza impartirea la 2
    shr ebx, 1


    pop edi 
    pop esi

    ; Compare array[mid] with pivot
    xor eax, eax
    mov eax, ebx
    ; shiftez cu 2 la stanga pentru a realiza inmultirea cu 4
    shl eax, 2
    cmp edx, [ecx + eax]
    ; daca array[mid] == pivot, elementul este gasit
    jz found          

    ; daca pivot > array[mid]
    jg search_right
    ; daca pivot < array[mid]
    jl search_left

search_left:
    mov edi, ebx
    ; decrementez mid
    sub edi, 1

    push dword edi
    ; push mid - 1
    push dword esi
    ; push start 

    ; apelez recursiv binary_search
    call binary_search

    ; curat stiva
    add esp, 8       
    jmp end

search_right:
    mov esi, ebx
    ; incrementez mid
    add esi, 1

    push dword edi 
    ; push end
    push dword esi
    ; push mid + 1

    ; apel recursiv a functiei
    call binary_search

    ;curatarea stivei
    add esp, 8
    jmp end

found:
    ; return indexul elementului gasit
    mov eax, ebx
    jmp end

not_found:
    ; return -1 , elementul nu a fost gasit
    mov eax, -1 

end:
    ; restaurez registrii si stiva
    pop ebx
    pop edi
    pop esi
    leave
    ret