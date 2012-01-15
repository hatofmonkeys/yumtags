Feature: Create tags of yum repositories
  In Order to make my server builds reproducible
  As A systems developer
  I want to create tagged views of yum repositories

  Scenario: View hello page
    Given I am on the home page
    Then I should see "Yumtags!"

  Scenario: Create a new tag
    Given I am on the home page
    When I press "Create tag"
    Then I should see "Tag created:"
