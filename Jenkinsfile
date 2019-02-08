#!/usr/bin/env groovy
// This Jenkinsfile pulls down and runs a pipeline defined in a Jenkins Shared Library at:
@Library('Enki@master') _

node {
    // Variables
    String projectName = 'enki-sample'
    String dockerRepoUrl = 'https://index.docker.io'

    // Setup
    gitCheckout = checkout scm // This line is required for the pipeline to run!!!!!

    // Stages
    gitInformation(gitInfo: gitCheckout)

    parallel "build-${projectName}": {
        dockerBuild(dockerImageName: projectName)
    }

    parallel "push-${projectName}": {
        dockerPush(dockerImage: projectName,
                   dockerRepoUrl: dockerRepoUrl,
                   dockerRepoCredsId: 'DOCKER_CREDENTIALS')
    }
}
