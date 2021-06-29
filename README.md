# AWS-CLI
Before doing all of the work in aws-CLI, First we need to configure the AWS-CLI from command prompt we need to give access to ouraccount with using "access key id" and "secret access key"
# create a vpc and show the vpcID
'''aws  ec2 create-vpc --cidr-block 10.0.0.0/16'''

This command is going to create a vpc in our console but without their name so we need to give the name of vpc, for naming purpose we use tagging so,
'''
