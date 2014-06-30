# Operating System
This repo contains my notes, exercie solutions as well as lab solutions for the Operating System Engineering
Course. In this file, I will record my progress and the notes for the course and
solutions.

## xv6

```
xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix Version 6 (v6) by MIT.
xv6 loosely follows the structure and style of v6, but is implemented for a modern x86-based
multiprocessor using ANSI C.
```

#### What I did?
  * add notes to the source file
  * modified the source code to solve the exercises given in the lecture

#### Progress
  * [Lec1: shell exercise](#shell-exercise)
    * basic exercises (ok)
    * challenge exercise (no)
  * Lec2: Boot xv6 exercise (no)
  * Lec3: Trace system calls; add halt (no)
  * Lec4: Lazy page allocation (no)
  * Lec5: xv6 CPU alarm (no)

#### Shell Exercise
check inclass_sh.c for solution.

1. Executing simple commands

    ```c++
    // use the execvp(const char *file, char *const argv[]) function
    // this function will duplicate the actions the shell in searching
    // an executable file if the specified file name does not contain '/'.

    // use the int fchmod(int fd, mode_t mode) to change the access permissions
    // of the file.
    // user: read/write
    // group: read
    // other: read
    if (fchmod(fd, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH) < 0) {
      perror("fchmod:");
    }
    ```

2. I/O redirection

    ```c++
    // Redirection operator `<` and `>`. Connect a command to a file.
    // `<` connects file to the command's standard input.
    // '>' connects file to the command's standard output.

    // use the dup2(int old_fd, int new_fd) function.
    // copy old_fd to new_fd, new_fd and old_fd point to the same file.

    // for redirection:
    file_fd = open(file_name, flag);
    dup2(file_fd, STDIN/STDOUT);
    close(file_fd);
    ```

3. Implement pipes

   ```
   // about int pipe(int fd[2])
   // fd[0] is used for read, fd[1] is used for write
   // fd[0] <- | PIPE | <- fd[1]
   // if fd[0] is closed, writing to pipe will receive a SIGPIPE
   // if fd[1] is closed, and it will generate a EOF for the read side
   // after the reader consumes any buffered data.

   // Baise Usage, Communicate between parent and child
   // Data flow from parent to child (one-way)
   // Dup2, Fork is the wrapper function for dup2 and fork, which handles the
   // error

   int p[2];
   if (pipe(p) < 0) {
     perror("pipe:");
   }
   if (Fork() == 0) {
     // child process
     Dup2(p[0], 0);  // connect stdin to PIPE
     close(p[0]);
     close(p[1]);
     // do something
   }
   // parent process
   Dup2(p[1], 1);  // connect stdout to PIPE
   close(p[1]);
   close(p[0]);
   // do something

   // Parent's stdout connects with Child's stdin
   ```

4. Challenge Exercise

    ```
    4.1 Implement lists of commands, sperated by ";"
    4.2 Implement sub shells by implementing "(" and ")"
    4.3 Implement running commands in the background by supporting "&" and "wait"
    ```

## JOS

```
A OS for the labs assgnments. Only contains pieces of skeleton code.
```

#### Progress
  * Lab 1 : C, Assembly, Tools, and Bootstrapping
    * Grade: 50/50
  * Lab 2 : Memory Management (no)




