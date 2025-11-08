pipeline {
    agent any

    environment {
        // These refer to the Jenkins credentials IDs you created
        AWS_SSH = credentials('aws-ssh-key')
        AZURE_CRED = credentials('azure-cred')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: 'main', url: 'https://github.com/<your-username>/capstone-project.git'
            }
        }

        stage('Prepare Ansible Key') {
            steps {
                echo "Preparing AWS SSH key for Ansible..."
                // The private key is stored temporarily in the workspace
                sh '''
                    echo "$AWS_SSH" > aws-key.pem || true
                    chmod 400 aws-key.pem
                    ls -l aws-key.pem
                '''
            }
        }

        stage('Deploy Nginx via Ansible') {
            steps {
                echo "Running Ansible Playbook to deploy Nginx..."
                sh '''
                    cd ansible
                    ansible-playbook -i inventory playbook.yaml --key-file ../aws-key.pem
                '''
            }
        }

        stage('Clean Up') {
            steps {
                echo "Cleaning up temporary files..."
                sh 'rm -f aws-key.pem'
            }
        }
    }

    post {
        always {
            echo "Build finished — cleaning workspace..."
            cleanWs()
        }
    }
}
