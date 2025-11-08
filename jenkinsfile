pipeline {
    agent any

    environment {
        // Paths to inventory and playbook files on your tools machine
        INVENTORY = '/home/ubuntu/inventory'
        PLAYBOOK = '/home/ubuntu/playbook.yaml'
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
                sh '''
                    # Ensure Ansible is installed
                    which ansible || sudo apt-get install -y ansible

                    # Copy the latest index files to Ansible folder
                    cp index-aws.html index-azure.html /home/ubuntu/ansible/

                    # Run the Ansible playbook
                    ansible-playbook -i $INVENTORY $PLAYBOOK
                '''
            }
        }

        stage('Restart Nginx') {
            steps {
                echo "Restarting Nginx on AWS and Azure servers..."
                sh '''
                    ansible all -i $INVENTORY -m service -a "name=nginx state=restarted" --become
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful — Nginx restarted on all servers!"
        }
        failure {
            echo "❌ Deployment failed. Check Jenkins console logs for errors."
        }
    }
}
