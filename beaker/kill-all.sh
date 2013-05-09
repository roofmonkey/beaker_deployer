json=$(bkr job-list --mine) 

echo "Are you really sure you want to cancel all beaker jobs ???"

echo $json | tr "," "\n" | grep -Po '(?<=\")[^"]*' > jobs

cat jobs

cat jobs | while read line ; do
   echo "CANCELLING $line"
   bkr job-cancel $line
   bkr job-delete $line
done

