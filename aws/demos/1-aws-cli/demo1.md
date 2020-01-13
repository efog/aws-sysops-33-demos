# Demo 1 Scenario
AWS Command Line Interface (AWS CLI)

## Prerequisites

The pre-requisites should be done before showing the console to the audience.

1. Ensure the AWS credentials are properly configured using environment variables:

    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - AWS_DEFAULT_REGION

## Setup

1. Build local container image from pre-built Ubuntu based AWS CLI enabled container image.

    ```` bash
    docker build -t ubuntu-local-awscli:0 --build-arg KEY_ID=$AWS_ACCESS_KEY_ID --build-arg SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --build-arg REGION=$AWS_DEFAULT_REGION -f demo1.Dockerfile .
    ```` 
    We'll re-use this container for all the following demos which require the AWS CLI.

1. Instantiate local container configured with environment variables. These environment variables override the default profile.

    ```` bash
    docker run --name local-awscli ubuntu-local-awscli:0
    ````

    Read more about AWS CLI environment variables here:
    [https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

## Steps

In this scenario we'll create a ubuntu based EC2 instance in the default region.

1. Configure the default profile if necessary

    ```` bash
    aws configure
    ````
    
    This allows the CLI to use the proper credentials. The AWS CLI allows different sets of credentials to be used through profiles.

    ```` bash
    aws configure --profile
    ````
    
    To use a different profile credentials, use the --profile command parameter with any AWS CLI command.

1. List all AMIs available in an AWS Region

    Gets all Ubuntu Bionic images owned by Amazon, running on x86-64 and outputs the AMI id.

    ```` bash
    $ aws ec2 describe-images --filters "Name=owner-alias,Values=[amazon]" "Name=architecture,Values=x86_64" "Name=name,Values=ubuntu-bionic*" --query "Images[*].[ImageId]" --output text

    ami-e24b7d9d
    ````

1. Create an SSH key-pair

    Registers a new key pair into the account for the default region which will be used to login to an EC2 Instance.

    ```` bash
    aws ec2 create-key-pair --key-name sysops33-demo-key --query "KeyMaterial" --output text > ~/.ssh/sysops33-demo-key.pem
    ````

1. Create an EC2 Instance

    Create an instance which we'll connect to using the AWS CLI.

    Use this command to test launch instance command:

    ```` bash
    $ aws ec2 run-instances --image-id $(aws ec2 describe-images --filters "Name=owner-alias,Values=[amazon]" "Name=architecture,Values=x86_64" "Name=name,Values=ubuntu-bionic*" --query "Images[*].[ImageId]" --output text) --count 1 --instance-type t1.micro --key-name sysops33-demo-key --query [Instances[0].InstanceId,Instances[0].NetworkInterfaces[0].Association.PublicDnsName] --tag-specifications 'ResourceType='instance',Tags=[{Key='owner',Value='student'},{Key='app',Value='vm'}]' --output text --dry-run

    An error occurred (DryRunOperation) when calling the RunInstances operation: Request would have succeeded, but DryRun flag is set.
    ```` 

    Remove dry-run to run the instance:
    
    ```` bash
    $ aws ec2 run-instances --image-id $(aws ec2 describe-images --filters "Name=owner-alias,Values=[amazon]" "Name=architecture,Values=x86_64" "Name=name,Values=ubuntu-bionic*" --query "Images[*].[ImageId]" --output text) --count 1 --instance-type t1.micro --key-name sysops33-demo-key --query [Instances[0].InstanceId] --tag-specifications 'ResourceType='instance',Tags=[{Key='owner',Value='student'},{Key='app',Value='vm'}]' --output text

    i-026bcb231de80de50
    ```` 

1. Connect to the instance:

    ```` bash
    ssh -i ~/.ssh/sysops33-demo-key.pem ec2-user@$(aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" "Name=tag:owner,Values=student" --query ["Reservations[*].Instances[*].NetworkInterfaces[0].Association.PublicDnsName"] --output text)
    ````

1. Delete the instance

    ```` bash
    aws ec2 terminate-instances --instance-id $(aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" "Name=tag:owner,Values=student" --query ["Reservations[*].Instances[*].InstanceId"] --output text)
    ```` 






