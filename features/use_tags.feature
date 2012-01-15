Feature: Use tagged yum repositories
  In Order to create reliable servers
  As A systems developer
  I want to use tagged yum repositories

  Background: Create a new tag
    Given I am on the home page
    And I stop the repository creator
    And I create a tag

  Scenario: Pending tags
    When I check the tag status
    Then I should see "pending"

  Scenario: Completed tags
    When I start the repository creator
    And I have a cup of tea
    And I check the tag status
    Then I should see "ready"