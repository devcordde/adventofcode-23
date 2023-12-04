#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <math.h>

#define file "./04input.txt" 
#define testfile "./04test.txt"
#define LINE_SIZE 128
//#define LINES 206
#define LINES 6

typedef struct cards {
	int winNumbersCount;
	int myNumbersCount;
	int wNumbers[10];
	int myNumbers[30];
	int copies;
} Cards;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(testfile, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

int findCardValue(Cards card[LINES], int cardNr) {
	int matches = 0;
	for (int i = 0; i < card[cardNr].myNumbersCount; i++) {
		for(int j = 0; j < card[cardNr].winNumbersCount; j++) {
			if (card[cardNr].myNumbers[i] == card[cardNr].wNumbers[j]) {
				matches++;
			}
		}
	}
	
	for(int i = 1; i <= matches; i++) {
		card[cardNr + i].copies += card[cardNr].copies;
	}

	return pow(2,matches - 1);
}

void fillNumbers(char input[LINE_SIZE], int sw, Cards card[LINES], int cardNr) {
	char *token, *rest = input;
	int count = 0;
	while ((token = strtok_r(rest, " ", &rest))) {
		if(sw == 0) {
			card[cardNr].wNumbers[count++] = atoi(token);
		} else {
			card[cardNr].myNumbers[count++] = atoi(token);
		}
	}

	if(sw ==0) { card[cardNr].winNumbersCount = count; } 
	else { card[cardNr].myNumbersCount = count; }
}

void parseInput(char input[][LINE_SIZE], Cards card[LINES], int lineCount) {
	for (int i = 0; i < LINES; i++) {
		card[i].copies = 1;
		char *token, *rest;
		token = strtok_r(input[i], ":", &rest);
		token = strtok_r(rest, "|", &rest);
		fillNumbers(token, 0, card, i);
		fillNumbers(rest, 1, card, i);
	}
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	Cards card[LINES];
	parseInput(input, card, lineCount);
	int value = 0, cards = 0;
	for(int i = 0; i < LINES; i++) {
		value += findCardValue(card, i);
		cards += card[i].copies;
	}
	

	printf("\n%d\n", value);
	printf("%d\n", cards);
	return 0;
}
