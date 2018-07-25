#!/bin/sh
Total=0
for region in `aws ec2 describe-regions --output text | cut -f3`
do
     echo -e "\nListing Instances in region:'$region'..."
     aws ec2 describe-instances --region $region --filters Name=instance-state-name,Values=running --output json | jq .Reservations[].Instances[].InstanceType | sort | uniq -c
		echo 
#Count ec2 numbers
counts=`aws ec2 describe-instances --region $region --filters Name=instance-state-name,Values=running --output json | jq .Reservations[].Instances[].InstanceType | sort | uniq -c |awk -F" " '{print $1}'|awk '{s+=$1} END {print s}'`

echo $counts
Total=$((counts+$Total))

done

echo "Total $Total ec2 Instances are running"

