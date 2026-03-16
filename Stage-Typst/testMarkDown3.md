# Processes, scheduling and interrupts

## Processes and scheduling

### Process, thread?

-   Confusion about the terms *process*, *thread* and *task*

-   In UNIX, a process is created using ```fork()``` and is composed of

    -   An address space, which contains the program code, data, stack,
        shared libraries, etc***

    -   A single thread, which is the only entity known by the
        scheduler***

-   Additional threads can be created inside an existing process, using
    ```pthread_create()```

    -   They run in the same address space as the initial thread of the
        process

    -   They start executing a function passed as argument to
        ```pthread_create()```

### Process, thread: kernel point of view

-   In kernel space, each thread running in the system is represented by
    a structure of type

-   From a scheduling point of view, it makes no difference between the
    initial thread of a process and all additional threads created
    dynamically using ```pthread_create()```

![image](slides/kernel-driver-development-processes/address-space***pdf){height="0***4\\textheight"}

### Relation between execution mode, address space and context

-   When speaking about *process* and *thread*, these concepts need to
    be clarified:

    -   *Mode* is the level of privilege allowing to perform some
        operations:

        -   *Kernel Mode*: in this level CPU can perform any operation
            allowed by its architecture; any instruction, any I/O
            operation, any area of memory accessed***

        -   *User Mode*: in this level, certain instructions are not
            permitted (especially those that could alter the global
            state of the machine), some memory areas cannot be accessed***

    -   Linux splits its *address space* in *kernel space* and *user
        space*

        -   *Kernel space* is reserved for code running in *Kernel
            Mode****

        -   *User space* is the place were applications execute
            (accessible from *Kernel Mode*)***

    -   *Context* represents the current state of an execution flow***

        -   The *process context* can be seen as the content of the
            registers associated to this process: execution register,
            stack register\*********

        -   The *interrupt context* replaces the *process context* when
            the interrupt handler is executed***

### A thread life

![image](slides/kernel-driver-development-processes/threads-life***pdf){height="0***8\\textheight"}

### Execution of system calls

![image](slides/kernel-driver-development-processes/syscalls***pdf){width="\\textwidth"}\
The execution of system calls takes place in the context of the thread
requesting them***
