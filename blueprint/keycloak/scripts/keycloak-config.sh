#!/bin/sh

#KEYCLOAK_URL=http://keycloak.ingress.shipyard.run:8080
#KEYCLOAK_URL=host.docker.internal:8080

apk update && apk --no-progress add jq

get_token(){
    echo $(curl -s \
           -d "client_id=admin-cli" \
           -d "username=admin" \
           -d "password=password" \
           -d "grant_type=password" \
           "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
           | jq -r .access_token)
}

# Get access token and create client
token=$( get_token )

client_id=$(curl -si \
            -X POST \
            -H "Authorization: Bearer ${token}" \
            -H "Content-Type: application/json" \
            -d @/scripts/configs/client.json \
            "${KEYCLOAK_URL}/admin/realms/master/clients" \
            | awk -F "/" '/Location/ {gsub("\r",""); print $8}')

# Generate client secret
token=$( get_token )
client_secret=$(curl -s \
                -X POST \
                -H "Authorization: Bearer ${token}" \
                -H "Content-Type: application/json" \
                "${KEYCLOAK_URL}/admin/realms/master/clients/${client_id}/client-secret" \
                | jq -r .value)

# Create User
token=$( get_token )
user_id=$(curl -si \
          -X POST \
          -H "Authorization: Bearer ${token}" \
          -H "Content-Type: application/json" \
          -d '{"username":"user","enabled":true,"emailVerified": true}' \
          "${KEYCLOAK_URL}/admin/realms/master/users" \
          | awk -F "/" '/Location/ {gsub("\r",""); print $8}')

# Set User password
token=$( get_token )
curl -s \
-X PUT \
-H "Authorization: Bearer ${token}" \
-H "Content-Type: application/json" \
-d '{"type": "password","value": "password","temporary": false}' \
"${KEYCLOAK_URL}/admin/realms/master/users/${user_id}/reset-password" \
