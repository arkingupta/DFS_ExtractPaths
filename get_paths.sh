#!/bin/bash

export PATH=/Applications/MATLAB_R2016b.app/bin/:$PATH
for filename in ./MotFiles/*.mat; do
    file=\'$filename\'
    matlab -nodisplay -r "write($file)"
    ./a.out
    outfile=${filename:27:14}
    #echo $outfile
    mv 'paths.txt' "${outfile}.txt"
done
