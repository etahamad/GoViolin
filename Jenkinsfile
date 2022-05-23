pipeline
{
    environment
    {
        IMAGE = 'etahamad/goviolin'
        DOCKERHUB_CREDS = credentials('dockerhub')
        DOCKER_IMAGE = ''
    }
    agent any
    stages
    {
        stage('Build')
        {
            steps
            {       
                script
                {
                    try
                    {
                        sh "docker build -t ${IMAGE} ."
                    }
                    catch(all)
                    {
                    }
                }          
            }
        }
        
        stage('Push')
        {
            steps
            {
                script
                {
                    try
                    {
                        sh "docker push ${IMAGE}:latest"
                    }
                    catch(all)
                    {
                    }
                }
            }
        }
       
    }
    post
    {
        always
        {
            echo 'Finished.'
        }
    }
}
