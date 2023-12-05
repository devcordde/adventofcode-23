#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

#define file "./05input.txt" 
#define LINE_SIZE 256
#define LINES 210

typedef struct maps {
	long dest[50];
	long source[50];
	long range[50];
	int count;
} Maps;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

int buildMaps(char input[][LINE_SIZE], Maps map[7], int mapNr, int startLine) {
	int count = 0;
	while (input[startLine + count][0] != '\n' && startLine + count < LINES) {
		char *token, *rest = input[startLine + count];
		map[mapNr].dest[count] = strtol(strtok_r(rest, " ", &rest), &token, 10);
		map[mapNr].source[count] = strtol(strtok_r(rest, " ", &rest), &token, 10);
		map[mapNr].range[count++] = strtol(strtok_r(rest, " ", &rest), &token, 10);
	}
	map[mapNr].count = count;
	return startLine + count + 2;
}

void parseInput(char input[][LINE_SIZE], Maps map[7], long seeds[20]) {
	char *token = input[0], *rest = input[0];
	int count = 0, startLine = 3;
	token = strtok_r(rest, " ", &rest);
	while ((token = strtok_r(rest, " ", &rest))) {
		seeds[count++] = strtol(token, &token, 10);
	}
	for (int i = 0; i < 7; i++) {
		startLine = buildMaps(input, map, i, startLine);
	}
}

long getLocationMapping(long seed, Maps map[7], int currentMap) {
	if (currentMap > 6) { return seed; }
	for (int i = 0; i < map[currentMap].count; i++) {
		if (seed >= map[currentMap].source[i] && seed < map[currentMap].source[i] + map[currentMap].range[i]) {
			return getLocationMapping(map[currentMap].dest[i] + (seed - map[currentMap].source[i]), map, currentMap + 1);
		}
	}
	return getLocationMapping(seed, map, currentMap + 1);
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	Maps map[7];
	long seeds[20];
	readInput(input);
	parseInput(input, map, seeds);
	long lowest = LONG_MAX;
	for (int i = 0; i < 20 ; i++) {
		if(seeds[i] > 0) {
			long temp = getLocationMapping(seeds[i], map, 0);
			if (temp < lowest) {
				lowest = temp;	
			}
		}
	}
	printf("Lowest location: %ld\n", lowest);
	lowest = LONG_MAX;
	for (int i = 0; i < 20; i++) {
		if(seeds[i] > 0) {
			for (int j = 0; j < seeds[i + 1]; j++) {
				long temp = getLocationMapping(seeds[i] + j, map, 0);
				if (temp < lowest) {
					lowest = temp;
				}
			}
		}
		i++;
	}
	printf("Lowest location 2: %ld\n", lowest);

	return 0;
}
