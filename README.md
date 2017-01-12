# maven-concourse-pipeline

The goal of this project is to build a Reference [Concourse](https://concourse.ci) Pipeline for Java applications. 

## Credits

https://github.com/starkandwayne/concourse-tutorial.


## Tutorial

We have built a step by step tutorial on how to build a standard Continuous Integration pipeline to build java applications.
We will dedicate a branch to perform each step. The main or master branch is dedicated to the chapter 00 where we set up Concourse.

The current project contains concourse artifacts, i.e. pipeline, tasks and script files. It does not build any specific project. Instead, we are going to use this project to build real application projects. In fact, we are going to build the project [app1](https://github.com/MarcialRosales/maven-concourse-pipeline-app1). This is a simple Spring Boot application.

### 00 - Set up Concourse

**Launch Concourse with Docker-compose**
We are going to launch Concourse using *Docker compose*. On this `master` branch
 we have a `docker-compose.yml` file and a `keys` folder with all the required ssh keys.

Make sure you are in the master branch (`git checkout master`) and you must have [Docker](https://docs.docker.com/engine/installation/)
and [Docker compose](https://docs.docker.com/compose/install/) installed too.

To launch concourse we run `docker-compose up` which by default reads the file `docker-compose.yml`. On this file we have declared the 3 containers we need to run Concourse: the **database**, the **web-server** which gives us the nice Concourse front-end and the **worker** container where concourse executes the tasks.

**Note: Running via docker-machine** : *If you are running concourse via docker-machine (not natively) make sure you set up the environment variable CONCOURSE_EXTERNAL_URL before running `docker-compose up`*.

```
CONCOURSE_EXTERNAL_URL=`echo $DOCKER_HOST | sed s/tcp/http/ | sed s/2376/8080/` nohup docker-compose up
```
We can open the `CONCOURSE_EXTERNAL_URL` in our browser. The default credentials are concourse:changeme

**Download fly**
Once we have *Concourse* running, we need to download a command line utility called **fly** from the main page of our *Concourse*.

**Login to Concourse**
Before we operate with *Concourse* through *fly* we need to login and remember that login attempt with an alias. Every command we subsequently invoke must refer to that alias.

Let's login to Concourse running under `http://192.168.99.100:8080` using username and password `concourse:changeme` and we give it the alias `plan1`:
```
fly -t plan1 login -c http://192.168.99.100:8080 -u concourse -p changeme
```

It is very likely that *fly* warns us with a message similar to this one:
```
fly version (2.2.1) is out of sync with the target (2.6.0). to sync up, run the following:

    fly -t plan1 sync

cowardly refusing to run due to significant version discrepancy
```

All we have to do is run the suggested command: `fly -t plan1 sync` and it will automatically upgrade our *fly* client.

Now, we are all set to continue.

### 01 - [Compile & Verify](https://github.com/MarcialRosales/maven-concourse-pipeline/tree/01_build_and_verify)

Do `git checkout 01_build_and_verify`

### 02 - [Use corporate Maven Repository](https://github.com/MarcialRosales/maven-concourse-pipeline/tree/02_use_corporate_maven_repo)

Do `git checkout 02_use_corporate_maven_repo`

### 03 - [Deploy artifact to Maven Repository](https://github.com/MarcialRosales/maven-concourse-pipeline/tree/03_deploy_artifact)

Do `git checkout 03_deploy_artifact`

### 20 - [Deploy artifact from Maven Repository to Cloud Foundry](https://github.com/MarcialRosales/maven-concourse-pipeline/tree/20_push_to_pcf)

Do `git checkout 20_push_to_pcf`


## Next Installments

### Deploy Java Reports (Junit, Code Analysis, others) to a web server

### Manage Artifact versions (minor, major, release, etc)

### Provision services (required by the application)

### Push to production if acceptance tests pass

### Provision the PCF runtime where to push our applications
Before we can push our application, we need to provision the necessary infrastructure. We need a PCF foundation identified by an URL, we also need an organization, a space and a user. That space/organization must be configured with certain physical prerequisites like amount of RAM, disk, etc.

This type of provisioning occurs before any application attempts to deploy itself. Furthermore, it is very likely that several applications will be deployed on the same runtime environment. To be more specifics, in terms of PCF, a runtime environment is a space within an organization within a PCF foundation. And we can go even further and assume that we could have many runtime environments for different line of business; we could have all the front-office applications running in one runtime environment and all the back-office apps in separate runtime environment. Some people use the term ecosystem to refer to a runtime environment. Sounds like a good name to me too. To summarize, applications are deployed to ecosystems which must be previously provisioned by someone...
