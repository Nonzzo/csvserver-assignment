#!/bin/bash
  
range=( $(seq  $counter -1 8)  )

for (( i=0; i<${#range[@]}; i++ )); do
        echo "$i,$(($RANDOM))" >> inputFile
done


