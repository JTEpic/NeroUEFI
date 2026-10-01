# NeroUEFI


Made by JTEpic

OS on UEFI project started october 2025


## Introduction

NeroUEFI is an Open Source, multi-platform operating system. It provides a simple, platform-independent OS for creating windows, contexts and surfaces, reading input, handling events, etc.

NeroUEFI natively supports Linux, macOS and Windows and other Unix-like systems. On Linux both Wayland and X11 are supported through QEMU.

NeroUEFI is licensed under the (ENTER LICENSE) license.

You can download the latest development or stable release as source.

The documentation is available online and is included in all source archives. See the release notes for new features, caveats and deprecations in the latest release. For more details see the version history.

The master branch is the stable integration branch and should always compile and run on all supported platforms, although details of newly added features may change until they have been included in a release. New features and many bug fixes live in other branches until they are stable enough to merge.

(NeroUEFI exists because of the contributions of many people around the world, whether by reporting bugs, providing community support, adding features, reviewing or testing code, debugging, proofreading docs, suggesting features or fixing bugs.)


## Compiling NeroUEFI

NeroUEFI is written primarily in C and Rust. NeroUEFI itself requires only the GCC and Rust compiler.

NeroUEFI supports compilation on Windows with Visual C++ 2013 and later, MinGW and MinGW-w64, on macOS with Clang and on Linux and other Unix-like systems with GCC and Clang. It will likely compile in other environments as well, but this is not regularly tested.

See the compilation guide for more information about how to compile NeroUEFI yourself.


## Using NeroUEFI

See the documentation for tutorials, guides and the API reference.


## Contributing to NeroUEFI

See the contribution guide for more information.


## System requirements

NeroUEFI supports nearly any modern system though it is recommended to run through QEMU.

See the compatibility guide in the documentation for more information.


## Dependencies

NeroUEFI itself needs the folowing headers and libraries for your OS and window system.

    gcc and gnu-efi for compiling
    qemu-desktop and edk2-ovmf for emulation
    parted and mtools for building bootable file
    rustup for access to rust tools/compiling, x86_64-unknown-uefi target


## Reporting bugs

Bugs are reported to our [issue tracker](https://github.com/JTEpic/NeroUEFI/issues). Please check the contribution guide for information on what to include when reporting a bug.


## Contact

On the GitHub page you can find the latest version of NeroUEFI, as well as news, documentation and other information about the project.

If you have a bug to report, a patch to submit or a feature you'd like to request, please file it in the [issue tracker](https://github.com/JTEpic/NeroUEFI/issues) on GitHub.

Finally, if you're interested in helping out with the development of NeroUEFI or porting it to your favorite platform, join us on GitHub.