#!/bin/sh
if [ "$1" = "" ]
then
  echo "usage: $0 [AccountID1] ( [AccountID2] [AccountID3] ...)"
	exit
fi

for account in $*
do
	echo accountid: $account
	export AWS_ACCESS_KEY_ID=ACCESSKEY
	export AWS_SECRET_ACCESS_KEY=SECRETKEY
	unset AWS_SECURITY_TOKEN
	CREDENTIALS=`aws sts assume-role --role-arn arn:aws:iam::$account:role/cross --role-session-name cross --output text | grep ^CREDENTIALS`
	set -- $CREDENTIALS
	export AWS_ACCESS_KEY_ID=$5
	export AWS_SECRET_ACCESS_KEY=$2
	export AWS_SECURITY_TOKEN=$3
	export AWS_DEFAULT_REGION=us-east-1
	for region in `aws ec2 describe-regions --output text | cut -f 2`
	do
		echo "-- $region"
		aws ec2 describe-instances --region $region --filters Name=instance-state-name,Values=running --output json | jq .Reservations[].Instances[].InstanceType | sort | uniq -c
		echo 
	done
done
