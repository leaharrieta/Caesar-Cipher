1) Project Overview
- Contact:
    Author: Leah Arrieta
    E-mail: leaha3@umbc.edu

- Introduction:
    This project is a command-line utility that allows users to input and encryt messages
    using various cryptographic techniques. The program is implemented in NASM x86-64 Assembly and C, 
    while using dynamically allocated memory to store messages.
    
    Key functionality:
    - Displaying stored messages: View currently saved messages.
    - Reading a new message: Replace an existing message with a new one (must start with an 
    uppercase letter and end with a punctuation mark).
    - Caesar Cipher Encryption: Encrypts a message by shifting its characters by a user-specified 
    amount (-25 to 25).
    - Frequency Decryption: Attempts to decrypt a message by analyzing letter frequencies.
    - Exiting the program: Properly frees allocated memory before quitting.

2) Installation and Setup
- Setup
    To develop the environment the Standard C Library, NASM, and a GCC compiler is needed as the code in in C. 
    This project was made and tested on Linux, so it is reccomended for it to be run on Linux. In addition, 
    there are no environmental variables required. 

- Build and Compile
    Compiling the project uses the Makefile.
    1. Open the directory will the files: main.asm, caesar.asm, cFunctions.c 
    2. Run "make"
    3. Run "make run"
    Also, to run valgrind, use "make val". To remove compiled files and executables use "make val". 

- Functions
    You can type /proc/cpuinfo to get the cpu information,
    /proc/loadavg for the number of currently running processes
    /proc/process_id_no/status to get various information (detailed in the documentation)
    /proc/process_id_no/environ to list the environment variables
    /proc/process_id_no/sched to isplay performance information
    history to view the last 10 input commands

3) Testing Strategies
- Test Cases
    1. q command - Exit:
        Purpose: Terminate the program and free memory when q is entered.
        Expected output: 'Goodbye!' is displayed, no errors or memory leaks.

    2. s command - Message Display:
        Purpose: Verify that stored messages are correctly displayed.
        Expected output: Each stored message appears with its index and no seg faults.
    
    3. r command - Replacement:
        Purpose: Make sure the user can replace a message if  validation rules are followed.
        Expected output: If message is invalid, display 'Invalid message, keeping current'. If 
        valid, replace the old message with the new.

    4. c command - Caesar Cipher:
        Purpose: Ensure that the program correctly shifts a message by a user-provided integer (-25 to 25).
        Expected output: The user is prompted to enter a shift value and a message. The shifted message 
        appears correctly with proper letter wrapping. Also, non-alphabetic characters are unchanged.

4) Trouble Shooting
- Common issues and Solutions
    1. "Error: ./project_4: No such file or directory"
        Cause: The program incorrectly compiled.
        Solution: Run "make" to compile the program.
    
    2. "Invalid message, keeping current" when replacing a message
        Cause: The entered message does not meet validation rules.
        Solution: Make sure the message starts with an uppercase letter and ends with 
        a period (.), question mark (?), or exclamation point (!).