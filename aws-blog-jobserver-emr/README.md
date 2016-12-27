This project is for using Spark JobServer with AWS EMR :

- It provides BA's for installing JobServer and a simple project for benchmarking
- This is to supplement a big data blogpost
  - Installing and Running JobServer for Apache Spark on Amazon EMR
    -- the post goes into detail all the steps necessary to set up

You **MUST** be familiar with [Spark JobServer](https://github.com/spark-jobserver/spark-jobserver) :

- Reading the documentation about [How to run Spark Jobserver on EMR](https://github.com/spark-jobserver/spark-jobserver/blob/master/doc/EMR.md).
- Reading about [Custom Contexts and Context-specific Jobs](https://github.com/spark-jobserver/spark-jobserver/blob/master/doc/contexts.md).

This project is built with maven and in the proper maven archtetype for Java and Scala.

Here are some supporting documents:

    ├── BA // This is where the files for the EMR creation are stored
    │   ├── configurations.json // configs for the EMR cluster
    │   ├── existing_build_jobserver_BA.sh // the BA if you have already built
    |   |                                  // the JobServer distro and staged it
    |   |                                  // on S3 (change the variables at
    |   |                                  // the header of the file)
    │   ├── full_install_jobserver_BA.sh   // the BA if you need to compile and
    |   |                                  // install the JobServer distro -
    |   |                                  // it copies a version back to S3
    |   |                                  // (change the variables at the
    |   |                                  // header of the file)
    │   └── startServer.sh
    ├── commands
    │   ├── commands-cluster.txt // sample commands of creating the cluster with AWS CLI
    │   ├── commands-flights.txt // sample commands of how to run the jar as a
    |   |                        // job on ERM/Spark (benchmark) and also
    |                            // how to interact with JobServer via CURL
    │   └── create-cl.sh // create cluster commands samples. 
    ├── jobserver_configs
    │   ├── emr_contexts.conf // context definitions for this project on JobServer
    │   └── emr_v1.6.1.sh // configruation for JobServer
