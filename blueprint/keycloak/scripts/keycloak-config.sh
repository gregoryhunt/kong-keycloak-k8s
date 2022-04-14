#!/bin/sh

#KEYCLOAK_URL=http://keycloak.ingress.shipyard.run:8080
apk update && apk add jq

get_token(){
    echo $(curl \
      -d "client_id=admin-cli" \
      -d "username=admin" \
      -d "password=password" \
      -d "grant_type=password" \
      "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
      | jq -r .access_token)
}

token=$( get_token )

curl -v \
-H "Authorization: Bearer ${token}" \
-H "Content-Type: application/json" \
"${KEYCLOAK_URL}/admin/realms/master/clients" | jq