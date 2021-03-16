pipeline {
  environment {
    imagename_src = "mcerolini/eo4africa"
    imagename_dst = "mcerolini/ctb-quantized-mesh"
    registryCredential = 'mcerolini'
    dockerImage = ''
  }
  agent none
  stages {

    stage('Building source') {
        agent {
            docker { 
                    image imagename_src
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
        }
        steps {
            sh 'apk add wget curl unzip make cmake libtool autoconf automake pkgconfig g++ zlib-dev docker'
            sh 'pwd'
            sh 'ls -la'
            sh 'rm -rf build'
            sh 'mkdir build'
            sh 'cd build && cmake .. && make && make install'
            sh 'rm -rf build'
            sh 'docker commit $(basename $(cat /proc/1/cpuset)) foo-docker'
            sh 'apk del wget curl unzip make cmake libtool autoconf automake pkgconfig g++ zlib-dev docker'
        }
    }

    stage('Building image') {
      agent any
      steps{
        script {
          dockerImage = docker.build imagename_dst
        }
      }
    }
    stage('Deploy Image') {
      agent any
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

          }
        }
      }
    }
    stage('Remove Unused docker image') {
      agent any
      steps{
        sh "docker rmi $imagename_dst:$BUILD_NUMBER"
         sh "docker rmi $imagename_dst:latest"

      }
    }
  }
}
