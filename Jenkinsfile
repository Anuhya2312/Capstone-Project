pipeline {
    agent any

    environment {
        INVENTORY = '/home/ubuntu/inventory'
        PLAYBOOK  = '/home/ubuntu/playbook.yaml'
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Pulling latest HTML files from GitHub..."
                git branch: 'main',
                    url: 'https://github.com/Anuhya2312/Capstone-Project.git'
            }
        }

        stage('Deploy to AWS & Azure') {
            steps {
                echo "Deploying updated HTML files to AWS and Azure servers..."

                // Inject both AWS and Azure credentials securely
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'AWS_KEY'),
                    sshUserPrivateKey(credentialsId: 'azure-cred', keyFileVariable: 'AZURE_KEY')
                ]) {
                    sh '''
                        # Ensure Ansible is installed
                        which ansible || sudo apt-get install -y ansible

                        # Copy latest HTML files into Ansible folder
                        cp index-aws.html index-azure.html /home/ubuntu/ansible/

                        # Run the Ansible playbook using both keys
                        ansible-playbook -i $INVENTORY $PLAYBOOK \
                            --private-key $AWS_KEY \
                            --extra-vars "ansible_ssh_private_key_file=$AWS_KEY"

                        # (Optional) If Azure uses a separate key
                        ansible-playbook -i $INVENTORY $PLAYBOOK \
                            --private-key $AZURE_KEY \
                            --extra-vars "ansible_ssh_private_key_file=$AZURE_KEY"
                    '''
                }
            }
        }

        stage('Restart Nginx') {
            steps {
                echo "Restarting Nginx on AWS and Azure servers..."
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'AWS_KEY'),
                    sshUserPrivateKey(credentialsId: 'azure-cred', keyFileVariable: 'AZURE_KEY')
                ]) {
                    sh '''
                        ansible all -i $INVENTORY -m service -a "name=nginx state=restarted" \
                            --become --private-key $AWS_KEY || true
                        ansible all -i $INVENTORY -m service -a "name=nginx state=restarted" \
                            --become --private-key $AZURE_KEY || true
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful — Nginx restarted on AWS and Azure!"
        }
        failure {
            echo "❌ Deployment failed. Check Jenkins console logs for details."
        }
    }
}
