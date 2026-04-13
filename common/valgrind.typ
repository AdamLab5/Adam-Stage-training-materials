#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "../typst/local/themeBootlin.typ": *

#import "../typst/local/common.typ": *


===  Valgrind

#link("https://valgrind.org/")

- #emph[instrumentation framework for building dynamic analysis tools]

  - detect many memory management and threading bugs

  - profile programs

- Supported architectures: x86, x86-64, ARMv7, ARMv8, mips32, s390,
  ppc32 and ppc64

- Very popular tool especially for debugging memory issues

- Runs your program on a synthetic CPU \$arrow.r\$\_significant performance
  impact (100 x slower on SAMA5D3!), but very detailed instrumentation

- Runs on the target. Easy to build with Yocto Project or Buildroot.

#align(center, [#image("valgrind1.png", width: 100%)]) 
===  Valgrind tools

- #emph[Memcheck]: detects memory-management problems

- #emph[Cachegrind]: cache profiler, detailed simulation of the I1, D1
  and L2 caches in your CPU and so can accurately pinpoint the sources
  of cache misses in your code

- #emph[Callgrind]: extension to Cachegrind, provides extra information
  about call graphs

- #emph[Massif]: performs detailed heap profiling by taking regular
  snapshots of a program's heap

- #emph[Helgrind]: thread debugger which finds data races in
  multithreaded programs. Looks for memory locations accessed by
  multiple threads without locking.

- More at #link("https://valgrind.org/info/tools.html")

===  Valgrind examples

- #emph[Memcheck]

  ```
  \$\_valgrind --leak-check=yes <program>
    ==19182== Invalid write of size 4
    ==19182==    at 0x804838F: f (example.c:6)
    ==19182==    by 0x80483AB: main (example.c:11)
    ==19182==  Address 0x1BA45050 is 0 bytes after a block of size 40 alloc'd
    ==19182==    at 0x1B8FF5CD: malloc (vg_replace_malloc.c:130)
    ==19182==    by 0x8048385: f (example.c:5)
    ==19182==    by 0x80483AB: main (example.c:11)
  ```

- #emph[Callgrind]

  ```
  \$\_valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --collect-jumps=yes <program>
  \$\_ls callgrind.out.*
  callgrind.out.1234
  \$\_callgrind_annotate callgrind.out.1234
  ```

===  Kcachegrind - Visualizing Valgrind profiling data

#align(center, [#image("kcachegrind.png", height: 80%)])
#link("https://github.com/KDE/kcachegrind")
