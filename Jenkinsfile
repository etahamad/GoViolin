pipeline{
    environment{
        IMAGE = 'etahamad/goviolin'
        DOCKERHUB_CREDS = credentials('dockerhub')
        DOCKERHUB_USERNAME = DOCKERHUB_CREDS.username
        DOCKERHUB_PASSWORD = DOCKERHUB_CREDS.password
        DOCKER_IMAGE = ''
        
        K8S_DEPLOYMENT_FILE = 'deployment.yaml'
        K8S_DEPLOYMENT_PRE_FILE = 'pre-deployment.yaml'
        K8S_SERVICE = 'goviolin-service'
        URL = ''
        
        TG_CHAT_ID = credentials('telegram_chat_id')
        TG_BOT_TOKEN = credentials('telegram_bot_token')
    }

    agent any

    stages{
        stage('Build'){
            steps{       
                script{
                    try{
                        sh "docker build -t ${IMAGE} ."
                        curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
                             -d chat_id="${TG_CHAT_ID}" \
                             -d "parse_mode=html" \
                             -d text="Your Build Stage in pipeline for GoViolin has been successfully build."
                    }
                    catch(all){
                        curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
                             -d chat_id="${TG_CHAT_ID}" \
                             -d "parse_mode=html" \
                             -d text="Your Build Stage in pipeline for GoViolin has been successfully build."
                    }
                }          
            }
        }

        stage('Push'){
            steps{
                script{
                    try{
                        sh 'docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}'
                        sh "docker push ${IMAGE}:latest"
                        curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
                             -d chat_id="${TG_CHAT_ID}" \
                             -d "disable_web_page_preview=true" \
                             -d "parse_mode=html" \
                             -d text="Imaged has been pushed to https://hub.docker.com/repository/docker/${IMAGE}"
                    }
                    catch(all){
                        curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
                             -d chat_id="${TG_CHAT_ID}" \
                             -d "parse_mode=html" \
                             -d text="Build failed, please check logs log.err (log file should be injected here from jenkins)"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes'){
            steps{
                script{
                    sh "kubectl apply -f ./${K8S_DEPLOYMENT_FILE}"
                    curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
                             -d chat_id="${TG_CHAT_ID}" \
                             -d "parse_mode=html" \
                             -d text="Successful Deployement on Kubernetes. To get the Web App URL RUN minikube service goviolin-service --url"
                }
            }
        }

    }
    post{
        always{
            sh 'docker logout'
            echo 'Finished.'
        }
    }
}
