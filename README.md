# AWS-CLI
Before doing all of the work in aws-CLI, First we need to configure the AWS-CLI from command prompt we need to give access to ouraccount with using "access key id" and "secret access key"
For configure the aws cli account we need to execute 

'''aws configure''' 

'''C:\Users\admin>aws configure

AWS Access Key ID [****************PSPV]: AKIA

AWS Secret Access Key [****************B9qp]: S

Default region name [us-east-1]: ap-south-1

Default output format [JSON]: json'''


in command prompt and after executing this we can give the access key id, secret access key, format of file, region these credentials we need to put in that after configuration our command prompt is ready to run another commands of aws cli.
# create a vpc and show the vpcID
- '''aws  ec2 create-vpc --cidr-block 10.0.0.0/16'''

![alt text](https://github.com/Sweta-sweta/AWS-CLI/blob/main/Capture1.PNG)

This command is going to create a vpc in our console but without their name so we need to give the name of vpc, for naming purpose we use tagging so,The below command is going to create the tag
- "aws ec2 create-tags --resources vpc-0d07a84c9647d2716 --tags Key=Name,Value=sweta-vpc"

after executing this command we can see the aws console, here we can see that the vpc with name 'sweta-vpc' has created

![alt text]()





