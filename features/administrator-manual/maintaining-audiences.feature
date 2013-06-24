Feature: Maintaining Audiences

  Administrators with the correct password are able to log in and add,
  remove and edit audiences.

  Creating audiences
  ------------------

  Click '[Create audience](/admin/audiences/new)' on the menu on the right to add new audience.
  Fill in the description - make sure that it isn't blank or is the
  same as an existing one - and click the 'Create audience' button when
  you're ready.

  The newly created audience will then appear in the list on the right
  hand menu.

  Editing audiences
  -----------------

  Click on any audience on the right. You are free to modify the
  audience description, as long as you don't leave it blank, or choose
  an identical name to another audience. Click 'Save changes' when you
  are done. You can also click 'Remove' to permanently remove audiences.

  Scenario: Adding an audience
    When I create an audience "I want to live in Thamesmead"
    Then the audience should be available for viewing on the main site

  Scenario: Trying to add an audience with an existing description
    When I create an audience "I want to live in Thamesmead"
    And I try to create another audience "I want to live in Thamesmead"
    Then I see an error telling me I can't create two audiences with the same description

  Scenario: Editing an existing audience
    Given the site has the following example audiences:
      | I want to go out |
    When I change the description of the audience "I want to go out" to "I want to have fun"
    Then the audience description should be updated on the main site

  Scenario: Removing an audience
    Given the site has the following example audiences:
      | I want to go out |
    When I delete the audience "I want to go out"
    Then the audience is no longer shown on the main site
