#include "kernel/types.h"
#include "user/user.h"

// Define how many numbers to go to
#define TOT_NUMS 280

void 
primes(void) {
	// Setup pipeline
	int pid, i;
	char leftPipe[2], rightPipe[2];
	int nums[TOT_NUMS];
	
	// Loop numbers i: 2->280
	if (fork() == 0) {
		for (i = 2; i <= TOT_NUMS; i++) {
			deleteMultiples(nums, i);
			if (nums[i] != -1) {
				// Prime found as all lower numbers are not valid factors
				pid = fork();
				if (pid == 0) {
					// Create child process to write to pipes
					// We are not writing to
					close(leftPipe[0]);
					close(rightPipe[1]);

					exit(0);
				} else if (pid > 0) {
					// Parent process
					// do stuff . . .
				} else {
					// Fork error
					fprintf(2, "Err: fork failed\n");
				} // EndIf
			} else {
				// Continue
			} // EndIf
		} // EndFor
	} else {
		// Assuming fork worked (as first process, shouldn't run out of descriptors here)
		int status;
		wait(status);
	}
} // End

int
main(int argc, char* argv[]) {
	primes();
	exit(0);
} // End

/**
 * Given an array of numbers and some value, change all multiples of val in array to -1
 * 
 * @param[in, out] arr Array where arr[idx] represents the number idx
 * @param[in] val Number to check 
 */
void 
deleteMultiples(int* arr[TOT_NUMS], int val) {
	int idx;

	for (idx=2; idx<=TOT_NUMS; idx++) {
		// Remove multiples
		if (idx % val == 0) {
			// Multiple found
			arr[idx] = -1;
		}
	}
}
