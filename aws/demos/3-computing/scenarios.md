# AWS Computing Demos

## Creating an IAM policy and attaching to EC2 instance

1. Create a storage bucket

    ```` bash
    $ aws s3api create-bucket --bucket sysops33demobucket
    {
        "Location": "/sysops33demobucket"
    }
    ````

1. Download policy document and create policy

    ```` bash
    $ cd ~
    
    $ wget https://raw.githubusercontent.com/efog/aws-sysops-33-demos/master/aws/demos/3-computing/s3accesspolicy.json

    --2020-01-17 20:00:41--  https://raw.githubusercontent.com/efog/aws-sysops-33-demos/master/aws/demos/3-computing/s3accesspolicy.json
    Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.136.133
    Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.136.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 2139 (2.1K) [text/plain]
    Saving to: 's3accesspolicy.json'

    s3accesspolicy.json                                                 100%[===================================================================================================================================================================>]   2.09K  --.-KB/s    in 0s       
    2020-01-17 20:00:41 (71.6 MB/s) - 's3accesspolicy.json' saved [2139/2139]

    $ aws iam create-policy --policy-name sysops33bucket-ec2-policy --policy-document file://s3accesspolicy.json
    {
        "Policy": {
            "PolicyName": "sysops33bucket-ec2-policy",
            "PolicyId": "ANPAUZXKVNYMTRI4I742T",
            "Arn": "arn:aws:iam::330130877977:policy/sysops33bucket-ec2-policy",
            "Path": "/",
            "DefaultVersionId": "v1",
            "AttachmentCount": 0,
            "PermissionsBoundaryUsageCount": 0,
            "IsAttachable": true,
            "CreateDate": "2020-01-17T20:02:53Z",
            "UpdateDate": "2020-01-17T20:02:53Z"
        }
    }
    ````

1. Create an IAM Role and assign policy
