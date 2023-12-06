#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#define file "./06input.txt" 
#define LINE_SIZE 128
#define LINES 2

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[][LINE_SIZE], long races[][10]) {
	for (int i = 0; i < 2; i++) {
		char *token, *rest = input[i];
		int count = 0;
		token = strtok_r(rest, " ", &rest);
		while ((token = strtok_r(rest, " ", &rest))) {
			races[i][count++] = atoi(token);
		}
	}
}

long findRaceResult(long time, long record) {
	long discriminant = time * time + (-4) * record;
     	double root1 = (-time + sqrt(discriminant)) / (-2);
      	double root2 = (-time - sqrt(discriminant)) / (-2);
	return ((long)ceil(root2) - 1) - (long)floor(root1);
}

long buildNumbers(long races[][10], int number) {
	for (int i = 1; i < 4; i++) {
		long pow = 10;
		while (races[number][i] >= pow) { pow *= 10; }
		races[number][i] = (races[number][i - 1] * pow) + races[number][i];
	}
	return races[number][3];
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	long races[LINES][10], result = 1;
	readInput(input);
	parseInput(input, races);
	for (int i = 0; i < 4; i++) { result *= findRaceResult(races[0][i], races[1][i]); }
	printf("Races multiplied: %ld\n", result);
	long sRace = findRaceResult(buildNumbers(races, 0), buildNumbers(races, 1));
	printf("Single Race result: %ld\n", sRace);
	return 0;
}
