pipeline {

    agent any
    environment {
      // ------ mvn path -----
        PATH = "/usr/bin/mvn/:$PATH"
      // ------ DOCKER -----
        imageName = "springbootdocker"
        registryCredentials = "nexus-user-credentials"
        registry = "172.18.0.4:8081"
        dockerImage = ''
        registryCredential = "dockerhub_cred"
        reg = "ghassen52/intern_repo"
      // --------------------
        // This can be nexus3 or nexus2
        NEXUS_VERSION = "nexus3"
        // This can be http or https
        NEXUS_PROTOCOL = "http"
        // Where your Nexus is running
        NEXUS_URL = "172.18.0.4:8081"
        // Repository where we will upload the artifact
        NEXUS_REPOSITORY = "artifact-repository"
        // Jenkins credential id to authenticate to Nexus OSS
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }

    stages {
       
        stage("clone code") {
            steps {
                script {
                    // Let's clone the source
                    git branch: 'main', credentialsId: 'be415b2c-6347-48a4-a24b-6cc743c73672', url: 'http://172.18.0.2/root/springbootdevops.git'                   
                     }
                    }
            }
        
         //  stage("RUN springboot app"){
         //       steps{
         //           script{
          //              sh "./mvnw spring-boot:run"
         //           }
        //        }
         //   }
           // ------ Sonar Quality Gate -----
        stage('Quality Gate Status Check') {
            steps{
                     script {
                             withSonarQubeEnv(installationName: 'sonar') {
                             sh "mvn clean install sonar:sonar"
                             }
                     }
                 }
        }
        //       ------ Building Springboot Project with mvn -----
        stage("mvn build") {
            steps {
                script {
                    // Since unit testing is out of the scope we skip them
                    sh "mvn package -DskipTests=true"
                }
            }
        }           
        //       ------ Building Docker image -----
         stage('Building image') {
           steps{
             script {
               dockerImage = docker.build reg
             }
           }
         }
   //       ------ Uploading Docker image to docker Hub -----
        stage('Upload Image') {
             steps{    
                  script {
                     docker.withRegistry( '', registryCredential ) {
                     dockerImage.push()
                     }
                }
              }
            }
       //stage('Start container') {
         // steps {
            //sh 'docker-compose up -d'
            //sh 'docker-compose ps'
          //}
    //}
    //       ------ Running Docker image -----
      stage('Docker Run') {
         steps{
             script {
                dockerImage.run("--net internship_internship_default --ip 172.18.0.6 -p 9090:8080 --name springbootdocker --rm -d")
         }
      }
    }
                    
//        stage('Uploading to Nexus') {
  //       steps{  
    //         script {
      //           docker.withRegistry( 'http://localhost:8081/', NEXUS_CREDENTIAL_ID ) {
        //  
          //    }
            //}
  //        }
    //    }
  //      stage('Running image') {
//          steps{
            //script {
          //    sh """
        //            docker run --rm -p 9090:8080 springbootdocker
      //              """
    //        }
  //        }
//        }
        //stage('Running image'){
        //    steps{
      //             script{
    //                  //   withDockerContainer(dockerImage) {
                    //     dockerImage.inside(){
                  //          sh "./mvnw spring-boot:run"
                //         }
              //          }
            //       }
          //  
        //        }
       // }
       
       //       ------ Deploying Jar Artifact to Nexus Repository -----
        stage("Publish to nexus") {
            steps {
                script {
                    // Read POM xml file using 'readMavenPom' step , this step 'readMavenPom' is included in: https://plugins.jenkins.io/pipeline-utility-steps
                    def pom = readMavenPom file: 'pom.xml';
                    writeMavenPom model: pom;
                    // Find built artifact under target folder
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    // Print some info from the artifact found
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    // Extract the path from the File found
                    artifactPath = filesByGlob[0].path;
                    // Assign to a boolean response verifying If the artifact name exists
                    artifactExists = fileExists artifactPath;

                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";

                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                // Artifact generated such as .jar, .ear and .war files.
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],

                                // Lets upload the pom.xml file for additional information for Transitive dependencies
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );

                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }

    }
    post {
        success {
            mail bcc: '', body: 'The build was successful ', cc: 'chamssidine.abderrahim@etudiant-isi.utm.tn', from: '', replyTo: '', subject: 'Successful Build', to: 'oueslatighassen5201@gmail.com'
        }
        failure {
            mail bcc: '', body: 'The build was a failure ', cc: 'chamssidine.abderrahim@etudiant-isi.utm.tn', from: '', replyTo: '', subject: 'failed Build', to: 'oueslatighassen5201@gmail.com'
        }
    }
}

