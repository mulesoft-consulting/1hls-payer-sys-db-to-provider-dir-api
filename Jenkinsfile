pipeline {
  agent {
    label 'bat-builder'
  }

  parameters {
    string (defaultValue: '4.3.0', description: 'This is the Mule Version to be specified', name: 'MULE_VERSION', trim: false)
  }

  environment {
    DEPLOY_CREDS = credentials('deploy-anypoint-user')
    MULE_VERSION = "${params.MULE_VERSION}"
    BG = "1Platform\\Health Care Accelerator\\Payer"
    BG_ID = "dffb45a2-a86e-4e2d-9541-f2b15cff324d"
    WORKER = "Small"
    DB_JDBC_URL = credentials("${BRANCH_NAME}-ajdbc-url")
    DB_JDBC_CRED = credentials("${BRANCH_NAME}-ajdbc-cred")
    DB_DRIVER = "org.postgresql.Driver"
    DB_DEFAULTDB = "hlsdemo"
  }
  stages {
    stage('Prepare') {
      steps {
        configFileProvider([configFile(fileId: "${BRANCH_NAME}-1hls-payer-sys-db-to-provider-dir-api.yaml", replaceTokens: true, targetLocation: './src/main/resources/config/configuration.yaml')]) {
          withCredentials([file(credentialsId: 'self-signed-keystore.jks', variable: 'KEYSTORE_FILE')]){
            sh 'echo "Branch NAME: $BRANCH_NAME"'
            sh 'cp $KEYSTORE_FILE ./src/main/resources/keystore.jks'
          }
        }
      }
    }

    stage('Build') {
      steps {
        withMaven(
          mavenSettingsConfig: 'certified-mvn-settings.xml'){
            sh 'mvn -B clean package -DskipTests'
        }
      }
    }

    stage('Test') {
      steps {
        withMaven(
          mavenSettingsConfig: 'certified-mvn-settings.xml'){
            sh 'mvn -B test -Dajdbc.driver=$DB_DRIVER -Dajdbc.url=$DB_JDBC_URL -Dajdbc.user=$DB_JDBC_CRED_USR -Dajdbc.password=$DB_JDBC_CRED_PSW -Dajdbc.defaultdb=$DB_DEFAULTDB'
        }
      }

      post {
        always {
          publishHTML (target: [
            allowMissing: false,
            alwaysLinkToLastBuild: false,
            keepAll: true,
            reportDir: 'target/site/munit/coverage',
            reportFiles: 'summary.html',
            reportName: "Code coverage"
          ])
        }
      }
    }

    stage('Deploy Development') {
      when {
        branch 'develop'
      }
      environment {
        ENVIRONMENT = 'Development'
        ANYPOINT_ENV = credentials("${ENVIRONMENT}-anypoint-client-id-secret")
      }
      steps {
        sh 'mvn -V -B -DskipTests deploy -DmuleDeploy -Dmule.version=$MULE_VERSION -Danypoint.username=$DEPLOY_CREDS_USR -Danypoint.password=$DEPLOY_CREDS_PSW -Dcloudhub.environment=$ENVIRONMENT -Denv.anypoint_client_id=$ANYPOINT_ENV_USR -Denv.anypoint_client_secret=$ANYPOINT_ENV_PSW -DbusinessGroup="$BG" -Dworkers=$WORKER -Dajdbc.url=$DB_JDBC_URL -Dajdbc.driver=$DB_DRIVER -Dajdbc.user=$DB_JDBC_CRED_USR -Dajdbc.password=$DB_JDBC_CRED_PSW -Dajdbc.defaultdb=$DB_DEFAULTDB'
      }
    }
    stage('Deploy Production') {
        when {
          branch 'master'
        }
        environment {
          ENVIRONMENT = 'Production'
          ANYPOINT_ENV = credentials("${ENVIRONMENT}-anypoint-client-id-secret")
        }
        steps {
          sh 'mvn -V -B -DskipTests deploy -DmuleDeploy -Dmule.version=$MULE_VERSION -Danypoint.username=$DEPLOY_CREDS_USR -Danypoint.password=$DEPLOY_CREDS_PSW -Dcloudhub.environment=$ENVIRONMENT -Denv.anypoint_client_id=$ANYPOINT_ENV_USR -Denv.anypoint_client_secret=$ANYPOINT_ENV_PSW -DbusinessGroup="$BG" -Dworkers=$WORKER -Dajdbc.url=$DB_JDBC_URL -Dajdbc.driver=$DB_DRIVER -Dajdbc.user=$DB_JDBC_CRED_USR -Dajdbc.password=$DB_JDBC_CRED_PSW -Dajdbc.defaultdb=$DB_DEFAULTDB'
        }
    }
    stage('Integration Test') {
      steps {
      	sh 'bat integration-scripts --config=devx'
      }
      post {
        always {
          publishHTML (target: [
            allowMissing: false,
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportDir: '/tmp',
            reportFiles: 'index.html',
            reportName: "Integration Test",
            includes: '**/index.html'
          ])
        }
      }
    }
  }

  post {
      always {
        step([$class: 'hudson.plugins.chucknorris.CordellWalkerRecorder'])
      }
  }

  tools {
    maven 'M3'
  }
}