#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define file "./02input.txt" 
#define LINE_SIZE 512
#define LINES 100

typedef struct pull {
	int red;
	int green;
	int blue;
} Pull;

typedef struct game{
	Pull pulls[10];	
} Game;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

int buildSum(Game games[LINES]) {
	int sum = 0;
	for(int i = 0; i <LINES; i++) {
		int valid = 1;
		for(int j = 0; j < (sizeof(games[i].pulls) / sizeof(Pull)); j++) {
			if(games[i].pulls[j].red > 12 || games[i].pulls[j].green > 13 || games[i].pulls[j].blue > 14) {
				valid = 0;
			}
		}
		if(valid) { sum += i + 1; }
	}
	return sum;
}

int buildPower(Game games[LINES]) {
	int power = 0;
	for(int i = 0; i <LINES; i++) {
		int red = 0, green = 0, blue = 0;
		for(int j = 0; j < (sizeof(games[i].pulls) / sizeof(Pull)); j++) {
			if (games[i].pulls[j].red > red) { red = games[i].pulls[j].red;	}
			if (games[i].pulls[j].green > green) { green = games[i].pulls[j].green;	}
			if (games[i].pulls[j].blue > blue) { blue = games[i].pulls[j].blue; }
		}
		power += red * green * blue;
	}
	return power;
}

void parsePulls(char* token, int i, Game games[LINES], int pull) {
	char *rest = token, *rest2;
	while((token = strtok_r(rest, ",", &rest))) {
		token = strtok_r(token, " ", &rest2);
		switch(rest2[0]) {
			case 'r': games[i].pulls[pull].red = atoi(token); break;
			case 'g': games[i].pulls[pull].green = atoi(token); break;
			case 'b': games[i].pulls[pull].blue = atoi(token); break;
		}
	}
}

void parseGames(char input[][LINE_SIZE], int lineCount, Game games[LINES]) {
	for (int i = 0; i < lineCount; i++) {
		int pull = 0;
		char *rest, *token = strtok_r(input[i], ":", &rest);
		while((token = strtok_r(rest, ";", &rest))) {
			parsePulls(token, i, games, pull++);
		}
	}
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	Game games[LINES];
	parseGames(input, lineCount, games);
	printf("Sum: %d\n", buildSum(games));
	printf("Power: %d\n", buildPower(games));
	return 0;
}
