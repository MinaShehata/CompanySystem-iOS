#
#  Podfile
#
#  Copyright (c) 2022 Netguru Sp. z o.o. All rights reserved.
#

# Pod sources
source 'https://cdn.cocoapods.org/'

# Initial configuration
platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

project 'CompanySystem-iOS'

pod 'SwiftLint', '~> 0.47.1'
pod 'SwiftFormat/CLI', '~> 0.49.9'

target 'CompanySystem-iOS' do
	# insert Pods here
	# remember to lock minor version of pod e.g. pod 'HockeySDK', '~> 4.1'
end

target 'CompanySystem-iOSTests' do
	# insert Pods for tests here.
	# remember to lock minor version of pod e.g. pod 'OHHTTPStubs', '~> 5.2'
end

plugin 'cocoapods-keys', {
    project: 'CompanySystem-iOS',
    keys: [
      "TEST_KEY"
    ]
}
