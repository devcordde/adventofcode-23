#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

#define file "./09input.txt" 
#define LINE_SIZE 126
#define LINES 200

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){ while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {} }
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[][LINE_SIZE], int histories[][LINE_SIZE]) {
	char *token, *rest;
	for (int i = 0; i < LINES; i++) {
		int count = 0;
		rest = input[i];
		while ((token = strtok_r(rest, " ", &rest))) { histories[i][count++] = atoi(token); }
		histories[i][count] = INT_MAX;
	}
}

int buildPyramid(int history[LINE_SIZE]) {
	int notEnd = 1, count = 0, lines;
	do { if (history[count] != INT_MAX) { count++; }
	else { notEnd = 0; }
	} while (notEnd);
	int history2[count][count + 1];
	for (int i = 0; i < count; i++) {
		history2[0][i] = history[i];
	}

	for (lines = 1; lines < count; lines++) {
		int zeroLine = 1;
		for (int j = 0 ; j < count - lines; j++) {
			history2[lines][j] = history2[lines - 1][j + 1] - history2[lines - 1][j];
			if (zeroLine && history2[lines][j] != 0) { zeroLine = 0; }
		}
		if (zeroLine) { break; }
	}

	history2[lines][count - lines] = 0;
	for (int i = lines - 1; i >= 0; i--) {
		history2[i][0] -= history2[i + 1][0]; 
		history2[i][count - i] = history2[i][count - i - 1] + history2[i + 1][count - i - 1]; 
	}
	history[0] = history2[0][0]; // possible Side-Effect hell but who cares?
	return history2[0][count];
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int histories[LINES][LINE_SIZE], sumEnd = 0, sumStart = 0;
	readInput(input);
	parseInput(input, histories);
	for (int i = 0; i < LINES; i++) {
		sumEnd += buildPyramid(histories[i]);
		sumStart += histories[i][0];
	}
	printf("Summe Teil1: %d\n", sumEnd);
	printf("Summe Teil2: %d\n", sumStart);
	return 0;
}
