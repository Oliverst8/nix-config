# Nix config

## Options
In the following section all of my options can be found

| Option name | Type | Description | Default value |
|---------|---------|---------|---------|
|desktop.hyprland.enable|bool|Enable/Install hyprland|false|
|systemFolder.name|str|The name of the current system (The name the config folder is in)|""|
|gottis.enable|bool|Enable gottis|false|
|git.enable|bool|Enable git|false|
|git.lazygit.enable|bool|Enable lazygit (Only works if git is enabled)|true|
|git.gh.enable|bool|Enable the github cli (Only works if git is enabled)|true|
|docker.enable|bool|Enable and install docker|false|
|docker.lazydocker.enable|bool|Enable lazydocker (Only works if docker is enabled)|true|
|vscode.enable|bool|Enable/Install vscode|true|
|itu.wiseflow.enable|bool|Enable/Install wiseflow|false|
|desktop.hyprland.monitors|str []|List of monitor description for hyprland|[ ]|
|drivers.nvidia.enable|bool|Enable/Install nvidia drivers|false|

## Garbage collect 
```
nix-env --list-generations

nix-collect-garbage  --delete-old

nix-collect-garbage  --delete-generations 1 2 3

# recommeneded to sometimes run as sudo to collect additional garbage
sudo nix-collect-garbage -d

# As a separation of concerns - you will need to run this command to clean out boot
sudo /run/current-system/bin/switch-to-configuration boot
```
[Link to post](https://www.reddit.com/r/NixOS/comments/10107km/comment/j2lekuj/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)

## Allow flakes on setup
The following needs to be added to allow rebuilding from flakes

```
# Enable nix flakes
nix.settings.experimental-features = [
  "nix-command"
  "flakes"
];
```
