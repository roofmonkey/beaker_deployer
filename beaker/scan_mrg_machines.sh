workdir=$(mktemp -d)

#Write the free machines to a file
bkr list-systems --free --group=mrg-devel > $workdir/free
#The file is csv style, with machine url on each line:
#mrg.a.1
#mrg.b.1
#etc...
#Now, for each line in the file - find the disk space 
#Get the value of a key from beaker xml file
function valueOfKey()
{ 
    #echo "<-vk"
    filename=$1
    key=$2
    #echo "searching for $key in $filename, with lines = $(wc -l $filename)" 
    if [ $(wc -l $filename | cut -f1 -d" ") == 0 ]; then 
       echo "empty file !! returning"	
       return -1;
    fi
    #echo "grep xlmns $filename | grep \"$key\" | grep -o -P '(?<=:ns).*(?=\=)')"
    ns=$(grep xmlns $filename | grep 	"$key#" | grep -o -P '(?<=:ns).*(?=\=)')
    if [ $ns > 0 ]; then
    	#echo "ns found for $key --> $ns"
    	#<ns5:key rdf:datatype="http://www.w3.org/2001/XMLSchema#integer">238475</ns5:key>
    	#Grep out this ns5 string's value from the tags between the > and <
    	keyvalue=$(grep "ns$ns:" $filename | grep ":key" | grep -o -P '(?<=\>).*(?=\<)')
    	#echo "vk->"
    else
	#echo "empty ns :( for $key in $filename";
    	keyvalue="<no ns>"
    fi
}

#echo "free machines path is $workdir/free" 
echo $(wc -l $workdir/free)
#echo "looping"
for machine in $(< $workdir/free);do
     #echo "machine " $machine
     bkr system-details $machine > $workdir/$machine
     #echo "now getting diskspace from $workdir/$machine"
     valueOfKey $workdir/$machine "DISKSPACE"
     diskspace=$keyvalue
     valueOfKey $workdir/$machine "NR_DISKS"    
     numdisks=$keyvalue
     valueOfKey $workdir/$machine "MEMORY"
     memory=$keyvalue
     valueOfKey $workdir/$machine "CPUMODEL"
     cpumodel=$keyvalue
     x86=$(grep x86 $workdir/$machine | wc -l )
    
     #echo "$machine diskspace is <<< $keyvalue >>> in ns=$ns in the file $workdir/$machine $(wc -l $workdir/$machine)"
     echo "$machine DISKSPACE=$diskspace NUMDISK=$numdisks MEMORY=$memory CPUMODEL=$cpumodel ns= $ns x86grep=$x86" >> machines.txt
done


