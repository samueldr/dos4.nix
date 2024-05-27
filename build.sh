#!/usr/bin/env bash

set -e
set -u

# Assuming source is at the default `C:\src` location.
# Otherwise needs adjustments.

DISK="dos.img"

dd bs=512 count=2880 if=/dev/zero of="$DISK"
# We need to trick dosbox into setting-up the floppy under A:
# It needs a valid filesystem
# The floppy will be formatted again later...
mkfs.vfat "$DISK"

cat > dosbox.conf <<EOF
[cpu]
core = dynamic
cycles = max

[autoexec]
imgmount -t floppy a $DISK
mount C ./
C:
> log.txt
build.bat
EOF

cat > build.bat <<'EOF'
>> C:\log.txt   cd src
>> C:\log.txt   call setenv
>> C:\log.txt   set

>> C:\log.txt nmake /x -

if errorlevel 1 goto :END
>> C:\log.txt   
>> C:\log.txt   echo Faking a system drive...
>> C:\log.txt   copy c:\src\bios\io.sys C:\
>> C:\log.txt   copy c:\src\dos\msdos.sys C:\
>> C:\log.txt   copy c:\src\cmd\command\command.com C:\
>> C:\log.txt   
>> C:\log.txt   ver set 4 0
>> C:\log.txt   
>> C:\log.txt   call cpy ..\out
>> C:\log.txt   cd C:\\OUT
>> C:\log.txt   format a: /S /SELECT /V:DOS4
>> C:\log.txt   copy C:\\out\\*.* a:
>> C:\log.txt   copy C:\\autoexec.bat a:
echo Build was successful?
goto :OK
:END
@echo off
echo There was an error while building...
@echo on
:OK
exit
EOF

unix2dos > autoexec.bat <<EOF
select menu
EOF

mkdir -p out

echo "--- log start ---" > log.txt
tail --quiet -F log.txt &

PS4=" $ "
set -x
dosbox-x -conf dosbox.conf "$@"

kill $(jobs -p)
