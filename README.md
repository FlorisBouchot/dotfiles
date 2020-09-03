<h1 align="center">My Dotfiles</h1>
<p align="center">My personal MacOS settings, applications and dotfiles!</p>

<br />

This repository sets up new Mac's with a couple commands, it sets up:
[My MacOS System Preferences](https://github.com/FlorisBouchot/dotfiles/blob/master/system/macos.sh)

[My Applications and VS Code extentions](https://github.com/FlorisBouchot/dotfiles/tree/master/bundle)

[And my dotfiles ](https://github.com/FlorisBouchot/dotfiles/tree/master/dotfiles) 



## Installation

```bash
# First it installs core tools such as xcode and brew.
# By default, You don't have access to any CLI tools as git and wget.
# This only uses by curl and bash, and it run completely automatic.
curl https://raw.githubusercontent.com/FlorisBouchot/dotfiles/master/install.sh| /bin/bash -s -- --init

# Installing CLI, GUI, MAS and VS Code Extentions. `--bundle`
# Symlinks dotfiles to its directories. `--dotfiles`
# Configuring MacOS system settings. `--system`
# Clone or download the repo
git clone https://github.com/FlorisBouchot/dotfiles.git
bash install.sh --all
```

#### Options

```bash

My personal dotfiles.

Options for install.sh
=================================================
init:     Core intialization
bundle:   Package installation
system:   MacOS system setting
dotfiles: Dotfiles installation
all:      All installations (except init)
```

<br />

## Thanks

A very big thanks to the following people and their amazing dotfiles and settings

https://github.com/ryuta69/dotfiles

https://github.com/mathiasbynens/dotfiles

https://github.com/webpro/dotfiles

And all the other people, websites and sources I totally forgot the name of!
