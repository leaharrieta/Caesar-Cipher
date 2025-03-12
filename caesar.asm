; File: caesar.asm
; Author: Leah Arrieta
; Description: This file implements a Caesar cipher encryption function in assembly.
;               This file:
;              - Takes user input for a shift value (-25 to 25).
;              - Validates input to ensure it falls within the required range.
;              - Reads a user-entered string (> 8 characters) for encryption.
;              - Shifts letters in the string based on the user-specified value.
;              - Displays the original and shifted message.
;
; Key Features:
;   - Handles both uppercase and lowercase letters.
;   - Ensures correct wrap-around behavior for alphabetic characters.
;   - Validates user input to prevent errors.

section .data

section .bss
    shift_buff:     resb 100
    string_buff:    resb 100
    output_buff:    resb 100

section .rodata
    request1:       db "Enter a shift value between -25 and 25 (inclusive): ", 0
    request1_len:   equ $ - request1
    request2:       db "Enter a string longer than 8 characters: ", 0
    request2_len:   equ $ - request2
    current:        db "Current message: ", 0
    current_len:    equ $ - current
    edited:         db "Edited message: ", 0
    edited_len:     equ $ - edited

section .text
global caesar

caesar:
    ; Prompt for shift value
shift_input:
    mov rax, 1
    mov rdi, 1
    mov rsi, request1
    mov rdx, request1_len
    syscall

    ; Read shift value
    mov rax, 0
    mov rdi, 0
    mov rsi, shift_buff
    mov rdx, 10
    syscall

    ; Validate shift value
    xor r9, r9      ; r9 will hold the shift value
    mov rsi, shift_buff

    ; Check for negative sign
    mov al, [rsi]   ; lower 8 bits of shift_buff
    cmp al, '-'
    jne validate_positive
    inc rsi         ; if equal, increment shift_buff
    mov r10, -1     ; mark as negative
    jmp validate_loop

validate_positive:
    mov r10, 1      ; mark as positive

validate_loop:
    mov al, [rsi]
    cmp al, 10      ; check for newline
    je check_range
    cmp al, '0'     ; check if value is 0-9
    jb invalid_shift
    cmp al, '9'
    ja invalid_shift
    sub al, '0'     ; convert from ASCII to integer
    imul r9, r9, 10
    add r9, rax     ; add digits to get the full integer
    inc rsi
    jmp validate_loop

check_range:
    ; Adjust for negative sign
    imul r9, r10
    cmp r9, 25      ; check if -25 <= num <= 25
    jg invalid_shift
    cmp r9, -25
    jl invalid_shift
    jmp string_input

invalid_shift:
    ; Display error message and prompt again
    jmp shift_input

string_input:
    ; Prompt for string input
    mov rax, 1
    mov rdi, 1
    mov rsi, request2
    mov rdx, request2_len
    syscall

    ; Read string input
    mov rax, 0
    mov rdi, 0
    mov rsi, string_buff
    mov rdx, 100
    syscall

    ; Check string length
    mov rsi, string_buff
    mov rcx, 0              ; increment set to 0

check_length:
    cmp byte [rsi + rcx], 0 ; compares 1 byte of string_buff at a time until it reaches null
    je validate_length
    inc rcx                 ; if not equal, increment rcx
    jmp check_length

validate_length:
    cmp rcx, 8
    jle invalid_length

    ; Display current message
    mov rax, 1
    mov rdi, 1
    mov rsi, current
    mov rdx, current_len
    syscall

    ; Display entered string
    mov rax, 1
    mov rdi, 1
    mov rsi, string_buff
    mov rdx, rcx
    syscall

    ; Process string for shifting
    mov rsi, string_buff
    mov rdi, output_buff
    mov rdx, r9             ; rdx holds the shift value

shift_loop:
    mov al, [rsi]           ; lower 8 bits of string_buff
    cmp al, 0               ; checks for null
    je display_result

    ; Check if character is uppercase
    cmp al, 'A'
    jb check_lowercase
    cmp al, 'Z'
    ja check_lowercase
    ; Shift uppercase letters
    sub al, 'A'
    add al, dl
    ; Wrap around if needed
    cmp al, 25 
    jg wrap_forward_upper
    cmp al, 0
    jl wrap_backward_upper
    jmp store_char_upper

; Wraps uppercase letters from Z-A
wrap_forward_upper:
    sub al, 26
    jmp store_char_upper

; Wraps uppercase letters from A-Z
wrap_backward_upper:
    add al, 26
    jmp store_char_upper    

; Stores uppercase letter
store_char_upper:
    add al, 'A'
    jmp store_char

check_lowercase:
    cmp al, 'a'
    jb store_char
    cmp al, 'z'
    ja store_char
    ; Shift lowercase letters
    sub al, 'a'
    add al, dl
    ; Wrap around if needed
    cmp al, 25 
    jg wrap_forward_lower
    cmp al, 0
    jl wrap_backward_lower
    jmp store_char_lower

; Wraps lowercase letters z-a
wrap_forward_lower:
    sub al, 26
    jmp store_char_lower

; Wraps lowercase letters a-z
wrap_backward_lower:
    add al, 26
    jmp store_char_lower

; Stores lowercase letters
store_char_lower:
    add al, 'a'
    jmp store_char

; Stores lower/upper characters
store_char:
    mov [rdi], al
    inc rdi
    inc rsi
    jmp shift_loop

invalid_length:
    ; Display error message for invalid string length
    jmp string_input

display_result:
    ; Null-terminate the output string
    mov byte [rdi], 0
    ; Store the length of the edited string in rcx
    sub rdi, output_buff       ; rdi now contains the length of the edited string
    mov rcx, rdi               ; store the length of the edited string in rcx

    ; Display edited message
    mov rax, 1
    mov rdi, 1
    mov rsi, edited
    mov rdx, edited_len
    syscall

    ; Display edited string
    mov rax, 1
    mov rdi, 1
    mov rsi, output_buff
    mov rdx, rcx               ; pass the correct length (stored in rcx)
    syscall

    ; Exit program
    mov rax, 60
    xor rdi, rdi
    ret
