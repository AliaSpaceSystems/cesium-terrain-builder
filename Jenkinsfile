pipeline {
  environment {
    imagename_src = "mcerolini/eo4africa"
    imagename_dst = "mcerolini/ctb"
    registryCredential = 'mcerolini'
    dockerImage = ''
  }
  agent none
  stages {

    stage('Building image') {
        agent {
            docker { 
                    image imagename_src
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
        }
        steps {
            sh 'apk add --no-cache wget curl unzip make cmake libtool autoconf automake pkgconfig g++ zlib-dev docker'
            sh 'pwd'
            sh 'ls -la'
            sh 'rm -rf build'
            sh 'mkdir build'
            sh 'cd build && cmake .. && make && make install'
            sh 'rm -rf build'
            sh 'docker commit $(basename $(cat /proc/1/cpuset)) foo-docker'
            sh 'apk del --no-cache wget curl unzip make cmake libtool autoconf automake pkgconfig g++ zlib-dev docker'
        }
    }

    stage('Deploy Image') {
      agent any
      steps{
        sh "docker tag foo-docker:latest $imagename_dst:$BUILD_NUMBER"
        script {
          docker.withRegistry( '', registryCredential ) {
            sh "docker push $imagename_dst:$BUILD_NUMBER"
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      agent any
      steps{
        sh "docker rmi $imagename_src:$BUILD_NUMBER"
         sh "docker rmi $imagename_src:latest"
        sh "docker rmi $imagename_dst:$BUILD_NUMBER"
         sh "docker rmi $imagename_dst:latest"

      }
    }
  }
}
