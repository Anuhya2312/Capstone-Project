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
                    scp -o StrictHostKeyChecking=no -i $AWS_SSH_KEY index-aws.html ubuntu@35.170.66.187:/home/ubuntu/
                    ssh -o StrictHostKeyChecking=no -i $AWS_SSH_KEY ubuntu@35.170.66.187 "
                        sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true
                        sudo cp /home/ubuntu/index-aws.html /var/www/html/index.html
                        sudo systemctl restart nginx
                    "
                '''
            }
        }

        stage('Deploy to Azure') {
            steps {
                echo "Deploying to Azure VM..."
                sh '''
                    sshpass -p "$AZURE_CRED_PSW" scp -o StrictHostKeyChecking=no index-azure.html azureuser@52.226.22.43:/home/azureuser/
                    sshpass -p "$AZURE_CRED_PSW" ssh -o StrictHostKeyChecking=no azureuser@52.226.22.43 "
                        sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true
                        sudo cp /home/azureuser/index-azure.html /var/www/html/index.html
                        sudo systemctl restart nginx
                    "
                '''
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                echo "Running Ansible Playbook on Tools EC2..."
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'AWS_KEY')]) {
                    sh '''
                        cd /var/lib/jenkins/workspace/deploy-nginx/
                        ansible-playbook -i inventory playbook.yaml --key-file $AWS_KEY
                    '''
                }
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
