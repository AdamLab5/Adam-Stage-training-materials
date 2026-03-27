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

= Autotools basics
<autotools-basics>
===  `configure.ac` language

- Really a shell script

- Processed through the ``` m4 ``` preprocessor

- Shell script augmented with special constructs for portability:

  - ``` AS_IF ``` instead of shell ``` if ... then .. fi ```

  - ``` AS_CASE ``` instead of shell ``` case ... esac ```

  - etc.

- #emph[autoconf] provides a large set of #emph[m4] macros to perform
  most of the usual tests

- Make sure to quote macro arguments with ``` [] ```

===  Minimal `configure.ac`

configure.ac

```bash
AC_INIT([hello], [1.0])
AC_OUTPUT
```

- ``` AC_INIT ```

  - Every configure script must call ``` AC_INIT ``` before doing
    anything else that produces output.

  - Process any command-line arguments and perform initialization and
    verification.

  - Prototype: 
    ``` AC_INIT (package, version, [bug-report], [tarname], [url])
    ```

- ``` AC_OUTPUT ```

  - Every ``` configure.ac ```, should finish by calling ``` AC_OUTPUT ```.

  - Generates and runs config.status, which in turn creates the
    makefiles and any other files resulting from configuration.

===  Minimal `configure.ac` example

```console
$ cat configure.ac AC_INIT([hello], [1.0])
AC_OUTPUT
$ ls configure.ac
$ autoreconf -i
$ ls autom4te.cache  configure  configure.ac
$ ./configure configure: creating ./config.status
$ ls autom4te.cache  config.log    config.status configure       configure.ac
$ wc -l configure
2390 configure
```

===  Additional basic macros

- ``` AC_PREREQ ```

  - Verifies that a recent enough version of #emph[autoconf] is used

  - ``` AC_PREREQ([2.68]) ```

- ``` AC_CONFIG_SRCDIR ```

  - Gives the path to one source file in your project

  - Allows #emph[autoconf] to check that it is really where it should be

  - ``` AC_CONFIG_SRCDIR([hello.c]) ```

- ``` AC_CONFIG_AUX_DIR ```

  - Tells #emph[autoconf] to put the auxiliary build tools it requires
    in a different directory, rather than the one of ``` configure.ac ```

  - Useful to keep cleaner build directory

===  Checking for basic programs

- ``` AC_PROG_CC ```, makes sure a C compiler is available

- ``` AC_PROG_CXX ```, makes sure a C++ compiler is available

- ``` AC_PROG_AWK ```, ``` AC_PROG_GREP ```, ``` AC_PROG_LEX ```, ```
  AC_PROG_YACC ```, etc.

===  Checking for basic programs: example

configure.ac

```
AC_INIT([hello], [1.0])
AC_PROG_CC
AC_OUTPUT
```

```console
$ ./configure checking for gcc... gcc checking whether the C compiler works... yes checking for C compiler default output file name... a.out checking for suffix of executables...
checking whether we are cross compiling... no checking for suffix of object files... o checking whether we are using the GNU C compiler... yes checking whether gcc accepts -g... yes checking for gcc option to accept ISO C89... none needed configure: creating ./config.status
```

===  `AC_CONFIG_FILES`

- ``` AC_CONFIG_FILES (file..., [cmds], [init-cmds]) ```

- Make ``` AC_OUTPUT ``` create each file by copying an input ``` file ```
  (by default ``` file.in ```), substituting the #emph[output variable
  values].

- Typically used to turn the Makefile templates ``` Makefile.in ``` files
  into final ``` Makefile ```.

- Example: 
  ``` AC_CONFIG_FILES([Makefile src/Makefile]) ```

- ``` cmds ``` and ``` init-cmds ``` are rarely used, see the
  #emph[autoconf] documentation for details.

===  Output variables

- #emph[autoconf] will replace ``` @variable@ ``` constructs by the
  appropriate values in files listed in ``` AC_CONFIG_FILES ```

- Long list of standard variables replaced by #emph[autoconf]

- Additional shell variables declared in ``` configure.ac ``` can be
  replaced using ``` AC_SUBST ```

- The following three examples are equivalent:

  ```
  AC_SUBST([FOO], [42])
  ```

  ```
  FOO=42
  AC_SUBST([FOO])
  ```

  ```
  AC_SUBST([FOO])
  FOO=42
  ```

===  `AC_CONFIG_FILES` example (1/2)

configure.ac

```
AC_INIT([hello], [1.0])
AC_PROG_CC
FOO=42
AC_SUBST([FOO])
AC_CONFIG_FILES([testfile])
AC_OUTPUT
```

testfile.in

```
abs_builddir = @abs_builddir@
CC = @CC@
FOO = @FOO@
```

===  `AC_CONFIG_FILES` example (2/2)

Executing ``` ./configure ```

```console
/tmp/foo$ ./configure checking for gcc... gcc checking whether the C compiler works... yes checking for C compiler default output file name... a.out checking for suffix of executables... 
checking whether we are cross compiling... no checking for suffix of object files... o checking whether we are using the GNU C compiler... yes checking whether gcc accepts -g... yes checking for gcc option to accept ISO C89... none needed configure: creating ./config.status config.status: creating testfile
```

Generated ``` testfile ```

```
abs_builddir = /tmp/foo CC = gcc FOO = 42
```

===  `configure.ac`: a shell script

- It is possible to include normal shell constructs in ``` configure.ac
  ```

- Beware to not use #emph[bashisms]: use only POSIX compatible
  constructs

#columns(gutter: 8pt)[

configure.ac

```
AC_INIT([hello], [1.0])
echo "The value of CC is $CC"
AC_PROG_CC
echo "The value of CC is now $CC"
FOO=42
AC_SUBST([FOO])
if test $FOO -eq 42 ; then
   echo "The value of FOO is correct!"
fi AC_CONFIG_FILES([testfile])
AC_OUTPUT
```

#colbreak()

Running ``` ./configure ```

```console
The value of CC is 
checking for gcc... gcc checking whether the C compiler works... yes checking for C compiler default output file name... a.out checking for suffix of executables... 
checking whether we are cross compiling... no checking for suffix of object files... o checking whether we are using the GNU C compiler... yes checking whether gcc accepts -g... yes checking for gcc option to accept ISO C89... none needed The value of CC is now gcc The value of FOO is correct!
configure: creating ./config.status config.status: creating testfile
```


]

===  Writing `Makefile.in`?

- At this point, we have seen the very basics of #emph[autoconf] to
  perform the configuration side of our software

- We could use ``` AC_CONFIG_FILES ``` to generate ``` Makefile ``` from
  ``` Makefile.in ```

- However, writing a ``` Makefile.in ``` properly is not easy, especially
  if you want to:

  - be portable

  - automatically handle dependencies

  - support conditional compilation

- For these reasons, ``` Makefile.in ``` are typically not written
  manually, but generated by #emph[automake] from a ``` Makefile.am ```
  file

===  `Makefile.am` language

- Really just a ``` Makefile ```

  - You can include regular #emph[make] code

- Augmented with #emph[automake] specific constructs that are expanded
  into regular #emph[make] code

- For most situations, the #emph[automake] constructs are sufficient to
  express what needs to be built

===  `Makefile.am` minimal example

- The minimal example of ``` Makefile.am ``` to build just one C file into
  a program is only two lines:

Makefile.am

```
bin_PROGRAMS = hello hello_SOURCES = main.c
```

===  Enabling #emph[automake] in `configure.ac`

- To enable #emph[automake] usage in ``` configure.ac ```, you need:

  - A call to ``` AM_INIT_AUTOMAKE ```

  - Generate the ``` Makefile ``` using ``` AC_CONFIG_FILES ```

- #emph[automake] will generate the ``` Makefile.in ``` at
  #emph[autoreconf] time, and #emph[configure] will generate the final
  ``` Makefile ```

configure.ac

```
AC_INIT([hello], [1.0])
AM_INIT_AUTOMAKE([foreign 1.13])
AC_PROG_CC
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
```

===  `AM_INIT_AUTOMAKE`

- ``` AM_INIT_AUTOMAKE([OPTIONS]) ```

- Interesting options:

  - ``` foreign ```, tells #emph[automake] to not require all the GNU
    Coding Style files such as ``` NEWS ```, ``` README ```, ``` AUTHORS ```,
    etc.

  - ``` dist-bzip2 ```, ``` dist-xz ```, etc. tell #emph[automake] which
    tarball format should be generated by ``` make dist ```

  - ``` subdir-objects ``` tells #emph[automake] that the objects are
    placed into the subdirectory of the build directory corresponding to
    the subdirectory of the source file

  - #emph[version], e.g ``` 1.14.1 ```, tells the minimal ``` automake ```
    version that is expected

===  `Makefile.am` syntax

- An #emph[automake] parsable Makefile.am is composed of #strong[product
  list variables]:

  ```
  bin_PROGRAMS = hello
  ```

- And #strong[product source variables]:

  ```
  hello_SOURCES = main.c
  ```

===  Product list variables

```
[modifier-list]prefix_PRIMARY = product1 product2 ...
```

- ``` prefix ``` is the installation prefix, i.e. where it should be
  installed

  - All ``` *dir ``` variables from #emph[autoconf] can be used, without
    their ``` dir ``` suffix: use ``` bin ``` for ``` bindir ```

  - E.g.: ``` bindir ```, ``` libdir ```, ``` includedir ```, ``` datadir ```,
    etc.

- ``` PRIMARY ``` describes what type of thing should be built:

  - ``` PROGRAMS ```, for executables

  - ``` LIBRARIES ```, ``` LTLIBRARIES ```, for libraries

  - ``` HEADERS ```, for publicly installed header files

  - ``` DATA ```, arbitrary data files

  - ``` PYTHON ```, ``` JAVA ```, ``` SCRIPTS ```

  - ``` MANS ```, ``` TEXINFOS ```, for documentation

- After the ``` = ``` sign, list of products to be generated

===  Product source variables

```
[modifier-list]product_SOURCES = file1 file2 ...
```

- The ``` product ``` is the normalized name of the product, as listed in
  a #emph[product list variable]

  - The normalization consists in replacing special characters such as
    ``` . ``` or ``` + ``` by ``` _ ```. For example, ``` libfoo+.a ``` in a
    #emph[product list variable] gives the ``` libfoo__a_SOURCES ```
    product source variable.

- ``` _SOURCES ``` is always used, it’s not like a configurable
  #emph[primary].

  - Contains the list of files containing the source code for the
    product to be built.

  - Both source files #emph[and] header files should be listed.

===  Example: building multiple programs

Makefile.am

```
bin_PROGRAMS = hello test hello_SOURCES = main.c common.c common.h test_SOURCES = test.c common.c common.h
```

- Building two programs: ``` hello ``` and ``` test ```

- Shared source files: ``` common.c ``` and ``` common.h ```

Your first #emph[autotools] project

- Your first `configure.ac`

- Adding and building a program

- Going further: ``` autoscan ``` and ``` make dist ```
