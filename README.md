DOS4, with Nix?
===============

Kind of.

This is mostly cheating.

It uses the toolchain bundled with the released source.
It's anyway quite likely nothing else can build this at this point in time.

And then, to run the build, just a good dose of `dosbox`.
Technically `dosbox-x` is used, but only because `format` works better there.

### How can I test this quickly?

```
 $ nix-build
 $ cp --no-preserve=mode result/dos.img ./
 $ qemu-system-i386 -fda dos.img
```

And you have a "modernized" 4.01 `select.exe`-based installer floppy!

Fun!?


### Modernized?

Main thing is it assumes a 1.44MB floppy, and reduces disk juggling by not requiring an installer disk backup.

Otherwise it is morally the same output, given the equivalent inputs.
