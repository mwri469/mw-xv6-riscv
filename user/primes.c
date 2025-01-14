#include "kernel/types.h"
#include "user/user.h"

// Define how many numbers to go to
#define TOT_NUMS 280

/**
 * primes() function. For intigers [2->281) seive through numbes, printing out primes.
 * Idea is illustrated in http://swtch.com/~rsc/thread/ due to Doug McIlroy.
 * For each prime, a new child process is created that reads from neighbour to the left and writes
 * to neighbour on the right on individual pipes.
 * 
 * Plan:
 * -----
 * Set up one pipe and one write pipe. On each seive 'layer', we print prime and seive its products.
 * Due to fundamental theorem of arithmetic, every positive int > 1 can be re-written as a product of
 * primes.
 *  layer 1, layer 2,  . . . ,layer n
 *   | 0002|->|print|  . . .  |     |
 *   | 0003|--| 0003|->. . .  |     |
 *   | ... |  | ... |         | ... |
 *   | 0277|--| 0277|--. . .->|print|
 *   | 0278|->| kill|  . . .  |     |
 */
void 
primes(int in_pipe) {
    int prime, buff, bytes;
    int out_pipe[2];

    // Read the first number from the pipe, which is the next prime
    bytes = read(in_pipe, &prime, sizeof(prime));
    if (bytes == 0) {
        close(in_pipe);
        exit(0);
    } else if (bytes < 0) {
        fprintf(2, "Err: error reading from pipe\n");
        close(in_pipe);
        exit(1);
    } // EndIf

    // Print the prime number
    fprintf(1, "prime %d\n", prime);

    // Create a new pipe for the next stage
    pipe(out_pipe);

    if (fork() == 0) {
        // Child process: close write end and recurse with the read end
        close(out_pipe[1]);
        close(in_pipe);
        primes(out_pipe[0]);
        exit(0);
    } else {
        // Parent process: close read end of the new pipe
        close(out_pipe[0]);

        // Filter numbers that are not divisible by the current prime
        while (read(in_pipe, &buff, sizeof(buff)) > 0) {
            if (buff % prime != 0) {
                write(out_pipe[1], &buff, sizeof(buff));
            }
        }

        // Close pipes and wait for the child
        close(out_pipe[1]);
        close(in_pipe);
        wait(0);
        exit(0);
    } // EndIf
} // End

int 
main(int argc, char* argv[]) {
    int in_pipe[2];
    int i;

    pipe(in_pipe);

    if (fork() == 0) {
        // Child process: start the sieve
        close(in_pipe[1]);
        primes(in_pipe[0]);
        exit(0);
    } else {
        // Parent process: write numbers into the pipe
        close(in_pipe[0]);
        for (i = 2; i <= TOT_NUMS; i++) {
            write(in_pipe[1], &i, sizeof(i));
        }

        // Close write end and wait for the child to finish
        close(in_pipe[1]);
        wait(0);
        exit(0);
    } // EndIf
} // End
