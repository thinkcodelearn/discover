Feature: Maintaining Places

  Administrators with the correct password are able to log in and add,
  remove and edit places on the map.

  Creating places
  ------------------

  Click '[Create place](/admin/places/new)' on the menu on the right to add new places. Fill
  in the name, and the details and click the 'Create place' button when
  you're ready.

  You'll also be able to choose a place by clicking and dragging a
  placeholder around on the map on the left.

  The newly created place will then be shown on the list of places on
  the right.

  Editing places
  --------------

  Click the place you want to edit on the right and make your changes.
  Click 'Save changes' when you are done. You can also click 'Delete' to
  permanently remove that place from the system.


  Adding an image to a place
  --------------------------

  Images are used as little thumbnails on the places. Add an image by
  clicking 'add image' on the menu on the right and uploading the image
  via the form provided. You can then reference the image on the place
  page.

  Scenario: Adding a place and associating it with a topic
    Given an example audience "I am looking for work" with these associated topics:
      | Job Centres          |
    When I create an example place within the topic "Job Centres":
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

  Scenario: Adding an image to a place
    Given I have uploaded an image called 'job-centres.png'
    When I create a place "Job Centre" with the 'job-centres.png' image
    Then an topic page for "Job Centre" should show the 'job-centres.png' image as the place's thumbnail image

  Scenario: Editing an existing place
    Given I have created a place called "Job Centre"
    When I change the name of the place to "Work Centre"
    Then the place name should be updated on the main site

  Scenario: Removing a place
    Given I have created a place called "Job Centre"
    When I delete the place again
    Then the place is no longer shown on the admin site
