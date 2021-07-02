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
export pubsubnetid=`egrep SubnetId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`   // exporting the public subnet id from the textfile and store it in a variable named pubsubnetid
aws ec2 create-tags --resources $pubsubnetid --tags Key=Name,Value=sayan_public_subnet        // creating the tags for public subnet
aws ec2 create-subnet --vpc-id $vpcid --cidr-block $CIDR_private > VPC_SAYA.txt               // creating the private subnet by giving private cidr block and store it in vpc_saya.txt file
cat VPC_SAYA.txt                                                                              // see the content of text file                                     
export privsubnetid=`egrep SubnetId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`   //creating the variable and store the private subnet id in this
aws ec2 create-tags --resources $privsubnetid --tags Key=Name,Value=sayan_private_subnet                          //creating tags for private subnet
aws ec2 create-internet-gateway > VPC_SAYA.txt                                                                    //create a internet gateway and store the output in text file
cat VPC_SAYA.txt                                                                                                  // see whatid in the text file
export IGW=`egrep InternetGatewayId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`   //export internet gateway id from the text file and store it in a variable
aws ec2 create-tags --resources $IGW --tags Key=Name,Value=sayan_internate_gateway                                //create a name tag for internet gateway
aws ec2 attach-internet-gateway --vpc-id $vpcid --internet-gateway-id $IGW                                        //attach your internet gateway to your pc
aws ec2 create-route-table --vpc-id $vpcid > VPC_SAYA.txt                                                         //create a public route table for vpc and store the output in the text file
cat VPC_SAYA.txt                                                                                                  // see the content of text file
export RoutePublic=`egrep RouteTableId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`  //export the public route table id  from the text file and store it in a variable
aws ec2 create-tags --resources $RoutePublic --tags Key=Name,Value=sayan_route_public                               //creating a tag for route table
aws ec2 create-route-table --vpc-id $vpcid > VPC_SAYA.txt                                                   
cat VPC_SAYA.txt                       
export RoutePrivate=`egrep RouteTableId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`  //export the private route table id from the text file
aws ec2 create-tags --resources $RoutePrivate --tags Key=Name,Value=sayan_private_route                              //creating tags for private route table
aws ec2 associate-route-table --subnet-id $pubsubnetid --route-table-id $RoutePublic                                  // create association between public subnet and public route table
aws ec2 associate-route-table --subnet-id $privsubnetid --route-table-id $RoutePrivate                                // create association between private subnet and public route table



aws ec2 modify-subnet-attribute --subnet-id $privsubnetid --map-public-ip-on-launch                                   // $privsubnetid is modified to declare that all instances launched into this subnet are assigned a public IPv4 address.



aws ec2 create-route --route-table-id $RoutePublic --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW              //creating route for specified route table
aws ec2 allocate-address  --domain vpc > VPC_SAYA.txt                                                                // address allocation for use of instance in vpc
cat VPC_SAYA.txt
export EIP=`egrep AllocationId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`           // exporting allocation id from text file and store it in variable
aws ec2 create-nat-gateway --subnet-id $privsubnetid --allocation-id $EIP > VPC_SAYA.txt                             // creating nat gateway ansd store the output in textfile
cat VPC_SAYA.txt
export NAT=`egrep NatGatewayId VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`           //exporting natgateway id from texttfile to a variable
aws ec2 create-tags --resources  $NAT --tags  Key=Name,Value=saya-NatGateway                                         // creating name tag

aws ec2 create-route --route-table-id $RoutePrivate --destination-cidr-block 0.0.0.0/0 --gateway-id $NAT             //creating private route in cidr block        
aws ec2 create-security-group  --group-name Saya-security-grpi --description "My security grp" --vpc-id $vpcid > VPC_SAYA.txt    //creating a security group and store the output in textfile

export securitygrp=`egrep GroupID VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`            // exporting the groupID of security group

aws ec2 create-tags --resources $securitygrp --tags Key=Name,Value=Saya-CLI-SecurityGrpi                               //creating a name tag

aws ec2 authorize-security-group-ingress --group-id $securitygrp --protocol tcp --port 80 --cidr 0.0.0.0/0             //giving the authorization to run on port 80

aws ec2 create-key-pair --key-name SayaKEY1237 --query 'KeyMaterial' --output text > SayaKEY1237                       // creating a key pair 

aws ec2 run-instances --image-id ami-011c99152163a87ae --count 1 --instance-type t2.micro --key-name SayaKEY1237 --subnet-id $pubsubnetid >VPC_SAYA.txt   //running the instance with key pair
export  instanceId=`egrep State VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`                                               //exporting the instance id in the variable
aws ec2 create-tags --resources  $instanceId --tags Key=Name,Value=WEBVPCSAYA_PUB                                                                         //creating a name tag for the public instance
aws ec2 run-instances --image-id ami-011c99152163a87ae --count 1 --instance-type t2.micro --key-name SayaKEY1237 --subnet-id $privsubnetid >VPC_SAYA.txt  //running the instance with key pair
export  InstanceId_Pri =`egrep State VPC_SAYA.txt | cut -d":" -f2 | sed 's/"//g' | sed 's/,//g' | cut -d" " -f2`                                          //exporting the instance id in the variable
aws ec2 create-tags --resources  $InstanceId_Pri --tags Key=Name,Value=WEBVPCSAYA_PRI                                                                     //creating a name tag for the private instance
cat VPC_SAYA.txt
echo " your Instances is created"
