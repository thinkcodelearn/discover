Feature: Viewing audiences on home page

  As a user who is interested in Thamesmead, I want to head to the front
  page of the "Discover Thamesmead" site and see a list of different
  audiences that the site is aimed at. This is so that I can select
  the audience that is most like me and see a list of tailored topics
  that I would be interested in, without having to wade through all the
  information the site wants to offer me.

  Scenario: User visits homepage
    Given the site has the following audiences:
      | I want to go out in Thamesmead      |
      | I want to do something with my kids |
      | I am looking for work               |
      | I want to move to Thamesmead        |
    When I visit the homepage of the site
    Then I see the list of audiences clearly displayed for me to select from
