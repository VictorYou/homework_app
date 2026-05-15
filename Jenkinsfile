def dockerTag = ""
def dockerImage = ""
def regionEksDev = [
    "us-east-1": "unique-alternative-sparrow"
]

def regionEksProd = [
    "us-west-1": "floral-hiphop-gopher"
]

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
        stage('deploy dev') {
            when {
                allOf {
                    branch 'develop'
                }
            }
            steps {
                script {
                    def eks = regionEksDev['us-east-1']
                    deployApp(region, dockerImage, eks)
                }
            }
        }
        stage('deploy prod') {
            when {
                allOf {
                    branch 'main'
                }
            }
            steps {
                script {
                    def eks = regionEksProd['us-west-1']
                    deployApp(region, dockerImage, eks)
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


def deployApp(region, dockerImage, eks) {
    dir("deployment/${region}") {
        withCredentials([usernamePassword(credentialsId: 'docker_user',
            passwordVariable: 'TOKEN',
            usernameVariable: 'USER')]) {
            sh """
            echo ${TOKEN} | docker login -u ${USER} --password-stdin
            kustomize edit set image hello-app-image=${dockerImage}
            kustomize build > deployment.yaml
            """
        }
        runKubectl(region, eks) { file->
            sh """
            export KUBECONFIG=${file}
            kubectl apply -f deployment.yaml
            kubectl rollout status deploy hello-app
            """
        }
    }
}

def runKubectl(region, eks, clo=null) {
    def timestamp = new Date().format('yyyy-MM-dd_HH-mm-ss')
    def tmpKubeconfig = "kubeconfig_${timestamp}"

    withCredentials([
        aws(
          credentialsId: "aws-credentials-us-west-1",
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
        sh """
        aws eks update-kubeconfig --name ${eks} --region ${region} --kubeconfig ${tmpKubeconfig}
        """
        if (clo) {
            clo.call(tmpKubeconfig)
        }
    }
}
