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
    parameters {
        string(name: 'GOLDEN_TEST1', defaultValue: 'yes', description: '')
    }
    stages {
        stage('build') {
            steps {
                script {
                //    docker.build("test:latest", "--build-arg=arg=Debug -f Dockerfile . ")
                    def scmVars = checkout changelog: false, poll: false,
                         scm: [
                           $class: 'GitSCM',
                           branches: BRANCH_NAME,
                           doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                           extensions: scmExtensions,
                           userRemoteConfigs: scm.userRemoteConfigs
                         ]
                    def gitCommit = scmVars.GIT_COMMIT
                    def shortGitCommit = gitCommit ? gitCommit[0..6] : "0000000"
                    def dateNow = new Date().format( 'yyyy-MM-dd' )
                    def dockerTag = args.dockerTag ?: "${dateNow}.${env.BUILD_NUMBER}-${shortGitCommit}-${envTag}"
                    docker.withRegistry("https://index.docker.io/v1/", 'docker_user') {
                    def image = docker.image("viyou/hello-app:3.0")
                    image.push()
                  }
                }
            }
        }
    }
    post {
        always {
            cleanWs disableDeferredWipeout: true, notFailBuild: true
        }
    }
}
