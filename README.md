# cisco_moduling
#### cisco-cml-on-aws ####
--------------------------
Pre-requisties:
-------------
* Terraform 
* aws

Steps: 
-----
* Import to snapshot from VMDK

>> aws ec2 import-snapshot \
    --disk-container Format=VMDK,UserBucket={S3Bucket=<Bucket_name>,S3Key=<Bucket_key>}

* Import Snapshot to AMI

>> aws ec2 register-image \
    --name <Image_name> \
    --root-device-name /dev/xvda \
    --block-device-mappings DeviceName=/dev/xvda,Ebs={SnapshotId=<snapshot_id>} DeviceName=/dev/xvdf,Ebs={VolumeSize=100}
    
* Running Jenkins Job
