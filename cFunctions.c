 /* 
 File: cFunctions.c
 Author: Leah Arrieta
 Description: This file implements helper functions for message management, memory 
               allocation, and decryption.
  Key Features:
  - displayMessages(): Prints all stored messages.
  - readMessage(): Allows the user to replace a message with validation.
  - freeMemory(): Frees dynamically allocated memory before exiting.
  - frequencyDecrypt(): Decrypts a message using letter frequency analysis.
 
  - Ensures messages are formatted correctly before saving.
  - Provides a simple frequency-based approach to breaking Caesar ciphers.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define ALPHABET_SIZE 26
#define MAX_TEXT_LENGTH 1000

extern void readMessage(char **messages);
extern void displayMessages(char **messages);
extern void frequencyDecrypt(char **messages);
extern void freeMemory(char **messages);

void displayMessages(char** messages) {
  for (int i = 0; i < 10; i++) {
    printf("Message[%d]: ", i);
    printf("%s\n", messages[i]);
  }
}

void freeMemory(char** messages){
  for (int i = 0; i < 10; i++){
    free(messages[i]);
    messages[i] = NULL;
  }
  messages = NULL;
}

void readMessage(char** messages) {
  int index = -1;
  const int MAX = 1024;
  char newMessage[MAX];

  do{
    printf("What string do you want to replace? \n");
    index = getchar() - '0';
  }while (index < 0 || index >= 10);

  while(getchar() != '\n');
  printf("Enter new message: ");
    // gets input
  if (fgets(newMessage, MAX, stdin)) {
    int length = strlen(newMessage);
    if(length > 0 && newMessage[length - 1] == '\n'){
      newMessage[length - 1] = '\0'; // makes the last value be a \0 instead of \n
      length--;
    }
  
  // Validate the message
  if (!isupper(newMessage[0]) || (newMessage[length - 1] != '.' && newMessage[length - 1] != '?' && newMessage[length - 1] != '!')) {
    printf("Invalid message, keeping current\n");
    return;
  }else{
    free(messages[index]);  
    messages[index] = strdup(newMessage);
    }
  }
}


void frequencyDecrypt(char **messages) {
  //check if there is message to decrypt
  for(int i = 0; i < 10; i++){
    if(messages[i] == NULL){
      printf("No message available to decrypt.\n");  
    }
    return;
  }

  char text[MAX_TEXT_LENGTH];
  strncpy(text, messages[0], MAX_TEXT_LENGTH - 1);
  text[MAX_TEXT_LENGTH - 1] = '\0';

  int frequencies[ALPHABET_SIZE] = {0};
  int repeated_frequencies[5] = {0};
  char common_chars[5];

  int length = (int)strlen(text);

  // Convert to lowercase for frequency analysis
  for(int i = 0; i < length; i++){
    text[i] = (char)tolower((unsigned char)text[i]);
  }

  // Count the frequency of each lowercase letter in the text
  for(int i = 0; i < length; i++){
    char c = text[i];
    if(c >= 'a' && c <= 'z'){
      frequencies[c - 'a']++;
    }
  }

  // Find top 5 frequencies
  for(int i = 0; i < 5; i++){
    int frequency_limit = 0;
    int index_limit = 0;

    for(int j = 0; j < ALPHABET_SIZE; j++){
      if(frequencies[j] > frequency_limit){
        frequency_limit = frequencies[j];
        index_limit = j;
      }
    }

    if(frequency_limit == 0){
      printf("Zero significant frequencies were found.\n");
      return;
    }

    common_chars[i] = (char)('a' + index_limit);
    repeated_frequencies[i] = frequency_limit;
    frequencies[index_limit] = 0;
  }

  // Display possible decryptions
  for(int i = 0; i < 5; i++){
    int shift = ('e' - common_chars[i] + ALPHABET_SIZE) % ALPHABET_SIZE;

    // Decrypt the message using the shift
    for(int j = 0; j < length; j++){
      char m = messages[0][j];
      if(isalpha((unsigned char)m)){
        char base = islower((unsigned char)m) ? 'a' : 'A';
        m = (char)(base + ((m - base + shift) % ALPHABET_SIZE));
      }
      putchar(m);
    }

    if(i < 4){ 
      printf("\nOR\n");
    }
  }
  printf("\n");
}
