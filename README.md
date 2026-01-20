# Jai Linux Setup

This repo contains a simple _bash_ script to help setting up and update _jai_ compiler in my computer.
It's a simplified version of how golang organize its things.


## How it works

By default it organize into the following directories:

- `~/jai/`: The root directory containing all of my jai related stuff (compilers and stuff). I also put dependencies like LSP (Jails) in this directory.
    If you want another directory, you can set an environment variable `JAI_ROOT` to customize the location.
- `~/jai/jai_compilers/`: Contains multiple versions of jai compiler.
- `~/jai/jai/`: A symlink to the jai version to be used from the `jai_compilers` directory.

The script takes the URL to the jai compiler. It'll download the zip file, unzip it, and put the compiler to the `~/jai/jai_compilers/`
directory. The symlink is then updated to this version.

## Usage

```sh
./jai_setup.sh <download link for the compiler>
```

## Post Setup
You can then update your `PATH` to use the jai binary:

```sh
export JAI_ROOT=$HOME/jai
export JAI_PATH=$JAI_ROOT/jai
export PATH=$JAI_PATH:$PATH
```

## Contributions

If you have a suggestion, feel free to create an issue for it!

Feel free to take inspiration to create your own version as well!

