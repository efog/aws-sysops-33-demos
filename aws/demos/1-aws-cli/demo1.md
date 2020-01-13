# Demo 1 Scenario
AWS Command Line Interface (AWS CLI)

## Prerequisites

The pre-requisites should be done before showing the console to the audience.

1. Ensure the AWS credentials are properly configured using environment variables:

    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - AWS_REGION

## Setup

1. Build local container image from pre-built Ubuntu based AWS CLI enabled container image.

    ```` bash
    docker build -t ubuntu-local-awscli:0 --build-arg KEY_ID=$AWS_ACCESS_KEY_ID --build-arg SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --build-arg REGION=$AWS_REGION -f demo1.Dockerfile .
    ```` 
    We'll re-use this container for all the following demos which require the AWS CLI.

1. Instantiate local container configured with environment variables. These environment variables override the default profile.

    ```` bash
    docker run --name local-awscli ubuntu-local-awscli:0
    ````

    Read more about AWS CLI environment variables here:
    [https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

## Steps

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

   ```` bash
   aws
   ````
