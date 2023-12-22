#include <stdio.h>
#include <string.h>

#define file "./14input.txt" 
#define LINE_SIZE 102
#define LINES 100

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void moveStone(char input[][LINE_SIZE], int x, int y, int xDir, int yDir) {
	input[x][y] = '.';
	while (!(x + xDir < 0 || y + yDir < 0 || x + xDir >= LINES || (y + yDir >= (int)strlen(input[0]) - 1) || strchr("#O", input[x + xDir][y + yDir]))) {
		x += xDir;
		y += yDir;
	}
	input[x][y] = 'O';
}

void tiltPlatform(char input[][LINE_SIZE], int xDir, int yDir) {
	if (xDir < 0 || yDir < 0) {
		for (int i = 0; i < LINES; i++) {
			for (int j = 0; j < (int)strlen(input[0]) - 1; j++) {
				if (input[i][j] == 'O') { moveStone(input, i, j, xDir, yDir); }		
			}
		}
	}
	if (xDir > 0 || yDir > 0) {
		for (int i = LINES - 1; i > - 1; i--) {
			for (int j = (int)strlen(input[0]) - 1; j > -1; j--) {
				if (input[i][j] == 'O') { moveStone(input, i, j, xDir, yDir); }		
			}
		}
	}
}

int countWeight(char input[][LINE_SIZE], int part) {
	int sum = 0;
	for (int i = 0; i < LINES; i++) {
		for (int j = 0; j < (int)strlen(input[0]); j++) {
			if (input[i][j] == 'O') { sum += LINES - i; }	
		}
	
	}
	if (part == 1) { printf("Load after 1 tilt: %d\n", sum); }
	return sum;
}

int findCycle(int weights[1000]) {
	int length;
	for (int i = 8; i < 500; i++) {
		if (weights[200] == weights[200 + i]) {
			length = 0;
			while (weights[200 + length] == weights[200 + i + length]) {
				length++;
				if (length > i) { return length; }
			}
		}	
	}
	return -1;
}

int main() {
	char input[LINES][LINE_SIZE];
	readInput(input);
	int weights[1000];
	for (int i = 0; i < 1000; i++) {
		tiltPlatform(input, -1, 0);
		if (i == 0) { countWeight(input,1); }
		tiltPlatform(input, 0, -1);
		tiltPlatform(input, 1, 0);
		tiltPlatform(input, 0, 1);
		weights[i] = countWeight(input, 2);
	}
	int length = findCycle(weights);
	printf("Weight after 1mrd cylces: %d\n", weights[200 + (1000000000 - 201) % (length - 1)]);
	return 0;
}
