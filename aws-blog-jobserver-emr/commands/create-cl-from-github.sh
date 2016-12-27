#!/bin/bash

export S3_BUCKET=your-s3-bucket
# cluster settings
export EMR_RELEASE_LABEL=emr-4.7.1
export CLUSTER_NAME=jobserver-dev-cl
export INSTANCE_TYPE_MASTER=m4.2xlarge
export INSTANCE_TYPE_SLAVE=m4.4xlarge
export INSTANCE_COUNT_MASTER=1
export INSTANCE_COUNT_SLAVE=5
export BID_PRICE_SLAVE=0.2
export AWS_KEY=your-key
export AWS_SUBNET=your-subnet
export AWS_SECURITY_GROUP=your-security-group

function default_bootstrap {
cat <<EOT > bootstrap.json
[
   {
      "Path":"${S3_BUCKET}/jobserver-emr/BA/full_install_jobserver_BA.sh",
      "Name":"Custom action"
   }
]
EOT
}

function default_attributes {
cat <<EOT > attributes.json
{
   "KeyName":"${AWS_KEY}",
   "InstanceProfile":"EMR_EC2_DefaultRole",
   "SubnetId":"${AWS_SUBNET}",
   "EmrManagedSlaveSecurityGroup":"${AWS_SECURITY_GROUP}",
   "EmrManagedMasterSecurityGroup":"${AWS_SECURITY_GROUP}"
}
EOT
}

function default_instances {
cat <<EOT > instances.json
[
   {
      "InstanceCount":${INSTANCE_COUNT_MASTER},
      "InstanceGroupType":"MASTER",
      "InstanceType":"${INSTANCE_TYPE_MASTER}",
      "Name":"Master instance group - 1"
   },
   {
      "InstanceCount":${INSTANCE_COUNT_SLAVE},
      "BidPrice":"0.2",
      "InstanceGroupType":"CORE",
      "InstanceType":"${INSTANCE_TYPE_SLAVE}",
      "Name":"Core instance group - $((INSTANCE_COUNT_SLAVE+1))"
   },
]
EOT
}

function default_configurations {
cat <<EOT > configurations.json
[
   {
      "Classification":"spark-defaults",
      "Properties":{
         "spark.serializer":"org.apache.spark.serializer.KryoSerializer",
         "spark.shuffle.service.enabled":"true"
      },
      "Configurations":[

      ]
   },
   {
      "Classification":"spark",
      "Properties":{
         "maximizeResourceAllocation":"true"
      },
      "Configurations":[

      ]
   }
]
EOT
}

for FILE in attributes.json bootstrap.json configurations.json instances.json
do
if [ ! -f ./${FILE} ]; then
    echo "generating default ${FILE}."
    case ${FILE} in configurations.json)
        default_configurations;;
        bootstrap.json)
        default_bootstrap;;
        attributes.json)
        default_attributes;;
        instances.json)
        default_instances
    esac
fi
done

function create_cluster {
    aws emr create-cluster \
        --applications Name=Hadoop Name=Hive Name=Ganglia Name=Spark \
        --bootstrap-actions file://./bootstrap.json \
        --ec2-attributes file://./attributes.json \
        --service-role EMR_DefaultRole \
        --enable-debugging \
        --release-label ${EMR_RELEASE_LABEL} \
        --log-uri ${S3_BUCKET}/logs/ \
        --name ${CLUSTER_NAME} \
        --instance-groups ./file://instances.json \
        --configurations ./file://configurations.json \
        --region us-east-1
}


# create_cluster | jq '.["ClusterId"]'
