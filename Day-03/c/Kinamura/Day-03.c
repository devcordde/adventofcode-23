#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <math.h>

#define file "./03input.txt" 
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

int isValidNumber(char input[][LINE_SIZE], int line, int pos, int length) {
	int start = pos;
	if((pos - 1 >= 0 && input[line][pos - 1] != '.') || (pos + length < LINE_SIZE - 2 && input[line][pos + length] != '.')) { return 1; }
	if(start - 1 < 0) { start = 1; }
	for (int i = start - 1; i <= start + length; i++) {		
		if (line - 1 > 0 && strchr(".\n",input[line-1][i]) == NULL && !isdigit(input[line - 1][i])) { return 1; }
		if (line + 1 < LINES -1 && strchr(".\n",input[line + 1][i]) == NULL && !isdigit(input[line + 1][i])) { return 1;	}
	}
	return 0;
}

int findLineSum(char input[][LINE_SIZE], int line){
	int lineSum = 0;
	for (int i = 0; i < LINE_SIZE -1; i++) {
		if (isdigit(input[line][i])) {
			int length = 0;
			while(isdigit(input[line][i + length])) { length++; }
			if (isValidNumber(input, line, i, length)) {
				int number = 0;
				for (int j = length; j > 0; j--) {
					number += pow(10, j - 1) * (input[line][i + length - j] - '0');
				}
				lineSum += number;
			}
			i += length -1;
		}
	}
	return lineSum;
}

int determineNumber(char input[][LINE_SIZE], int line, int pos) {
	char number[3] = {'\0','\0','\0'};
	int length = 0, start = 0, end = 0;
	if(isdigit(input[line][pos-1])) { start--; }
	if(start == -1 && isdigit(input[line][pos-2])) { start--; }
	if(isdigit(input[line][pos+1])) { end++; }
	if(end == 1 && isdigit(input[line][pos+2])) { end++; }
	for(; start <= end; start++) {
		number[length++] = input[line][pos + start];
	}
	return atoi(number);	
}

int getGearValueIfValid(char input[][LINE_SIZE], int line, int pos) {
	int numbers[9], count = 0;
	for (int i = pos - 1; i <= pos + 1; i++) {
		if (isdigit(input[line - 1][i])) {
			int number = determineNumber(input, line - 1, i);
			if(count == 0) { numbers[0] = number; count++; }
			if(count > 0 && number != numbers[0]) {numbers[1] = number; count++; }
		}
		if (isdigit(input[line][i])) {
			int number = determineNumber(input, line, i);
			if(count == 0) { numbers[0] = number; count++; }
			if(count > 0 && number != numbers[0]) {numbers[1] = number; count++; }
		}
		if (isdigit(input[line + 1][i])) {
			int number = determineNumber(input, line + 1, i);
			if(count == 0) { numbers[0] = number; count++; }
			if(count > 0 && number != numbers[0]) {numbers[1] = number; count++; }
		}
	
	}
	if(count == 1) { return 0; }
	return numbers[0]*numbers[1];
}

int findGearValuesPerLine(char input[][LINE_SIZE], int line) {
	int lineGearValue = 0;
	for (int i = 0; i < LINE_SIZE - 1; i++) {
		if (input[line][i] == '*') {
			lineGearValue += getGearValueIfValid(input,line,i);
		}
	}
	return lineGearValue;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	int finalSum = 0, gearSum = 0;
	for (int i = 0; i < lineCount; i++) {
		finalSum += findLineSum(input,i);
		gearSum += findGearValuesPerLine(input,i);
	}
	fprintf(stdout, "Summe aller PartNumbers: %d\n", finalSum);
	fprintf(stdout, "Summe aller GearValues: %d\n", gearSum);
	return 0;
}
