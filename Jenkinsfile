pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                echo "Pulling latest HTML files from GitHub..."
                git branch: 'main', url: 'https://github.com/Anuhya2312/Capstone-Project.git'
            }
        }

        stage('Deploy to AWS') {
            steps {
                echo "Deploying to AWS EC2..."
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', 
                                                  keyFileVariable: 'AWS_KEY', 
                                                  usernameVariable: 'AWS_USER')]) {
                    sh '''
                        # Copy index-aws.html to AWS EC2
                        scp -o StrictHostKeyChecking=no -i $AWS_KEY index-aws.html \$AWS_USER@35.170.66.187:/tmp/

                        # SSH into EC2 and move the file to Nginx directory
                        ssh -o StrictHostKeyChecking=no -i $AWS_KEY \$AWS_USER@35.170.66.187 "
                            sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true
                            sudo mv /tmp/index-aws.html /var/www/html/index.html
                            sudo systemctl restart nginx
                        "
                    '''
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                echo "Deploying to Azure VM..."
                withCredentials([usernamePassword(credentialsId: 'azure-cred', 
                                                 usernameVariable: 'AZURE_USER', 
                                                 passwordVariable: 'AZURE_PSW')]) {
                    sh '''
                        # Copy index-azure.html to Azure VM
                        sshpass -p $AZURE_PSW scp -o StrictHostKeyChecking=no index-azure.html $AZURE_USER@172.178.18.234:/tmp/

                        # SSH into Azure VM and move file to Nginx directory
                        sshpass -p $AZURE_PSW ssh -o StrictHostKeyChecking=no $AZURE_USER@172.178.18.234 "
                            sudo cp /var/www/html/index.html /var/www/html/index-backup.html || true
                            sudo mv /tmp/index-azure.html /var/www/html/index.html
                            sudo systemctl restart nginx
                        "
                    '''
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                echo "Running Ansible Playbook on Tools EC2..."
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', 
                                          keyFileVariable: 'AWS_KEY', 
                                          usernameVariable: 'AWS_USER')]) {
                sh '''
                    echo "Using SSH key from Jenkins credentials"
                    chmod 600 "$AWS_KEY"

                    # Move into Ansible directory in jenkins workspace
                    cd $WORKSPACE/ansible

                    # Run Ansible Playbook using Jenkins-provided key
                    ansible-playbook -i inventory playbook.yaml \
                        --private-key="$AWS_KEY" \
                        -u "$AWS_USER" \
                        -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
                        -vvvv
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
            echo "❌ Deployment failed. Check Jenkins console logs."
        }
    }
}
