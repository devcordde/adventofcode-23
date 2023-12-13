#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#define file "./12input.txt" 
#define testfile "./12test.txt"
#define LINE_SIZE 128
#define LINES 1000
//#define LINES 6

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

void parseInput(char input[][LINE_SIZE], char condition[][30], int arrangement[][10]) {
	for (int i = 0; i < LINES; i++) {
		char *token, *rest = input[i];
		int count = 0;
		strcpy(condition[i], strtok_r(rest, " ", &rest));
		while ((token = strtok_r(rest, ",", &rest))) {
			arrangement[i][count++] = atoi(token);
		}
		arrangement[i][count] = 0;	
	}
}

int checkArrangementForValidity(char condition[30], int arrangement[10], long positions, int countNr) {
	int pos = 0, count = 0, valid = 1;
	for (int i = 0; i <= strlen(condition); i++) {
		if (positions > 0) {
			if (condition[i] == '?' && (positions % 2)) {
				condition[i] = '#';
				positions = positions >> 1;
			}
			if (condition[i] == '?' && !(positions %2)) {
				condition[i] = '.';
				positions = positions >> 1;
			}
		}

		if (condition[i] == '?' && positions == 0) { condition[i] = '.'; }
		if (condition[i] == '#') { count++; }
		if (condition[i] != '#' && count != 0) {
			if (count == arrangement[pos]) {
				pos++;
				count = 0;
			} else { valid = 0; }
		}
		if (pos == countNr && count > 0) { valid = 0; }
	}
	if (pos < countNr && count == pos) {
		count = 0;
		pos++;
	}
	if (count > 0 && pos + 1 <= countNr) {
		if (count == arrangement[pos] && pos + 2 == countNr) { pos++;} 
		else { valid = 0; }
	}
	if (pos  < countNr) { valid = 0; }
	
	return valid;
}

int countCombinations(char condition[30], int arrangement[10]) {
	int sum = 0, countDot = 0, countTag = 0, countFree = 0, count = 0, countNr = 0;
	while (arrangement[count] != 0) {
		sum += arrangement[count++];
		countNr++;
	}
	count = 0;
	while (count < strlen(condition)) {
		if (condition[count] == '.') { countDot++; }		
		if (condition[count] == '#') { countTag++; }		
		if (condition[count++] == '?') { countFree++; }		
	}
	int combinationsSum = 0;
	for (long i = 0; i < pow(2, countFree + 1); i++) {
		char cond[30];
		strcpy(cond, condition);
		int places = 0;
		long binary = i;
		while (binary) {
			if (binary % 2) {
				places++;
				binary = binary >> 1;
			} else { binary = binary >> 1; }
		}
		if (sum - countTag == places || sum - countTag == places - 1) {
			combinationsSum += checkArrangementForValidity(cond, arrangement, i, countNr);
		}
		if (i % 10000000 == 0 && i != 0) { printf("%ld\n", i); }
	}
	
	return combinationsSum/2;
}

//setup for Part2, useless for part 1
void buildlongCheck(char condition[30], int arrangement[10], char newCondition[120], int newArrangement[40]) {
	strcpy(newCondition, condition);
	for (int i = 0; i < 4; i++) {
		strcat(newCondition, "?");
		strcat(newCondition, condition);
	}
	int count = 0;
	for (int i = 0; i < 5; i++) {
		int internalCount = 0;
		while (arrangement[internalCount] != 0) {
			newArrangement[count++] = arrangement[internalCount++];
		}
	}
	newArrangement[count] = 0;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	char condition[LINES][30];
	int arrangement[LINES][10];
	readInput(input);
	parseInput(input, condition, arrangement);
	int overallSum = 0;
	for (int i = 0; i < LINES; i++) {
		overallSum += countCombinations(condition[i], arrangement[i]);
	}
	printf("Sum of all Combinations: %d\n", overallSum);

	return 0;
}
