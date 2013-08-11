#!/usr/bin/env bash

###### Validate that servers are reachable before proceeding ##### 
slaves=( `cat "/root/servers" `)
for node in "${slaves[@]}"
  do
     ssh root@$node /usr/bin/extendtesttime.sh 99
done

