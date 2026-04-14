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

= Overview of major embedded Linux software stacks

===  D-Bus


#table(columns: (50%, 50%), stroke: none, [

- #emph[Message-oriented middleware mechanism that allows communication
  between multiple processes running concurrently on the same machine]

- Relies on a daemon to pass messages between applications

- Mainly used by system daemons to offer services to client applications

- Example: a network configuration daemon, running as #emph[root],
  offers a D-Bus API that CLI and GUI clients can use to configure
  networking

- Several busses

  - One system bus, accessible by all users, for system services

  - One session bus for each user logged in

- Object model: interfaces, objects, methods, signals

- #link("https://www.freedesktop.org/wiki/Software/dbus/")

#align(center, [#image("dbus.pdf", width: 100%)])


])

===  systemd (1)

- Modern #emph[init] system used by almost all Linux desktop/server
  distributions

- Much more complex than #emph[Busybox init], but also much more
  powerful

- Only supported with #emph[glibc], not with #emph[uClibc] and
  #emph[Musl]

- Provides features such as

  - Parallel startup of services, taking into account dependencies

  - Monitoring of services

  - On-demand startup of services, through #emph[socket activation]

  - Resource-management of services: CPU limits, memory limits

- Configuration based on #emph[unit files]

  - Declarative language, instead of shell scripts used in other init
    systems

===  systemd (2)

- Systemd also provides

  - #emph[journald], logging daemon, replacement for #emph[syslogd]

  - #emph[networkd], network configuration management

  - #emph[udevd], hotplugging and `/dev` management

  - #emph[logind], login management

  - #emph[systemctl], tool to control/monitor systemd

  - And many, many other things

- #link("https://systemd.io/")

===  systemd service unit file example

/usr/lib/systemd/system/sshd.service

```
[Unit]
Description=OpenSSH server daemon Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service Wants=sshd-keygen.service

[Service]
EnvironmentFile=/etc/sysconfig/sshd ExecStart=/usr/sbin/sshd -D \$OPTIONS
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process Restart=on-failure RestartSec=42s

[Install]
WantedBy=multi-user.target
```

===  Example systemctl/journalctl commands

- `systemctl status`, status of all services

- `systemctl status <service>`, status of one service

- `systemctl [start|stop] <service>`, start or stop a service

- `systemctl [enable|disable] <service>`, enable or disable a
  service, i.e. whether it should start at boot time

- `systemctl list-units`, list all available units

- `journalctl -a`, all logs

- `journalctl -f`, show the last entries, and keep printing new entries
  as they arrive

- `journalctl -u`, logs from a particular service

===  Linux graphics stack overview

#align(center, [#image("graphics-stack.pdf", height: 850%)])

===  Display controller support

- Deprecated Linux kernel subsystem: #emph[fbdev]

  - Still a few old graphics drivers only available in this subsystem

  - If possible, don't use!

  - #link("https://en.wikipedia.org/wiki/Linux_framebuffer")[https://en.wikipedia.org/wiki/Linux_framebuffer]

- Modern Linux kernel subsystem: #emph[DRM]

  - Supports display controllers of SoC or graphics cards, and all types
    of display panels and bridges: parallel, LVDS, DSI, HDMI,
    DisplayPort, etc.

  - Also supports small display panels connected over I2C or SPI

  - Devices exposed as `/dev/dri/cardX`

  - Companion user-space library: `libdrm`, includes a very handy test
    tool: `modetest`

  - #link("https://en.wikipedia.org/wiki/Direct_Rendering_Manager")[https://en.wikipedia.org/wiki/Direct_Rendering_Manager]

===  GPU support: OpenGL acceleration

- Open-source

  - A kernel driver in the DRM subsystem to send commands to the GPU and
    manage memory

  - `mesa3d` user-space library implementing the various OpenGL APIs,
    contains massive GPU-specific logic

  - More and more GPUs supported

  - #link("https://www.mesa3d.org/")

- Proprietary

  - Many embedded GPUs used to be supported only through proprietary
    blobs \$arrow.r\$\_long-term maintenance issues

  - A kernel driver provided out-of-tree by the vendor \$arrow.r\$\_they
    are not accepted upstream if the user-space is closed source

  - A (huge) closed-source user-space binary blob implementing the
    various OpenGL APIs

===  Concept of display servers


#table(columns: (50%, 50%), stroke: none, [

- The Linux kernel does not handle the #emph[multiplexing] of the
  display and input devices between applications

  - Only one user-space application can use a display and a given set of
    input devices

- Display servers are special user-space applications that multiplex
  display/input by:

  - Allowing multiple client GUI applications to submit their window
    contents

  - Composing the final frame visible on the screen, based on contents
    submitted by applications, window visibility and layering

  - Propagating input events to the appropriate clients, based on focus

#align(center, [#image("display-server.pdf", width: 100%)])

])

===  X11 and X.org

- #emph[X.org] is the historical display server on UNIX systems,
  including Linux

- Implements the #emph[X11] protocol, used between clients and the
  server

  - UNIX socket for local clients, TCP for remote clients

- On modern Linux, works on top of DRM or fbdev for graphics, input
  subsystem for input events

- Still maintained, but now legacy.

- X11 license

- #link("https://www.x.org")

#align(center, [#image("xorg.pdf", width: 100%)])


===  Wayland

- #emph[Communication #strong[protocol] that specifies the communication
  between a display server and its clients, as well as a C library
  implementation of that protocol]

- A display server using the Wayland protocol is called a Wayland
  #strong[compositor]

- Modern replacement for the aging X11 protocol

- More heavily based on OpenGL technologies

- #link("https://wayland.freedesktop.org/")

- #link("https://en.wikipedia.org/wiki/Wayland_(display_server_protocol)")[https://en.wikipedia.org/wiki/Wayland_(display_server_protocol)]

#align(center, [#image("wayland.png", width: 100%)]) 

===  Wayland compositors

- Weston

  - The reference compositor

  - #link("https://gitlab.freedesktop.org/wayland/weston")

- Mutter, used by the GNOME desktop environment 
  #link("https://gitlab.gnome.org/GNOME/mutter")

- wlroots, a Wayland compositor library, used by

  - Cage, a Wayland kiosk-style compositor 
    #link("https://github.com/Hjdskes/cage")

  - swayWM, a tiling Wayland compositor 
    #link("https://swaywm.org/")

- And many more 
  #link("https://wiki.archlinux.org/title/wayland#Compositors")[https://wiki.archlinux.org/title/wayland#Compositors]

===  Concept of graphics toolkits


#table(columns: (50%, 50%), stroke: none, [

- The X11 and Wayland protocols are very low-level protocols

- While possible, developing applications directly using those protocols
  or their corresponding client libraries would be painful

- Existence of #emph[toolkits]

  - Some of them work only on top of a display server: X11 or Wayland

  - Some of them can work directly on top of DRM + input, for single
    full-screen applications

- Widget-oriented toolkits, with APIs to create windows, buttons, text
  fields, drop-down lists, etc.

- Game/multimedia-oriented toolkits, with no pre-defined widget API

#align(center, [#image("toolkit.pdf", height: 80%)])


])

===  Qt


#table(columns: (50%, 50%), stroke: none, [

- Highly popular and well-documented development framework, providing:

  - Core libraries: data structures, event handling, XML, databases,
    networking, etc.

  - Graphics libraries: widgets and more

- Standard API is C++, but bindings to other languages available

- Works as

  - Single application with DRM with OpenGL, or #emph[fbdev] with no
    acceleration

  - Multiple applications on top of X11 or Wayland

- Multiplatform: Linux, MacOS, Windows.

- Somewhat complex licensing, with a mix of LGPLv3, GPLv2, GPLv3, and an
  (expensive) commercial license

- #link("https://www.qt.io/")

#align(center, [#image("qt-logo.pdf", width: 100%)]) 
])

===  Gtk


#table(columns: (50%, 50%), stroke: none, [

- Toolkit used as the base for the GNOME desktop environment, the most
  popular desktop environment for Linux desktop distributions, but
  loosing traction in embedded projects.

- Composed of #emph[glib] (core library), #emph[pango] (text handling),
  #emph[cairo] (vector graphics), #emph[gtk] (widget library)

- Standard API in C, but bindings exist for many languages

- Requires a display server: X11 or Wayland

- License: LGPLv2

- Version 3.x the most deployed currently, 4.x is a new major release

- Multiplatform: Linux, MacOS, Windows.

- #link("https://www.gtk.org")

#align(center, [#image("gtk-logo.png", width: 100%)])

])

===  Flutter


#table(columns: (50%, 50%), stroke: none, [

- Cross-platform UI application development: Linux, Android, iOS,
  Windows, MacOS

- Developed and maintained by Google

- Applications must be developed using the #emph[Dart] programming
  language

- Applications can run in the Dart virtual machine, or be natively
  compiled for better performance.

- License: BSD-3-Clause

- #link("https://flutter.dev")

Read our blog post:
#link("https://bootlin.com/blog/flutter-nvidia-jetson-openembedded-yocto/")
#align(center, [#image("Google-flutter-logo.pdf", width: 100%)])

#align(center, [#image("flutter-app.png", width: 90%)]) 
])

===  SDL


#table(columns: (50%, 50%), stroke: none, [

- #emph[Cross-platform development library designed to provide low level
  access to audio, keyboard, mouse, joystick, and graphics hardware]

- Implemented in C, lightweight

- Does not provide a widget library

- Games, media players, custom UIs

- License: zlib license (simple permissive license)

#align(center, [#image("sdl-logo.png", width: 100%)])

])

===  Other graphical toolkits

- Enlightenment Foundation Libraries (EFL) / Elementary

  - Lightweight and very powerful, but a lot less popular

  - Work on top of X or Wayland.

  - License: LGPLv2.1

  - #link("https://www.enlightenment.org/about-efl.md")

- LVGL

  - Very lightweight, mostly targeted at micro-controllers, but also
    runs on Linux

  - License: MIT

  - #link("https://lvgl.io/")

- See
  #link("https://en.wikipedia.org/wiki/List_of_widget_toolkits")[https://en.wikipedia.org/wiki/List_of_widget_toolkits]

===  Linux multimedia stack overview

#align(center, [#image("multimedia-stack.pdf", height: 850%)])

===  Audio stack

- Kernel-side: the ALSA subsystem, #emph[Advanced Linux Sound
  Architecture]

  - Includes drivers for audio interfaces and audio codecs

  - Exposes audio devices in `/dev/snd/`

  - #link("https://alsa-project.org")

- Companion user-space library: #emph[alsa-lib]

- Audio servers

  - Needed when multiple applications share audio devices: mix audio
    stream, route audio stream from specific applications to specific
    devices

  - #emph[JACK]: mainly for professional audio

  - #emph[pulseaudio]: mainly for regular desktop Linux audio

  - #emph[pipewire]: modern replacement for both pulseaudio and JACK,
    already adopted by some Linux distributions

  - #link("https://pipewire.org/")

===  Video stack

- Kernel-side: Video4Linux subsystem, or V4L in short

  - Supports camera devices: webcams as well as camera interfaces of
    SoCs and camera sensors (parallel, CSI, etc.)

  - Also used to support video encoding/decoding HW accelerators: H264,
    H265, etc.

  - Exposes video devices as `/dev/videoX`

  - #link("https://www.linuxtv.org/")

- Traditional user-space library: #emph[libv4l]

- New user-space library, more modern, with many more features, under
  adoption: #emph[libcamera]

- Supported in lots of multimedia stacks/software: GStreamer, ffmpeg,
  VLC, etc.

===  GStreamer

- #emph[Library for constructing graphs of media-handling components]

- Allows to create #emph[pipelines] to transform, convert, stream,
  display, capture multimedia streams, both audio and video

- Composed of a vast amounts of plugins: video capture/display, audio
  capture/playback, encoding/decoding, scaling, filtering, and more.

- #link("https://gstreamer.freedesktop.org/")

- An interesting alternative is #emph[ffmpeg]

#align(center, [#image("gstreamer-pipeline.png", width: 60%)])

===  Further details on Linux graphics and multimedia stacks


#table(columns: (50%, 50%), stroke: none, [

- Bootlin's
  #link("https://bootlin.com/doc/training/graphics")[ #emph[Understanding the Linux graphics stack]]
  training

- Bootlin's
  #link("https://bootlin.com/doc/training/audio")[ #emph[Embedded Linux Audio]]
  training

- Complete courses focused exclusively on those topics

- Freely available training materials

#align(center, [#image("linux-graphics-course-slide.jpg", width: 100%)])
#align(center, [#image("linux-audio-course-slide.jpg", width: 100%)])

])

===  Linux networking stack

#align(center, [#image("networking-stack.pdf", height: 850%)])

===  Web accessible UI

- Very common in embedded systems to use a Web interface for device
  configuration/monitoring

- Needs a web server: #emph[Busybox httpd] for very simple needs,
  #emph[lighttpd], #emph[nginx], #emph[apache] for more complex needs

- Can use PHP, NodeJS or other interpreted languages, or simple CGI
  shell scripts

===  Web browsers: rendering engines To add HTML rendering capability
to your device

- WebKit

  - Started by Apple, used in iOS, Safari

  - Open source project: LGPLv2.1 and BSD-2-Clause

  - #link("https://webkit.org/")

  - Integrated with Gtk: #link("https://webkitgtk.org/")[WebKitGTK]

  - Integrated with Qt: #link("https://wiki.qt.io/Qt_WebKit")[QtWebKit]

  - Port optimized for embedded devices:
    #link("https://wpewebkit.org/")[WPE WebKit]

- Blink

  - Forked from WebKit

  - Developed by Google, used in Chrome

  - #link("https://en.wikipedia.org/wiki/Blink_(browser_engine)")[https://en.wikipedia.org/wiki/Blink_(browser_engine)]

  - Integrated with Qt:
    #link("https://wiki.qt.io/QtWebEngine")[QtWebEngine]

  - Used by #link("https://www.electronjs.org/")[Electron]

===  Web-based UIs

- An alternative to native GUI applications is to create a GUI based on
  Web technologies

- Run a Web browser full-screen, and use popular Web technologies to
  develop the application

- Some possible options

  - #emph[#link("https://github.com/Igalia/cog")[Cog]], a simple
    launcher for the WPE Webkit port

  - #emph[#link("https://www.electronjs.org/")[Electron]], a way to
    package a NodeJS application with a web rendering engine, into a
    self-contained application

- Beware of the footprint and performance impact: a web rendering engine
  is a massive and resource-consuming piece of software

===  Programming languages

- Wide range of languages and frameworks available, not just C/C++

- Beware of footprint and performance implications

- Natively compiled languages

  - Rust

  - Go

  - Ada

  - Fortran

- Interpreted languages

  - Python

  - Javascript, NodeJS

  - Lua

  - Shell scripts

  - Perl, Ruby, PHP

#setuplabframe([Integration of additional software stacks],[

- Integration of #emph[systemd] as an init system

- Use #emph[udev] built in #emph[systemd] for automatic module loading

]))
