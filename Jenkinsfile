pipeline {

    agent any

    
    environment {
        PATH = "/usr/bin/mvn:$PATH"

        // This can be nexus3 or nexus2
        NEXUS_VERSION = "nexus3"
        // This can be http or https
        NEXUS_PROTOCOL = "http"
        // Where your Nexus is running
        NEXUS_URL = "172.18.0.4:8081"
        // Repository where we will upload the artifact
        NEXUS_REPOSITORY = "maven-nexus-repo"
        // Jenkins credential id to authenticate to Nexus OSS
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }

    stages {
        stage("clone code") {
            steps {
                script {
                    // Let's clone the source
                    git branch: 'main', credentialsId: 'be415b2c-6347-48a4-a24b-6cc743c73672', url: 'http://172.18.0.2/root/javaapp.git'
                }
            }
        }
        stage('Quality Gate Status Check') {
            steps{
                     script {
                         withSonarQubeEnv(installationName: 'sonar') {
                       sh "mvn clean sonar:sonar"
                        

                         }
                        
                      
                     }
    
                     }
            
        }
        stage("mvn build") {
            steps {
                script {
                    // If you are using Windows then you should use "bat" step
                    // Since unit testing is out of the scope we skip them
                    sh "mvn package -DskipTests=true"
                 
                }
            }
        }

        stage("publish to nexus") {
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
