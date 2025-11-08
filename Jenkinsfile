pipeline {
    agent any

    environment {
        AWS_SSH_KEY = credentials('aws-ssh-key')  // SSH key for AWS EC2
        AZURE_CRED = credentials('azure-cred')    // Username + Password for Azure
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Pulling latest code from GitHub..."
                git branch: 'main', url: 'https://github.com/Anuhya2312/Capstone-Project.git'
            }
        }

        stage('Deploy to AWS') {
            steps {
                echo "Deploying to AWS EC2..."
                sh '''
                    # Copy index-aws.html from Jenkins workspace to AWS EC2
                    scp -o StrictHostKeyChecking=no -i $AWS_SSH_KEY index-aws.html ubuntu@35.170.66.187:/home/ubuntu/

                    # Now SSH into EC2 and move it into Nginx web directory
                    ssh -o StrictHostKeyChecking=no -i $AWS_SSH_KEY ubuntu@35.170.66.187 "
                        sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true
                        sudo cp /home/ubuntu/index-aws.html /var/www/html/index.html
                    "
                '''
           }
        }



        stage('Deploy to Azure') {
             steps {
                 echo "Deploying to Azure VM..."
                 sh '''
                     scp -o StrictHostKeyChecking=no -i $AZURE_SSH_KEY index-azure.html azureuser@52.226.22.43:/home/azureuser/

                     ssh -o StrictHostKeyChecking=no -i $AZURE_SSH_KEY azureuser@52.226.22.43 "
                         sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true
                         sudo cp /home/azureuser/index-azure.html /var/www/html/index.html
                     "
                 '''
             }
        }

        stage('Run Ansible Playbook') {
            steps {
                echo "Running Ansible Playbook on Tools EC2..."
                sh '''
                cd /home/ubuntu
                ansible-playbook -i inventory playbook.yaml
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully on both AWS and Azure!"
        }
        failure {
            echo "❌ Deployment failed. Please check logs."
        }
    }
}
