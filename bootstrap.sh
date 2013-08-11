#!/usr/bin/env bash
cd /root/

git clone --recursive git@github.com:roofmonkey/SystemTests.git
git clone git@github.com:roofmonkey/self_contained_install.git
git clone git@github.com:roofmonkey/beaker_deployer.git

echo "About to setup servers file : are the servers in this script up to date ? If not cancel and edit this script".

#Edit this with the correct server list.
cat >servers << EOF
mrg40
mrg42
mrg19
mrg44
EOF

###### Validate that servers are reachable before proceeding ##### 
slaves=( `cat "servers" `)
for node in "${slaves[@]}"
  do
    echo "pinging $node"
    unreachable=`ping -c4 $node 2>&1 | awk '/100% packet loss|unk/'`
    if [ ! "$unreachable" == "" ]; then
        echo "$node unreachable. 
              <<< $unreachable >>> 
        Update the servers in the above declaration and re run this script"
        exit
    fi
    echo "   success ! $node : $unreachable"
done


#Copy over updated slaves into "slaves" file. 
cp /root/servers /root/self_contained_install/deploy/slaves

echo "Comment out the IFCONFIG script in BEAKER and click enter to proceed...also, set passwords on all nodes so that you can enter them"
echo "Press enter when ready to proceed."
read x

#Setup passwordless ssh 
/root/beaker_deployer/ifconfig.sh servers

#Extend the life of all nodes, permanantly
echo "finally, adding extender to /etc/cron/daily for all nodes - so that these are perm machines"
chmod 777 extend.sh
cp extend.sh /etc/cron.daily/
