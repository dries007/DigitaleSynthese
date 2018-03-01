# Digitale Synthese Course work (2018)

No copying of source code!



# VHDL without ModelSim on Arch Linux

Using [GHDL](http://ghdl.free.fr/index.html) for analysis, compilation and simulating and [GTKWave](http://gtkwave.sourceforge.net/) for visualization.

+ [GHDL Manual](http://ghdl.readthedocs.io/en/latest/)
+ [GHDL man page](https://linux.die.net/man/1/ghdl)
+ [GTKWave man page](https://linux.die.net/man/1/gtkwave)

## Installation

Install packages `ghdl` and `gtkwave` & setup environment:

+ `pacaur -S --needed ghdl gtkwave` _This can take a while._

  If this command fails once with a weird `gcc-build not found` error just run it again.

+ Create gtkwave config file: `cp /usr/share/gtkwave/examples/gtkwaverc .gtkwaverc`
+ Add `shopt -s globstar` to your `~/.bashrc`. You may need to re-login or `source ~/.bashrc` for this to apply.

## Project layout

+ `/`: Project root
  + `src/`: Sources root
  + `simu/`: Work folder for object files, ignore in git!

## Build script

```bash
ENTITY="<primary entity, usually something_tb>"
# Set folder, VHDL standard, allow evil "std_logic_unsigned" etc packages
OPT="--work=work --workdir=simu --std=93c --ieee=synopsys -fexplicit"
mkdir -p simu # Make sure simu exists
ghdl -i ${OPT} src/**/*.vhd # Import
ghdl -m ${OPT} ${ENTITY} # Make
ghdl -r ${ENTITY} --vcd=simu/wave.vcd # Simulate
```

Open `wave.vcd` with GTKWave.

You can reload the file with `ctrl+shift+r`, so you do not have to re-open the file.



Cleanup your folder with `ghdl --clean --workdir=simu`.

## Sublime integration

Install packages:

- `VHDL`
- `SublimeLinter`
- `SublimeLinter-contrib-ghdl`



Configure SublimeLinter:

- Open settings via `Tools -> SublimeLinter  -> Open Settings`.

  If there is no json in there but a line of text, save. It will bring up an error and reset the default file.

- Add in the `ghdl` object under `linters`:
  - To `args`:
    - `--work=work`
    - `--workdir=simu`
    - `--std=93c`
    - `--ieeee=synopsys`
    - `-fexplicit`



TODO: sublime not done yet, was figuring out errors

