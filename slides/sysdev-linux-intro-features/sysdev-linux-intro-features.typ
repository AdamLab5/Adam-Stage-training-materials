===  Linux kernel in the system

#align(center, [#image("linux-kernel-in-system.pdf", height: 80%)])

===  Linux kernel main roles

- #strong[Manage all the hardware resources]: CPU, memory, I/O.

- Provide a #strong[set of portable, architecture and hardware
  independent APIs] to allow user space applications and libraries to
  use the hardware resources.

- #strong[Handle concurrent accesses and usage] of hardware resources
  from different applications.

  - Example: a single network interface is used by multiple user space
    applications through various network connections. The kernel is
    responsible for "multiplexing" the hardware resource.

===  System calls


#table(columns: (50%, 50%), stroke: none, [

- The main interface between the kernel and user space is the set of
  system calls

- About 400 system calls that provide the main kernel services

  - File and device operations, networking operations, inter-process
    communication, process management, memory mapping, timers, threads,
    synchronization primitives, etc.

- This system call interface is wrapped by the C library, and user space
  applications usually never make a system call directly but rather use
  the corresponding C library function

#align(center, [#image("system-calls.pdf", width: 100%)])
Image credits (Wikipedia): 
#link("https://bit.ly/2U2rdGB") 
])

===  Pseudo filesystems

- Linux makes system and kernel information available in user space
  through #strong[pseudo filesystems], sometimes also called
  #strong[virtual filesystems]

- Pseudo filesystems allow applications to see directories and files
  that do not exist on any real storage: they are created and updated on
  the fly by the kernel

- The two most important pseudo filesystems are

  - `proc`, usually mounted on `/proc`: 
    Operating system related information (processes, memory management
    parameters...)

  - `sysfs`, usually mounted on `/sys`: 
    Representation of the system as a tree of devices connected by
    buses. Information gathered by the kernel frameworks managing these
    devices.
