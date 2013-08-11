#!/usr/bin/env bash

###### Validate that servers are reachable before proceeding ##### 
slaves=( `cat "/home/install/hadoop-1.1.2.23/conf/slaves" `)
for node in "${slaves[@]}"
  do
     ssh root@$node /usr/bin/extendtesttime.sh 99
done

