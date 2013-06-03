Feature: Choosing a topic and viewing places

  When looking at a grid of topics, you can tap on any of the topics you
  like and see a map page showing all the different places associated
  with a topic.

  Scenario:
    Given an example topic "Job Centres" within "I am looking for work" with this example place:
      | Name        | Job Centre Shirley St                              |
      | Information | The information about the job centre in Shirley St |
      | Address     | Shirley St, Thamesmead, E3 4AA                     |
      | Telephone   | 020 8765 4242                                      |
      | URL         | www.jobcentre.org                                  |
      | E-mail      | hello@jobcentre.org                                |
      | Facebook    | http://facebook.com/job-centre-shirley             |
      | Twitter     | http://twitter.com/job-centre-shirley              |
      | Location    | 51.12323, -0.1229                                  |
    When I view the "Job Centres" topic within "I am looking for work"
    Then I can see a map showing the place above
    And I can see basic information about the place
