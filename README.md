# sc-adente
not-pretentious livecoding stuff.

## setup
- Install `supercollider` with plugins: `sudo apt install supercollider sc3-plugins`
- Install [SuperDirt](https://codeberg.org/musikinformatik/SuperDirt):
  ```shell
  echo 'include("SuperDirt");' | sclang
  ```
- Install ported plugins:
  ```shell
    curl -L --fail -o /tmp/ported.zip "https://github.com/madskjeldgaard/portedplugins/releases/download/v0.4.1/PortedPlugins-Linux.zip"
    unzip -q -d ~/.local/share/SuperCollider/Extensions -o /tmp/ported.zip
  ```
- Install mi-UGens:
  ```shell
  curl -L --fail -o /tmp/mi-UGens.zip "https://github.com/v7b1/mi-UGens/releases/download/v0.0.9/mi-UGens-Linux.zip"
  unzip -q -d ~/.local/share/SuperCollider/Extensions -o /tmp/mi-UGens.zip
  ```
- [clone sam-ples](#sam-ples)
- start superdirt with PipeWire: `pw-jack sclang superdirt_startup.scd`

## Sam-ples

Install `rclone`: `sudo apt install rclone`
Create config: `rclone config create annoying drive`

Retrieve samples:
```rclone sync annoying:sam-ples ~/.sam-ples -P```

Update samples:
```rclone sync ~/.sam-ples annoying:sam-ples -P```

## Quarks
https://github.com/madskjeldgaard/linuxutils-quark

## Synths
`synthdefs_extra.scd` taken from https://github.com/pierstu/tidalcycles/blob/master/synthdefs_extra.scd

other synthdefs and effects:
https://github.com/Olbos/Tidal-Olbos

### plugins for addictional synths
mi-ugens:
https://github.com/v7b1/mi-UGens

PortedPlugins:
https://github.com/madskjeldgaard/portedplugins
