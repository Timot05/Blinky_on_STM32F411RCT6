# Blinky on STM32F411RCT6

This is a simple blinking light on an STM32F4 Microcontroller. This is based on the libraries provided by ST and [this tutorial](http://ralfhandrich.de/wp/?p=7) by Ralf Handrich.

To build, run the command: make

To flash, run the command: openocd -s ../../blinky -f test.cfg
the -s option allows to include the common.cfg file located in the openocd folder.
