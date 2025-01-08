#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    // Init variables
    int pipe_pc[2], pipe_cp[2];
    char buff[5];
    int pid;

    // Init pipes
    if (pipe(pipe_pc) < 0 || pipe(pipe_cp) < 0) {
        fprintf(2, "Error opening pipe\n");
        exit(1);
    }

    pid = fork();
    if (pid == 0) {
        // Child process
        close(pipe_pc[1]); // Close write end of parent-to-child pipe
        close(pipe_cp[0]); // Close read end of child-to-parent pipe

        if (read(pipe_pc[0], buff, 5) == 5) {
            fprintf(1, "%d: received %s\n", getpid(), buff);
        } else {
            fprintf(2, "%d: error reading in child process\n", getpid());
        }
        close(pipe_pc[0]);

        if (write(pipe_cp[1], "pong", 5) < 5) {
            fprintf(2, "%d: error writing in child process\n", getpid());
        }
        close(pipe_cp[1]);

    } else if (pid > 0) {
        // Parent process
        close(pipe_pc[0]); // Close read end of parent-to-child pipe
        close(pipe_cp[1]); // Close write end of child-to-parent pipe

        if (write(pipe_pc[1], "ping", 5) < 5) {
            fprintf(2, "%d: error writing in parent process\n", getpid());
        }
        close(pipe_pc[1]);

        if (read(pipe_cp[0], buff, 5) == 5) {
            fprintf(1, "%d: received %s\n", getpid(), buff);
        } else {
            fprintf(2, "%d: error reading in parent process\n", getpid());
        }
        close(pipe_cp[0]);
    }

    exit(0);
}
