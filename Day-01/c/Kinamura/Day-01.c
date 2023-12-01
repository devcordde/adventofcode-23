#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define file "../../../../prompts/01input.txt" 
#define testfile "../../../../prompts/01test.txt"
#define LINE_SIZE 128
#define LINES 1000

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput( char input[][LINE_SIZE], int numbers[][2], int lineCount) {
	for (int i = 0; i < lineCount; i++) {
		int first = 1;
		for(int j = 0; j < strlen(input[i]); j++) {
			if(isdigit(input[i][j]) && first) {
				numbers[i][0] = input[i][j] - '0';
				first = 0;
			}
			if (isdigit(input[i][j])) {
				numbers[i][1] = input[i][j] - '0';
			}
		}
	}
}

int sumLines(int numbers[][2]) {
	int sum = 0;
	for(int i = 0; i < LINES; i++) {
		sum += 10 * numbers[i][0] + numbers[i][1];
	}
	return sum;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	int numbers[LINES][2];
	char* p;
	parseInput(input, numbers, lineCount);
	fprintf(stdout, "%d\n", sumLines(numbers));
	for(int i = 0; i < LINES; i++) {
		for(int j = 0; j < 5; j++) {
			if ((p = strstr(input[i], "one"))) { p[1] = '1'; }
			if ((p = strstr(input[i], "two"))) { p[1] = '2'; }
			if ((p = strstr(input[i], "three"))) { p[2] = '3'; }
			if ((p = strstr(input[i], "four"))) { p[2] = '4'; }
			if ((p = strstr(input[i], "five"))) { p[2] = '5'; }
			if ((p = strstr(input[i], "six"))) { p[1] = '6'; }
			if ((p = strstr(input[i], "seven"))) { p[2] = '7'; }
			if ((p = strstr(input[i], "eight"))) { p[2] = '8'; }
			if ((p = strstr(input[i], "nine"))) { p[2] = '9'; }
		}
	}
	parseInput(input, numbers, lineCount);
	fprintf(stdout, "%d\n", sumLines(numbers));
	return 0;
}
