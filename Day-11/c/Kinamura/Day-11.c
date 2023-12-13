#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define file "./11input.txt" 
#define LINE_SIZE 142
#define LINES 140

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void markFree(char input[][LINE_SIZE], int rowCol, int sw) {
	for (int i = 0; i < LINES; i++) {
		if (sw) { input[i][rowCol] = (input[i][rowCol] == '.') ? ':' : '|'; 
		} else { input[rowCol][i] = (input[rowCol][i] == '.') ? ':' : '|'; }
	}
}

void findFree(char input[][LINE_SIZE], int run) {
	for (int i = 0; i < LINES; i++) {
		int free = 1;
		for (int j = 0; j < LINES; j++) {
			if (((run) ? input[j][i] : input[i][j]) != '.' && ((run) ? input[j][i] : input[i][j]) != ':') { free = 0; break; }
		}
		if (free) { (run) ? markFree(input, i, 1) : markFree(input, i, 0); }
	}
}

int findAllGalaxies(char input[][LINE_SIZE], int coords[][2]) {
	int count = 0;
	for (int i = 0; i < LINES; i++) {
		for (int j = 0; j < LINES; j++) {
			if (input[i][j] == '#') {
				coords[count][0] = i;
				coords[count][1] = j;
				count++;
			}
		}
	}
	return count;
}

long getManhattanDistance(char input[][LINE_SIZE], int coords[][2], int IndexA, int IndexB, int bonusDist) {
	int xDist = abs(coords[IndexA][0] - coords[IndexB][0]), yDist = abs(coords[IndexA][1] - coords[IndexB][1]);
	long distance = xDist + yDist;
	int start = (coords[IndexA][0] > coords[IndexB][0]) ? coords[IndexB][0] : coords[IndexA][0];
	for (int i = start; i < start + xDist; i++) {
		if (input[i][coords[IndexA][1]] == ':') { distance += 1 + bonusDist; }
		if (input[i][coords[IndexA][1]] == '|') { distance += 2 + (2 * bonusDist); }
	}
	start = (coords[IndexA][1] > coords[IndexB][1]) ? coords[IndexB][1] : coords[IndexA][1];
	for (int i = start; i < start + yDist; i++) {
		if (input[coords[IndexA][0]][i] == ':') { distance += 1 + bonusDist; }
		if (input[coords[IndexA][0]][i] == '|') { distance += 2 + (2 * bonusDist); }
	}
	return distance;
}

long sumAllDistances(char input[][LINE_SIZE], int coords[][2], int galaxiesCount, int bonusDist) {
	long sum = 0;
	for (int i = 0; i < galaxiesCount - 1; i++) {
		for (int j = i + 1; j < galaxiesCount; j++) {
			sum += getManhattanDistance(input, coords, i, j, bonusDist);			
		}
	
	}
	return sum;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	readInput(input);
	int coords[1000][2];
	findFree(input, 0);
	findFree(input, 1);
	int galaxiesCount = findAllGalaxies(input, coords);
	long sum = sumAllDistances(input, coords, galaxiesCount, 0);
	printf("Young distance: %ld\n", sum);
	sum = sumAllDistances(input, coords, galaxiesCount, 999998);
	printf("Old distance: %ld\n", sum);
	return 0;
}
