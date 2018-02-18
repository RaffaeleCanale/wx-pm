### Easily setup a bash environment with many useful scripts, auto-completion and quick configuration setup.

# Configuration

1. Setup you `config.properties` file with both these properties:
  - `__PROJECTS_DIR__`: Directory where all the compatible projects will be setup
  - `__PATH__`: Directory that will be added to `$PATH`

2. Copy your favourite `.bashrc` configuration to `.bashrc_template`

# Installation

Simply run:
```
./install.sh
```
This will setup the scripts with your configuration. Then run:
```
./dist/wx setup
```
**Warning:** This will override your `~/.bashrc` file!

This will setup your new `bashrc` file and add `wx` to your path.

# Run

On any compatible, run
```
wx install
```
