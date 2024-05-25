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

And you technically have a DOS4 image.

Fun!?
