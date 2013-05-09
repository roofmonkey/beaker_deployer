echo "Reading machines.txt file, did you edit out the ones you dont want? - if not, please abort"

read
IFS="
"
for line in `cat machines.txt`;do
    machine=$(echo $line | cut -d' ' -f1)
    cat ./job.xml | sed -e 's/INPUT_MACHINE_NAME/'"$machine"'/' > $machine.xml 
    echo "wrote $machine.xml"
done;
