#!/bin/sh
help(){
more << erom
Name:
nice_hog - run cpu hogs nicely (at a lower priority)

Usage:
nice_hog -# [ /usr/lib/nspluginwrapper/npviewer.bin ] ...
nice_hog --ulimit "ulimit options quoted" -# [ /usr/lib/nspluginwrapper/npviewer.bin ] ...
nice_hog --unnice -# [ /usr/lib/nspluginwrapper/npviewer.bin ] ...
nice_hog --help # this help text

Synopsis:
This tool(hack) was written to deal with the problem of rogue processes,
in particular $feral_list is the default.

This is achieved by adding "-1" to the name of the original program, and 
create a replacement that nices this renamed program.

You may also specify any of the ulimit options (in quotes) if you want
to further restrict the operation of the process. An example would be
to kill the process after it uses an hours of CPU time, or if it's memory
usage gets to high. See example 1 below.

The reason I wrote this program was because so many web pages have flash
embedded, and often when a flash ran on my laptop the CPU fan went nuts. I
mean "a web advertisement" chugging across the top of my screen, who
cares... not me. (Esp if it wastes watts, and makes green house gases)

Now if I could click on a tab in firefox and nice the hog pages forever
I would be a happy hacker.

Fortunately - on my laptop - when npviewer.bin is niced the CPU does
not scale up the MegaHertz, does not spin up the fan to full speed,
and does not make as much of a racket, and maybe it save your battery
from being suck dry. (The flash does still suck a bit more power somehow)

Usage: (This will nice_hog npviewer.bin by default)
To install: (Only need to be root for system owned files)
# nice_hog /usr/lib/nspluginwrapper/npviewer.bin
OR
# nice_hog -5 /usr/lib/nspluginwrapper/npviewer.bin

To uninstall:
# nice_hog --unnice /usr/lib/nspluginwrapper/npviewer.bin

Example 1:
This example will raise the niceness to 2, and kill $feral_list if
it uses more the an hour of CPU... Install as follows:
# nice_hog --ulimit "-t 3600" -2
-rwxr-xr-x 1 root root 268 2008-06-18 22:26 /usr/lib/nspluginwrapper/npviewer.bin
-rwxr-xr-x 1 root root 145692 2008-06-18 10:14 /usr/lib/nspluginwrapper/npviewer.bin-2
Note: killing you flash at 3600 might not be exactly what you want.
test it out with a shorter interval.

Example 2:
These commands work on almost any program (except /bin/sh), for example:

# nice_hog /usr/bin/xclock
-rwxr-xr-x 1 root root 62820 2008-04-05 04:22 /usr/bin/nice_xclock
-rwxr-xr-x 1 root root 168 2008-06-18 12:34 /usr/bin/xclock

# xclock -update 1 &
[28] 666

# ps -lp 666
F S UID PID PPID C PRI NI ADDR SZ WCHAN TTY TIME CMD
0 S 0 666 555 0 81 1 - 2206 sys_po pts/3 00:00:00 xclock-1

# nice_hog --unnice /usr/bin/xclock
-rwxr-xr-x 1 root root 62820 2008-04-05 04:22 /usr/bin/xclock

Bugs^H^H^H^HFeatures:
The newly new script belongs to the person who created it (probably
root), and the permissions are a+rx (which may be not what you want).
Also on some systems renaming a file with the SetUI bit on may cause
the bit to be removed, or trigger a security audit alert.

The --ulimit option must appear first.

If the niceness isnt 1 you must also specify the niceness when unniceing.
# nice_hog --unnice -10 /usr/bin/xclock

Some error messages are not too helpful, esp from basename.

License: 
GPL - Author NevilleDNZ
erom
}

feral_list="/usr/lib/nspluginwrapper/i386/linux/npviewer.bin" # etc ... (add your favourites)

if [ "$1" = "--help" ]; then
help "$@"
exit 1
elif [ "$1" = "--unnice" ]; then
unnice="$1"; shift
fi

case "$1" in
(--ulimit*)
ulimit="ulimit $2"; 
shift 2;;
esac

case "$1" in 
(-[1-9]*)niceness="$1"; shift;;
([1-9]*)niceness="$1"; shift;;
(*)niceness="-1";; # just enough to prevent fan/AMD from warp speed
esac

if [ "$*" = "" ]; then
set -- $feral_list
fi

domesticate(){
cat << tac > "$feral"
#!/bin/sh
$ulimit
exec nice -n $niceness "$hog" "\$@"
#exec -a "$feral" nice $niceness "$hog" "\$@"
#exec -a "$basename" nice $niceness "$hog" "\$@"
tac
}

for feral in "$@"; do
basename="$(basename "$feral")"
hog="$(dirname "$feral")/$(basename "$feral")$niceness"
if [ "$unnice" ]; then
if [ -x "$hog" ]; then
mv "$hog" "$feral"
fi
ls -l "$feral"
elif [ ! -x "$hog" ]; then
mv "$feral" "$hog"
domesticate
chmod a+rx "$feral"
ls -l "$feral" "$hog"
fi
done # od :guitar:
