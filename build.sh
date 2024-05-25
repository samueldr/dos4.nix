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
cd src
REM setenv
REM For some reason running a batch file stops the batch file?
$(cat src/setenv.bat)
nmake >> ..\\log.txt

echo Faking a system drive...
copy c:\\src\\bios\\io.sys C:\\
copy c:\\src\\dos\\msdos.sys C:\\
copy c:\\src\\cmd\\command\\command.com C:\\

ver set 4 0

cpy ..\\out
REM exit
EOF

# Same issue :/
cat >> src/cpy.bat <<EOF
echo uuuugh
cd C:\\OUT
format a: /S /SELECT /V:DOS4
copy C:\\out\\*.* a:
copy C:\\autoexec.bat a:
exit
EOF

unix2dos > autoexec.bat <<EOF
path dos4
select menu
EOF

mkdir -p out

PS4=" $ "
set -x
exec dosbox-x -conf dosbox.conf "$@"
