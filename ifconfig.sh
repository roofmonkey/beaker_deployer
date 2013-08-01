#Run this script (edit the nodes first) to setup passwordless ssh between nodes.
#Commented out the Node[***] declarations for safety. 

servers=$1
if [ $# -eq 0 ]
  then
    echo "No arguments supplied., enter servers path"
    read servers
fi


master=$(head -1 $servers | tail -1)
Node[0]=$(head -2 $servers | tail -1)
Node[1]=$(head -3 $servers | tail -1)
Node[2]=$(head -4 $servers | tail -1)
echo "master $master and ${Node[0]} ${Node[1]} ${Node[3]}"
read

#Un comment this section if its a new master.
#Make an RSA key for this master node.  Assumes one doesnt exist yet.
#echo "making new local rsa key... okay?"

#read
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

#setup passwordless ssh into self
cat ~/.ssh/id_rsa.pub | ssh root@$master 'cat >> /root/.ssh/authorized_keys'


for i in "${Node[@]}"
do
	#ip=$(ssh root@$i ifconfig | grep inet | grep Bcast | cut -d\: -f2 | cut -d ' ' -f1)
	#echo "$i ip is $ip --- if that looks okay, then click enter to continue.. " 
	
	#Now, try to ssh into this machine passwordlessly, store the result
	ssh -oNumberOfPasswordPrompts=0 -q root@$i exit
	pwdless=$?
	#Also, lets see if we have the "master" key in the results.
	command="ssh root@$i 'cat /root/.ssh/authorized_keys | grep "$master" | wc -l'"
	authkeys=$($command) 
	echo "(okay if empty) authkeys = $authkeys"
	read
	#contains key to this machine	
	if [ $pwdless == 0 ] && [ $authkeys -ge 1 ]; then
		echo "Skipping this machine $i, we already can connect to it $pwdless $authkeys"
          	continue
	fi

	echo "$i ? $pwdless and $authkeys ?"
	read
	#uncomment below to generate ssh keys
        #now, ssh into the machine and make an id_rsa key...
        echo "Now generating a key on remote machine ..." 
	#remove any trace of this server locally.. 
	ssh-keygen -R $i
	ssh root@$i 'ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa'        
	sleep 1
	
	echo "Now copying over the key ..."		
	cat ~/.ssh/id_rsa.pub | ssh root@$i 'cat >> /root/.ssh/authorized_keys'
	sleep 1
	echo "authorized keys... after..... "
	read
	ssh root@$i 'cat /root/.ssh/authorized_keys'
	
	echo "Done copying id_rsa.pub into $i's authorized keys, now you can ssh into $i"	
	echo "This should NOT ask you for a password..."
	ssh root@$i exit
done

