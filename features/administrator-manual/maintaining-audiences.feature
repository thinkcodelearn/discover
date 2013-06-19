Feature: Maintaining Audiences

  Administrators with the correct password are able to log in and add,
  remove and edit audiences.

  Scenario: Adding an audience
    When I create an audience "I want to live in Thamesmead"
    Then the audience should be available for viewing on the main site

  Scenario: Trying to add an audience with an existing description
    When I create an audience "I want to live in Thamesmead"
    And I try to create another audience "I want to live in Thamesmead"
    Then I see an error telling me I can't create two audiences with the same description
