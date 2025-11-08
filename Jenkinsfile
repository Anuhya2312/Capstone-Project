pipeline {
    agent any

    environment {
        AWS_SSH_KEY = credentials('aws-ssh-key')  // SSH Username + private key
        AZURE_CRED  = credentials('azure-cred')   // Username + password
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

                    # SSH into AWS EC2 and move it to Nginx web root
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
                    sshpass -p "$AZURE_CRED_PSW" scp -o StrictHostKeyChecking=no index-azure.html $AZURE_CRED_USR@52.226.22.43:/home/azureuser/

                    sshpass -p "$AZURE_CRED_PSW" ssh -o StrictHostKeyChecking=no $AZURE_CRED_USR@52.226.22.43 "
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
