#import "@local/bootlin:0.1.0": *
#import "@local/bootlin-yocto:0.1.0": *
#import "@local/bootlin-utils:0.1.0": *
#import "../../typst/local/themeBootlin.typ": *
#import "../../typst/local/common.typ": *
#show: bootlin-theme.with(
  aspect-ratio: "16-9",

config-common(
  // Compile with `typst c --input handout=1 ...` to generate the handout.
  handout: "handout" in sys.inputs and sys.inputs.handout == "1",
))
#show raw.where(block: true): set block(fill: luma(240), inset: 1em, radius:0.5em, width:100%)
#show raw.where(block: false): r => { text(fill: color-link)[#r] } 

= Optimizing applications
<optimizing-applications>
===  Measuring: strace

- Allows to trace all the system calls made by an application and its
  children.

- Useful to:

  - Understand how time is spent in user space

  - For example, easy to find file open attempts (``` open() ```), file
    access (``` read() ```, ``` write() ```), and memory allocations (```
    mmap2() ```). Can be done without any access to source code!

  - Find the biggest time consumers (low hanging fruit)

  - Find unnecessary work done in applications and scripts. Example:
    opening the same file(s) multiple times, or trying to open files
    that do not exist.

- Limitation: you can’t trace the ``` init ``` process!

===  perf

- Uses hardware performance counters, much faster than Valgrind!

- Need a kernel with #kconfig("CONFIG_PERF_EVENTS") and
  #kconfig("CONFIG_HW_PERF_EVENTS")

- User space tool: ``` perf ```. It is part of the kernel sources so it is
  always in sync with your kernel.

- Usage:

  ```
  perf record /my/command
  ```

- Get the results with:

  ```
  perf report
  ```

- Note: advice to run ``` perf ``` on a filesystem built with glibc.
  Didn’t manage to compile ``` perf ``` on a Musl root filesystem
  (Buildroot 2021.02 status). Once again, glibc is recommended for
  debugging.

===  perf report output

```
# To display the perf.data header info, please use --header/--header-only options.
#
#
# Total Lost Samples: 0
#
# Samples: 5K of event 'cycles'
# Event count (approx.): 1392529663
#
# Overhead  Command  Shared Object             Symbol
# ........  .......  ........................  ....................................
#
    10.72%  ffmpeg   [kernel.kallsyms]         [k] video_get_user
    10.60%  ffmpeg   [kernel.kallsyms]         [k] vector_swi
     4.76%  ffmpeg   libc-2.31.so              [.] ioctl
     4.22%  ffmpeg   [kernel.kallsyms]         [k] __se_sys_ioctl
     3.81%  ffmpeg   [kernel.kallsyms]         [k] __video_do_ioctl
     3.42%  ffmpeg   libavformat.so.58.45.100  [.] avformat_find_stream_info
     2.83%  ffmpeg   [kernel.kallsyms]         [k] video_usercopy
     2.70%  ffmpeg   libc-2.31.so              [.] cfree
     2.58%  ffmpeg   [kernel.kallsyms]         [k] __fget_light
     2.53%  ffmpeg   libpthread-2.31.so        [.] __errno_location
     2.40%  ffmpeg   [kernel.kallsyms]         [k] arm_copy_from_user
     2.26%  ffmpeg   [kernel.kallsyms]         [k] memset
     2.09%  ffmpeg   [kernel.kallsyms]         [k] mutex_unlock
     2.06%  ffmpeg   [kernel.kallsyms]         [k] v4l2_ioctl
     2.05%  ffmpeg   libavcodec.so.58.91.100   [.] av_init_packet
     1.95%  ffmpeg   libc-2.31.so              [.] memset
...
```

Optimizing the application

- Compile the video player with just the features needed at run time.

- Trace and profile the video player with ``` strace ```

- Observe size and time savings
