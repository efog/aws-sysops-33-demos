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

    ````bash
    $ curl -O https://raw.githubusercontent.com/efog/aws-sysops-33-demos/master/aws/demos/3-computing/ec2s3bucketaccessrole.json
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
    100   573  100   573    0     0   5673      0 --:--:-- --:--:-- --:--:--  5673

    $ aws iam create-role --role-name sysops33bucket-ec2-role --assume-role-policy-document file://ec2s3bucketaccessrole.json
    {
        "Role": {
            "Path": "/",
            "RoleName": "sysops33bucket-ec2-role",
            "RoleId": "AROAUZXKVNYMXIJNKVLOG",
            "Arn": "arn:aws:iam::330130877977:role/sysops33bucket-ec2-role",
            "CreateDate": "2020-01-17T20:27:33Z",
            "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            }
        }
    }

    $ aws iam create-instance-profile --instance-profile-name sysops33demobucket-read-profile
    {
        "InstanceProfile": {
            "Path": "/",
            "InstanceProfileName": "sysops33demobucket-read-profile",
            "InstanceProfileId": "AIPAUZXKVNYMYCTSP62QW",
            "Arn": "arn:aws:iam::330130877977:instance-profile/sysops33demobucket-read-profile",
            "CreateDate": "2020-01-17T20:36:12Z",
            "Roles": []
        }
    }

    aws iam add-role-to-instance-profile --instance-profile-name sysops33demobucket-read-profile --role-name sysops33bucket-ec2-role
    ````

1. Attach the instance profile to EC2 instance

    ```` bash
    aws ec2 associate-iam-instance-profile --iam-instance-profile Name=sysops33demobucket-read-profile --instance-id i-0b3801785f38c79c3
    {
        "IamInstanceProfileAssociation": {
            "AssociationId": "iip-assoc-0c5136883a0ec3183",
            "InstanceId": "i-0b3801785f38c79c3",
            "IamInstanceProfile": {
                "Arn": "arn:aws:iam::330130877977:instance-profile/sysops33demobucket-read-profile",
                "Id": "AIPAUZXKVNYMYCTSP62QW"
            },
            "State": "associating"
        }
    }
    ````

1. Test inside the instance its capability to download a file through the AWS S3 CLI

    ```` bash
    ubuntu@ip-172-31-18-206:~$ aws s3 cp s3://sysops33demobucket/README.md .
    download: s3://sysops33demobucket/README.md to ./README.md
    ubuntu@ip-172-31-18-206:~$ cat README.md
    # aws-sysops-33-demos
    ````