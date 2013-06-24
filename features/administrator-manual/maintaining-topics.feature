Feature: Maintaining Topics

  Administrators with the correct password are able to log in and add,
  remove and edit topics.

  Creating topics
  ------------------

  Click '[Create topic](/admin/topics/new)' on the menu on the right to add new topics.
  Fill in the name - make sure that it isn't blank or is the same as
  an existing one - and click the 'Create topic' button when you're
  ready.

  The newly created topic will then appear in the list on the right
  hand admin menu, and be available to associate with audiences.

  Editing topics
  --------------

  Click on any topic on the right. You are free to modify the name,
  as long as you don't leave it blank, or choose an identical name to
  another topic. Click 'Save changes' when you are done. You can also
  click 'Remove' to permanently remove topics.

  Scenario: Adding a topic and associating it with an audience
    Given the site has the following example audiences:
      | I want to go out |
    When I create a topic "Restaurants"
    And I associate it with the "I want to go out" audience
    Then the topic should be shown under that audience

  Scenario: Trying to add a topic with an existing name
    When I create a topic "Youth"
    And I try to create another topic "Youth"
    Then I see an error telling me I can't create two topics with the same name

  Scenario: Editing an existing topic
    Given an example audience "I am looking for work" with these associated topics:
      | Job Centres          |
    When I change the name of the topic "Job Centres" to "Work Centres"
    Then the topic name should be updated on the main site

  Scenario: Removing an audience
    When I create a topic "Youth"
    And I delete the topic again
    Then the topic is no longer shown on the admin site
