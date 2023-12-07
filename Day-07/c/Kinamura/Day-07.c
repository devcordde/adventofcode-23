#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define file "./07input.txt" 
#define LINE_SIZE 12
#define LINES 1000

typedef struct game {
	char cards[5];
	int bid, class, rank;
} Game;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseinput(char input[][LINE_SIZE], Game games[LINES]) {
	for (int i = 0; i < LINES; i++) {
		char *rest;
		strcpy(games[i].cards, strtok_r(input[i], " ", &rest));
		games[i].bid = atoi(rest);
	}
}

int getCharPosition(char c, int part) {
	char *str1 = " 23456789TJQKA", *str2 = " J23456789TQKA";
	int i = 0;
	if (part == 1) { while (c != str1[i]) { ++i; }}
	if (part == 2) { while (c != str2[i]) { ++i; }}
	return i - 1;
}

void getHandClass(Game games[LINES], int part) {
	for (int gameNr = 0; gameNr < LINES; gameNr++) {
		int sizes[2] = {0,0}, jokerCount = 0, count = 0, pos = 0;
		char matchedChar = '-';
		for (int i = 0; i < 5; i++) {
			if (games[gameNr].cards[i] == 'J') { jokerCount++; }
			for (int j = i + 1; j < 5; j++) {
				if (i < 5 && (games[gameNr].cards[i] != 'J' || part == 1) && games[gameNr].cards[i] == games[gameNr].cards[j] && games[gameNr].cards[i] != matchedChar) {
				count++;
				}	
			}
			if (count > 0) {
				sizes[pos++] = count;
				count = 0;
				matchedChar = games[gameNr].cards[i];
			}
		}

		if (part == 1) { jokerCount = 0; }
		if (sizes[0] == 4) { games[gameNr].class = 6; }
		if (sizes[0] == 3) { games[gameNr].class = 5 + jokerCount; }
		if (sizes[0] == 2 && sizes[1] == 1) { games[gameNr].class = 4; }
		if (sizes[0] == 2 && sizes[1] == 0) { games[gameNr].class = 3 + ceil(1.5 * jokerCount); }
		if (sizes[0] == 1 && sizes[1] == 2) { games[gameNr].class = 4; }
		if (sizes[0] == 1 && sizes[1] == 1) { games[gameNr].class = 2; }
		if (sizes[0] == 1 && sizes[1] == 0) { games[gameNr].class = 1; }
		if (sizes[0] == 0) { games[gameNr].class = 0; }
		if (part == 2) {
			if(games[gameNr].class == 2 && jokerCount == 1) { games[gameNr].class = 4; }
			if(games[gameNr].class == 1 && jokerCount == 1) { games[gameNr].class = 3; }
			if(games[gameNr].class == 1 && jokerCount == 2) { games[gameNr].class = 5; }
			if(games[gameNr].class == 1 && jokerCount == 3) { games[gameNr].class = 6; }
			if(games[gameNr].class == 0 && jokerCount == 1) { games[gameNr].class = 1; }
			if(games[gameNr].class == 0 && jokerCount == 2) { games[gameNr].class = 3; }
			if(games[gameNr].class == 0 && jokerCount == 3) { games[gameNr].class = 5; }
			if(games[gameNr].class == 0 && jokerCount >= 4) { games[gameNr].class = 6; }
		}
		jokerCount = 0;
	}
	puts(""); //lazy buffer-flush
}

void radixSort(Game games[LINES], int part) {
	int counts[13] = {0,0,0,0,0,0,0,0,0,0,0,0,0};
	Game gameS1[13][LINES];
	int count;
	for(int digits = 0; digits < 5; digits++) {
		for (int i = 0; i < LINES; i++) {
			int pos = getCharPosition(games[i].cards[4 - digits], part);
			gameS1[pos][counts[pos]] = games[i];
			counts[pos]++;
		}
		count = 0;
		for (int i = 0; i < 13; i++) {
			for (int j = 0; j < counts[i]; j++) {
				games[count++] = gameS1[i][j];
			}
		}
		for (int i = 0; i < 13; i++) { counts[i] = 0; }
	}
}

void sortGames(Game games[LINES]) {
	Game gamesSorting[7][LINES];
	int counts[7] = {0,0,0,0,0,0,0};
	for (int i = 0; i < LINES; i++) {
		int pos = games[i].class;
		gamesSorting[pos][counts[pos]] = games[i];
		counts[pos]++;
	}
	int count = 0;
	for (int i = 0; i < 7; i++) {
		for (int j = 0; j < counts[i]; j++) {
			games[count++] = gamesSorting[i][j];		
		}
	}
	int total = 0; 
	count = 0;
	for(int i = 0; i < LINES; i++) {
		total += games[i].bid * (i + 1);
	}
	printf("%d", total);
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	Game games[LINES];
	readInput(input);
	parseinput(input, games);
	radixSort(games, 1);
	getHandClass(games, 1);
	sortGames(games);
	radixSort(games, 2);
	getHandClass(games, 2);
	sortGames(games);
	puts("");
	return 0;
}
