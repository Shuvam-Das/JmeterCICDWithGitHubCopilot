pipeline {
    agent any

    // Define parameters to change workload dynamically at runtime
    parameters {
        string(name: 'THREAD_COUNT', defaultValue: '10', description: 'Number of Virtual Users')
        string(name: 'RAMP_UP', defaultValue: '5', description: 'Ramp up time in seconds')
        string(name: 'LOOP_COUNT', defaultValue: '2', description: 'Number of loops')
        string(name: 'JMX_FILE', defaultValue: 'tests/load_test.jmx', description: 'Path to JMX file')
    }

    stages {
        stage('Build JMeter Image') {
            steps {
                script {
                    // Build the image locally so we have the latest version
                    bat 'docker build -t my-jmeter-runner .'
                }
            }
        }

        stage('Run Performance Test') {
            steps {
                script {
                    // Clean previous reports
                    bat 'if exist report rmdir /s /q report'
                    bat 'mkdir report'
                    
                    // Run JMeter in Docker
                    // We mount the current workspace (${WORKSPACE}) to /jmeter inside the container
                    bat """
                        docker run --rm ^
                        -v "${WORKSPACE}":/jmeter ^
                        -w /jmeter ^
                        my-jmeter-runner ^
                        -n ^
                        -t ${params.JMX_FILE} ^
                        -l report/result.jtl ^
                        -e -o report/html ^
                        -Jthreads=${params.THREAD_COUNT} ^
                        -Jrampup=${params.RAMP_UP} ^
                        -Jloops=${params.LOOP_COUNT}
                    """
                }
            }
        }
    }

    post {
        always {
            // Publish the HTML Report to Jenkins UI
            publishHTML(target: [
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'report/html',
                reportFiles: 'index.html',
                reportName: 'JMeter Dashboard'
            ])
        }
    }
}
