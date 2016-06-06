#include <stdio.h>
#include <stdlib.h>

int main (void) {

	int i, result;

    	for (i = 0; i < 10000; i++) {
		add_one(i, &result);
        	if (result != (i+1)) {
            		printf("[ERROR ] Unexpected Output...\n");
            		exit(EXIT_FAILURE);
        	}
    	}

    	return 0;
}
