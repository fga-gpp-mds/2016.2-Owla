Feature: registration_member

  Scenario: a user should be able to registrate
    Given I go to /
    When I click "Register a new membership"
    Then I should be in "/members/new"
    When I write "Gabriel Alves" on "member_name"
    When I write "gabriel@gmail.com" on "member_email"
    When I write "gabi" on "member_alias"
    When I write "testtest" on "member_password"
    When I write "testtest" on "member[password_confirmation]"
    When I click button "Register"
    Then I should be in "Gabriel Alves" homepage
    And the object with attribute "name" and value "Gabriel Alves" of "member" klass was created

  Scenario: a user tries to log in without confirmation
    Given I go to /
    When I click button "Enter"
    Then I should be in "/login"

  Scenario: a user tries to log in with right data
    Given I go to /
    Given I have created "victor@gmail.com"
    When I write "victor@gmail.com" on "session_email"
    When I write "testtest" on "session_password"
    When I click button "Enter"
    Then I should be in "Victor Navarro" homepage

  Scenario: a user logged in logs out
    Given I go to /
    Given I have created "victor@gmail.com"
    When I write "victor@gmail.com" on "session_email"
    When I write "testtest" on "session_password"
    When I click button "Enter"
    Then I should be in "Victor Navarro" homepage
    When I click "LOGOUT"
    Then I should be in "/"
