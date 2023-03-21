# wsl-autofont
Set Windows Terminal font size automatically depending on your screen.

Scripts to run from within WSL:
- `autoset_font_size.sh` detects which screens are connected
- `set_terminal_font_size.sh` sets font size in Windows Terminal (in all the profiles (!))
- `.bash_aliases` example aliases to call `set_terminal_font_size.sh` manually (also used in `autoset_font_size.sh`)

Requirements: jq, moreutils, dos2unix, gawk

Let's say you have a laptop, at work you have an external screen, and a different one when working from home. And let's say that at home you have two different setups (you go to a coworking space, etc.). These have all different sizes / resolution.

This powershell command detects the connected screens: `powershell.exe -Command Get-CimInstance -Namespace 'root\wmi' -ClassName WmiMonitorBasicDisplayParams`. Run this in each scenario to get device identifiers, then adapt `autoset_font_size.sh` and/or the aliases to your taste.

Example:
```
$ MONITOR_INFO="$(powershell.exe -Command Get-CimInstance -Namespace 'root\wmi' -ClassName WmiMonitorBasicDisplayParams | dos2unix)"
$ awk -F '\' '/^InstanceName/ { print $2 }' <<<"$MONITOR_INFO"
LEN40BA
SAM7174
```

Here we can see I'm at the 'office' with `LEN40BA` being the built-in laptop screen and `SAM7174` the external one.

The last step is adding `autoset_font_size.sh` to `~/.bashrc` so that when you start WSL, it sets the font size for you (make sure it only runs once).
