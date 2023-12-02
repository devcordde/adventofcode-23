#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define file "./02input.txt" 
#define LINE_SIZE 512
#define LINES 100

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

int checkValidity(char pull[128]) {
	int red = 0, blue = 0, green = 0;
	char *token, *rest = pull, *rest2;
	while((token = strtok_r(rest, ",", &rest))) {
		token = strtok_r(token, " ", &rest2);
		switch(rest2[0]) {
			case 'r': red += atoi(token); break;
			case 'g': green += atoi(token); break;
			case 'b': blue += atoi(token); break;
		}
	}
	return (red > 12 || green > 13 || blue > 14);
}

void getMax(char pull[128], int current[3]) {
	char *token, *rest = pull, *rest2;
	while((token = strtok_r(rest, ",", &rest))) {
		token = strtok_r(token, " ", &rest2);
		if(rest2[0] == 'r' && current[0] < atoi(token)) {current[0] = atoi(token);}
		if(rest2[0] == 'g' && current[1] < atoi(token)) {current[1] = atoi(token);}
		if(rest2[0] == 'b' && current[2] < atoi(token)) {current[2] = atoi(token);}
	}
}

void parseInput(char input[][LINE_SIZE], int lineCount) {
	char* rest;
	int sum = 0, powSum = 0;
	for (int i = 0; i < lineCount; i++) {
		char inputLine[LINE_SIZE]; 
		strcpy(inputLine,input[i]);
		int invalid = 0, colors[3] = {0,0,0};
		char* token = strtok_r(inputLine, ":", &rest);
		while((token = strtok_r(rest, ";", &rest))) {
			if((invalid = checkValidity(token))) {
				break;
			}
		}
		if(!invalid) {
			sum += i + 1;	
		}
		
		strcpy(inputLine,input[i]);
		token = strtok_r(inputLine, ":", &rest);
		while((token = strtok_r(rest, ";", &rest))) {
			getMax(token, colors);
		}
		powSum += colors[0] * colors[1] * colors[2];
	}
	fprintf(stdout, "%d\n", sum);
	fprintf(stdout, "%d\n", powSum);
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	int lineCount = readInput(input);
	parseInput(input, lineCount);
	return 0;
}
