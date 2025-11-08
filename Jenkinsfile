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
                ssh -o StrictHostKeyChecking=no -i ${AWS_SSH_KEY} ubuntu@35.170.66.187 '
                    cd /home/ubuntu &&
                    sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true &&
                    sudo cp ~/index-aws.html /var/www/html/index.html
                '
                '''
            }
        }

        stage('Deploy to Azure') {
            steps {
                echo "Deploying to Azure VM..."
                sh '''
                sshpass -p "${AZURE_CRED_PSW}" ssh -o StrictHostKeyChecking=no ${AZURE_CRED_USR}@52.226.22.43 '
                    cd /home/azureuser &&
                    sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true &&
                    sudo cp ~/index-azure.html /var/www/html/index.html
                '
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
