# Pages

## Building, Testing, and Installation

You'll need the following dependencies:
 * meson
 * valac
 * libglib2.0-dev
 * libgranite-dev
 * libgtk-3-dev
 * libreofficekit-dev

If you don't have LibreOffice installed, you'll need to install:
 * libreoffice-core-nogui
 * libreoffice-writer-nogui
 * libreoffice-calc-nogui
 * libreoffice-draw-nogui
 * libreoffice-impress-nogui

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

```bash
meson build --prefix=/usr
cd build
ninja
```

To install, use `ninja install`, then execute with `com.github.tintou.pages`

```bash
ninja install
com.github.tintou.pages
```

