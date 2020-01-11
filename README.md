# slic3r_automation
A sample folder structure with make file automates slicing STL files into GCODE

I made this automation tool to save me work when I do 3d printing. 
It is a way of organizing STL files and printing recipes.
[It uses the `slic3r` slicing tool because it has great command line options.]


**The How and Why**

_Ready to Print_

You want to print some design, for example some archery target pins you have done before.
The printer is loaded with black abs filament.
You are not even sure what you had named the file.
You look in the folder `printables/my_printer/black_abs/archery`
and find the file `target_pin_twice.gcode`.
Just what you wanted, ready to go, even though you have never before
tried that design with the black abs filament.
 
_New Filament_

You have a new filament that requires some different settings, like temperature.
Let's say it is a nice wood mimic filament.
Just add a configuration file `wood_pla.ini` to the folder `recipes/filaments`.
Then type `make` at the command line.
You will soon have `printables/my_printer/wood_pla` folder that contains the `gcode` files
for all of your favorite things to print, all organised by categories.

_Changed Filament_

You decide the wood filament would print better at a lower temperature.
So you edit or otherwise change the `wood.ini` file. Then run the `make` command.
This will redo all of the files in `printables/my_printer/wood_pla` with the changes
but will not redo anything else.

_New Design_

You have a new design, `rook.stl`,  to make a chess rook.
You plan on making all the different chess pieces.
So you make a new folder in `categories` name `chess`.
You are pretty sure the rook will print fine without supports.
So you make a subfolder in `chess` named `plain`.
You place `rook.stl` in this folder.
So you now have `categories/chess/plain/rook.stl`.
The name of the folder `plain` matches the name of a printing recipe
`recipes/printing/plain.ini`.
Now you run the `make` command.
You will then have a `gcode` file for each filament in `recipes/filaments`.
For example if your filament recipes are `black_abs.ini` and `wood_pla.ini`
you will then have two gcode files for the rook design:
 * `printables/my_printer/black_abs/chess/rook.gcode`
 * `printables/my_printer/wood_pla/chess/rook.gcode`
 
 _Changed Design_
 
 If you find a better design for your rook, just replace the
 `rook.stl` file with the improved design.
 As long as this file has a newer time stamp than before,
 all you have to do is run the `make` command.
 
 _Changing Which Printing Recipe Is Used_
 
 As you create or acquire designs for the rest of the chess pieces,
 just add them to the same `categories/chess/plain` folder.
 If one of the pieces, say the queen, does not print well
 without supports, then choose a different recipe from the
 folder `recipes/printing`. Suppose you want to use the
 recipe `supported.ini` from there. Just move `queen.stl`
 out of the folder `categories/chess/plain` into a
 folder `categories/chess/supported`.
 Now when you run `make` the queen will be get a `gcode`file with supports
 while the other pieces will continue to use the plain printing file.
 
 _New Printing Recipe_
 
 Suppose `knight.stl` is extra tricky and does not print well even with
 the `support.ini` recipe. You decide to tweak up a special recipe just
 for the knight. Make a new trial recipe and place it in the `recipes/printing`
 folder. Let's say you name the recipe `fancy.ini`.
 Make a new folder `categories/chess/fancy` and place `knight.stl` there.
 Running `make` will create `knight.gcode` for all of your filaments.
 As you do your trial prints, just keep editing `fancy.ini` and running `make`.
 You will quickly get updated versions of `knight.gcode`.
 
 _New Printer_
 
 You have a new printer. Congratulations! But it needs some different settings.
 Just create a new printer recipe in `recipes/printers`. 
 Let's say you call the new printer `super_printer`.
 Then name the recipe `super_printer.ini`.
 So you should now have a file `recipes/printers/super_printer.ini`.
 Just run 'make'.
 This will create new `gcode` files for all of your designs and filaments
 in the folder `printables/super_printer`.
 
 _Reorganizing_
 
 Inspired by too much coffee and doughnuts, you decide to reorganize
 everything. You rename categories, rename filaments, combine categories,
 rename recipes, rename `stl` files and all manner of other well intended chaos.
 While the `make` command is pretty good at recreating outputs when
 the inputs are changed, it is not so good at cleaning out obsolete crud.
 No problem. Just run `make clean`. It will toss out all of the outputs.
 The run `make` and it will recreate everything using your new and hopefully
 more wonderful organization.
 
 **Requirements**
 
  * You need to have the `make` utility installed on your system.
  * You need to have a compatible operating system. So far this has been tested on:
    * Ubuntu 18.04
  * You need to have a compatible version of `slic3r`. The `slic3r` exectuable needs
    to be defined in the `slicing_command` line of `category_level_makefile`.
 
 **Trouble Shooting**
 
  * Check that the  `slicing_command` line of `category_level_makefile` matches the
  name of your `slic3r`.
  * Examine the contents of the `factory` folder.

**Licensing**

**Use at your own risk or do not use it at all.**