#
#  Dangerfile
#

# Configuration
jira_project_id = 'TEST'
jira_project_base_url = 'https://netguru.atlassian.net/browse'

# Link JIRA ticket
jira.check(
  key: [jira_project_id],
  url: jira_project_base_url,
  search_title: true,
  search_commits: false,
  fail_on_warning: false,
  report_missing: false,
  skippable: false
)

# Ensure there is JIRA ID in PR title
is_jira_id_included = github.pr_title.include? "[#{jira_project_id}-"
warn "PR doesn`t have JIRA ID in title or it`s not correct. PR title should begin with [#{jira_project_id}-" if (is_jira_id_included == false)

# Ensure there is a summary for a PR
warn "Please provide a summary in the Pull Request description" if github.pr_body.length < 5

# Generate report
report = xcov.produce_report(
  scheme: "CompanySystem-iOS",
  workspace: "CompanySystem-iOS.xcworkspace",
  skip_slack: true,
  only_project_targets: true,
)
xcov.output_report(report)

# Run SwiftFormat
swiftformat.check_format

# Run SwiftLint
swiftlint.lint_files

# Check for print and NSLog statements in modified files
ios_logs.check

changedFiles = (git.added_files + git.modified_files).select{ |file| file.end_with?('.swift') }
changedFiles.each do |changed_file|
  addedLines = git.diff_for_file(changed_file).patch.lines.select{ |line| line.start_with?('+') }

  # Check for TODOs in modified files
  warn "There are TODOs inside modified files!" if addedLines.map(&:downcase).select{ |line| line.include?('//') & line.include?('todo') }.count != 0

  # Check if new header files contains '//  Created by ' line
  fail "`//  Created by ` lines in header files should be removed" if addedLines.select{ |line| line.include?('//  Created by ') }.count != 0
end

# Check commits - warn if they are not nice
commit_lint.check warn: :all

# Post random mem from thecodinglove.com. Uncomment the next line if you want to add it.
# the_coding_love.random
