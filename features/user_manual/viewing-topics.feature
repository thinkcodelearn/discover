Feature: Choosing an audience and viewing topics

  After I've looked at the audience list, I want to click on the
  audience that's most relevant to me and see a grid of topics that I
  might be most interested in.

  Scenario:
    Given an audience "I am looking for work" with these associated topics:
      | Job Centres          |
      | Recruitment Agencies |
      | Post Offices         |
    When I select the audience "I am looking for work" from the home page
    Then I should see the topics I'm interested in
