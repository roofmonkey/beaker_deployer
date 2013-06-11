git clone git@github.com:roofmonkey/SystemTests.git
git clone git@github.com:roofmonkey/self_contained_install.git
git clone git@github.com:roofmonkey/beaker_deployer.git
cd beaker_deployer/

echo "About to setup servers file : are the servers in this script up to date ? If not cancel and edit this script".

#Edit this with the correct server list.
cat >servers << EOF
mrg19
mrg22
mrg41
mrg44
EOF

#Copy over updated slaves into "slaves" file. 
cp servers ./self_contained_install/deploy/slaves

echo "Comment out the IFCONFIG script in BEAKER and click enter to proceed...also, set passwords on all nodes so that you can enter them"
echo "Press enter when ready to proceed."
read x

#Setup passwordless ssh 
./ifconfig.ssh
