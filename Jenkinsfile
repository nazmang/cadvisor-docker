pipeline {
	environment {
		registry = 'nazman/cadvisor'
		registryCredential = 'dockerhub'
		DOCKER_BUILDKIT = '1'
		DOCKER_CLI_EXPERIMENTAL = 'enabled'
		CADVISOR_VERSION="${params.CADVISOR_VERSION}"
	}
	agent { label 'jnlp-agent-docker' }
	stages {
		stage('Build buildx') {
			steps{
				sh 'env'
				script {
					def buildx = docker.build ("local/buildx", "--platform=local -o . https://github.com/docker/buildx.git")
					buildx.run("--rm --privileged multiarch/qemu-user-static --reset -p yes i")
				}
				sh '''
					mkdir -p ~/.docker/cli-plugins && mv -f buildx ~/.docker/cli-plugins/docker-buildx 
					docker buildx rm default || true
					docker buildx inspect --bootstrap 					
					docker buildx create --name multibuilder --use
				'''	
			}
		}
		stage('Clone source') { // for display purposes
            steps {
                git 'https://github.com/google/cadvisor.git'                
            }
		}	
		stage ('Build and Push'){
			steps {		
				sh '''
				cp deploy/Dockerfile .
				docker buildx build --platform linux/arm64,linux/amd64,linux/arm/v7,linux/arm/v6 \
				--tag nazman/cadvisor:$CADVISOR_VERSION \
				--tag nazman/cadvisor:latest \
				--tag gcr.io/cadvisor/cadvisor:$CADVISOR_VERSION \
				 . --push
				'''	
			}
		}
				
    }
}