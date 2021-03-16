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
                    args '-u root:root'
                    }
        }
        steps {
            sh 'apk add --no-cache wget curl unzip make cmake libtool  autoconf automake pkgconfig g++ zlib-dev'
            sh 'pwd'
            sh 'ls -la'
            sh 'rm -rf build'
            sh 'mkdir build'
            sh 'cd build && cmake .. && make && make install'
        }   
    }

    stage('Deploy Image') {
      agent any
      steps{
        sh "docker tag imagename_src:$BUILD_NUMBER imagename_dst:$BUILD_NUMBER"
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
        sh "docker rmi $imagename_src:$BUILD_NUMBER"
         sh "docker rmi $imagename_src:latest"
        sh "docker rmi $imagename_dst:$BUILD_NUMBER"
         sh "docker rmi $imagename_dst:latest"

      }
    }
  }
}
