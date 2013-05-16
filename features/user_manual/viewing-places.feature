Feature: Choosing a topic and viewing places

  When looking at a grid of topics, you can tap on any of the topics you
  like and see a map page showing all the different places associated
  with a topic.

  Scenario:
    Given an example topic "Job Centres" with these example places:
      | Name                    | Address                        | Location           |
      | Job Centre Shirley St   | Shirley St, Thamesmead, E3 4AA | 51.12345, -0.53943 |
      | Job Centre Evans Rd     | Evans Rd, Thamesmead, E3 4BB   | 51.12345, -0.53943 |
      | Job Centre Rotham Place | Rotham Pl, Thamesmead, E3 4CC  | 51.12345, -0.53943 |
    When I view the "Job Centres" topic
    Then I can see a map showing all the different places above
    And I can see basic information about each place
