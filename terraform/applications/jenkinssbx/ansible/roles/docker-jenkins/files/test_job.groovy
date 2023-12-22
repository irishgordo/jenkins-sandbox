pipelineJob('test-job') {
    disabled()
    description('just a test job for jenkins')
    logRotator {
      numToKeep(-1)
      daysToKeep(5)
    }
    quietPeriod(120)
    triggers {
      cron('30 13 * * *')
    }

    definition {
        cps {
            sandbox()
            script('''
pipeline {
    agent { label 'master' }
    stages {
        stage('blurt out test-job.groovy') {
            steps {
                echo "hello world..."
            }
        }
    }
}
            ''')
        }
    }
}