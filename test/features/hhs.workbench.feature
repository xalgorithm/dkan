@enableDKAN_Workflow
Feature:
  HHS specific workbench tests.

  @api  @javascript
  Scenario Outline: As <user>, I <visibility> be able to access My workbench
    Given Users:
      | name       | mail                     | status | roles                             |
      | AUTH       | AUTH@fakeemail.com       | 1      | Authenticated User                |
      ## HHS workflow contributor has access
      | AUTH-WC    | AUTH-WC@fakeemail.com    | 1      | Workflow Contributor              |
      | ED         | ED@fakeemail.com         | 1      | Editor                            |
      | ED-WM      | ED-WM@fakeemail.com      | 1      | Editor, Workflow Moderator        |
      | SM         | SM@fakeemail.com         | 1      | Site Manager                      |
      | SM-WS      | SM-WS@fakeemail.com      | 1      | Site Manager, Workflow Supervisor |
    When I am logged in as "<user>"
    Then I <visibility> see the link "My Workbench"

    Examples:
      | user       | visibility |
      | AUTH       | should not |
      | AUTH-WC    | should     |
      | ED         | should not |
      | ED-WM      | should     |
      | SM         | should not |
      | SM-WS      | should     |

  @api 
  Scenario Outline: As a <role>, in Workbench, I <visibility> be able to access <tab>
    Given pages:
      | name | url             |
      | Workbench | /admin/workbench |
    When I am logged in as an "<role>"
    And I am on "Workbench" page
    Then I <visibility> see the link "<tab>"

    Examples:
      | role                 | tab           | visibility |
      | Workflow Contributor | My drafts     | should     |
      | Workflow Moderator   | My drafts     | should     |
      | Workflow Supervisor  | My drafts     | should     |
      | Workflow Contributor | Needs review  | should     |
      | Workflow Moderator   | Needs review  | should     |
      | Workflow Supervisor  | Needs review  | should     |
      | Workflow Contributor | Stale drafts  | should not |
      | Workflow Moderator   | Stale drafts  | should not |
      | Workflow Supervisor  | Stale drafts  | should     |
      | Workflow Contributor | Stale reviews | should not |
      | Workflow Moderator   | Stale reviews | should not |
      | Workflow Supervisor  | Stale reviews | should     |

  @api 
  Scenario Outline: As <user>, I should be able to upgrade all draft content to needs review
    Given Users:
      | name    | mail                  | status | roles                |
      | AUTH-WC | AUTH-WC@fakeemail.com | 1      | Workflow Contributor |
      | AUTH-WM | AUTH-WM@fakeemail.com | 1      | Workflow Moderator   |
      | AUTH-WS | AUTH-WS@fakeemail.com | 1      | Workflow Supervisor  |
    And pages:
      | name      | url                           |
      | My drafts | /admin/workbench/drafts-active |
    When I am logged in as "<user>"
    And I am on "My drafts" page
    Then I should see the button "Submit for review"

    Examples:
      | user    |
      | AUTH-WC |
      | AUTH-WM |
      | AUTH-WS |

  @api 
  Scenario Outline: As <user>, I should not be able to upgrade draft content to needs review
    Given Users:
      | name    | mail                  | status | roles                |
      | AUTH    | AUTH@fakeemail.com    | 1      | Authenticated User   |
      | ED      | ED@fakeemail.com      | 1      | Editor               |
      | SM      | SM@fakeemail.com      | 1      | Site Manager         |
    And pages:
      | name      | url                            |
      | My drafts | /admin/workbench/drafts-active |
    When I am logged in as "<user>"
    Then I should not be able to access "My drafts"

    Examples:
      | user |
      | AUTH |
      | ED   |
      | SM   |

  @api 
  Scenario Outline: As <user>, I <visibility> be able to see content in <page> of My Workbench
    Given groups:
      | title |
      | Smallville |
      | Star City  |
      | Bludhaven  |
      | Coast City |
    And Users:
      | name               | mail                             | status | roles                             |
      | AUTH-WC-Smallville | AUTH-WC-Smallville@fakeemail.com | 1      | Workflow Contributor              |
      | AUTH-WC-Bludhaven  | AUTH-WC-Bludhaven@fakeemail.com  | 1      | Workflow Contributor              |
      | ED-WM-Smallville   | ED-WM-Smallville@fakeemail.com   | 1      | Editor, Workflow Moderator        |
      | ED-WM-Bludhaven    | ED-WM-Bludhaven@fakeemail.com    | 1      | Editor, Workflow Moderator        |
      | SM-WS-Smallville   | SM-WS-Smallville@fakeemail.com   | 1      | Site Manager, Workflow Supervisor |
      | SM-WS-Bludhaven    | SM-WS-Bludhaven@fakeemail.com    | 1      | Site Manager, Workflow Supervisor |
      | SM                 | SM-NoGroup@fakeemail.com         | 1      | Site Manager, Workflow Supervisor |
    And group memberships:
      | user               | role on group        | group      | membership status |
      | AUTH-WC-Smallville | member               | Smallville | Active            |
      | AUTH-WC-Bludhaven  | member               | Bludhaven  | Active            |
      | ED-WM-Smallville   | administrator member | Smallville | Active            |
      | ED-WM-Bludhaven    | administrator member | Bludhaven  | Active            |
      | SM-WS-Smallville   | administrator member | Smallville | Active            |
      | SM-WS-Bludhaven    | administrator member | Bludhaven  | Active            |
    And datasets:
      | title                           | author             | moderation   | moderation_date   | date created  | publisher  |
      | Smallville Draft Dataset        | AUTH-WC-Smallville | draft        | Jul 21, 2015      | Jul 21, 2015  | Smallville |
      | Smallville Needs Review Dataset | AUTH-WC-Smallville | needs_review | Jul 21, 2015      | Jul 21, 2015  | Smallville |
      | Smallville Published Dataset    | AUTH-WC-Smallville | published    | Jul 21, 2014      | Jul 21, 2015  | Smallville |
      | Bludhaven Draft Dataset         | AUTH-WC-Bludhaven  | draft        | Jul 21, 2015      | Jul 21, 2015  | Bludhaven  |
      | Bludhaven Needs Review Dataset  | AUTH-WC-Bludhaven  | needs_review | Jul 21, 2015      | Jul 21, 2015  | Bludhaven  |
      | Bludhaven Published Dataset     | AUTH-WC-Bludhaven  | published    | Jul 21, 2014      | Jul 21, 2015  | Bludhaven  |
      | Bludhaven Published Dataset 2   | AUTH-WC-Bludhaven  | published    | Jul 21, 2014      | Jul 21, 2015  | Bludhaven  |
    And resources:
      | title                                        | dataset                        | author             | moderation   | format | publisher  | moderation_date   |
      | Smallville Draft-Draft Resource              | Smallville Draft Dataset       | AUTH-WC-Smallville | draft        | csv    | Smallville | Jul 21, 2015      |
      | Smallville Draft-Needs Review Resource       | Smallville Draft Dataset       | AUTH-WC-Smallville | needs_review | csv    | Smallville | Jul 21, 2015      |
      | Smallville Draft-Published Resource          | Smallville Draft Dataset       | AUTH-WC-Smallville | published    | csv    | Smallville | Jul 21, 2015      |
      | Bludhaven Needs Review-Draft Resource        | Bludhaven Needs Review Dataset | AUTH-WC-Bludhaven  | draft        | csv    | Bludhaven  | Jul 21, 2015      |
      | Bludhaven Needs Review-Needs Review Resource | Bludhaven Needs Review Dataset | AUTH-WC-Bludhaven  | needs_review | csv    | Bludhaven  | Jul 21, 2015      |
      | Bludhaven Needs Review-Published Resource    | Bludhaven Needs Review Dataset | AUTH-WC-Bludhaven  | published    | csv    | Bludhaven  | Jul 21, 2015      |
      | Bludhaven Published-Needs Review Resource    | Bludhaven Published Dataset    | AUTH-WC-Bludhaven  | needs_review | csv    | Bludhaven  | Jul 21, 2015      |
    And pages:
      | name          | url                                 |
      | My drafts     | /admin/workbench/drafts-active       |
      | Needs review  | /admin/workbench/needs-review-active |
      | Stale drafts  | /admin/workbench/drafts-stale        |
      | Stale reviews | /admin/workbench/needs-review-stale  |
    When I am logged in as "<user>"
    And I am on "<page>" page
    Then I <visibility> see the text "<name>"

    Examples:
      | user               | page          | visibility | name                                         |
      | AUTH-WC-Smallville | My drafts     | should     | Smallville Draft Dataset                     |
      | AUTH-WC-Smallville | My drafts     | should not | Bludhaven Draft Dataset                      |
      | AUTH-WC-Smallville | My drafts     | should not | Smallville Needs Review Dataset              |
      | AUTH-WC-Smallville | My drafts     | should not | Smallville Published Dataset                 |
      | AUTH-WC-Smallville | My drafts     | should     | Smallville Draft-Draft Resource              |
      | AUTH-WC-Smallville | My drafts     | should not | Smallville Draft-Needs Review Resource       |
      | AUTH-WC-Smallville | My drafts     | should not | Smallville Draft-Published Resource          |
      | AUTH-WC-Smallville | My drafts     | should not | Bludhaven Needs Review-Draft Resource        |
      | AUTH-WC-Smallville | Needs review  | should     | Smallville Needs Review Dataset              |
      | AUTH-WC-Smallville | Needs review  | should not | Smallville Published Dataset                 |
      | AUTH-WC-Smallville | Needs review  | should not | Bludhaven Needs Review Dataset               |
      | AUTH-WC-Smallville | Needs review  | should not | Bludhaven Needs Review-Needs Review Resource |
      | AUTH-WC-Smallville | Needs review  | should     | Smallville Draft-Needs Review Resource       |
      | AUTH-WC-Smallville | Needs review  | should not | Smallville Draft-Published Resource          |
      | ED-WM-Smallville   | My drafts     | should not | Smallville Draft Dataset                     |
      | ED-WM-Smallville   | My drafts     | should not | Bludhaven Draft Dataset                      |
      | ED-WM-Smallville   | My drafts     | should not | Smallville Draft-Draft Resource              |
      | ED-WM-Smallville   | My drafts     | should not | Bludhaven Needs Review-Draft Resource        |
      | ED-WM-Bludhaven    | My drafts     | should not | Bludhaven Needs Review-Draft Resource        |
      | ED-WM-Bludhaven    | Needs review  | should     | Bludhaven Needs Review Dataset               |
      | ED-WM-Bludhaven    | Needs review  | should not | Bludhaven Needs Review-Draft Resource        |
      | ED-WM-Bludhaven    | Needs review  | should     | Bludhaven Needs Review-Needs Review Resource |
      | ED-WM-Bludhaven    | Needs review  | should not | Smallville Needs Review Dataset              |
      | ED-WM-Bludhaven    | Needs review  | should not | Smallville Draft Dataset                     |
      | ED-WM-Bludhaven    | Needs review  | should     | Bludhaven Published-Needs Review Resource    |
      | ED-WM-Bludhaven    | Needs review  | should not | Bludhaven Published Dataset 2                |
      | SM-WS-Smallville   | My drafts     | should not | Smallville Draft Dataset                     |
      | SM-WS-Smallville   | Needs review  | should     | Smallville Needs Review Dataset              |
      | SM-WS-Smallville   | Needs review  | should     | Bludhaven Needs Review Dataset               |
      | SM-WS-Smallville   | Needs review  | should     | Bludhaven Needs Review-Needs Review Resource |
      | SM-WS-Smallville   | Stale drafts  | should     | Bludhaven Draft Dataset                      |
      | SM-WS-Smallville   | Stale drafts  | should     | Smallville Draft Dataset                     |
      | SM-WS-Smallville   | Stale reviews | should     | Bludhaven Needs Review Dataset               |
      | SM-WS-Smallville   | Stale reviews | should     | Smallville Needs Review Dataset              |
      | SM                 | My drafts     | should not | Smallville Draft Dataset                     |
      | SM                 | Needs review  | should     | Smallville Needs Review Dataset              |
      | SM                 | Needs review  | should     | Bludhaven Needs Review Dataset               |
      | SM                 | Needs review  | should     | Bludhaven Needs Review-Needs Review Resource |
      | SM                 | Stale drafts  | should     | Bludhaven Draft Dataset                      |
      | SM                 | Stale drafts  | should     | Smallville Draft Dataset                     |
      | SM                 | Stale reviews | should     | Bludhaven Needs Review Dataset               |
      | SM                 | Stale reviews | should     | Smallville Needs Review Dataset              |

  @api 
  Scenario Outline: As a role, I should be able to upgrade all content to published
    Given groups:
      | title      |
      | Coast City |
    And Users:
      | name    | mail                  | status | roles                              |
      | AUTH-GA | AUTH-GA@fakeemail.com | 1      | Authenticated User                 |
      | AUTH-GM | AUTH-GM@fakeemail.com | 1      | Authenticated User                 |
      | AUTH-WC | AUTH-WC@fakeemail.com | 1      | Workflow Contributor               |
      | AUTH-WM | AUTH-WM@fakeemail.com | 1      | Workflow Moderator                 |
      | AUTH-WS | AUTH-WS@fakeemail.com | 1      | Workflow Supervisor, site manager  |
      | AUTH    | AUTH@fakeemail.com    | 1      | Authenticated User                 |
    And group memberships:
      | user    | role on group        | group      | membership status |
      | AUTH-GA | administrator member | Coast City | Active            |
      | AUTH-GM | member               | Coast City | Active            |
    And datasets:
      | title      | author  | moderation   | moderation_date   | date created | publisher  |
      | Dataset 04 | AUTH-GA | draft        | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 08 | AUTH-GM | draft        | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 09 | AUTH-WC | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 10 | AUTH-WM | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 11 | AUTH-WS | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 12 | AUTH    | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 16 | AUTH-GA | needs_review | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 20 | AUTH-GM | needs_review | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 21 | AUTH-WC | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 22 | AUTH-WM | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 23 | AUTH-WS | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 24 | AUTH    | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 28 | AUTH-GA | published    | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 32 | AUTH-GM | published    | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 33 | AUTH-WC | published    | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 34 | AUTH-WM | published    | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 35 | AUTH-WS | published    | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 36 | AUTH    | published    | Jul 21, 2015      | Jul 21, 2015 |            |
    And pages:
      | name         | url                                 |
      | My drafts    | /admin/workbench/drafts-active       |
      | Needs review | /admin/workbench/needs-review-active |
    When I am logged in as "<user>"
    And I am on "<page>" page
    Then I should see "<count>" items of ".views-dkan-workflow-tree-item" or more in the "dkan_workflow_tree" region

    Examples:
      | user    | page         | count |
      | AUTH-WC | My drafts    | 1     |
      | AUTH-WM | My drafts    | 1     |
      | AUTH-WS | My drafts    | 1     |
      | AUTH-WC | Needs review | 1     |
      | AUTH-WM | Needs review | 1     |
      | AUTH-WS | Needs review | 6     |

  @api 
  Scenario Outline: As a role, I should not be able to upgrade all content to published
    Given groups:
      | title      |
      | Coast City |
    And Users:
      | name    | mail                  | status | roles                |
      | AUTH-GA | AUTH-GA@fakeemail.com | 1      | Authenticated User   |
      | AUTH-GM | AUTH-GM@fakeemail.com | 1      | Authenticated User   |
      | AUTH-WC | AUTH-WC@fakeemail.com | 1      | Workflow Contributor |
      | AUTH-WM | AUTH-WM@fakeemail.com | 1      | Workflow Moderator   |
      | AUTH-WS | AUTH-WS@fakeemail.com | 1      | Workflow Supervisor  |
      | AUTH    | AUTH@fakeemail.com    | 1      | Authenticated User   |
      | ED      | ED@fakeemail.com      | 1      | Editor               |
      | SM      | SM@fakeemail.com      | 1      | Site Manager         |
    And group memberships:
      | user    | role on group        | group      | membership status |
      | AUTH-GA | administrator member | Coast City | Active            |
      | AUTH-GM | member               | Coast City | Active            |
    And datasets:
      | title      | author  | moderation   | moderation_date   | date created | publisher  |
      | Dataset 04 | AUTH-GA | draft        | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 08 | AUTH-GM | draft        | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 09 | AUTH-WC | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 10 | AUTH-WM | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 11 | AUTH-WS | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 12 | AUTH    | draft        | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 16 | AUTH-GA | needs_review | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 20 | AUTH-GM | needs_review | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 21 | AUTH-WC | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 22 | AUTH-WM | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 23 | AUTH-WS | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 24 | AUTH    | needs_review | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 28 | AUTH-GA | published    | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 32 | AUTH-GM | published    | Jul 21, 2015      | Jul 21, 2015 | Coast City |
      | Dataset 33 | AUTH-WC | published    | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 34 | AUTH-WM | published    | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 35 | AUTH-WS | published    | Jul 21, 2015      | Jul 21, 2015 |            |
      | Dataset 36 | AUTH    | published    | Jul 21, 2015      | Jul 21, 2015 |            |
    And pages:
      | name         | url                                 |
      | My drafts    | /admin/workbench/drafts-active       |
      | Needs review | /admin/workbench/needs-review-active |
    When I am logged in as "<user>"
    Then I should not be able to access "<page>"

    Examples:
      | user    | page         |
      | AUTH-GA | My drafts    |
      | AUTH-GM | My drafts    |
      | AUTH    | My drafts    |
      | ED      | My drafts    |
      | SM      | My drafts    |
      | AUTH-GA | Needs review |
      | AUTH-GM | Needs review |
      | AUTH    | Needs review |
      | ED      | Needs review |
      | SM      | Needs review |

  @api  @mail
  Scenario Outline: As a user, I should/should not receive an email on content moderation state change
    Given groups:
      | title       |
      | Smallville  |
      | Bludhaven   |
    And users:
      | name      | mail                          | status | roles                             |
      | Robin     | robin@teentitans.org          | 1      | editor, Workflow Contributor      |
      | Spoiler   | stephanie.brown@yahoo.com     | 0      | editor, Workflow Contributor      |
      | Nightwing | acrobatman@bludhaven.com      | 1      | editor, Workflow Moderator        |
      | Batgirl   | silenceisgolden@bludhaven.com | 1      | editor, Workflow Moderator        |
      | Oracle    | iseeall@clocktower.org        | 1      | Site Manager, Workflow Supervisor |
      | Superboy  | konel@teentitans.org          | 1      | editor,  Workflow Contributor     |
      | Ma Kent   | supermom@smallville.com       | 1      | editor, Workflow Moderator        |
      | Pa Kent   | superdad@smallville.com       | 1      | editor, Workflow Moderator        |
      | Superman  | Superman@fakeemail.com        | 1      | Authenticated User                |
    And group memberships:
      | user      | role on group         | group       | membership status |
      | Robin     | member                | Bludhaven   | Active            |
      | Spoiler   | member                | Bludhaven   | Active            |
      | Nightwing | administrator member  | Bludhaven   | Active            |
      | Batgirl   | administrator member  | Bludhaven   | Active            |
      | Oracle    | administrator member  | Bludhaven   | Active            |
      | Superboy  | member                | Smallville  | Active            |
      | Ma Kent   | administrator member  | Smallville  | Active            |
      | Pa Kent   | administrator member  | Smallville  | Blocked           |
    And datasets:
      | title                             | author    | moderation    | publisher   | moderation_date   | date created |
      | Smallville Dataset Draft          | Superboy  | draft         | Smallville  | Jul 21, 2015      | Jul 21, 2015 |
      | Smallville Dataset Needs Review   | Pa Kent   | needs_review  | Smallville  | Jul 21, 2015      | Jul 21, 2015 |
      | Dataset 01                        | Oracle    | draft         | Bludhaven   | Jul 21, 2015      | Jul 21, 2015 |
      | Dataset 02                        | Superboy  | needs_review  | Smallville  | Jul 21, 2015      | Jul 21, 2015 |
      | Dataset 03                        | Superman  | draft         |             | Jul 21, 2015      | Jul 21, 2015 |
    #And feedback:
      #| title                             | author    | moderation    | associated content |
      #| Bludhaven Feedback Draft          | Robin     | draft         | Dataset 01         |
      #| Bludhaven Feedback Needs Review   | Robin     | needs_review  | Dataset 01         |
      #| Smallville Feedback Draft         | Superboy  | draft         | Dataset 02         |
      #| Smallville Feedback Needs Review  | Superboy  | needs_review  | Dataset 02         |
      #| Groupless Feedback Draft          | Robin     | draft         | Dataset 03         |
      #| Groupless Feedback Needs Review 1 | Spoiler   | needs_review  | Dataset 03         |
      #| Groupless Feedback Needs Review 2 | Robin     | needs_review  | Dataset 03         |
    And pages:
      | name             | url                                  |
      | My drafts        | /admin/workbench/drafts-active       |
      | Needs review     | /admin/workbench/needs-review-active |
    And the email queue is cleared
    And I am logged in as "<moderator>"
    When I am on "<workbench tab>" page
    And I click the "<link>" next to "<content title>"
    Then the user "<user>" <visibility> receive an email

    Examples:
      | moderator | workbench tab | link              | content title                     | user      | visibility  |
      #| Robin     | My drafts     | Submit for Review | Bludhaven Feedback Draft          | Nightwing | should      |
      #| Robin     | My drafts     | Submit for Review | Bludhaven Feedback Draft          | Batgirl   | should      |
      #| Robin     | My drafts     | Submit for Review | Bludhaven Feedback Draft          | Oracle    | should not  |
      #| Robin     | My drafts     | Submit for Review | Bludhaven Feedback Draft          | Robin     | should      |
      #| Robin     | My drafts     | Submit for Review | Bludhaven Feedback Draft          | Ma Kent   | should not  |
      #| Nightwing | Needs review  | Publish           | Bludhaven Feedback Needs Review   | Robin     | should      |
      #| Nightwing | Needs review  | Publish           | Bludhaven Feedback Needs Review   | Nightwing | should not  |
      #| Nightwing | Needs review  | Publish           | Bludhaven Feedback Needs Review   | Oracle    | should not  |
      #| Nightwing | Needs review  | Publish           | Bludhaven Feedback Needs Review   | Superboy  | should not  |
      #| Nightwing | Needs review  | Publish           | Bludhaven Feedback Needs Review   | Ma Kent   | should not  |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 1 | Spoiler   | should      |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 1 | Superboy  | should not  |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 1 | Oracle    | should not  |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 1 | Ma Kent   | should not  |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 1 | Nightwing | should not  |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 1 | Batgirl   | should not  |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 2 | Spoiler   | should not  |
      #| Oracle    | Needs review  | Reject            | Groupless Feedback Needs Review 2 | Oracle    | should not  |
      #| Robin     | My drafts     | Submit for Review | Groupless Feedback Draft          | Oracle    | should      |
      #| Robin     | My drafts     | Submit for Review | Groupless Feedback Draft          | Robin     | should      |
      #| Robin     | My drafts     | Submit for Review | Groupless Feedback Draft          | Ma Kent   | should not  |
      #| Robin     | My drafts     | Submit for Review | Groupless Feedback Draft          | Nightwing | should not  |
      #| Robin     | My drafts     | Submit for Review | Groupless Feedback Draft          | Batgirl   | should not  |
      #| Superboy  | My drafts     | Submit for Review | Smallville Feedback Draft         | Ma Kent   | should      |
      #| Superboy  | My drafts     | Submit for Review | Smallville Feedback Draft         | Pa Kent   | should not  |
      #| Superboy  | My drafts     | Submit for Review | Smallville Feedback Draft         | Superboy  | should      |
      #| Superboy  | My drafts     | Submit for Review | Smallville Feedback Draft         | Robin     | should not  |
      #| Superboy  | My drafts     | Submit for Review | Smallville Feedback Draft         | Nightwing | should not  |
      #| Superboy  | My drafts     | Submit for Review | Smallville Feedback Draft         | Oracle    | should not  |
      #| Ma Kent   | Needs review  | Reject            | Smallville Feedback Needs Review  | Superboy  | should      |
      #| Ma Kent   | Needs review  | Reject            | Smallville Feedback Needs Review  | Ma Kent   | should not  |
      #| Ma Kent   | Needs review  | Reject            | Smallville Feedback Needs Review  | Oracle    | should not  |
      #| Ma Kent   | Needs review  | Publish           | Smallville Feedback Needs Review  | Superboy  | should      |
      #| Ma Kent   | Needs review  | Publish           | Smallville Feedback Needs Review  | Ma Kent   | should not  |
      #| Ma Kent   | Needs review  | Publish           | Smallville Feedback Needs Review  | Oracle    | should not  |
      | Ma Kent   | Needs review  | Reject            | Smallville Dataset Needs Review   | Pa Kent   | should      |
      | Ma Kent   | Needs review  | Reject            | Smallville Dataset Needs Review   | Ma Kent   | should not  |
      | Ma Kent   | Needs review  | Publish           | Smallville Dataset Needs Review   | Pa Kent   | should      |
      | Ma Kent   | Needs review  | Publish           | Smallville Dataset Needs Review   | Ma Kent   | should not  |
      | Superboy  | My drafts     | Submit for Review | Smallville Dataset Draft          | Ma Kent   | should      |
      | Superboy  | My drafts     | Submit for Review | Smallville Dataset Draft          | Pa Kent   | should not  |
