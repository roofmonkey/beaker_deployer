beaker
======

beaker_deployer

For EACH beaker use case, there is a subdirectory.

The ifconfig script will setup the universal stuff (passwordless ssh).

To deploy any of these:

1) create beaker instances using the beaker/ scripts

2) run ifconfig.sh inside of beaker (ssh -A into beaker, git clone this repo, and run ifconfig.sh)

3) run your specific setup (i.e. git clone the self_contained_install repo, run deploy_all.sh, etc...)
