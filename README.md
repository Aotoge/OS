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
  * [Lec1: shell exercises](#shell-exercise) (no)
  * Lec2: Boot xv6 exercise (no)
  * Lec3: Trace system calls; add halt (no)
  * Lec4: Lazy page allocation (no)
  * Lec5: xv6 CPU alarm (no)

#### Shell-Exercise

1. Executing simple commands

    ```c++
    // use the execvp(const char *file, char *const argv[]) function
    // this function will duplicate the actions the shell in searching
    // an executable file if the specified file name does not contain '/'.
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

## JOS

```
A OS for the labs assgnments. Only contains pieces of skeleton code.
```

#### Progress
  * Lab 1 : C, Assembly, Tools, and Bootstrapping (no)
  * Lab 2 : Memory Management (no)
  *




