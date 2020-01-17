# AWS Storage Demos

## Creating a volume and attaching it to an EC2

1. Launch an instance

    ```` bash
    aws ec2 create-key-pair --key-name sysops33-demo-key --query "KeyMaterial" --output text > ~/.ssh/sysops33-demo-key.pem
    ````

    ```` bash
    $ aws ec2 run-instances --image-id $(aws ec2 describe-images --filters "Name=owner-alias,Values=[amazon]" "Name=architecture,Values=x86_64" "Name=name,Values=ubuntu-bionic*" --query "Images[*].[ImageId]" --output text) --count 1 --instance-type t2.micro --key-name sysops33-demo-key --query [Instances[0].InstanceId] --tag-specifications 'ResourceType='instance',Tags=[{Key='owner',Value='student'},{Key='app',Value='vm'}]' --output text

    i-0ea4000a4e6c4b4ce
    ````

1. Create and connect a volume to the instance

    ```` bash
    $ aws ec2 create-volume --size 80 --availability-zone us-east-1d --volume-type gp2 --encrypted

    {
        "AvailabilityZone": "us-east-1d",
        "CreateTime": "2020-01-17T16:15:20.000Z",
        "Encrypted": true,
        "Size": 80,
        "SnapshotId": "",
        "State": "creating",
        "VolumeId": "vol-0493959e6533f62bb",
        "Iops": 240,
        "Tags": [],
        "VolumeType": "gp2"
    }

    $ aws ec2 attach-volume --volume-id vol-0493959e6533f62bb --instance-id i-0ea4000a4e6c4b4ce --device /dev/sdf

    {
        "AttachTime": "2020-01-17T16:18:13.918Z",
        "Device": "/dev/sdf",
        "InstanceId": "i-0ea4000a4e6c4b4ce",
        "State": "attaching",
        "VolumeId": "vol-0493959e6533f62bb"
    }
    ````

1. Connect to the instance and mount the disk

    ```` bash
    $ lsblk
    NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0     7:0    0 86.6M  1 loop /snap/core/4650
    loop1     7:1    0 12.6M  1 loop /snap/amazon-ssm-agent/150
    loop2     7:2    0 89.1M  1 loop /snap/core/8268
    loop3     7:3    0   18M  1 loop /snap/amazon-ssm-agent/1480
    xvda    202:0    0    8G  0 disk 
    └─xvda1 202:1    0    8G  0 part /
    xvdf    202:80   0   80G  0 disk 
    ````

    Format the filesystem

    ```` bash
    $ sudo mkfs -t xfs /dev/xvdf
    meta-data=/dev/xvdf              isize=512    agcount=4, agsize=5242880 blks
                =                       sectsz=512   attr=2, projid32bit=1
                =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
    data        =                       bsize=4096   blocks=20971520, imaxpct=25
                =                       sunit=0      swidth=0 blks
    naming      =version 2              bsize=4096   ascii-ci=0 ftype=1
    log         =internal log           bsize=4096   blocks=10240, version=2
                =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime    =none                   extsz=4096   blocks=0, rtextents=0
    ````

    Mount

    ```` bash
    $ sudo mkdir /data
    $ sudo mount /dev/xvdf /data
    $ df -h
    
    Filesystem      Size  Used Avail Use% Mounted on
    udev            481M     0  481M   0% /dev
    tmpfs            99M  740K   98M   1% /run
    /dev/xvda1      7.7G  3.2G  4.6G  41% /
    tmpfs           492M     0  492M   0% /dev/shm
    tmpfs           5.0M     0  5.0M   0% /run/lock
    tmpfs           492M     0  492M   0% /sys/fs/cgroup
    /dev/loop0       87M   87M     0 100% /snap/core/4650
    /dev/loop1       13M   13M     0 100% /snap/amazon-ssm-agent/150
    /dev/loop2       90M   90M     0 100% /snap/core/8268
    /dev/loop3       18M   18M     0 100% /snap/amazon-ssm-agent/1480
    tmpfs            99M     0   99M   0% /run/user/1000
    /dev/xvdf        80G  114M   80G   1% /data
    ````

1. Demo snapshot

    1. Create initial snapshot
    
        ```` bash
        $ aws ec2 create-snapshot --volume-id vol-0493959e6533f62bb --description "first snapshot"

        {
            "Description": "first snapshot",
            "Encrypted": true,
            "OwnerId": "330130877977",
            "Progress": "",
            "SnapshotId": "snap-09ad544c6ae11db69",
            "StartTime": "2020-01-17T16:31:39.000Z",
            "State": "pending",
            "VolumeId": "vol-0493959e6533f62bb",
            "VolumeSize": 80,
            "Tags": []
        }
        ````
    
    1. Modify volume data

    1. Create a new snapshot

        ```` bash
        $ aws ec2 create-snapshot --volume-id vol-0493959e6533f62bb --description "second snapshot"

        {
            "Description": "second snapshot",
            "Encrypted": true,
            "OwnerId": "330130877977",
            "Progress": "",
            "SnapshotId": "snap-0102ccc28ad438045",
            "StartTime": "2020-01-17T16:38:01.000Z",
            "State": "pending",
            "VolumeId": "vol-0493959e6533f62bb",
            "VolumeSize": 80,
            "Tags": []
        }
        ````
