# Multiplication-calculator-shell-script
#!/bin/bash

## This is a multiplication shell script, Calculate decimals using command 'expr'.

## Writen by callcz 20220801

Usage : ./multiplication.sh [OPTIONS] [FACTOR 0] [FACTOR 1] [FACTOR 2] ...

        example: `./multiplication.sh 1 0.2 -3` as '1*0.2*(-3)'.
        
options:

  -     Using shell pipes as input sources.
  -     
        example: `echo 1 0.2| ./multiplication.sh - -3` as '1 * 0.2 * (-3)'.
        
  --help,-h     List this help.

example:

$./multiplication.sh 3.1415926 2.718281828459045

8.5397340770014051750670

$./multiplication.sh 45 89 63 80

20185200

$echo 6 7 | ./multiplication.sh - 8 9

3024
