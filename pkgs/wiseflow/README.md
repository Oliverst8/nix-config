# Wiseflow

ITU = sucker

You probarly need this

```sh
[Desktop Entry]
Name= WISEflow Device Monitor
Comment=WISEflow Device Monitor is an application used during flows on the WISEflow platform with device monitoring enabled.
Exec=wiseflow-device-monitor %u
Icon=wiseflow-device-monitor
Type=Application
Terminal=false
MimeType=x-scheme-handler/wfdm;
```

This should go inside

```sh
~/.local/share/applications/wiseflow-device-monitor.desktop
```

This made it work, no idea why:

```
xdg-mime default wiseflow-device-monitor.desktop x-scheme-handler/wfdm
xdg-mime query default x-scheme-handler/wfdm
```

Last test working commit

```
def6decf92883d5e419572caee6f6385d7663608
```

Turn of AI pisss
Jetbrains
And copilot chat neovim
