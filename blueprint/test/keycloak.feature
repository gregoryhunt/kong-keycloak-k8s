Feature: Keycloak blueprint
  In order to test Shipyard creates containers correctly
  I should apply a blueprint which defines a simple container setup
  and test the resources are created correctly

Scenario: Keycloak environment
  Given I have a running blueprint
    Then the following resources should be running
      | name                | type        |
      | local               | network     |
      | k8s                 | k8s_cluster |
  And a HTTP call to "http://kong-80.ingress.shipyard.run:10080" should result in status 404
  And a HTTP call to "http://keycloak.ingress.shipyard.run:8080" should result in status 200