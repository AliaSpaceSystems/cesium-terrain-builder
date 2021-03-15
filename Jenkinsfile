pipeline {
	agent {
    docker { 
            image 'mcerolini/eo4africa'
            args '-u root:root'
            }
  }

	options {
		buildDiscarder(logRotator(numToKeepStr: '10'))
	}

	parameters {
		booleanParam name: 'RUN_TESTS', defaultValue: true, description: 'Run Tests?'
	}

	stages {
        stage ('Build') {
            steps {
                //sh 'apt-get update -y'
                //sh 'apt-get install -y cmake build-essential libgdal-dev'
                sh 'apk add --no-cache wget curl unzip make cmake libtool  autoconf automake pkgconfig g++ zlib-dev'
                sh 'pwd'
                sh 'ls -la'
                sh 'rm -rf build'
                sh 'mkdir build'
                sh 'cd build && cmake .. && make && make install'
            }
        }

        stage('Test') {
            when {
                environment name: 'RUN_TESTS', value: 'true'
            }
            steps {
                ctest 'InSearchPath'
            }
        }  
	}
    post { 
        always { 
            cleanWs()
        }
    }
}
