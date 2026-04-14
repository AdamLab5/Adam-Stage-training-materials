#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "typst/local/themeBootlin.typ": *

#import "typst/local/common.typ": *

#show: bootlin-theme.with( aspect-ratio: "16-9",
config-common(handout: "handout" in sys.inputs and sys.inputs.handout
== "1", ))

#show raw.where(block: true): set block(fill: luma(240), inset: 1em,
radius: 0.5em, width: 100%)

#show raw.where(block: true): set text(size: 13pt)

#show raw.where(block: false): r => text(fill: color-link)[#r]

#show raw.where(lang: "c", block: true): set block(fill: luma(240),
inset: 0.4em, radius: 0.5em, width: 95%, breakable: true, above: 12pt,
below: 12pt)

#show raw.where(lang: "c", block: true): set text(11pt)

#show raw.where(lang: "console", block: true):set block(fill:
luma(240), inset: 0.4em, radius: 0.5em, width: 95%, breakable: true,
above: 6pt)

#show raw.where(lang:"console", block: true): set text(12pt)

== U-Boot Falcon Mode

===  Goal: boot faster!
#table(
columns: (40%, 60%), stroke: none, gutter: 12pt,
[
  U-Boot Falcon Mode is about reducing the time
spent in the bootloader.
],[

#align(center, [#image("2falcons.pdf", height: 65%)])
#[
  #set text(size: 20pt)
#align(center, "Falcons are the fastest animals on Earth!") 
]
#[
  #set text(size: 12pt)
#align(center, "Image credits: "+[#link("https://openclipart.org/detail/287044/falcon-2")])
]
])

===  Example: booting on Microchip SAMA5D36
You first need to understand how your SoC boots:

#table(
columns: (50%, 50%), stroke: none, gutter: 12pt,
[
#align(center, [#image("sama5d36-boot-diagram.png", height: 80%)])
],[
#align(center, [#image("sama5d36-nvm-bootloader-program.png", height: 80%)])

])
#[
  #set text(size: 13pt)
Source: Microchip SAMA5D36 datasheet 
]
#linebreak()
#[
  #v(-0.2em)
  #set text(size: 11pt)
#link("https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-11121-32-bit-Cortex-A5-Microcontroller-SAMA5D3_Datasheet_B.pdf")[https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-11121-32-bit-Cortex-A5-Microcontroller-SAMA5D3_Datasheet_B.pdf]]

===  Normal and Falcon boot on Microchip SAMA5D3
#table(
columns: (20%, 62%, 18%), stroke: none, gutter: 12pt,
[
#v(0.5em)
#align(center, [#image("at91-boot.pdf", width: 102%)])
#[
  #set text(size: 14pt)
  #v(0.7em)
#align(center, "Boot process with U-Boot")
]
],[
#[
  #set text(size: 16pt)
- #strong[RomBoot]: tries to find a valid bootstrap image from various
  storage sources, and load it into SRAM (DRAM not initialized yet).
  Size limited to the SRAM size (here 64 KB).
#v(0.5em)
- #strong[U-Boot SPL] (#emph[Secondary Program Loader]): runs from SRAM
  (inside the SoC). Initializes the DRAM controller plus storage devices
  (MMC, NAND), loads the secondary bootloader into DRAM and starts it.
  Much bigger size limits!
#v(0.5em)

- #strong[U-Boot]: runs from DRAM. Initializes other hardware devices
  (network, USB, etc.). Loads the kernel image from storage or network
  to DRAM and starts it. 
  #emph[This is the part that can be skipped]
#v(0.5em)

- #strong[Linux Kernel]: runs from DRAM. Takes over the system
  completely (the bootloader no longer exists).
#v(0.5em)


This scheme applies to all modern SoCs.
]], [
#align(center, [#image("at91-falcon-boot.pdf", width:105%)])
#[
  #set text(size: 13pt)
  #v(2em)
#align(center, "Boot process without U-Boot "+[#emph[(Falcon mode)]])
]

])

===  Falcon mode advantages and drawbacks
#[
  #set text(size: 21pt)
- Main advantage: since Linux and U-Boot are both loaded to RAM, 
  U-Boot’s #emph[Falcon Mode] mainly saves time by directly loading
  Linux from the SPL instead of loading and executing the full U-Boot
  first.

- Drawback: you lose the flexibility brought by the full U-Boot. You
  have to follow a special procedure to update the kernel binary, DTB
  and kernel command line parameters.

- Advantage: the interactivity offered by the full U-Boot is not
  necessary on a production device. Falcon boot works in the same way on
  all SoCs on which U-Boot SPL is supported. This makes it easier to
  apply this technique on all your projects!
]
===  What U-Boot does (1) 
U-Boot has multiple ways of preparing the kernel boot:
#v(0.5em)
- #emph[ATAGS] - The old way (before Device Tree) 
  U-Boot prepares the Linux kernel command line (`bootargs`), the
  machine ID and other information for Linux in a tagged list, and
  passes its address to Linux through a register.
#v(0.5em)
- #emph[Flattened Device Tree] - The standard way

  - U-Boot checks the device tree loaded in RAM or directly provides its
    own.

  - U-Boot checks the specifics of the hardware (amount and location of
    RAM, MAC address, present devices...), possibly loads corresponding
    Device Tree overlays, and modifies (fixes-up) the Device Tree
    accordingly.

  - U-Boot stores the Linux kernel command line (`bootargs`) in the
    `chosen` section in the Device Tree.

===  What U-Boot does (2)

- #emph[FIT Image] - The new way #v(0.3em)
  - U-Boot loads the kernel(s), device tree(s), initramfs image(s),
    signature(s) from a single file (#emph[FIT Image])

  - That’s used for secure booting, for booting recovery images, etc.

  - U-Boot also implements Device Tree fix-ups, of course.
#v(0.5em)
Using the `spl export` command in U-Boot, you can do such preparation
work ahead of time.
#v(0.5em)
- In this presentation, we just cover standard Device Tree booting.

- U-Boot also has support for FIT Image loading in the SPL, but that may
  still be a bit experimental, and such code must fit within your
  maximum allowable size for the SPL. 
  #linebreak()
  See #projfile("u-boot",
  "arch/arm/cpu/armv8/fsl-layerscape/doc/README.falcon")

===  Falcon mode usage overview (1) 
#[
  #set text(size: 19.9pt)
Here are the generic steps you need to go through:
#v(0.5em)
- Recompile U-Boot with support for Falcon Mode
  (#projconfig("u-boot", "CONFIG_SPL_OS_BOOT")), with support
  for `spl export` (#projconfig("u-boot", "CONFIG_CMD_SPL")), and
  for the way you want to boot.
#v(0.5em)

- Also make sure that #projconfig("u-boot",
  "CONFIG_SPL_SIZE_LIMIT") is set (find the SRAM size for your CPU,
  `0x10000` for SAMA5D36), otherwise, U-Boot won’t complain when the SPL
  is bigger.
#v(0.5em)

- Build the kernel legacy `uImage` file from `zImage` (see next slides)
#v(0.5em)

- Set the kernel command line (`bootargs` environment variable)
#v(0.5em)

- Load the `uImage`, initramfs (if any) and Device Tree images to RAM as
  usual.
]
===  Falcon mode usage overview (2) 
Continued...
#v(0.5em)

- Have U-Boot execute the preprocessing before booting Linux, but stop
  right before doing it: 
  `spl export fdt <kernel-addr> <initramfs-addr> <dtb-addr>`
#v(0.5em)

- Save the exported data (#emph[ARGS]) from RAM to storage, in
  #emph[Flattened Device Tree] form, so that the SPL can load it and
  directly pass it to the Linux kernel. The below environment variables
  will help:

  - `fdtargsaddr`: location of #emph[ARGS] in RAM

  - `fdtargslen`: size of #emph[ARGS] in RAM

- If supported by your board (code explanations given later), set your
  `boot_os` environment variable to `yes/Yes/true/True/1` to enable
  direct OS booting.

===  spl export example output

#table(
columns: (65%, 35%), stroke: none, gutter: 16pt,
[
  
```
=> fatload mmc 0:1 0x21000000 uImage
5483584 bytes read in 530 ms (9.9 MiB/s)
=> fatload mmc 0:1 0x22000000 dtb
27795 bytes read in 7 ms (3.8 MiB/s)
=> setenv bootargs console=ttyS0,115200
=> spl export fdt 0x21000000 - 0x22000000
## Booting kernel from Legacy Image at 21000000 ...
   Image Name:   Linux-5.12.6
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    5483520 Bytes = 5.2 MiB
   Load Address: 20008000
   Entry Point:  20008000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 22000000
   Booting using the fdt blob at 0x22000000
   Loading Kernel Image
   Loading Device Tree to 2fb2c000, end 2fb35c92 ... OK
subcommand not supported subcommand not supported
   Loading Device Tree to 2fb1f000, end 2fb2bc92 ... OK
Argument image is now in RAM: 0x2fb1f000
```

],[

#align(center, [#image("horus.pdf", height: 80%)])
#[
  #v(1em)
  #set text(size: 12pt)
#align(center, "Image credits:") 
#linebreak()
#v(-1.2em)
#align(center, [#link("https://openclipart.org/detail/292953/horus")])
]

])

===  How to create the uImage file 
Microchip SAMA5D3 Xplained board example
#v(0.5em)

- Need to know the loading address that should be used for your board.
  Usually on ARM32, it’s the starting physical address of RAM plus
  `0x8000`.
#v(0.5em)

- Either generate it from the Linux build system: 
#v(0.5em)

  ```
  make LOADADDR=0x20008000 uImage
  ```
#v(0.5em)

- Or generate it using U-Boot’s `mkimage` command: 
#v(0.5em)

  #text(size:20pt)[
  ```
  mkimage -A arm -O linux -C none  -T kernel 
  -a 0x20008000 -e 0x20008000 
  -n "Linux-5.12.6" 
  -d arch/arm/boot/zImage arch/arm/boot/uImage
  ```
]
===  U-Boot code changes to support a new board (1) 
Your `board/<vendor>/<board>/<board>.c` file must at least 
implement the #projfunc("u-boot", "spl_start_uboot") function. 
Here’s the most typical example:
#v(0.5em)
```c
#ifdef CONFIG_SPL_OS_BOOT
int spl_start_uboot(void)
{
       if (CONFIG_IS_ENABLED(SPL_SERIAL_SUPPORT) && serial_tstc() && serial_getc() == 'c')
               /* break into full u-boot on 'c' */
               return 1;

       if (CONFIG_IS_ENABLED(SPL_ENV_SUPPORT)) {
               env_init();
               env_load();
               if (env_get_yesno("boot_os") != 1)
                       return 1;
       }
       return 0;
}
#endif
```

===  U-Boot code changes to support a new board (2) 
If you cannot fit support for an environment in the SPL, 
the #projfunc("u-boot", "spl_start_uboot") function can be
simpler:
#v(0.5em)
```c
#ifdef CONFIG_SPL_OS_BOOT
int spl_start_uboot(void)
{
       if (CONFIG_IS_ENABLED(SPL_SERIAL_SUPPORT) && serial_tstc() && serial_getc() == 'c')
               /* break into full u-boot on 'c' */
               return 1;

       return 0;
}
#endif
```

===  U-Boot code changes to support a new board (3) 
Or even, if reading characters from the serial line doesn’t work:
#v(0.5em)
```c
#ifdef CONFIG_SPL_OS_BOOT
int spl_start_uboot(void)
{
       return 0;
}
#endif
```
#v(0.5em)
You may also need extra defines to be set, but you will find which ones
are missing at compile time.

===  How to fall back to U-Boot

#table(
columns: (68%, 32%), stroke: none, gutter: 12pt,
[

- If supported by your board, hit the specified key on the serial
  console and back in U-Boot, disable the `boot_os` environment
  variable. That’s it.
#v(0.5em)
- Otherwise, try to cause OS loading to fail. The easiest way is to
  erase the kernel binary and if needed the `spl export` output.
#v(0.5em)
- If this doesn’t work, re-compile and update the SPL without Falcon
  mode support, or temporarily modify the #projfunc("u-boot",
  "spl_start_uboot") function to always return `1`. This way, you
  don’t lose your configuration.

],[
#align(center, [#image("falcon-blue.png", height: 60%)])


])

===  Booting from raw MMC - Proposed storage layout

#table(
columns: (50%, 50%), stroke: none, gutter: 12pt,
[ 
  #align(center, [
  For use on Microchip SAMA5D3 Xplained 
  #v(0.5em)
  #table(
  columns: 3,
  align: (col, row) => (left,center,center,).at(col),
  inset: 6pt,
  
  
    
  [
    #set text(size: 14pt)
  #align(center, "Offset" +[#linebreak()] +"(512 b sector)")
  ],
  [#set text(size: 14pt)
  OffSet (bytes)],
  [#set text(size: 14pt)
  Contents],
  [#set text(size: 14pt)
  0x0],
  [#set text(size: 14pt)
  0],
  [
    #set text(size: 14pt)
    #align(center, "MBR" + [#linebreak()] + "(Master Boot Record)")],
  [#set text(size: 14pt)
  0x100],
  [#set text(size: 14pt)
  128 KiB],
  [#set text(size: 14pt)
  SPL ARGS],
  [#set text(size: 14pt)
  0x200],
  [#set text(size: 14pt)
  256 KiB],
  [#set text(size: 14pt)
  u-boot.img],
  [#set text(size: 14pt)
  0x1000],
  [#set text(size: 14pt)
  2 MiB],
  [#set text(size: 14pt)
  uImage],
  [#set text(size: 14pt)
  0x4000],
  [#set text(size: 14pt)
  16 MiB],
  [#set text(size: 14pt)
  Start of FAT partition],

  )

])


],[
  

- A FAT partition is required to store the SPL file (`boot.bin`).
  SAMA5D36 doesn’t support an SPL file on raw MMC (unlike i.MX6).
#v(0.5em)
- Caution: partition offsets should be a multiple of the #emph[segment]
  size, as indicated by the device’s `preferred_erase_size` attribute
  under `/sys/bus/mmc/devices/`.


])

===  Booting from raw MMC - Configuration 
U-Boot configuration (starting from `sama5d3_xplained_mmc_defconfig`): 
#[
  #set text(size: 17pt)
#projconfigval("u-boot", "CONFIG_SPL_OS_BOOT", "y") 
#linebreak()
#projconfigval("u-boot", "CONFIG_SPL_SIZE_LIMIT", "0x10000") 
#linebreak()
#projconfigval("u-boot", "CONFIG_SPL_LEGACY_IMAGE_FORMAT", "y") 
#linebreak()
#projconfigval("u-boot", "CONFIG_SPL_MMC", "y") 
#linebreak()
#projconfigval("u-boot", "CONFIG_CMD_SPL", "y") 
#linebreak()
#projconfigval("u-boot", "CONFIG_CMD_SPL_WRITE_SIZE", "0x7000") 
#linebreak()
#projconfigval("u-boot", "CONFIG_SYS_MMCSD_RAW_MODE_U_BOOT_SECTOR", "0x200") 
#linebreak()
#projconfignotset("u-boot", "CONFIG_SPL_FS_FAT") 
]
#linebreak()
#[
  #set text(size: 14pt)
  #v(1em)
include/configs/sama5d3_xplained.h
]
#v(-0.1em)
```c
#define CONFIG_SYS_MMCSD_RAW_MODE_ARGS_SECTOR 0x100  /* 256 KiB */
#define CONFIG_SYS_MMCSD_RAW_MODE_ARGS_SECTORS (CONFIG_CMD_SPL_WRITE_SIZE / 512)
#define CONFIG_SYS_MMCSD_RAW_MODE_KERNEL_SECTOR 0x1000 /* 2 MiB */
#define CONFIG_SYS_SPL_ARGS_ADDR 0x22000000
```

===  Booting from Raw MMC - Writing to raw storage

#table(
columns: (45%, 55%), stroke: none, gutter: 30pt,
[ 
  #[
  #set text(size: 16pt)
  On your GNU/Linux host:

- Write U-Boot (using the same block size as sector size, to get the
  same offsets): 
  `sudo dd if=u-boot.img of=/dev/sdc bs=512 seek=512 conv=sync`

- Write `uImage`: 
  `sudo dd if=uImage of=/dev/sdc bs=512 seek=4096 conv=sync`

- Reminder: in our case (SAMA5D36), the SPL is copied to `boot.bin` in a
  FAT partition.
]
],[
  #[
    #set text(size: 13.5pt)
  
On your U-Boot target, after `spl export`:
#v(0.5em)
- Select the right MMC 
  device for `mmc write`:
#v(0.5em)
  ```
  => mmc list Atmel mci: 0 (SD)
  Atmel mci: 1

  => mmc dev 0
  switch to partitions #0, OK
  mmc0 is current device
  ```
#v(0.5em)
- Check the size of ARGS
#v(0.5em)
  ```
  => printenv fdtargslen
  ```
#v(0.5em)
- Divide it by the sector size (512), and convert it to hexadecimal
  (round it up), and use the value to save the ARGS to raw MMC:
#v(0.5em)
  ```
  => mmc write ${fdtargsaddr} 0x100 0x67
  ```
#v(0.5em)
- #strong[Caution]: the last argument of `mmc write` is a #strong[number
  of sectors]. If you pass a number of bytes, you’ll erase your FAT
  partition!
]

])

===  Booting from Raw MMC - Results and notes

#table(
columns: (50%, 50%), stroke: none, gutter: 12pt,
[
  #[
    #set text(size: 16pt)
  Reference test
#v(0.5em)
- Loading `zImage` and `dtb` from FAT through `fatload` and using a zero
  `bootdelay`: #linebreak()
  `setenv bootdelay 0`#linebreak()
  `setenv bootcmd ’fatload mmc 0:`#linebreak()`1 0x21000000 zImage; fatload mmc 0:`#linebreak()`1 0x22000000; bootz 0x21000000 - 0x22000000'`
#v(0.5em)
- Not completely fair because we have the filesystem overhead, but
  that’s the standard / easiest way on MMC. We could have loaded images
  from raw MMC, but that’s very inconvenient.
#v(0.5em)
- Best result (using `grabserial`): #linebreak()
  `[3.452681 0.000099] Please press Enter to activate this console.`
  ]
],[ 
  #[
    #set text(size: 16pt)
    Falcon boot test
#v(0.5em)
- Best result: 
  `[3.191228 0.000134] Please press Enter to activate this console.`
#v(0.5em)
- We saved 261 ms, but that’s disappointing.
#v(0.5em)
- Adding instrumentation to the SPL allowed us to understand why:
#v(0.5em)
  - Time to load the kernel from U-Boot / FAT: 530 ms

  - Time to load the kernel from SPL / raw MMC: 1.010 ms
#v(0.5em)
- Here the specific MMC driver in SPL has poor performance (lack of
  DMA?)
#v(0.5em)
- We had much better results on different hardware, such as saving 1.2s
  on i.MX6, and 1.05s on TI AM3358 (Beagle Bone Black, loading from FAT
  with U-Boot SPL 2022.04).

  ]
])

===  Booting from raw NAND - Configuration

#table(
columns: (55%, 50%), stroke: none, gutter: 0.5em,
[ 

#[
    #set text(size: 19pt)
Proposed NAND layout #linebreak()
For use on Microchip SAMA5D3 Xplained 
]
#v(0.5em)
#align(center)[#table(
  columns: 3,
  align: (col, row) => (left,center,center,).at(col),
  inset: 6pt,
  [#set text(size: 15pt)
  Offset], [#set text(size: 15pt)
  Size], [#set text(size: 15pt)
  Contents],
  [#set text(size: 15pt)
  0x0],
  [#set text(size: 15pt)
  256 KiB],
  [#set text(size: 15pt)
  SPL (`spl/u-boot-spl.bin`)],
  [#set text(size: 15pt)
  0x40000],
  [#set text(size: 15pt)
  1 MiB],
  [#set text(size: 15pt)
  U-Boot (`u-boot.bin`)],
  [#set text(size: 15pt)
  0x15.50000],
  [#set text(size: 15pt)
  128 KiB],
  [#set text(size: 15pt)
  U-Boot redundant environment],
  [#set text(size: 15pt)
  0x160000],
  [#set text(size: 15pt)
  128 KiB],
  [#set text(size: 15pt)
  U-Boot environment],
  [#set text(size: 15pt)
  0x180000],
  [#set text(size: 15pt)
  128 KiB],
  [#set text(size: 15pt)
  Original DTB or CMD],
  [#set text(size: 15pt)
  0x1a0000],
  [#set text(size: 15pt)
  6.375 MiB],
  [#set text(size: 15pt)
  uImage],
  [#set text(size: 15pt)
  0x800000],
  [],
  [#set text(size: 15pt)
  Other partitions],
)
]
#v(0.5em)
#[
  #set text(size: 18pt)
Notes:
#v(0.3em)
- Only the SPL offset is hardcoded
#v(0.3em)
- All others can be configured differently
#v(0.3em)
- Offsets must be a multiple of the erase block size (128 KiB)
]
],[ 
  #[
    #set text(size: 18pt)
    #v(-0.5em)
    U-Boot configuration #linebreak()
  ]
#[
  #set text(size: 13pt)
  #v(0.2em)
#projconfigval("u-boot", "CONFIG_SPL_OS_BOOT", "y")
#v(0.2em)
#projconfigval("u-boot", "CONFIG_SPL_SIZE_LIMIT", "0x10000")
#v(0.2em)
#projconfigval("u-boot", "CONFIG_ENV_OFFSET", "0x160000") 
#v(0.2em)
#projconfigval("u-boot", "CONFIG_ENV_OFFSET_REDUND",
"0x140000") 
#v(0.2em)
#projconfigval("u-boot", "CONFIG_SPL_LEGACY_IMAGE_FORMAT",
"y") 
#v(0.2em)
#projconfigval("u-boot", "CONFIG_SPL_NAND_SUPPORT", "y")
#v(0.2em)
#projconfigval("u-boot", "CONFIG_SPL_NAND_DRIVERS", "y") 
#v(0.2em)
#projconfigval("u-boot", "CONFIG_SPL_NAND_BASE", "y") 
#v(0.2em)
#projconfigval("u-boot", "CONFIG_CMD_SPL_WRITE_SIZE",
"0x7000") 
#v(0.2em)
#projconfigval("u-boot", "CONFIG_CMD_SPL_NAND_OFS",
"0x180000") 
#linebreak()
#[
  #set text(size: 16pt)
(starting from #linebreak() `sama5d3_xplained_nandflash_defconfig`)
]
]
#[
  #set text(size: 14pt)
  #linebreak()
include/configs/sama5d3_xplained.h
]
#v(-0.3em)
```c
/* Generic settings */
#define CONFIG_SYS_NAND_U_BOOT_OFFS     0x40000

/* Falcon boot support on raw NAND */
#define CONFIG_SYS_NAND_SPL_KERNEL_OFFS 0x1a0000
```

])

===  Booting from raw NAND - Results and notes

- Reference test #v(0.5em)

  - To be fair, using a zero `bootdelay` and the exact `zImage` and
    `dtb` size: #linebreak()
    `setenv bootdelay 0` #linebreak() `setenv bootcmd ’nand read 0x21000000 0x1a0000
    0x53ac00; nand read 0x22000000 0x180000 0x6c93; bootz 0x21000000 -
    0x22000000'` #v(0.3em)

  - Best result (using `grabserial`): #linebreak()
    `[4.320618 0.000470] Please press Enter to activate this console.` #v(0.5em)

- Falcon boot test #v(0.5em)

  - Best result (using `grabserial`): 
    `[3.768543 0.000125] Please press Enter to activate this console.` #v(0.3em)

  - We saved 552 ms!

===  U-Boot code and debugging Falcon Mode

#table(
columns: (70%, 30%), stroke: none, gutter: 12pt,
[

- Depending on how you boot, read the corresponding code:

  - #projfile("u-boot", "common/spl/spl_mmc.c")

  - #projfile("u-boot", "common/spl/spl_nand.c")

  - Other files in #projfile("u-boot", "common/spl/")#v(0.3em)

- If booting doesn’t work, the easiest way is to add `puts();` lines to
  trace strategic functions and check return values. You’ll get the
  messages in the serial console.

],[

#align(center, [#image("falcon-red.png", height: 70%)])


])

===  Issues and lessons learned (1)
#[
  #set text(size: 21pt)
- #emph[SPL storage driver performance]: not on all platforms, 
  but at least here on Microchip SAMA5.#v(0.3em)

- #emph[Features limited by space]: what can be done with Falcon booting
  is not limited by U-Boot features, but by how much code can fit in the
  limited SRAM. 
  This is why I couldn’t show Falcon booting from a FAT partition,
  because adding support for this filesystem and disk partitions to the
  SPL doesn’t fit in the maximum size possible on the particular
  platform chosen for the demo.#v(0.3em)

- #emph[U-Boot initializations]: in addition to the FDT fixups without
  which the Linux kernel may not boot, the Linux kernel may also rely on
  some initializations performed by U-Boot. Before such dependencies can
  be removed by updating kernel drivers, you may need to hardcode such
  initializations in the SPL, provided you have enough space!
]
===  Issues and lessons learned (2)
#[
  #set text(size: 20.8pt)
- #emph[Limited automation]: while the `uImage` file can be updated
  automatically in the storage image, any change in the kernel command
  line or Device Tree must go through the `spl export` command
  #strong[on the board]. The FDT fixups done by U-Boot are not trivial
  to reproduce. This makes it difficult to prepare production images
  without a manual step in U-Boot.#v(0.3em)

- #emph[No decompression]: U-Boot currently doesn’t seem to support
  decompression in the SPL. If your architecture doesn’t support kernel
  self-decompression and relies on the bootloader (e.g. arm64 or riscv),
  Falcon mode won’t be available if you are using a compressed kernel.#v(0.3em)

- Falcon mode severely complicates the implementation of A/B updates, as
  all the logic to switch between versions should be implemented in the
  SPL.#v(0.3em)

- #emph[Side note]: Found that U-Boot’s `bootm` was noticeably slower
  than `bootz` (+170 ms)
]
===  Further work

#table(
columns: (65%, 35%), stroke: none, gutter: 12pt,
[

- Improve raw MMC read performance in the SPL on Microchip SAMA5#v(0.3em)

- Didn’t try with what U-Boot calls the #emph[Raw] kernel images yet,
  supported with #[#set text(size: 18pt)
  #projconfig("u-boot",
  "CONFIG_SPL_RAW_IMAGE_SUPPORT")]. Assuming this corresponds to
  the `arch/arm/boot/Image`#v(0.3em)

- Didn’t try FIT Image support in SPL yet. Will try on an SoC with more
  space for SPL (i.MX)
],[

#align(center, [#image("millenium-falcon.pdf", width: 110%)])
#[
  #v(-2em)
  #set text(size: 13pt)
#align(center, "Image credits:") #linebreak()
]
#[
  #set text(size: 13pt)
  #v(-1em)
#align(center, [#link("https://openclipart.org/detail/224913/clip-is-a-brick-star-wars-millenium-falcon-set-4488")])
]

])

===  References

- Bootlin’s commit to support Falcon boot on SAMA5D3 Xplained in
  mainline U-Boot:
  #link("https://source.denx.de/u-boot/u-boot/-/commit/ea83ea5afd18")#v(0.5em)

- U-Boot’s #projfile("u-boot", "doc/README.falcon") file#v(0.5em)

- Linus Walleij: #emph[How the ARM32 kernel decompresses]: #linebreak()
  #link("https://people.kernel.org/linusw/how-the-arm32-linux-kernel-decompresses")

#setuplabframe([Reduce bootloader time],[

- Experiment with faster storage#v(0.3em)

- Skipping U-Boot through the #emph[Falcon Mode], directly booting Linux
  from U-Boot SPL.#v(0.3em)

- Measuring the final boot time.

])
