#!/bin/sh  
echo "Lets Create a Ec2 Instance"
echo "==================================="
echo " Enter your CIDR"
read CIDR                                                       //taking CIDR as input from the user
export CIDR                                                     //exporing the CIDR values
aws ec2 create-vpc --cidr-block $CIDR > VPC_SAYA.txt            //creating vpc and outputs are going to store in text file named "VPC_SAYA.txt"
cat VPC_SAYA.txt                                                //see what are stored in text file
export vpcid=`egrep VpcId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`  //storing vpc id from textfile in variable named as "vpcid"

aws ec2 create-tags  --resources $vpcid --tags Key=Name,Value=sayan-vpc2         //creating the nametag for the vpc

echo "Hey your Vpc-Id is $vpcid"
echo "============================================================"
echo "Enter the Public CIDR Public"
echo "=============================================="
read CIDR_public                                            // input your public CIDR
export CIDR_public                                          //export public CIDR 
echo "Enter the CIDR private"
echo "=============================================="
read CIDR_private                                          //input private CIDR
export CIDR_private                                        //export public CIDR
aws ec2 create-subnet --vpc-id $vpcid --cidr-block $CIDR_public > VPC_SAYA.txt           //creating a subnet and stored output given by this code in text file "VPC_SAYA.txt" 
cat VPC_SAYA.txt                                                                         // see what are stored in th text file
export pubsubnetid=`egrep SubnetId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources $pubsubnetid --tags Key=Name,Value=sayan_public_subnet
aws ec2 create-subnet --vpc-id $vpcid --cidr-block $CIDR_private > VPC_SAYA.txt
cat VPC_SAYA.txt
export privsubnetid=`egrep SubnetId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources $privsubnetid --tags Key=Name,Value=sayan_private_subnet
aws ec2 create-internet-gateway > VPC_SAYA.txt
cat VPC_SAYA.txt
export IGW=`egrep InternetGatewayId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources $IGW --tags Key=Name,Value=sayan_internate_gateway
aws ec2 attach-internet-gateway --vpc-id $vpcid --internet-gateway-id $IGW
aws ec2 create-route-table --vpc-id $vpcid > VPC_SAYA.txt
cat VPC_SAYA.txt
export RoutePublic=`egrep RouteTableId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources $RoutePublic --tags Key=Name,Value=sayan_route_public
aws ec2 create-route-table --vpc-id $vpcid > VPC_SAYA.txt
cat VPC_SAYA.txt
export RoutePrivate=`egrep RouteTableId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources $RoutePrivate --tags Key=Name,Value=sayan_private_route
aws ec2 associate-route-table --subnet-id $pubsubnetid --route-table-id $RoutePublic
aws ec2 associate-route-table --subnet-id $privsubnetid --route-table-id $RoutePrivate



aws ec2 modify-subnet-attribute --subnet-id $privsubnetid --map-public-ip-on-launch



aws ec2 create-route --route-table-id $RoutePublic --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW
aws ec2 allocate-address  --domain vpc > VPC_SAYA.txt
cat VPC_SAYA.txt
export EIP=`egrep AllocationId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-nat-gateway --subnet-id $privsubnetid --allocation-id $EIP > VPC_SAYA.txt
cat VPC_SAYA.txt
export NAT=`egrep NatGatewayId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources  $NAT --tags  Key=Name,Value=saya-NatGateway

aws ec2 create-route --route-table-id $RoutePrivate --destination-cidr-block 0.0.0.0/0 --gateway-id $NAT
aws ec2 create-security-group  --group-name Saya-security-grpi --description "My security grp" --vpc-id $vpcid > VPC_SAYA.txt

export securitygrp=`egrep State VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`

aws ec2 create-tags --resources $securitygrp --tags Key=Name,Value=Saya-CLI-SecurityGrpi

aws ec2 authorize-security-group-ingress --group-id $securitygrp --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 create-key-pair --key-name SayaKEY1237 --query 'KeyMaterial' --output text > SayaKEY1237

aws ec2 run-instances --image-id ami-011c99152163a87ae --count 1 --instance-type t2.micro --key-name SayaKEY1237 --subnet-id $pubsubnetid >VPC_SAYA.txt
export  instanceId=`egrep State VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources  $instanceId --tags Key=Name,Value=WEBVPCSAYA_PUB
aws ec2 run-instances --image-id ami-011c99152163a87ae --count 1 --instance-type t2.micro --key-name SayaKEY1237 --subnet-id $privsubnetid >VPC_SAYA.txt
export  InstanceId_Pri =`egrep State VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`
aws ec2 create-tags --resources  $InstanceId_Pri --tags Key=Name,Value=WEBVPCSAYA_PRI
cat VPC_SAYA.txt
echo " your Instances is created"
