git clone git@github.com:roofmonkey/SystemTests.git
git clone git@github.com:roofmonkey/self_contained_install.git
git clone git@github.com:roofmonkey/beaker_deployer.git
cd beaker_deployer/
#Edit this with the correct server list.
cat >servers << EOF
mrg19
mrg22
mrg41
mrg44
EOF
