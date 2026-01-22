pipeline {
    agent any
    
    stages {
        stage('Diagnose Channel') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'slack-token', variable: 'SLACK_TOKEN')]) {
                        sh '''
                            echo "=== Channel Diagnosis ==="
                            
                            # Find channel by ID
                            echo "\\n1. Looking for channel with ID C09PEC2E03A:"
                            curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
                                "https://slack.com/api/conversations.info?channel=C09PEC2E03A" | \
                                jq '. | {ok: .ok, error: .error, channel: {id: .channel.id, name: .channel.name, is_channel: .channel.is_channel, is_private: .channel.is_private}}'
                            
                            # List all channels
                            echo "\\n2. All channels (first 20):"
                            curl -s -H "Authorization: Bearer $SLACK_TOKEN" \
                                "https://slack.com/api/conversations.list?types=public_channel,private_channel&limit=20" | \
                                jq '.channels[] | {id: .id, name: .name, is_member: .is_member}'
                            
                            # Test posting with exact API
                            echo "\\n3. Testing direct API post:"
                            curl -s -X POST \
                                -H "Authorization: Bearer $SLACK_TOKEN" \
                                -H 'Content-type: application/json' \
                                --data '\''{"channel":"C09PEC2E03A","text":"Direct API test to channel ID"}' \
                                https://slack.com/api/chat.postMessage | jq '. | {ok: .ok, error: .error, channel: .channel}'
                        '''
                    }
                }
            }
        }
    }
}
