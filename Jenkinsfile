def dockerTag = ""
def dockerImage = ""

pipeline {
    agent any
    options {
        buildDiscarder(logRotator(daysToKeepStr: '45'))
        disableConcurrentBuilds()
        skipStagesAfterUnstable()
        preserveStashes(buildCount: 20)
        disableResume()
        timestamps()
        timeout(time: 24, unit: 'HOURS')
    }
    stages {
        stage('build') {
            steps {
                script {
                    def gitCommit = sh script: "git log HEAD -1 --pretty=format:%H", returnStdout: true
                    def shortGitCommit = gitCommit ? gitCommit[0..6] : "0000000"
                    def dateNow = new Date().format( 'yyyy-MM-dd' )
                    dockerTag = "${dateNow}.${env.BUILD_NUMBER}-${shortGitCommit}"
                    dockerImage = "viyou/hello-app:${dockerTag}"
                    dir('hello-app') {
                        docker.build(dockerImage)
                    }
                    docker.withRegistry("https://index.docker.io/v1/", 'docker_user') {
                        def image = docker.image(dockerImage)
                        image.push()
                    }
                    currentBuild.displayName = dockerTag
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    dir("deployment/us-west-1") {
                        sh """
                        kustomize edit set image hello-app-image=${dockerImage}
                        kustomize build > deployment.yaml
                        kubectl apply -f deployment.yaml
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
