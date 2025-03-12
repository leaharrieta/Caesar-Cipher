; File: main.asm
; Author: Leah Arrieta
; Description: This assembly program serves as the main entry point for a 
;              command-line utility that allows users to interact with messages.
;              It provides a menu-driven interface where users can display, 
;              read, encrypt, and decrypt messages using a Caesar cipher.
;
; Key Features:
;   - Displays a menu for user input.
;   - Stores up to 10 dynamically allocated messages.
;   - Allows message replacement with validation.
;   - Calls the Caesar cipher function for encryption.
;   - Calls frequency analysis function for decryption.
;   - Properly frees allocated memory before exiting.

section .data
    message: db "This is the original message." , 0
    message_count equ 10

section .bss
    pointers: resq 80 ; array of pointers to hold 10 messages
    choice: resb 1
    choice_len: resb 1

section .rodata
    menu_prompt: db "Encryption menu options:", 10
    menu_prompt_len equ $ - menu_prompt

    option_prompt: db "Enter option letter -> "
    option_prompt_len equ $ - option_prompt

    show_prompt: db "s - show current messages", 10
    show_prompt_len equ $ - show_prompt

    read_prompt: db "r - read a new message", 10
    read_prompt_len equ $ - read_prompt

    caesar_prompt: db "c - caesar cipher", 10
    caesar_prompt_len equ $ - caesar_prompt

    frequency_prompt: db "f - frequency decrypt", 10
    frequency_prompt_len equ $ - frequency_prompt

    quit_prompt: db "q - quit program", 10
    quit_prompt_len equ $ - quit_prompt

    error_message: db "Invalid message, keeping current", 10
    error_message_len equ $ - error_message

    replace_prompt: db "What string do you want to replace? ", 10
    replace_prompt_null db 0

    print_message: db "Message["
    print_message_len equ $ - print_message

    message_end: db "]: "

    goodbye_message: db "Goodbye!", 10

    newline db 10

    menu_items dq menu_prompt, show_prompt, read_prompt, caesar_prompt, frequency_prompt, quit_prompt
    menu_len dq menu_prompt_len, show_prompt_len, read_prompt_len, caesar_prompt_len, frequency_prompt_len, quit_prompt_len

section .text
    extern strcpy
    extern malloc
    extern readMessage
    extern displayMessages
    extern freeMemory
    extern frequencyDecrypt
    extern play_wordle
    extern caesar
    global _start

_start:
    push rbp
    mov rbp, rsp

    xor rbx, rbx
    mov r12, pointers 
    mov r13, 0                      ; used for state flipping
    ; allocate memory for each array index in message_ptr
    allocate_message_memory:
        cmp rbx, 10
        je display_menu

        mov rdi, 30
        call malloc

        mov rdx, rax                ; gets the dynamically allocated memory

        mov [r12 + rbx * 8], rdx    ; stores it at the index

        mov rdi, rdx
        mov rsi, message
        call strcpy                 ; copies the original message into the index

        inc rbx
        jmp allocate_message_memory 


    ; display the menu
    display_menu:
        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall
        
        ; loop to print all the menu options
        xor rbx, rbx
        .loop:
            cmp rbx, 6
            jge ask_input

            ; Display current menu item
            mov rax, 1             
            mov rdi, 1             
            mov rsi, [menu_items + rbx * 8] 
            mov rdx, [menu_len + rbx * 8] 
            syscall

            inc rbx
            jmp .loop

    ; asks for menu location
    ask_input:
        ; prints option 
        mov rax, 1
        mov rdi, 1
        mov rsi, option_prompt
        mov rdx, option_prompt_len 
        syscall 

        ; gets input
        mov rax, 0              
        mov rdi, 0              
        mov rsi, choice       
        mov rdx, 2       
        syscall 

        ; loads the option
        mov al, BYTE [choice]
        ; calls the corresponding menu option
        cmp al, 's'
        je show_command
        cmp al, 'r'
        je read_command
        cmp al, 'c'
        je caesar_command
        cmp al, 'f'
        je frequency_command
        cmp al, 'z'
        je z_function
        cmp al, 'q'
        je exit

        cmp al, 'S'
        je show_command
        cmp al, 'R'
        je read_command
        cmp al, 'C'
        je caesar_command
        cmp al, 'F'
        je frequency_command
        cmp al, 'Z'
        je z_function
        cmp al, 'Q'
        je exit

        ; Reprompt if invalid command entered
        jmp ask_input

    show_command:
        mov rdi, pointers
        call displayMessages
        jmp display_menu
    read_command:
        mov rdi, pointers
        call readMessage
        jmp display_menu
    caesar_command:
        mov rdi, pointers 
        call caesar
        jmp display_menu
    frequency_command:
        mov rdi, pointers
        call frequencyDecrypt
        jmp display_menu
    z_function:
        ;sub rsp, 8
        ;call play_wordle
        ;add rsp, 8
        ;jmp display_menu

    exit:
        mov rdi, pointers
        call freeMemory

        mov rax, 1      
        mov rdi, 1      
        mov rsi, goodbye_message
        mov rdx, 9
        syscall

        mov rax, 60
        xor edi, edi
        syscall
