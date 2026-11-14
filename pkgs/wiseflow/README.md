# Wiseflow

ITU = sucker

Currently packaging `wiseflow_device_monitor_2.7.0_linux.deb`.

The desktop entry and the `x-scheme-handler/wfdm` default are now installed by the
module, so no manual steps are needed. If you still have the old hand-written file,
delete it — it shadows the packaged one and is missing `JSC_SIGNAL_FOR_GC=12`:

```sh
rm -f ~/.local/share/applications/wiseflow-device-monitor.desktop
xdg-mime query default x-scheme-handler/wfdm   # should print wiseflow-device-monitor.desktop
```

## Updating

Drop the new `.deb` in this directory, `git add` it (flakes only see tracked files),
bump the filename in `default.nix`, and diff the deb's own desktop entry against the
one we install — upstream has snuck env vars into `Exec=` before.

Note that `webkitgtk_4_0` is gone from unstable, so it comes from the pinned 25.05
input and is not in the binary cache. Expect a long local compile after a bump.

## Gotchas

- The app shells out to `gnome-screenshot`, which hangs the system check on non-GNOME
  Wayland. `default.nix` swaps in a shim that calls `spectacle` (KDE) or `grim` there, and
  the real `gnome-screenshot` on X11.
- Enabling the option also installs an XFCE (X11) session, which is what WISEflow
  recommends. Pick it at the login screen for real exams.
- Browsers export an `LD_LIBRARY_PATH` full of host libs, which crashes the old glibc in
  the FHS env (`GLIBC_2.43 not found`), so the wrapper unsets it.
- The app finds "foreground" processes via `xwininfo`. On Wayland it finds none, sends
  `"foregroundProcesses":null`, and the server answers 400 (shown as the "not connected"
  badge / stuck upload queue). `GDK_BACKEND=x11` makes its own window visible to itself.
  Native Wayland apps are still never reported as foreground; use an X11 session if that matters.
- Debug browser launches with `journalctl --user | grep wiseflow`.

## Notes

Turn of AI pisss
Jetbrains
And copilot chat neovim

Last test working commit

```
def6decf92883d5e419572caee6f6385d7663608
```
