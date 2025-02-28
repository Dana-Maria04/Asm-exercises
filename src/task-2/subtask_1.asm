; subtask 1 - qsort

section .data
; indexul i declarat global pentru sortare
    i dd 0
; indexul j declarat global pentru sortare
    j dd 0

section .text
    global quick_sort
    ;; no extern functions allowed

quick_sort:
    ;  initializare stack frame
    enter 0, 0

    push edi
    push esi
    push ebx

    ; start index
    mov eax, dword [ebp + 12]  
    ; end index
    mov ebx, dword [ebp + 16]  
    ; elems
    mov esi, dword [ebp + 8]   

    ; daca start index >= end index atunci return
    cmp eax, ebx
    jnl qsort_done

    ; initializez i si j pentru a incepe partitionarea
    mov dword [i], eax         
    mov dword [j], eax        

    ; stocam adresa elementului pivot
    lea edi, [esi + (4 * ebx)] 
    mov edx, dword [edi]       

qsort_part_loop:
    ; j < end index
    mov ecx, dword [j]
    cmp ecx, ebx               
    jnb qsort_end_part

    ; offsetul este 4 deoarece avem de a face cu tipul int
    lea edi, [esi + (4 * ecx)]
    cmp edx, dword [edi]  
    ; elems[j] < pivot     
    jb qsort_cont_loop

    push edx        

    mov edx, dword [edi]       
    mov eax, dword [i]
    ; iteram prin toate elementele mai mici decat pivotul
    lea edi, [esi + (4 * eax)] 

    ; edi = elems[i]
    mov edi, dword [edi]     
    ; calculez adresa elem i
    mov dword [esi + (4 * eax)], edx
    ; offsetul 4 este pentru a trece la urmatorul element
    mov dword [esi + (4 * ecx)], edi

    ; restaurez pivotul
    pop edx                   

    mov eax, dword [i]
    ; incrementez i
    add eax, 1
    mov dword [i], eax        

qsort_cont_loop:

    mov ecx, dword [j]
    ; incrementez j
    add ecx, 1
    mov dword [j], ecx
    ; sarim la inceputul buclei      
    jmp qsort_part_loop

qsort_end_part:
    ; interschimbam pivotul cu elementul de pe pozitia i
    mov eax, dword [i]

    ; calculez adresa elem i
    lea edi, [esi + (4 * eax)] 
    mov edx, dword [edi]      

    ; calculez adresa elem end index
    lea edi, [esi + (4 * ebx)] 
    mov edi, dword [edi]      

    ; calculez adresa elem j
    mov dword [esi + (4 * ebx)], edx 
    ; calculez adresa elem i
    mov dword [esi + (4 * eax)], edi 

    mov eax, dword [i]
    ; decrementez i
    sub eax, 1
    mov dword [i], eax 

    push eax
    ; dau push penrtu a apela recursiv quick_sort la partea stanga
    push dword [ebp + 12]  
    ; push pentru a apela recursiv quick_sort     
    push dword [ebp + 8]  
    ; apelez quick_sort recursiv    
    call quick_sort

    ; curat stiva
    add esp, 8
    pop eax

    ; incrementez i
    add eax, 1
    mov dword [i], eax 
    ; dau push pentru a apela recursiv quick_sort la partea dreapta        
    push dword [ebp + 16]     
    push eax
    ; dau push pentru a apela recursiv quick_sort
    push dword [ebp + 8]  
    ; apelez quick_sort recursiv    
    call quick_sort
    ; ajustez stiva
    add esp, 12

qsort_done:
    ; cleanup
    pop ebx
    pop esi
    pop edi

    leave
    ret