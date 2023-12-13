#include <stdio.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

#define file "./10input.txt" 
#define LINE_SIZE 142
#define LINES 140

void markAccessible(char input[][LINE_SIZE], int x, int y);

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void findStartingTile(char input[][LINE_SIZE], int start[2]) {
	for (int line = 0; line < LINES; line++) {
		for (int column = 0; column < LINE_SIZE - 1; column++) {
			if (input[line][column] == 'S') {
				start[0] = line;
				start[1] = column;
				return;
			}
			if (input[line][column] == '\n') { break; }
		}
	}
}

int getPipeLength(char input[][LINE_SIZE], int row, int column, int rowDir, int columnDir) {
	long count = 0;
	while (input[row][column] != '.' && row < LINES && row > -1 && column < LINE_SIZE && column > -1) {
		if (strchr("-_",input[row][column]) != NULL && columnDir == 1) {
			input[row][column] = '_';
			column++;
		}
		else if (strchr("-_", input[row][column]) != NULL && columnDir == -1) {
			input[row][column] = '_';
			column--;
		}
		else if (strchr("|:", input[row][column]) != NULL && rowDir == 1) {
			input[row][column] = ':';
			row++;
		}
		else if (strchr("|:", input[row][column]) != NULL && rowDir == -1) {
			input[row][column] = ':';
			row--;
		}
		else if (strchr("71", input[row][column]) != NULL && columnDir == 1) {
			input[row][column] = '1';
			columnDir = 0;
			rowDir = 1;
			row++;
		}
		else if (strchr("71", input[row][column]) != NULL && rowDir == -1) {
			input[row][column] = '1';
			columnDir = -1;
			rowDir = 0;
			column--;
		}
		else if (strchr("Jj", input[row][column]) != NULL && rowDir == 1) {
			input[row][column] = 'j';
			rowDir = 0;
			columnDir = -1;
			column--;
		}
		else if (strchr("Jj", input[row][column]) != NULL && columnDir == 1) {
			input[row][column] = 'j';
			rowDir = -1;
			columnDir = 0;
			row--;
		}
		else if (strchr("Ll", input[row][column]) != NULL && rowDir == 1) {
			input[row][column] = 'l';
			rowDir = 0;
			columnDir = 1;
			column++;
		}
		else if (strchr("Ll", input[row][column]) != NULL && columnDir == -1) {
			input[row][column] = 'l';
			rowDir = -1;
			columnDir = 0;
			row--;
		}
		else if (strchr("Ff", input[row][column]) != NULL && rowDir == -1) {
			input[row][column] = 'f';
			rowDir = 0;
			columnDir = 1;
			column++;
		}
		else if (strchr("Ff", input[row][column]) != NULL && columnDir == -1) {
			input[row][column] = 'f';
			rowDir = 1;
			columnDir = 0;
			row++;
		}
		else if (input[row][column] == 'S') {
			return (int)ceil((double)count / 2);
		}
		count++;
	}
	return count;
}

int findOppositePoint(char input[][LINE_SIZE], int start[2]) {
	if (strchr("|:71Ff",input[start[0] - 1][start[1]]) != NULL) {
		return(getPipeLength(input, start[0] - 1, start[1], -1, 0));
	}
	if (strchr("-_LlFf", input[start[0]][start[1] - 1]) != NULL) {
		return(getPipeLength(input, start[0], start[1] - 1, 0, -1));
	}
	if (strchr("-_Jj71", input[start[0]][start[1] + 1]) != NULL) {
		return(getPipeLength(input, start[0] + 1, start[1], 1, 0));
	}
	if (strchr("|:LlJj", input[start[0] + 1][start[1]]) != NULL) {
		return(getPipeLength(input, start[0], start[1] + 1, 0, 1));
	}
	return 0;
}

void markAccessible2(char bigGrid[][LINE_SIZE * 3 - 6], int x, int y) {
	if(strchr("#X", bigGrid[x][y]) != NULL) {
		return;
	}
	bigGrid[x][y] = '#';
	if (x - 1 >= 0 && bigGrid[x - 1][y] != 'X') { markAccessible2(bigGrid, x - 1, y); }
	if (y - 1 >= 0 && bigGrid[x][y - 1] != 'X') { markAccessible2(bigGrid, x, y - 1); }
	if (x + 1 < LINES * 3 - 1 && bigGrid[x + 1][y] != 'X') { markAccessible2(bigGrid, x + 1, y); }
	if (y + 1 < LINE_SIZE * 3 - 6 && bigGrid[x][y + 1] != 'X') { markAccessible2(bigGrid, x, y + 1); }
}

void fillBigGrid(char bigGrid[][LINE_SIZE * 3 - 6], char fillWith, int x, int y) {
	if (strchr("|-LJ7F.S :_lj1f", fillWith) != NULL) {
		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				bigGrid[3 * x + i][3 * y + j] = '.';
			}
		
		}
	}
	if (fillWith == 'S') {
		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				bigGrid[3 * x + i][3 * y + j] = 'X';
			}
		
		}
	}
	if (fillWith == '_') {
		bigGrid[3 * x + 1][3 * y + 0] = 'X';
		bigGrid[3 * x + 1][3 * y + 1] = 'X';
		bigGrid[3 * x + 1][3 * y + 2] = 'X';
	}
	if (fillWith == ':') {
		bigGrid[3 * x + 0][3 * y + 1] = 'X';
		bigGrid[3 * x + 1][3 * y + 1] = 'X';
		bigGrid[3 * x + 2][3 * y + 1] = 'X';
	}
	if (fillWith == 'l') {
		bigGrid[3 * x + 0][3 * y + 1] = 'X';
		bigGrid[3 * x + 1][3 * y + 1] = 'X';
		bigGrid[3 * x + 1][3 * y + 2] = 'X';
	}
	if (fillWith == 'j') {
		bigGrid[3 * x + 0][3 * y + 1] = 'X';
		bigGrid[3 * x + 1][3 * y + 1] = 'X';
		bigGrid[3 * x + 1][3 * y + 0] = 'X';
	}
	if (fillWith == '1') {
		bigGrid[3 * x + 1][3 * y + 0] = 'X';
		bigGrid[3 * x + 1][3 * y + 1] = 'X';
		bigGrid[3 * x + 2][3 * y + 1] = 'X';
	}
	if (fillWith == 'f') {
		bigGrid[3 * x + 1][3 * y + 2] = 'X';
		bigGrid[3 * x + 1][3 * y + 1] = 'X';
		bigGrid[3 * x + 2][3 * y + 1] = 'X';
	}
}

void expandGrid(char input[][LINE_SIZE], char bigGrid[][LINE_SIZE * 3 - 6]) {
	for (int i = 0; i < LINES; i++) {
		for (int j = 0; j < LINE_SIZE - 3; j++) {
			fillBigGrid(bigGrid, input[i][j], i, j);	
		}
	}
}

void tempMarkRemaining(char input[][LINE_SIZE]) {
	for (int i = 0; i < LINES; i++) {
		for (int j = 0; j < LINE_SIZE - 2; j++) {
			if (strchr("_:jl1fS#", input[i][j]) == NULL ) {
				input[i][j] = 'O';
			}
		}
	}
}

void reduceGrid(char input[][LINE_SIZE], char bigGrid[][LINE_SIZE * 3 - 6]) {
	for (int i = 0; i < LINES; i++) {
		for (int j = 0; j < LINE_SIZE - 2; j++) {
			input[i][j] = bigGrid[3 * i + 1][3 * j + 1];
		}
	}
}

int countValidSpots(char input[][LINE_SIZE]) {
	int count = 0;
	for (int i = 0; i < LINES - 3; i++) {
		for (int j = 0; j < LINE_SIZE - 4; j++) {
			if (input[i][j] == '.') {
				count++;
			}
		}
	}
	return count;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE], bigGrid[LINES * 3][LINE_SIZE * 3 - 6];
	readInput(input);
	int start[2] = {0,0};
	findStartingTile(input, start);
	printf("Length: %d\n", findOppositePoint(input, start));
	expandGrid(input, bigGrid);
	markAccessible2(bigGrid, 0, 0);
	reduceGrid(input, bigGrid);
	//Print for nice picture :P
//	for (int i = 0; i < LINES * 3 -1; i++) {
//		printf("%s\n", bigGrid[i]);
//	}
	printf("Fields inside: %d\n", countValidSpots(input));
	return 0;
}
