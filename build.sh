#!/usr/bin/env bash

set -e
set -u

# Assuming source is at the default `C:\src` location.
# Otherwise needs adjustments.

cat > dosbox.conf <<EOF
[cpu]
core = dynamic
cycles = max

[autoexec]
mount C ./
C:
cd src
REM setenv
REM For some reason running a batch file stops the batch file?
$(cat src/setenv.bat)
nmake >> ..\\log.txt
cpy ..\\out
exit
EOF

# Same issue :/
echo "exit" >> src/cpy.bat

mkdir -p out

PS4=" $ "
set -x
exec dosbox -conf dosbox.conf "$@"
