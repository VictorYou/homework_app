def dockerTag = ""
def dockerImage = ""
def regionEks = [
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
        stage('deploy') {
            steps {
                script {
                    dir("deployment/us-west-1") {
                        withCredentials([usernamePassword(credentialsId: 'docker_user',
                            passwordVariable: 'TOKEN',
                            usernameVariable: 'USER')]) {
                            sh """
                            echo ${TOKEN} | docker login -u ${USER} --password-stdin
                            kustomize edit set image hello-app-image=${dockerImage}
                            kustomize build > deployment.yaml
                            """
                        }
                        runKubectl('us-west-1') {
                            sh """
                            kubectl apply -f deployment.yaml
                            """
                        }
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


def runKubectl(region, clo=null) {
    def timestamp = new Date().format('yyyy-MM-dd_HH-mm-ss')
    def tmpKubeconfig = "kubeconfig_${timestamp}"
    def eks = regionEks[region]

    withCredentials([
        aws(
          credentialsId: "aws-credentials-us-west-1",
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
        sh """
        aws eks update-kubeconfig --name ${eks} --region ${region} --kubeconfig ${tmp_kubeconfig}
        """
        if (clo) {
            clo.call(tmpKubeconfig)
        }
    }
}
