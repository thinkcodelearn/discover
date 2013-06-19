Feature: Maintaining Audiences

  Administrators with the correct password are able to log in and add,
  remove and edit audiences.

  Scenario: Administrator adds an audience
    When I create an audience "I want to live in Thamesmead"
    Then the audience should be available for viewing on the main site
