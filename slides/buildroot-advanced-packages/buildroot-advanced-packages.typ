#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "/typst/local/themeBootlin.typ": *

#import "/typst/local/common.typ": *

#show: bootlin-theme.with( aspect-ratio: "16-9",
config-common(handout: "handout" in sys.inputs and sys.inputs.handout
== "1", ))

#show raw.where(block: true): set block(fill: luma(240), inset: 1em,
radius: 0.5em, width: 100%)


#show raw.where(block: false): r => text(fill: color-link)[#r]

#show raw.where(lang: "c", block: true): set block(fill: luma(240),
inset: 0.4em, radius: 0.5em, width: 95%, breakable: true, above: 12pt,
below: 12pt)

#show raw.where(lang: "c", block: true): set text(11pt)

#show raw.where(lang: "console", block: true):set block(fill:
luma(240), inset: 0.4em, radius: 0.5em, width: 95%, breakable: true,
above: 6pt)

#show raw.where(lang:"console", block: true): set text(12pt)

= Advanced package aspects

== Licensing report
<licensing-report>
===  Licensing report: introduction

- A key aspect of embedded Linux systems is #strong[license compliance].#v(0.3em)

- Embedded Linux systems integrate together a number of open-source
  components, each distributed under its own license.#v(0.3em)

- The different open-source licenses may have #strong[different
  requirements], that must be met before the product using the embedded
  Linux system starts shipping.#v(0.3em)

- Buildroot helps in this license compliance process by offering the
  possibility of generating a number of #strong[license-related
  information] from the list of selected packages.#v(0.3em)

- Generated using:#v(0.3em)
#[
  #set text(size: 17pt)
  ```
  $ make legal-info
  ```
]
===  Licensing report: contents of `legal-info`

- `sources/` and `host-sources/`, all the source files that are
  redistributable (tarballs, patches, etc.)#v(0.3em)

- `manifest.csv` and `host-manifest.csv`, CSV files with the list of
  #emph[target] and #emph[host] packages, their version, license, etc.#v(0.3em)

- `licenses/` and `host-licenses/<pkg>/`, the full license text of all
  #emph[target] and #emph[host] packages, per package#v(0.3em)

- `buildroot.config`, the Buildroot `.config` file#v(0.3em)

- `legal-info.sha256` hashes of all #emph[legal-info] files#v(0.3em)

- `README`

===  Including licensing information in packages

- `<pkg>_LICENSE`#v(0.3em)

  - Comma-separated #strong[list of license(s)] under which the package
    is distributed.

  - Must use SPDX license codes, see #link("https://spdx.org/licenses/")

  - Can indicate which part is under which license (programs, tests,
    libraries, etc.)#v(0.3em)

- `<pkg>_LICENSE_FILES`#v(0.3em)

  - Space-separated #strong[list of file paths] from the package source
    code containing the license text and copyright information

  - Paths relative to the package top-level source directory#v(0.3em)

- `<pkg>_REDISTRIBUTE`#v(0.3em)

  - Boolean indicating whether the package source code can be
    redistributed or not (part of the `legal-info` output)

  - Defaults to `YES`, can be overridden to `NO`

  - If `NO`, source code is not copied when generating the licensing
    report

===  Licensing information examples
#[
  #set text(size: 14.5pt)
linux.mk
]
#[
  #set text(size: 19pt)
```make
LINUX_LICENSE = GPL-2.0
LINUX_LICENSE_FILES = COPYING
```
]
#v(0.8em)
#[
  #set text(size: 14.5pt)
acl.mk
]
#[
  #set text(size: 19pt)
```make
ACL_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
ACL_LICENSE_FILES = doc/COPYING doc/COPYING.LGPL
```
]
#v(0.8em)
#[
  #set text(size: 14.5pt)
owl-linux.mk
]
#[
  #set text(size: 19pt)
```make
OWL_LINUX_LICENSE = PROPRIETARY
OWL_LINUX_LICENSE_FILES = LICENSE
OWL_LINUX_REDISTRIBUTE = NO
```
]
== Security vulnerability tracking
<security-vulnerability-tracking>
===  Security vulnerability tracking

- Security has obviously become a key issue in embedded systems that are
  more and more commonly connected.#v(0.3em)

- Embedded Linux systems typically integrate 10-100+ open-source
  components \$arrow.r\$ not easy to keep track of their potential
  security vulnerabilities#v(0.3em)

- Industry relies on #emph[Common Vulnerability Exposure] (CVE) reports
  to document known security issues#v(0.3em)

- Buildroot is able to identify if packages are affected by known CVEs,
  by using the #emph[National Vulnerability Database]

  - `make pkg-stats`

  - Produces `$(O)/pkg-stats.html`, `$(O)/pkg-stats.json`#v(0.3em)

- Note: this is limited to known CVEs. It does not guarantee the absence
  of security vulnerabilities.#v(0.3em)

- Only applies to open-source packages, not to your own custom code.

===  Example `pkg-stats` output

#align(center, [#image("pkg-stats-output.png", width: 100%)])
#align(center, [#image("pkg-stats-output-summary.png", width: 100%)])

===  CPE: Common Platform Enumeration

- Concept of #emph[Common Platform Enumeration], which gives a unique
  identifier to a software release

  - E.g.: `cpe:2.3:a:xiph:libao:1.2.0:*:*:*:*:*:*:*`

- By default Buildroot uses:

  - `cpe:2.3:a:<pkg>_project:<pkg>:<pkg>_VERSION:*:*:*:*:*:*:*`

  - Not always correct!

- Can be modified using:

  - `<pkg>_CPE_ID_PREFIX`

  - `<pkg>_CPE_ID_VENDOR`

  - `<pkg>_CPE_ID_PRODUCT`

  - `<pkg>_CPE_ID_VERSION`

  - `<pkg>_CPE_ID_UPDATE`

- Concept of #emph[CPE dictionary] provided by NVD, which contains all
  known CPEs.

  - `pkg-stats` checks if the CPE of each package is known in the
    #emph[CPE dictionary]

===  NVD CVE-2020-35492 example

#align(center, [#image("nvd-example.png", height: 80%)])

===  CPE information in packages
#[
  #set text(size: 14.5pt)
`package/bash/bash.mk`
]
#[
  #set text(size: 19pt)
```
BASH_CPE_ID_VENDOR = gnu
```
]

#v(0.8em)

#[
  #set text(size: 14.5pt)
`package/audit/audit.mk`
]
#[
  #set text(size: 19pt)
```
AUDIT_CPE_ID_VENDOR = linux_audit_project AUDIT_CPE_ID_PRODUCT = linux_audit
```
]

#v(0.8em)

#[
  #set text(size: 14.5pt)
`linux/linux.mk`
]
#[
  #set text(size: 19pt)
```
LINUX_CPE_ID_VENDOR = linux LINUX_CPE_ID_PRODUCT = linux_kernel LINUX_CPE_ID_PREFIX = cpe:2.3:o
```
]

#v(0.8em)

#[
  #set text(size: 14.5pt)
`package/libffi/libffi.mk`
]
#[
  #set text(size: 19pt)
```
LIBFFI_CPE_ID_VERSION = 3.3
LIBFFI_CPE_ID_UPDATE = rc0
```
]
===  `<pkg>_IGNORE_CVES` variable

- There are cases where a CVE reported by the #emph[pkg-stats] tool in
  fact is not relevant:

  - The security fix has been backported into Buildroot

  - The vulnerability does not affect Buildroot due to how the package
    is configured or used#v(0.3em)

- The `<pkg>_IGNORE_CVES` variable allows a package to tell
  #emph[pkg-stats] to ignore a particular CVE

  #v(0.8em)
#[
  #set text(size: 14.5pt)
`package/bind/bind.mk`
]
#[
  #set text(size: 19pt)
```
#Only applies to RHEL6.x with DNSSEC validation on BIND_IGNORE_CVES = CVE-2017-3139
```
]
#v(0.8em)
#[
  #set text(size: 14.5pt)
`package/avahi/avahi.mk`
]
#[
  #set text(size: 19pt)
```
#0001-Fix-NULL-pointer-crashes-from-175.patch AVAHI_IGNORE_CVES += CVE-2021-36217
```
]
===  CycloneDX SBOM

- Buildroot can generate a SBOM (Software Bill Of Material) matching the
  standard #link("https://cyclonedx.org/")[CycloneDX] format#v(0.3em)

#[
  #set text(size: 19pt)
  ```
  $ make show-info | ./utils/generate-cyclonedx -o buildroot.sbom
  ```
] #v(0.3em)
- This can be used to document the contents of the build#v(0.3em)

- But also for vulnerability tracking, for example in conjunction with
  tools such as #link("https://dependencytrack.org/")[Dependency Track]

== Patching packages
<patching-packages>
===  Patching packages: why?

- In some situations, it might be needed to patch the source code of
  certain packages built by Buildroot.#v(0.3em)

- Useful to:

  - Fix cross-compilation issues

  - Backport bug or security fixes from upstream

  - Integrate new features or fixes not available upstream, or that are
    too specific to the product being made#v(0.3em)

- Patches are automatically applied by Buildroot, during the
  #emph[patch] step, i.e. after extracting the package, but before
  configuring it.#v(0.3em)

- Buildroot already comes with a number of patches for various packages,
  but you may need to add more for your own packages, or to existing
  packages.

===  Patch application ordering

- Overall the patches are applied in this order:#v(0.3em)

  + Patches mentioned in the `<pkg>_PATCH` variable of the package
    `.mk` file. They are automatically downloaded before being applied.

  + Patches present in the package directory `package/<pkg>/*.patch`

  + Patches present in the #emph[global patch directories]#v(0.3em)

- In each case, they are applied:

  - In the order specified in a `series` file, if available

  - Otherwise, in alphabetic ordering

===  Patch conventions

- There are a few conventions and best practices that the Buildroot
  project encourages to use when managing patches#v(0.3em)

- Their name should start with a sequence number that indicates the
  ordering in which they should be applied.#v(0.6em)
#[
  #set text(size: 14.5pt)
  ls package/nginx/\*.patch
]
#[
  #set text(size:15pt)
  ```
  0001-auto-type-sizeof-rework-autotest-to-be-cross-compila.patch
  0002-auto-feature-add-mechanism-allowing-to-force-feature.patch
  0003-auto-set-ngx_feature_run_force_result-for-each-featu.patch
  0004-auto-lib-libxslt-conf-allow-to-override-ngx_feature_.patch
  0005-auto-unix-make-sys_nerr-guessing-cross-friendly.patch
  [...]
  ```
]
#v(0.5em)
- Each patch should contain a description of what the patch does, and if
  possible its upstream status.#v(0.3em)

- Each patch should contain a `Signed-off-by` that identifies the author
  of the patch.#v(0.3em)

- Patches should be generated using `git format-patch` when possible.

===  Patch example
#[
  #set text(size: 13pt)
```
From 81289d1d1adaf5a767a4b4d1309c286468cfd37f Mon Sep 17 00:00:00 2001
From: Samuel Martin <s.martin49@gmail.com>
Date: Thu, 24 Apr 2014 23:27:32 +0200
Subject: [PATCH] auto/type/sizeof: rework autotest to be cross-compilation
 friendly

Rework the sizeof test to do the checks at compile time instead of at runtime. This way, it does not break when cross-compiling for a different CPU architecture.

Signed-off-by: Samuel Martin <s.martin49@gmail.com>
---
 auto/types/sizeof | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/auto/types/sizeof b/auto/types/sizeof index 9215a54..c2c3ede 100644
--- a/auto/types/sizeof
+++ b/auto/types/sizeof
@@ -14,7 +14,7 @@ END
 
 ngx_size=
 
-cat << END > \$NGX_AUTOTEST.c
+cat << \_EOF > \$NGX_AUTOTEST.c
[...]
```
]
===  Global patch directories

- You can include patches for the different packages in their package
  directory, `package/<pkg>/`.#v(0.3em)

- However, doing this involves changing the Buildroot sources
  themselves, which may not be appropriate for some highly specific
  patches.#v(0.3em)

- The #emph[global patch directories] mechanism allows to specify
  additional locations where Buildroot will look for patches to apply on
  packages.#v(0.3em)

- `BR2_GLOBAL_PATCH_DIR` specifies a space-separated list of
  directories containing patches.#v(0.3em)

- These directories must contain sub-directories named after the
  packages, themselves containing the patches to be applied.

===  Global patch directory example
#[
  #set text(size: 14.5pt)
Patching #emph[strace]
]
#[
  #set text(size:15pt)
```
$ ls package/strace/*.patch
0001-linux-aarch64-add-missing-header.patch

$ find ~/patches/
~/patches/
~/patches/strace/
~/patches/strace/0001-Demo-strace-change.patch

$ grep ^BR2_GLOBAL_PATCH_DIR .config BR2_GLOBAL_PATCH_DIR="$(HOME)/patches"

$ make strace
[...]
>>> strace 4.10 Patching

Applying 0001-linux-aarch64-add-missing-header.patch using patch: 
patching file linux/aarch64/arch_regs.h

Applying 0001-Demo-strace-change.patch using patch: 
patching file README
[...]
```
]
===  Generating patches

- To generate the patches against a given package source code, there are
  typically two possibilities.#v(0.3em)

- Use the upstream version control system, often #emph[Git]#v(0.3em)

- Use a tool called `quilt`

  - Useful when there is no version control system provided by the
    upstream project

  - #link("https://savannah.nongnu.org/projects/quilt")

===  Generating patches: with Git

Needs to be done outside of Buildroot: you cannot use the Buildroot
package build directory.#v(0.3em)

+ Clone the upstream Git repository 
  `git clone https://...`#v(0.3em)

+ Create a branch starting on the tag marking the stable release of the
  software as packaged in Buildroot 
  `git checkout -b buildroot-changes v3.2`#v(0.3em)

+ Import existing Buildroot patches (if any) 
  `git am /path/to/buildroot/package/<foo>/*.patch`#v(0.3em)

+ Make your changes and commit them 
  `git commit -s -m "this is a change"`#v(0.3em)

+ Generate the patches 
  `git format-patch v3.2`

===  Generating patches: with Quilt

+ Extract the package source code: #linebreak() `tar xf /path/to/dl/<foo>-<version>.tar.gz`#v(0.3em)

+ Inside the package source code, create a directory for patches #linebreak() `mkdir patches`#v(0.3em)

+ Import existing Buildroot patches #linebreak() `quilt import /path/to/buildroot/package/<foo>/*.patch`#v(0.3em)

+ Apply existing Buildroot patches #linebreak() `quilt push -a`#v(0.3em)

+ Create a new patch #linebreak() `quilt new 0001-fix-header-inclusion.patch`#v(0.3em)

+ Edit a file #linebreak() `quilt edit main.c`#v(0.3em)

+ Refresh the patch #linebreak()`quilt refresh`

== User, permission and device tables
<user-permission-and-device-tables>
===  Package-specific users

- The default skeleton in `system/skeleton/` has a number of default
  users/groups.#v(0.3em)

- Packages can define their own custom users/groups using the
  `<pkg>_USERS` variable:#v(0.3em)

  ```
  define <pkg>_USERS
          username uid group gid password home shell groups comment endef
  ```
#v(0.3em)
- Examples:#v(0.3em)

  ```make
  define AVAHI_USERS
          avahi -1 avahi -1 * - - -
  endef
  ```#v(0.3em)
  ```make
  define MYSQL_USERS
          mysql -1 nogroup -1 * /var/mysql - - MySQL daemon endef
  ```

===  File permissions and ownership

- By default, before creating the root filesystem images, Buildroot
  changes the ownership of all files to `0:0`, i.e. `root:root`#v(0.3em)

- Permissions are preserved as is, but since the build is executed as
  non-root, it is not possible to install setuid applications.#v(0.3em)

- A default set of permissions for certain files or directories is
  defined in `system/device_table.txt`.#v(0.3em)

- The `<pkg>_PERMISSIONS` variable allows packages to define special
  ownership and permissions for files and directories:#v(0.3em)

  ```
  define <pkg>_PERMISSIONS
  name type mode uid gid major minor start inc count endef
  ```#v(0.3em)

- The `major`, `minor`, `start`, `inc` and `count` fields are not used.

===  File permissions and ownership: examples

- `sudo` needs to be installed #emph[setuid root]:#v(0.3em)

  ```make
  define SUDO_PERMISSIONS
          /usr/bin/sudo f 4755 0 0 - - - - -
  endef
  ```#v(0.3em)

- `/var/lib/nginx` needs to be owned by `www-data`, which has UID/GID
  `33` defined in the skeleton:#v(0.3em)

  ```make
  define NGINX_PERMISSIONS
          /var/lib/nginx d 755 33 33 - - - - -
  endef
  ```

===  Devices

- Defining devices only applies when the chosen `/dev` management
  strategy is #emph[Static using a device table]. In other cases,
  #emph[device files] are created dynamically.#v(0.3em)

- A default set of #emph[device files] is described in
  `system/device_table_dev.txt` and created by Buildroot in the root
  filesystem images.#v(0.3em)

- When packages need some additional custom devices, they can use the
  `<pkg>_DEVICES` variable:#v(0.3em)

  ```
  define <pkg>_DEVICES
  name type mode uid gid major minor start inc count endef
  ```#v(0.3em)

- Becoming less useful, since most people are using a dynamic `/dev`
  nowadays.

===  Devices: example
#[
  #set text(size: 14.5pt)
xenomai.mk
]
```make
define XENOMAI_DEVICES
/dev/rtheap  c  666  0  0  10  254  0  0  -
/dev/rtscope c  666  0  0  10  253  0  0  -
/dev/rtp     c  666  0  0  150 0    0  1  32
endef
```

== Init scripts and systemd unit files
<init-scripts-and-systemd-unit-files>
===  Init scripts, systemd unit files

- Buildroot supports several main init systems: #emph[sysvinit],
  #emph[BusyBox], #emph[systemd], #emph[OpenRC]#v(0.3em)

- When packages want to install a program to be started at boot time,
  they need to install a startup script (
  #emph[sysvinit]/#emph[BusyBox]), a #emph[systemd service] file, etc.#v(0.3em)

- They can do so using the following variables, which contain a list of
  shell commands.

  - `<pkg>_INSTALL_INIT_SYSV`

  - `<pkg>_INSTALL_INIT_SYSTEMD`

  - `<pkg>_INSTALL_INIT_OPENRC`#v(0.3em)

- Buildroot will execute the appropriate `<pkg>_INSTALL_INIT_xyz`
  commands of all enabled packages depending on the selected init
  system.

===  Init scripts, systemd unit files: example
#[
  #set text(size:14.5pt)
bind.mk
]
```make
define BIND_INSTALL_INIT_SYSV
        $(INSTALL) -m 0755 -D package/bind/S81named 
                $(TARGET_DIR)/etc/init.d/S81named 
endef

define BIND_INSTALL_INIT_SYSTEMD
        $(INSTALL) -D -m 644 package/bind/named.service 
                $(TARGET_DIR)/usr/lib/systemd/system/named.service
endef
```

== Config scripts
<config-scripts>
===  Config scripts: introduction

- Libraries not using `pkg-config` often install a #strong[small shell
  script] that allows applications to query the compiler and linker
  flags to use the library.#v(0.3em)

- Examples: `curl-config`, `freetype-config`, etc.#v(0.3em)

- Such scripts will:

  - generally return results that are #strong[not appropriate for
    cross-compilation]

  - be used by other cross-compiled Buildroot packages that use those
    libraries#v(0.3em)

- By listing such scripts in the `<pkg>_CONFIG_SCRIPTS` variable,
  Buildroot will #strong[adapt the prefix, header and library paths] to
  make them suitable for cross-compilation.#v(0.3em)

- Paths in `<pkg>_CONFIG_SCRIPTS` are relative to
  `$(STAGING_DIR)/usr/bin`.

===  Config scripts: examples
#[
  #set text(size: 14.5pt)
libpng.mk
]

```make
LIBPNG_CONFIG_SCRIPTS = \
        libpng$(LIBPNG_SERIES)-config libpng-config
```
#v(1em)
#[
  #set text(size: 14.5pt)
imagemagick.mk
]
```make
IMAGEMAGICK_CONFIG_SCRIPTS = \
        $(addsuffix -config,Magick MagickCore MagickWand Wand)

ifeq ($(BR2_INSTALL_LIBSTDCPP)$(BR2_USE_WCHAR),yy)
IMAGEMAGICK_CONFIG_SCRIPTS += Magick++-config 
endif
```

===  Config scripts: effect
#[
  #set text(size: 14.5pt)
Without `<pkg>_CONFIG_SCRIPTS`
]
#[
  #set text(size: 19pt)
```
$ ./output/staging/usr/bin/libpng-config --cflags --ldflags
-I/usr/include/libpng16
-L/usr/lib -lpng16
```] #v(1em)
#[
  #set text(size: 14.5pt)
With `<pkg>_CONFIG_SCRIPTS`
]
#[
  #set text(size: 16pt)
```
$ ./output/staging/usr/bin/libpng-config --cflags --ldflags
-I.../buildroot/output/host/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/libpng16
-L.../buildroot/output/host/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/lib -lpng16
```
]
== Hooks
<hooks>
===  Hooks: principle (1)

- Buildroot #emph[package infrastructure] often implement a default
  behavior for certain steps:

  - `generic-package` implements for all packages the download, extract
    and patch steps

  - Other infrastructures such as `autotools-package` or `cmake-package`
    also implement the configure, build and installations steps#v(0.3em)

- In some situations, the package may want to do #strong[additional
  actions] before or after one of these steps.#v(0.3em)

- The #strong[hook] mechanism allows packages to add such custom
  actions.

===  Hooks: principle (2)

- There are #strong[pre] and #strong[post] hooks available for all steps
  of the package compilation process:#v(0.3em)

  - download, extract, rsync, patch, configure, build, install, install
    staging, install target, install images, legal info

  - `<pkg>_(PRE|POST)_<step>_HOOKS`

  - Example: `CMAKE_POST_INSTALL_TARGET_HOOKS`,
    `CVS_POST_PATCH_HOOKS`, `BINUTILS_PRE_PATCH_HOOKS`#v(0.3em)

- Hook variables contain a list of make macros to call at the
  appropriate time.

  - Use `+=` to register an additional hook to a hook point#v(0.3em)

- Those make macros contain a list of commands to execute.

===  Hooks: examples
#[
  #set text(size: 14.5pt)
bind.mk: remove unneeded binaries
]
#[
  #set text(size: 16pt)
```make
define BIND_TARGET_REMOVE_TOOLS
        rm -rf $(addprefix $(TARGET_DIR)/usr/bin/, $(BIND_TARGET_TOOLS_BIN))
endef

BIND_POST_INSTALL_TARGET_HOOKS += BIND_TARGET_REMOVE_TOOLS

```] #v(1em)
#[
  #set text(size: 14.5pt)
vsftpd.mk: adjust configuration
]
#[
  #set text(size: 16pt)
```make
define VSFTPD_ENABLE_SSL
        $(SED) 's/.*VSF_BUILD_SSL/#define VSF_BUILD_SSL/' \
                $(@D)/builddefs.h 
endef

ifeq ($(BR2_PACKAGE_OPENSSL),y)
VSFTPD_DEPENDENCIES += openssl host-pkgconf VSFTPD_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs libssl libcrypto`
VSFTPD_POST_CONFIGURE_HOOKS += VSFTPD_ENABLE_SSL
endif
```
]
== Overriding commands
<overriding-commands>
===  Overriding commands: principle

- In other situations, a package may want to completely
  #strong[override] the default implementation of a step provided by a
  package infrastructure.#v(0.3em)

- A package infrastructure will in fact only implement a given step
  #strong[if not already defined by a package].#v(0.3em)

- So defining `<pkg>_EXTRACT_CMDS` or `<pkg>_BUILD_CMDS` in your
  package `.mk` file will override the package infrastructure
  implementation (if any).

===  Overriding commands: examples
#[
  #set text(size: 14.5pt)
jquery: source code is only one file
]
#[
  #set text(size: 16pt)
```make
JQUERY_SITE = http://code.jquery.com JQUERY_SOURCE = jquery-$(JQUERY_VERSION).min.js

define JQUERY_EXTRACT_CMDS
        cp $(DL_DIR)/$(JQUERY_SOURCE) $(@D)
endef
```] #v(1em)
#[
  #set text(size: 14.5pt)
tftpd: install only what’s needed
]
#[
  #set text(size: 16pt)
```make
define TFTPD_INSTALL_TARGET_CMDS
        $(INSTALL) -D $(@D)/tftp/tftp $(TARGET_DIR)/usr/bin/tftp
        $(INSTALL) -D $(@D)/tftpd/tftpd $(TARGET_DIR)/usr/sbin/tftpd 
endef

$(eval $(autotools-package))
```]

== Legacy handling
<legacy-handling>
===  Legacy handling: `Config.in.legacy`

- When a `Config.in` option is removed, the corresponding value in the
  `.config` is silently removed.#v(0.3em)

- Due to this, when users upgrade Buildroot, they generally don’t know
  that an option they were using has been removed.#v(0.3em)

- Buildroot therefore adds the removed config option to
  `Config.in.legacy` with a description of what has happened.#v(0.3em)

- If any of these legacy options is enabled then Buildroot refuses to
  build.

== DEVELOPERS file
<developers-file>
===  `DEVELOPERS` file: principle

- A top-level `DEVELOPERS` file lists Buildroot developers and
  contributors interested in specific packages, board #emph[defconfigs]
  or architectures.#v(0.3em)

- Used by:

  - The `utils/get-developers` script to identify to whom a patch on an
    existing package should be sent

  - The Buildroot #emph[autobuilder] infrastructure to notify build
    failures to the appropriate package or architecture developers#v(0.3em)

- Important to add yourself in `DEVELOPERS` if you contribute a new
  package/board to Buildroot.

===  `DEVELOPERS` file: extract
#[
  #set text(size: 17.5pt)
```
N:      Thomas Petazzoni <thomas.petazzoni@bootlin.com>
F:      arch/Config.in.arm F:      boot/boot-wrapper-aarch64/
F:      boot/grub2/
F:      package/android-tools/
F:      package/cmake/
F:      package/cramfs/
[...]
F:      toolchain/

N:      Waldemar Brodkorb <wbx@openadk.org>
F:      arch/Config.in.bfin F:      arch/Config.in.m68k F:      arch/Config.in.or1k F:      arch/Config.in.sparc F:      package/glibc/
```
]
== Virtual packages
<virtual-packages>
===  Virtual packages

- There are situations where different packages provide an
  implementation of the same interface#v(0.3em)

- The most useful example is OpenGL

  - OpenGL is an API

  - Each HW vendor typically provides its own OpenGL implementation,
    each packaged as separate Buildroot packages#v(0.3em)

- Packages using the OpenGL interface do not want to know which
  implementation they are using: they are simply using the OpenGL API#v(0.3em)

- The mechanism of #emph[virtual packages] in Buildroot allows to solve
  this situation.

  - `libgles` is a virtual package offering the OpenGL ES API

  - Ten packages are #emph[providers] of the OpenGL ES API:
    `gpu-amd-bin-mx51`, `imx-gpu-viv`, `gcnano-binaries`, `mali-t76x`,
    `mesa3d`, `nvidia-driver`, `rpi-userland`, `sunxi-mali-mainline`,
    `ti-gfx`, `ti-sgx-um`

===  Virtual packages

#align(center, [#image("virtual-packages.pdf", width: 100%)])

===  Virtual package definition: Config.in
#[
  #set text(size: 14.5pt)
libgles/Config.in
]
#[
  #set text(size: 17pt)
```
config BR2_PACKAGE_HAS_LIBGLES
        bool

config BR2_PACKAGE_PROVIDES_LIBGLES
        depends on BR2_PACKAGE_HAS_LIBGLES
        string
```]#v(0.3em)

- `BR2_PACKAGE_HAS_LIBGLES` is a hidden boolean

  - Packages needing OpenGL ES will `depends on` it.

  - Packages providing OpenGL ES will `select` it.#v(0.3em)

- `BR2_PACKAGE_PROVIDES_LIBGLES` is a hidden string

  - Packages providing OpenGL ES will define their name as the variable
    value

  - The `libgles` package will have a build dependency on this provider
    package.

===  Virtual package definition: `.mk`
#[
  #set text(size: 14.5pt)
libgles/libgles.mk
]
#[
  #set text(size: 18pt)
```make
$(eval $(virtual-package))
```] #v(0.5em)

- Nothing to do: the `virtual-package` infrastructure takes care of
  everything, using the `BR2_PACKAGE_HAS_<name>` and
  `BR2_PACKAGE_PROVIDES_<name>` options.

===  Virtual package provider
#[
  #set text(size: 14.5pt)
sunxi-mali-mainline/Config.in
]
#[
  #set text(size: 18pt)
```
config BR2_PACKAGE_SUNXI_MALI_MAINLINE
        bool "sunxi-mali-mainline"
        select BR2_PACKAGE_HAS_LIBEGL
        select BR2_PACKAGE_HAS_LIBGLES

config BR2_PACKAGE_PROVIDES_LIBGLES
        default "sunxi-mali-mainline"
```]#v(1em)
#[
  #set text(size: 14.5pt)
sunxi-mali-mainline/sunxi-mali-mainline.mk
]

#[
  #set text(size: 18pt)
```make
[...]
SUNXI_MALI_MAINLINE_PROVIDES = libegl libgles
[...]
```] #v(0.5em)

- The variable `<pkg>_PROVIDES` is only used to detect if two
  providers for the same virtual package are enabled.

===  Virtual package user
#[
  #set text(size: 14.5pt)
qt5/qt5base/Config.in
]
#[
  #set text(size: 18pt)
```
config BR2_PACKAGE_QT5BASE_OPENGL_ES2
        bool "OpenGL ES 2.0+"
        depends on BR2_PACKAGE_HAS_LIBGLES
        help
          Use OpenGL ES 2.0 and later versions.
```
] #v(1em)
#[
  #set text(size: 14.5pt)
qt5/qt5base/qt5base.mk
]
#[
  #set text(size: 18pt)
```make
ifeq ($(BR2_PACKAGE_QT5BASE_OPENGL_DESKTOP),y)
QT5BASE_CONFIGURE_OPTS += -opengl desktop QT5BASE_DEPENDENCIES   += libgl 
else ifeq ($(BR2_PACKAGE_QT5BASE_OPENGL_ES2),y)
QT5BASE_CONFIGURE_OPTS += -opengl es2
QT5BASE_DEPENDENCIES   += libgles 
else QT5BASE_CONFIGURE_OPTS += -no-opengl 
endif
```]

#setuplabframe([Advanced packages],[

- Package an application with a mandatory dependency and an optional
  dependency#v(0.3em)

- Package a library, hosted on GitHub#v(0.3em)

- Use #emph[hooks] to tweak packages#v(0.3em)

- Add a patch to a package

])
