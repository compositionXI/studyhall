Feature: visit profile page
  In order to see profile information
  As a user
  I want to see their profile page.

Scenario: Viewing any page on the site
  Given I am logged in as a user
  When I click the profile link
  Then I should go to the profile page 
  