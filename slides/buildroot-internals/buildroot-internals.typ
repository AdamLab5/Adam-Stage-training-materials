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

#show raw.where(block: true): set text(size: 11pt)

#show raw.where(block: false): r => text(fill: color-link)[#r]

#show raw.where(lang: "c", block: true): set block(fill: luma(240),
inset: 0.4em, radius: 0.5em, width: 95%, breakable: true, above: 12pt,
below: 12pt)

#show raw.where(lang: "c", block: true): set text(11pt)

#show raw.where(lang: "console", block: true):set block(fill:
luma(240), inset: 0.4em, radius: 0.5em, width: 95%, breakable: true,
above: 6pt)

#show raw.where(lang:"console", block: true): set text(12pt)

= Understanding Buildroot internals

===  Configuration system

- Uses, almost unchanged, the #emph[kconfig] code from the kernel, in
  `support/kconfig` (variable `CONFIG`)

- #emph[kconfig] tools are built in `\$(BUILD_DIR)/buildroot-config/`

- The main `Config.in` file, passed to *config, is at the top-level of
  the Buildroot source tree

```make
CONFIG_CONFIG_IN = Config.in CONFIG = support/kconfig BR2_CONFIG = \$(CONFIG_DIR)/.config

-include \$(BR2_CONFIG)

\$(BUILD_DIR)/buildroot-config/%onf:
        mkdir -p \$(@D)/lxdialog
        ... \$(MAKE) ... -C \$(CONFIG) -f Makefile.br \$(@F)

menuconfig: \$(BUILD_DIR)/buildroot-config/mconf outputmakefile
        @\$(COMMON_CONFIG_ENV) \$< \$(CONFIG_CONFIG_IN)
```

===  Configuration hierarchy

#columns(gutter: 8pt)[
#align(center, [#image("menuconfig-toplevel.png", width: 100%)])
#colbreak()
#align(center, [#image("config-hierarchy.pdf", width: 100%)])

]

===  When you run `make`...

#align(center, [#image("global-build-logic.pdf", width: 100%)])

===  Where is `\$(PACKAGES)` filled?

Part of `package/pkg-generic.mk`

```make

#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages

define inner-generic-package
 ...
\$(2)_KCONFIG_VAR = BR2_PACKAGE_\$(2)
 ...
ifeq (\$\$(\$\$(\$(2)_KCONFIG_VAR)),y)
PACKAGES += \$(1)
endif # \$(2)_KCONFIG_VAR

endef # inner-generic-package
```

- Adds the lowercase name of an enabled package as a make target to the
  `\$(PACKAGES)` variable

- `package/pkg-generic.mk` is really the core of the package
  infrastructure

===  Diving into `pkg-generic.mk`

- The `package/pkg-generic.mk` file is divided in two main parts:

  + Definition of the actions done in each step of a package build
    process. Done through #emph[stamp file targets].

  + Definition of the `inner-generic-package`, `generic-package` and
    `host-generic-package` macros, that define the sequence of actions,
    as well as all the variables needed to handle the build of a
    package.

===  Definition of the actions: code

#columns(gutter: 8pt)[

```make
\$(BUILD_DIR)/%/.stamp_downloaded:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_extracted:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_patched:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_configured:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_built:
        # Do some stuff here
        \$(Q)touch \$@
```

#colbreak()

```make
\$(BUILD_DIR)/%/.stamp_host_installed:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_staging_installed:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_images_installed:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_target_installed:
        # Do some stuff here
        \$(Q)touch \$@

\$(BUILD_DIR)/%/.stamp_installed:
        # Do some stuff here
        \$(Q)touch \$@
```


]

- `\$(BUILD_DIR)/%/` \$\\$\_build directory of any package

- a #emph[make] target depending on one stamp file will trigger the
  corresponding action

- the #emph[stamp file] prevents the action from being re-executed

===  Action example 1: download

```make
# Retrieve the archive
\$(BUILD_DIR)/%/.stamp_downloaded:
        \$(foreach hook,\$(\$(PKG)_PRE_DOWNLOAD_HOOKS),\$(call \$(hook))\$(sep))
        [...]
        \$(foreach p,\$(\$(PKG)_ALL_DOWNLOADS),\$(call DOWNLOAD,\$(p))\$(sep))
        \$(foreach hook,\$(\$(PKG)_POST_DOWNLOAD_HOOKS),\$(call \$(hook))\$(sep))
        \$(Q)mkdir -p \$(@D)
        \$(Q)touch \$@
```

- Step handled by the package infrastructure

- In all #emph[stamp file targets], `PKG` is the upper case name of the
  package. So when used for BusyBox, `\$(\$(PKG)_SOURCE)` is the value
  of `BUSYBOX_SOURCE`.

- #emph[Hooks]: make macros called before and after each step.

- `<pkg>_ALL_DOWNLOADS` lists all the files to be downloaded, which
  includes the ones listed in `<pkg>_SOURCE`,
  `<pkg>_EXTRA_DOWNLOADS` and `<pkg>_PATCH`.

===  Action example 2: build

```make
# Build
\$(BUILD_DIR)/%/.stamp_built::
        @\$(call step_start,build)
        @\$(call MESSAGE,"Building")
        \$(foreach hook,\$(\$(PKG)_PRE_BUILD_HOOKS),\$(call \$(hook))\$(sep))
        +\$(\$(PKG)_BUILD_CMDS)
        \$(foreach hook,\$(\$(PKG)_POST_BUILD_HOOKS),\$(call \$(hook))\$(sep))
        @\$(call step_end,build)
        \$(Q)touch \$@
```

- Step handled by the package, by defining a value for
  `<pkg>_BUILD_CMDS`.

- Same principle of #emph[hooks]

- `step_start` and `step_end` are part of instrumentation to measure
  the duration of each step (and other actions)

===  The `generic-package` macro

- Packages built for the target:

  ```make
  generic-package = \$(call inner-generic-package,
                           \$(pkgname),\$(call UPPERCASE,\$(pkgname)),
                           \$(call UPPERCASE,\$(pkgname)),target)
  ```

- Packages built for the host:

  ```make
  host-generic-package = \$(call inner-generic-package,
                                host-\$(pkgname),\$(call UPPERCASE,host-\$(pkgname)),
                                \$(call UPPERCASE,\$(pkgname)),host)
  ```

- In `package/libzlib/libzlib.mk`:

  ```make
  LIBZLIB_... = ...

  \$(eval \$(generic-package))
  \$(eval \$(host-generic-package))
  ```

- Leads to:

  ```make
  \$(call inner-generic-package,libzlib,LIBZLIB,LIBZLIB,target)
  \$(call inner-generic-package,host-libzlib,HOST_LIBZLIB,LIBZLIB,host)
  ```

===  `inner-generic-package`: defining variables

#columns(gutter: 8pt)[

Macro code

```make
\$(2)_TYPE    =  \$(4)
\$(2)_NAME    =  \$(1)
\$(2)_RAWNAME =  \$\$(patsubst host-%,%,\$(1))

\$(2)_BASE_NAME = \$(1)-\$\$(\$(2)_VERSION)
\$(2)_DIR       = \$\$(BUILD_DIR)/\$\$(\$(2)_BASE_NAME)



ifndef \$(2)_SOURCE
 ifdef \$(3)_SOURCE
  \$(2)_SOURCE = \$\$(\$(3)_SOURCE)
 else
  \$(2)_SOURCE ?=
    \$\$(\$(2)_RAWNAME)-\$\$(\$(2)_VERSION).tar.gz
 endif endif

ifndef \$(2)_SITE
 ifdef \$(3)_SITE
  \$(2)_SITE = \$\$(\$(3)_SITE)
 endif endif

...
```

#colbreak()

Expanded for `host-libzlib`

```make
HOST_LIBZLIB_TYPE    = host HOST_LIBZLIB_NAME    = host-libzlib HOST_LIBZLIB_RAWNAME = libzlib

HOST_LIBZLIB_BASE_NAME =
  host-libzlib-\$(HOST_LIBZLIB_VERSION)
HOST_LIBZLIB_DIR       =
  \$(BUILD_DIR)/host-libzlib-\$(HOST_LIBZLIB_VERSION)

ifndef HOST_LIBZLIB_SOURCE
 ifdef LIBZLIB_SOURCE
  HOST_LIBZLIB_SOURCE = \$(LIBZLIB_SOURCE)
 else
  HOST_LIBZLIB_SOURCE ?=
   libzlib-\$(HOST_LIBZLIB_VERSION).tar.gz
 endif endif

ifndef HOST_LIBZLIB_SITE
 ifdef LIBZLIB_SITE
  HOST_LIBZLIB_SITE = \$(LIBZLIB_SITE)
 endif endif

...
```


]

===  `inner-generic-package`: dependencies

```make
ifeq (\$(4),target)
ifeq (\$\$(\$(2)_ADD_SKELETON_DEPENDENCY),YES)
\$(2)_DEPENDENCIES += skeleton endif ifeq (\$\$(\$(2)_ADD_TOOLCHAIN_DEPENDENCY),YES)
\$(2)_DEPENDENCIES += toolchain endif endif

...

ifeq (\$\$(BR2_CCACHE),y)
ifeq (\$\$(filter host-tar host-skeleton host-xz host-lzip host-fakedate host-ccache,\$(1)),)
\$(2)_DEPENDENCIES += host-ccache endif endif
```

- Adding the `skeleton` and `toolchain` dependencies to target packages.
  Except for some specific packages (e.g. C library).

===  `inner-generic-package`: stamp files

```make
\$(2)_TARGET_INSTALL =           \$\$(\$(2)_DIR)/.stamp_installed
\$(2)_TARGET_INSTALL_TARGET =    \$\$(\$(2)_DIR)/.stamp_target_installed
\$(2)_TARGET_INSTALL_STAGING =   \$\$(\$(2)_DIR)/.stamp_staging_installed
\$(2)_TARGET_INSTALL_IMAGES =    \$\$(\$(2)_DIR)/.stamp_images_installed
\$(2)_TARGET_INSTALL_HOST =      \$\$(\$(2)_DIR)/.stamp_host_installed
\$(2)_TARGET_BUILD =             \$\$(\$(2)_DIR)/.stamp_built
\$(2)_TARGET_CONFIGURE =         \$\$(\$(2)_DIR)/.stamp_configured
\$(2)_TARGET_RSYNC =             \$\$(\$(2)_DIR)/.stamp_rsynced
\$(2)_TARGET_RSYNC_SOURCE =      \$\$(\$(2)_DIR)/.stamp_rsync_sourced
\$(2)_TARGET_PATCH =             \$\$(\$(2)_DIR)/.stamp_patched
\$(2)_TARGET_EXTRACT =           \$\$(\$(2)_DIR)/.stamp_extracted
\$(2)_TARGET_SOURCE =            \$\$(\$(2)_DIR)/.stamp_downloaded
\$(2)_TARGET_DIRCLEAN =          \$\$(\$(2)_DIR)/.stamp_dircleaned
```

- Defines shortcuts to reference the stamp files

```make
\$\$(\$(2)_TARGET_INSTALL):                PKG=\$(2)
\$\$(\$(2)_TARGET_INSTALL_TARGET):         PKG=\$(2)
\$\$(\$(2)_TARGET_INSTALL_STAGING):        PKG=\$(2)
\$\$(\$(2)_TARGET_INSTALL_IMAGES):         PKG=\$(2)
\$\$(\$(2)_TARGET_INSTALL_HOST):           PKG=\$(2)
[...]
```

- Pass variables to the stamp file targets, especially `PKG`

===  `inner-generic-package`: sequencing

#columns(gutter: 8pt)[

```make
\$(1):                   \$(1)-install
\$(1)-install:           \$\$(\$(2)_TARGET_INSTALL)

ifeq (\$\$(\$(2)_INSTALL_TARGET),YES)
\$\$(\$(2)_TARGET_INSTALL): \$\$(\$(2)_TARGET_INSTALL_TARGET)
endif ifeq (\$\$(\$(2)_INSTALL_STAGING),YES)
\$\$(\$(2)_TARGET_INSTALL): \$\$(\$(2)_TARGET_INSTALL_STAGING)
endif ifeq (\$\$(\$(2)_INSTALL_IMAGES),YES)
\$\$(\$(2)_TARGET_INSTALL): \$\$(\$(2)_TARGET_INSTALL_IMAGES)
endif

\$(1)-install-target:            \$\$(\$(2)_TARGET_INSTALL_TARGET)
\$\$(\$(2)_TARGET_INSTALL_TARGET): \$\$(\$(2)_TARGET_BUILD)

\$(1)-install-staging:                   \$\$(\$(2)_TARGET_INSTALL_STAGING)
\$\$(\$(2)_TARGET_INSTALL_STAGING):        \$\$(\$(2)_TARGET_BUILD)

\$(1)-install-images:            \$\$(\$(2)_TARGET_INSTALL_IMAGES)
\$\$(\$(2)_TARGET_INSTALL_IMAGES): \$\$(\$(2)_TARGET_BUILD)
```

#colbreak()

```make
\$(1)-build:             \$\$(\$(2)_TARGET_BUILD)
\$\$(\$(2)_TARGET_BUILD):  \$\$(\$(2)_TARGET_CONFIGURE)

\$(1)-configure:                 \$\$(\$(2)_TARGET_CONFIGURE)
\$\$(\$(2)_TARGET_CONFIGURE):      | \$\$(\$(2)_FINAL_DEPENDENCIES)
\$\$(\$(2)_TARGET_CONFIGURE):      \$\$(\$(2)_TARGET_PATCH)

\$(1)-patch:             \$\$(\$(2)_TARGET_PATCH)
\$\$(\$(2)_TARGET_PATCH):  \$\$(\$(2)_TARGET_EXTRACT)

\$(1)-extract:                   \$\$(\$(2)_TARGET_EXTRACT)
\$\$(\$(2)_TARGET_EXTRACT):        \$\$(\$(2)_TARGET_SOURCE)
\$\$(\$(2)_TARGET_EXTRACT): | \$\$(\$(2)_FINAL_EXTRACT_DEPENDENCIES)

\$(1)-source:            \$\$(\$(2)_TARGET_SOURCE)
\$\$(\$(2)_TARGET_SOURCE): | \$\$(\$(2)_FINAL_DOWNLOAD_DEPENDENCIES)

\$\$(\$(2)_TARGET_SOURCE): | prepare
\$\$(\$(2)_TARGET_SOURCE): | dependencies
```


]

===  `inner-generic-package`: sequencing diagram

#align(center, [#image("package-build-sequencing.pdf", height: 80%)])

===  Preparation work: prepare, dependencies

pkg-generic.mk

```make
\$\$(\$(2)_TARGET_SOURCE): | prepare
\$\$(\$(2)_TARGET_SOURCE): | dependencies
```

- All packages have two targets in their dependencies:

  - `prepare`: generates a kconfig-related `auto.conf` file

  - `dependencies`: triggers the check of Buildroot system dependencies,
    i.e. things that must be installed on the machine to use Buildroot

===  Rebuilding packages?

#columns(gutter: 8pt)[

- Once one step of a package build process has been done, it is never
  done again due to the #emph[stamp file]

- Even if the package configuration is changed, or the package is
  disabled \$\\$\_Buildroot doesn’t try to be smart

- One can force rebuilding a package from its configure, build or
  install step using `make <pkg>-reconfigure`, `make <pkg>-rebuild`
  or `make <pkg>-reinstall`

#colbreak()

```make
\$(1)-clean-for-reinstall:
                        rm -f \$\$(\$(2)_TARGET_INSTALL)
                        rm -f \$\$(\$(2)_TARGET_INSTALL_STAGING)
                        rm -f \$\$(\$(2)_TARGET_INSTALL_TARGET)
                        rm -f \$\$(\$(2)_TARGET_INSTALL_IMAGES)
                        rm -f \$\$(\$(2)_TARGET_INSTALL_HOST)

\$(1)-reinstall:         \$(1)-clean-for-reinstall \$(1)

\$(1)-clean-for-rebuild: \$(1)-clean-for-reinstall
                        rm -f \$\$(\$(2)_TARGET_BUILD)

\$(1)-rebuild:           \$(1)-clean-for-rebuild \$(1)

\$(1)-clean-for-reconfigure: \$(1)-clean-for-rebuild
                        rm -f \$\$(\$(2)_TARGET_CONFIGURE)

\$(1)-reconfigure:       \$(1)-clean-for-reconfigure \$(1)
```


]

===  Specialized package infrastructures

- The `generic-package` infrastructure is fine for packages having a
  #strong[custom] build system

- For packages using a #strong[well-known build system], we want to
  factorize more logic

- Specialized #strong[package infrastructures] were created to handle
  these packages, and reduce the amount of duplication

- For #emph[autotools], #emph[CMake], #emph[Python], #emph[Perl],
  #emph[Lua], #emph[Meson], #emph[Golang], #emph[QMake], #emph[kconfig],
  #emph[Rust], #emph[kernel-module], #emph[Erlang], #emph[Waf] packages

===  CMake package example: `flann`

package/flann/flann.mk

```make
FLANN_VERSION = 1.9.1
FLANN_SITE = \$(call github,mariusmuja,flann,\$(FLANN_VERSION))
FLANN_INSTALL_STAGING = YES
FLANN_LICENSE = BSD-3-Clause FLANN_LICENSE_FILES = COPYING
FLANN_CONF_OPTS = 
        -DBUILD_C_BINDINGS=ON 
        -DBUILD_PYTHON_BINDINGS=OFF 
        -DBUILD_MATLAB_BINDINGS=OFF 
        -DBUILD_EXAMPLES=\$(if \$(BR2_PACKAGE_FLANN_EXAMPLES),ON,OFF) 
        -DUSE_OPENMP=\$(if \$(BR2_GCC_ENABLE_OPENMP),ON,OFF) 
        -DPYTHON_EXECUTABLE=OFF 
        -DCMAKE_DISABLE_FIND_PACKAGE_HDF5=TRUE

\$(eval \$(cmake-package))
```

===  CMake package infrastructure (1/2)

```make
define inner-cmake-package

\$(2)_CONF_ENV                   ?=
\$(2)_CONF_OPTS                  ?=
...

\$(2)_SRCDIR                     = \$\$(\$(2)_DIR)/\$\$(\$(2)_SUBDIR)
\$(2)_BUILDDIR                   = \$\$(\$(2)_SRCDIR)

ifndef \$(2)_CONFIGURE_CMDS
ifeq (\$(4),target)
define \$(2)_CONFIGURE_CMDS
    (cd \$\$(\$\$(PKG)_BUILDDIR) && 
     \$\$(\$\$(PKG)_CONF_ENV) \$\$(HOST_DIR)/bin/cmake \$\$(\$\$(PKG)_SRCDIR) 
         -DCMAKE_TOOLCHAIN_FILE="\$\$(HOST_DIR)/share/buildroot/toolchainfile.cmake" 
         ...
         \$\$(\$\$(PKG)_CONF_OPTS) 
    )
endef else define \$(2)_CONFIGURE_CMDS
... host case ...
endef endif endif
```

===  CMake package infrastructure (2/2)

```make
\$(2)_DEPENDENCIES += host-cmake

ifndef \$(2)_BUILD_CMDS
ifeq (\$(4),target)
define \$(2)_BUILD_CMDS
        \$\$(TARGET_MAKE_ENV) \$\$(\$\$(PKG)_MAKE_ENV) \$\$(\$\$(PKG)_MAKE) \$\$(\$\$(PKG)_MAKE_OPTS)
            -C \$\$(\$\$(PKG)_BUILDDIR)
endef else
... host case ...
endif endif

... other commands ...

ifndef \$(2)_INSTALL_TARGET_CMDS
define \$(2)_INSTALL_TARGET_CMDS
        \$\$(TARGET_MAKE_ENV) \$\$(\$\$(PKG)_MAKE_ENV) \$\$(\$\$(PKG)_MAKE) \$\$(\$\$(PKG)_MAKE_OPTS)
          \$\$(\$\$(PKG)_INSTALL_TARGET_OPT) -C \$\$(\$\$(PKG)_BUILDDIR)
endef endif

\$(call inner-generic-package,\$(1),\$(2),\$(3),\$(4))

endef

cmake-package = \$(call inner-cmake-package,\$(pkgname),...,target)
host-cmake-package = \$(call inner-cmake-package,host-\$(pkgname),...,host)
```

===  Autoreconf in `pkg-autotools.mk`

- Package infrastructures can also add additional capabilities
  controlled by variables in packages

- For example, with the `autotools-package` infra, one can do
  `FOOBAR_AUTORECONF = YES` in a package to trigger an
  #emph[autoreconf] before the #emph[configure] script is executed

- Implementation in `pkg-autotools.mk`

  ```make
  define AUTORECONF_HOOK
          @\$\$(call MESSAGE,"Autoreconfiguring")
          \$\$(Q)cd \$\$(\$\$(PKG)_SRCDIR) && \$\$(\$\$(PKG)_AUTORECONF_ENV) \$\$(AUTORECONF)
               \$\$(\$\$(PKG)_AUTORECONF_OPTS)
          ...
  endef

  ifeq (\$\$(\$(2)_AUTORECONF),YES)
  ...
  \$(2)_PRE_CONFIGURE_HOOKS += AUTORECONF_HOOK
  \$(2)_DEPENDENCIES += host-automake host-autoconf host-libtool endif
  ```

===  Toolchain support

- One #emph[virtual package], `toolchain`, with two implementations in
  the form of two packages: `toolchain-buildroot` and
  `toolchain-external`

- `toolchain-buildroot` implements the #strong[internal toolchain
  back-end], where Buildroot builds the cross-compilation toolchain from
  scratch. This package simply depends on `host-gcc-final` to trigger
  the entire build process

- `toolchain-external` implements the #strong[external toolchain
  back-end], where Buildroot uses an existing pre-built toolchain

===  Internal toolchain back-end

#columns(gutter: 8pt)[

- Build starts with utility host tools and libraries needed for gcc
  (`host-m4`, `host-mpc`, `host-mpfr`, `host-gmp`). Installed in
  `\$(HOST_DIR)/bin,include,lib`

- Build goes on with the cross binutils, `host-binutils`, installed in
  `\$(HOST_DIR)/bin`

- Then the first stage compiler, `host-gcc-initial`

- We need the `linux-headers`, installed in
  `\$(STAGING_DIR)/usr/include`

- We build the C library, `uclibc` in this example. Installed in
  `\$(STAGING_DIR)/lib`, `\$(STAGING_DIR)/usr/include` and of course
  `\$(TARGET_DIR)/lib`

- We build the final compiler `host-gcc-final`, installed in
  `\$(HOST_DIR)/bin`

#colbreak()
#align(center, [#image("internal-toolchain-graph-depends.pdf", height: 80%)])

]

===  External toolchain back-end

#columns(gutter: 8pt)[

- `toolchain-external-package` infrastructure, implementing the common
  logic for all external toolchains

  - Implemented in
    `toolchain/toolchain-external/pkg-toolchain-external.mk`

- Packages in `toolchain/toolchain-external/` are using this
  infrastructure

  - E.g. `toolchain-external-arm-aarch64`, `toolchain-external-bootlin`

- `toolchain-external` is a virtual package itself depends on the
  selected external toolchain.

#colbreak()
#align(center, [#image("external-toolchain-graph-depends.pdf", width: 100%)])

]

===  External toolchain example

toolchain/toolchain-external/toolchain-external-arm-aarch64/toolchain-external-arm-aarch64.mk

```make
TOOLCHAIN_EXTERNAL_ARM_AARCH64_VERSION = 2020.11
TOOLCHAIN_EXTERNAL_ARM_AARCH64_SITE = 
    https://developer.arm.com/-/media/Files/downloads/
      gnu-a/10.2-\$(TOOLCHAIN_EXTERNAL_ARM_AARCH64_VERSION)/binrel

TOOLCHAIN_EXTERNAL_ARM_AARCH64_SOURCE = 
    gcc-arm-10.2-\$(TOOLCHAIN_EXTERNAL_ARM_AARCH64_VERSION)-x86_64-aarch64-none-linux-gnu.tar.xz

\$(eval \$(toolchain-external-package))
```

===  `toolchain-external-package` logic

+ Extract the toolchain to `\$(HOST_DIR)/opt/ext-toolchain`

+ Run some checks on the toolchain to verify it matches the
  configuration specified in #emph[menuconfig]

+ Copy the toolchain #emph[sysroot] (C library and headers, kernel
  headers) to `\$(STAGING_DIR)/usr/include,lib`

+ Copy the toolchain libraries to `\$(TARGET_DIR)/usr/lib`

+ Create symbolic links or wrappers for the compiler, linker, debugger,
  etc from `\$(HOST_DIR)/bin/<tuple>-<tool>` to
  `\$(HOST_DIR)/opt/ext-toolchain/bin/<tuple>-<tool>`

+ A wrapper program is used for certain tools (gcc, ld, g++, etc.) in
  order to ensure a certain number of compiler flags are used,
  especially `–sysroot=\$(STAGING_DIR)` and target-specific flags.

===  Root filesystem image generation

- Once all the targets in `\$(PACKAGES)` have been built, it’s time to
  create the root filesystem images

- First, the `target-finalize` target does some cleanup of
  `\$(TARGET_DIR)` by removing documentation, headers, static
  libraries, etc.

- Then the root filesystem image targets listed in `\$(ROOTFS_TARGETS)`
  are processed

- These targets are added by the common filesystem image generation
  infrastructure `rootfs`, in `fs/common.mk`

- The purpose of this infrastructure is to:

  - Collect the users, permissions and device tables

  - Make a copy of `TARGET_DIR` per filesystem image

  - Generate a shell script that assigns users, permissions and invokes
    the filesystem image creation utility

  - Invoke the shell script under `fakeroot`

===  `fs/common.mk`, dependencies and table generation

```make
ROOTFS_COMMON_DEPENDENCIES = 
        host-fakeroot host-makedevs 
        \$(BR2_TAR_HOST_DEPENDENCY) 
        \$(if \$(PACKAGES_USERS)\$(ROOTFS_USERS_TABLES),host-mkpasswd)

rootfs-common: \$(ROOTFS_COMMON_DEPENDENCIES) target-finalize
        @\$(call MESSAGE,"Generating root filesystems common tables")
        rm -rf \$(FS_DIR)
        mkdir -p \$(FS_DIR)
        \$(call PRINTF,\$(PACKAGES_USERS)) >> \$(ROOTFS_FULL_USERS_TABLE)
        cat \$(ROOTFS_USERS_TABLES) >> \$(ROOTFS_FULL_USERS_TABLE)
        \$(call PRINTF,\$(PACKAGES_PERMISSIONS_TABLE)) > \$(ROOTFS_FULL_DEVICES_TABLE)
        cat \$(ROOTFS_DEVICE_TABLES) >> \$(ROOTFS_FULL_DEVICES_TABLE)
        \$(call PRINTF,\$(PACKAGES_DEVICES_TABLE)) >> \$(ROOTFS_FULL_DEVICES_TABLE)
```

===  `fs/common.mk`, `rootfs` infrastructure 1

```make
define inner-rootfs

ROOTFS_\$(2)_IMAGE_NAME ?= rootfs.\$(1)
ROOTFS_\$(2)_FINAL_IMAGE_NAME = \$\$(strip \$\$(ROOTFS_\$(2)_IMAGE_NAME))
ROOTFS_\$(2)_DIR = \$\$(FS_DIR)/\$(1)
ROOTFS_\$(2)_TARGET_DIR = \$\$(ROOTFS_\$(2)_DIR)/target

ROOTFS_\$(2)_DEPENDENCIES += rootfs-common
```

===  `fs/common.mk`, `rootfs` infrastructure 2

```make

\$\$(BINARIES_DIR)/\$\$(ROOTFS_\$(2)_FINAL_IMAGE_NAME): \$\$(ROOTFS_\$(2)_DEPENDENCIES)
        @\$\$(call MESSAGE,"Generating filesystem image \$\$(ROOTFS_\$(2)_FINAL_IMAGE_NAME)")
        [...]
        mkdir -p \$\$(ROOTFS_\$(2)_DIR)
        rsync -auH 
                --exclude=/\$\$(notdir \$\$(TARGET_DIR_WARNING_FILE)) 
                \$\$(BASE_TARGET_DIR)/ 
                \$\$(TARGET_DIR)
        echo '#!/bin/sh' > \$\$(FAKEROOT_SCRIPT)
        echo "set -e" >> \$\$(FAKEROOT_SCRIPT)
        echo "chown -h -R 0:0 \$\$(TARGET_DIR)" >> \$\$(FAKEROOT_SCRIPT)
        PATH=\$\$(BR_PATH) \$\$(TOPDIR)/support/scripts/mkusers \$\$(ROOTFS_FULL_USERS_TABLE) \$\$(TARGET_DIR) >> \$\$(FAKEROOT_SCRIPT)
        echo "\$\$(HOST_DIR)/bin/makedevs -d \$\$(ROOTFS_FULL_DEVICES_TABLE) \$\$(TARGET_DIR)" >> \$\$(FAKEROOT_SCRIPT)
        [...]
        \$\$(call PRINTF,\$\$(ROOTFS_\$(2)_CMD)) >> \$\$(FAKEROOT_SCRIPT)
        chmod a+x \$\$(FAKEROOT_SCRIPT)
        PATH=\$\$(BR_PATH) \$\$(HOST_DIR)/bin/fakeroot -- \$\$(FAKEROOT_SCRIPT)
[...]
ifeq (\$\$(BR2_TARGET_ROOTFS_\$(2)),y)
TARGETS_ROOTFS += rootfs-\$(1)
endif endef

rootfs = \$(call inner-rootfs,\$(pkgname),\$(call UPPERCASE,\$(pkgname)))
```

===  `fs/ubifs/ubifs.mk`

```make
UBIFS_OPTS := -e \$(BR2_TARGET_ROOTFS_UBIFS_LEBSIZE) 
              -c \$(BR2_TARGET_ROOTFS_UBIFS_MAXLEBCNT) 
              -m \$(BR2_TARGET_ROOTFS_UBIFS_MINIOSIZE)

ifeq (\$(BR2_TARGET_ROOTFS_UBIFS_RT_ZLIB),y)
UBIFS_OPTS += -x zlib endif
...

UBIFS_OPTS += \$(call qstrip,\$(BR2_TARGET_ROOTFS_UBIFS_OPTS))

ROOTFS_UBIFS_DEPENDENCIES = host-mtd

define ROOTFS_UBIFS_CMD
        \$(HOST_DIR)/sbin/mkfs.ubifs -d \$(TARGET_DIR) \$(UBIFS_OPTS) -o \$@
endef

\$(eval \$(rootfs))
```

===  Final example

#align(center, [#image("final-example.pdf", height: 80%)])
