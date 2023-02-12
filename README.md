<!-- Readme
    Couple of points about editing:

    1. Keep it SIMPLE.
    2. Refer to reference docs and other external sources when possible.
    3. Remember that the file must be useful for new / external developers, and stand as a documentation basis on its own.
    4. Try to make it as informative as possible.
    5. Do not put data that can be easily found in code.
    6. Include this file on ALL branches.
    7. Do not put sensitive data (eg. access tokens, keys, etc.) into this file! Store them in a secure enclave, e.g. 1Password

    Below are links that should be replaced!
-->
[cdLink1]: ${CONTINUOUS_DELIVERY_STAGING_LINK}
[cdLink2]: ${CONTINUOUS_DELIVERY_PROD_LINK}
[jiraBoardLink]: ${JIRA_BOARD_LINK}
[confluenceLink]: ${CONFLU_WIKI_LINK}
[projectSlackChannel]: ${PROJECT_SLACK_CHANNEL}
[bitriseLink]: ${BITRISE_LINK}
[appCenterLink]: ${APP_CENTER_LINK}
[firebaseLink]: ${FIREBASE_LINK}
[iOSAppsSetupGuide]: https://netguru.atlassian.net/wiki/spaces/IOS/pages/9208158/Technical+Setup+Checklist

<!-- Put your project's name -->
# CompanySystem-iOS

<!-- Add links to CD places like App Center, Firebase Distribution or other  -->
<!-- Add links to CI configs with build status and deployment environment -->
<!-- If using Bitrise CI, https://devcenter.bitrise.io/api/app-status-badge can be used to generate status badges -->
<!-- Make sure to define which branch is used to build the app for a given environment, eg. staging is built from develop, etc. -->
| environment           | deployment            | status        |
|-----------------------|-----------------------|---------------|
| staging (develop)     | [${CD}][cdLink1] link | CI status tag |
| production (master)   | [${CD}][cdLink2] link | CI status tag |

Welcome to the **CompanySystem-iOS** project.
${PROJECT_DESCRIPTION}

- [JIRA][jiraBoardLink]
- [CONFLUENCE][confluenceLink]
- [SLACK CHANNEL][projectSlackChannel]
- 1Password: ${VAULT_NAME}
- [Netguru development workflow](https://netguru.atlassian.net/wiki/display/DT2015/Netguru+development+flow)
- [Netguru iOS projects setup guide][iOSAppsSetupGuide]

## Services
<!-- Add list of services the project requires -->
* [Bitrise][bitriseLink]
* [Firebase][firebaseLink]
* [App Center][appCenterLink]
* etc.

## Configuration

### Prerequisites
Things that you need to have before start working with a project.
<!-- This should be rather obvious for an iOS Dev, but could be helpful for anyone else. -->

- [Ruby](https://rubygems.org)
- [Bundler](http://bundler.io) (`gem install bundler`)
- [Homebrew](https://brew.sh)
- [Carthage](https://github.com/Carthage/Carthage) (`brew install carthage`)
- [CocoaPods](https://cocoapods.org) (`brew install cocoapods`)
- [Xcodegen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- [Xcode X](https://developer.apple.com/Xcode) (iOS SDK Y)

### Installation
1. Clone repository
2. Install required Gems:
	```bash
	bundle install
	```
3. Run Carthage:
	```bash
	carthage bootstrap --platform iOS --cache-builds
	```
4. Run `xcodegen generate` to create `*.xcodeproj` file (we do not commit project files).
5. Move `IDETemplateMacros.plist` file to the `${PROJECT_NAME}.xcodeproj/xcshareddata` directory.
6. Download `.env` file from project's 1Password ${VAULT_NAME} Vault and paste it into the root project's directory.
7. Install pods through Bundler:
	```bash
	bundle exec pod install
	```
8. Set up SwiftFormat (more info below).
9. Open `${PROJECT NAME}.xcworkspace` file and build the project.

## Code Style guidelines and Linters

### Implementing Code Style guidelines with SwiftLint

<!-- Include project specific coding guidelines and linter tools used to enforce them -->
When committing to the repository, please, format your code according to the team code style guide.<br>To automatically point out any discrepancies, please use [SwiftLint](https://github.com/realm/SwiftLint) tool
with the following rules sets:
- [Basic Rules](https://github.com/netguru/how-we-roll/blob/master/Mobile/iOS/templates/.swiftlint-basic.yml)
- (Recommended)[Strict Rules](https://github.com/netguru/how-we-roll/blob/master/Mobile/iOS/templates/.swiftlint-strict.yml)
- (Optional)[Rules](https://github.com/netguru/how-we-roll/blob/master/Mobile/iOS/templates/.swiftlint-strictest.yml)
To install SwitLint, follow: [SwiftLint installation](https://github.com/realm/SwiftLint#installation)

### Enforcing common Code Style with SwiftFormat

There is a tool called [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) that can fix some issues in your code automatically.<br>To enable usage of SwiftFormat as a pre-commit git hook, follow:
[SwiftFormat pre-commit git hook guide](https://netguru.atlassian.net/wiki/spaces/IOS/pages/1298466439/SwiftFormat+Implementation#Git-Hooks)

## Code Quality guidelines
<!-- Avoid entering all the rules here; Rather point to appropriate WIKI pages / guides -->

- Respect Swift [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Adhere to [Internal Swift Coding guidelines](https://netguru.atlassian.net/wiki/spaces/IOS/pages/6881379/Swift+Style+Guide)

## Project guide

### Project configurations
<!-- List the most important project configurations and their distinctive features -->

#### development
 - crashlytics **disabled**
 - analytics **disabled**
 - staging API connected

#### production
 - crashlytics **enabled**
 - analytics **enabled**
 - production API connected

### (Optionally) Navigation
<!-- Describe (briefly) how the navigation is structured in the app, where is the entry point, what are the main classes, etc. -->
<!-- Eg. The app uses Flow Coordinator pattern (with Root Flow Coordinators), more info: https://netguru.com; main factory: RootFlowCoordinatorFactory; entry point: WindowController -->
<!-- If the section seems too long or complicated, simply move it to the project WIKI -->

### (Optionally) Architecture overview
<!-- Describe (briefly) what is the app architecture, why this solution was chosen, what are the main classes / components, etc. -->
<!-- Eg. The app uses classical MVVM architecture with Flow Coordinator navigation, more info: https://netguru.com -->
<!-- If the section seems too long or complicated, simply move it to the project WIKI -->

## Related repositories
- [projectname](https://github.com/company/projectname)
- [projectname-android](https://github.com/company/projectname-android)
- [projectname-front](https://github.com/company/projectname-front)
