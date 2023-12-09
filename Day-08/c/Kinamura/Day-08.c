#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define file "./08input.txt" 
#define LINE_SIZE 274
#define LINES 748

typedef struct node {
	char name[4], left[4], right[4];
	int leftIndex, rightIndex;
} Node;

int readInput(char prompts[][LINE_SIZE]){
	FILE *input = fopen(file, "r");
	int i = 0;
	if (input != NULL){
		while (fgets(prompts[i++],LINE_SIZE,input) != NULL) {}
	}
	return (fclose(input) & 0) | (i - 1);
}

char* parseInput(char input[][LINE_SIZE], Node nodes[LINES]) {
	for (int i = 2; i < LINES; i++) {
		char *rest = input[i];
		strcpy(nodes[i-2].name, strtok_r(rest, " ", &rest));
		strtok_r(rest, "(", &rest);
		strcpy(nodes[i-2].left, strtok_r(rest, ",", &rest));
		strcpy(nodes[i-2].right, strtok_r(rest, " ", &rest));
		nodes[i-2].right[3] = '\0';
	}
	return input[0];
}

int findNodeIndex(Node nodes[LINES], char node[4]) {
	for (int i = 0; i < LINES - 2; i++) {
		if (!strcmp(nodes[i].name,node)) { return i; }	
	}
	return -1;
}

void buildPaths(Node nodes[LINES]) {
	for (int i = 0; i < LINES -2 ; i++) {
		nodes[i].leftIndex = findNodeIndex(nodes, nodes[i].left);	
		nodes[i].rightIndex = findNodeIndex(nodes, nodes[i].right);
	}
}

void traverseNodes(Node nodes[LINES], char *path, int nodeIndex) {
	int steps = 0, pathIndex = 0;
	while (strcmp(nodes[nodeIndex].name,"ZZZ") != 0) {
		steps++;
		if (path[pathIndex] == 'L') { nodeIndex = nodes[nodeIndex].leftIndex; }
		if (path[pathIndex] == 'R') { nodeIndex = nodes[nodeIndex].rightIndex; }
		if (path[++pathIndex] == '\n') { pathIndex = 0; }
	}
	printf("%d\n", steps);
}

int findANodes(Node nodes[LINES], int aNodeIndex[LINES/2]) {
	int count = 0;
	for (int i = 0; i < LINES - 2; i++) {
		if (nodes[i].name[2] == 'A') { aNodeIndex[count++] = i; }	
	}
	return count;
}

int runPath(Node nodes[LINES], char *path, int index) {
	int steps = 0, pathIndex = 0;
	while(1) {
		if (path[pathIndex] == 'L') { index = nodes[index].leftIndex; }
		if (path[pathIndex] == 'R') { index = nodes[index].rightIndex; }
		if (path[++pathIndex] == '\n') { pathIndex = 0; }
		steps++;
		if (nodes[index].name[2] == 'Z') { return steps; }
	}
}

long findGCD(long current, int new) {
	for(long i = 2; i <= current && i <= new; i++) {
		if (current % i == 0 && new % i == 0) { return i; }
	}
	return 1;
}

int main(int argc, char** argv) {
	char input[LINES][LINE_SIZE];
	Node nodes[LINES];
	int aNodeIndex[LINES/2];
	readInput(input);
	char* path = (char*)malloc(LINE_SIZE * sizeof(char));
	strcpy(path, parseInput(input, nodes));
	buildPaths(nodes);
	aNodeIndex[0] = findNodeIndex(nodes, "AAA");
	traverseNodes(nodes, path,  aNodeIndex[0]);
	int nodeACount = findANodes(nodes, aNodeIndex);
	long lcm = 1;
	for (int i = 0; i < nodeACount; i++) {
		int new = runPath(nodes, path, aNodeIndex[i]);
		lcm = (new * lcm) / findGCD(lcm, new);
	}
	printf("%ld\n", lcm);
	return 0;
}
