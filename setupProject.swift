#!/usr/bin/env swift
//
//  setupProject.swift
//  PROJECT_NAME
//

import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
/*
 Helper functions
 */

@discardableResult func runProcess(_ command: String) -> String? {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = command.split(separator: " ").map { String($0) }
    let pipe = Pipe()
    process.standardOutput = pipe
    try? process.run()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: String.Encoding.utf8)
}

func bold(_ text: String) -> String {
    "\u{001B}[1m" + text + "\u{001B}[0m"
}

func printBold(_ text: String) {
    print(bold(text))
}

func loadFile(_ name: String) -> String {
    try! String(contentsOfFile: name, encoding: .utf8)
}

func writeText(_ text: String, to fileName: String) {
    try! text.write(to: URL(fileURLWithPath: fileName), atomically: true, encoding: .utf8)
}

func runRename(for pattern: String) {
    // Workaround for sed issue.
    let command = "LC_CTYPE=C LANG=C find . -type f -not -path '*/\\.git/*' -exec sed -i ''  -e \(pattern) {} +"
    writeText(command, to: "rename.sh")
    runProcess("bash rename.sh")
    runProcess("rm rename.sh")
}

/*
 Validate required tools are installed
 */
["bundler", "xcodegen", "carthage"].forEach { tool in
    let output = runProcess("which \(tool)")!
    if output.contains("not found") || output.isEmpty {
        printBold("\(tool) is not installed, please install it first!")
        exit(1)
    }
}

/*
 Gather user input
 */

printBold("Hello 👋")

print("Welcome in new project setup script. I will take you thought the whole proces.")
printBold("\n➡️  Provide app name(without spaces):")
var name = readLine(strippingNewline: true)!
printBold("\n➡️  Provide bundle id(follow template: com.netguru.projectName)")
var bundleId = readLine(strippingNewline: true)!
printBold("\nIt is required to generate new app via Neil. Here is the command to use:")
print("/bob neil run create_app \(bundleId) \(name)")

print("Would you like to open slack to send the command(send this command ^ in the conversation that will open)? [yes/no]")
var decission = readLine(strippingNewline: true)!
if decission == "yes" {
    runProcess("open https://netguru.slack.com/archives/CH1S66B9A")
}

print("\nNow you need to wait for iOS supporter, however, you can continue the setup here.")

print("\n❗ Using multiple frameworks inside the app supports modularization efforts since the begining of the project.")
print("Great story about modularization can be found here: \(bold("https://tech.justeattakeaway.com/2019/12/18/modular-ios-architecture-just-eat/"))")
print("\nWould you like to add one additional framework target?[yes/no]")
var setupFramework = readLine(strippingNewline: true)!.lowercased() == "yes"

/*
 Update template
 */
print("")

print("Fixing Configurations")
runProcess("mv Configurations/NetguruTemplateApp Configurations/\(name)")
runProcess("mv Configurations/\(name)/NetguruTemplateApp-Base.xcconfig Configurations/\(name)/\(name)-Base.xcconfig")
runProcess("mv Configurations/\(name)/NetguruTemplateApp-Debug.xcconfig Configurations/\(name)/\(name)-Debug.xcconfig")
runProcess("mv Configurations/\(name)/NetguruTemplateApp-Production.xcconfig Configurations/\(name)/\(name)-Production.xcconfig")
runProcess("mv Configurations/\(name)/NetguruTemplateApp-Staging.xcconfig Configurations/\(name)/\(name)-Staging.xcconfig")

let nameTests = "\(name)Tests"
runProcess("mv Configurations/NetguruTemplateAppTests Configurations/\(nameTests)")
runProcess("mv Configurations/\(nameTests)/NetguruTemplateAppTests-Base.xcconfig Configurations/\(nameTests)/\(nameTests)-Base.xcconfig")
runProcess("mv Configurations/\(nameTests)/NetguruTemplateAppTests-Debug.xcconfig Configurations/\(nameTests)/\(nameTests)-Debug.xcconfig")
runProcess("mv Configurations/\(nameTests)/NetguruTemplateAppTests-Production.xcconfig Configurations/\(nameTests)/\(nameTests)-Production.xcconfig")
runProcess("mv Configurations/\(nameTests)/NetguruTemplateAppTests-Staging.xcconfig Configurations/\(nameTests)/\(nameTests)-Staging.xcconfig")
print("✅")

print("Setting up the project using new name: \(name)")
runRename(for: "s/NetguruTemplateApp/\(name)/g")
print("✅")

print("Updating bundle id's with value: \(bundleId)")
let escapedBundleId = bundleId.replacingOccurrences(of: ".", with: "\\.")
runRename(for: "s/com\\.netguru\\.xcodegenDemo/\(escapedBundleId)/g")
print("✅")

if !setupFramework {
    print("Disabling additional framework 😥")
    // Update project.yml
    var projectYml = loadFile("project.yml")
    projectYml = projectYml.components(separatedBy: "CoreFramework:").first!

    let range1 = projectYml.range(of: "dependencies:")
    let range2 = projectYml.range(of: "scheme:")
    let result = projectYml[projectYml.startIndex..<range1!.lowerBound] + projectYml[range2!.lowerBound..<projectYml.endIndex]
    writeText(String(result), to: "project.yml")

    // Update Podfile
    let podfile = loadFile("Podfile")
    var podfileFinal = podfile.components(separatedBy: "target 'CoreFramework' do").first!
    podfileFinal += "plugin 'cocoapods-keys', {"
    podfileFinal += podfile.components(separatedBy: "plugin 'cocoapods-keys', {").last!
    writeText(podfileFinal, to: "Podfile")

    // remove configurations folder
    runProcess("rm -r Configurations/CoreFramework")
    // remove sources
    runProcess("rm -r CoreFramework")
    print("✅")
}

print("Running carthage")
runProcess("cp .env.sample .env")
runProcess("carthage bootstrap")
print("✅")

print("Running xcodegen")
runProcess("xcodegen generate")
print("✅")

print("Running Cocoapods")
runProcess("bundle install")
runProcess("bundle exec pod install")
print("✅")

print("Fixing header template")
runProcess("mkdir \(name).xcworkspace/xcshareddata")
runProcess("mv IDETemplateMacros.plist \(name).xcworkspace/xcshareddata/IDETemplateMacros.plist")
runProcess("git add \(name).xcworkspace/xcshareddata/IDETemplateMacros.plist -f")
print("✅")

print("Fixing readme")
var readme = loadFile("README.md")
let range = readme.range(of: "<!-- Readme")
readme = String(readme[range!.lowerBound..<readme.endIndex])
writeText(readme, to: "README.md")
print("✅")

print("Remove setup script")
runProcess("rm setupProject.swift")
print("✅")

print("Creating git commit")
runProcess("git add -A")
runProcess("git commit -m InitialSetup")
print("✅")

let hostname = runProcess("hostname")!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }
}

var semaphore = DispatchSemaphore(value: 0)
let params = "app_name=\(name.urlEncoded)&bundle_id=\(bundleId.urlEncoded)&hostname=\(hostname.urlEncoded)"
let urlString = "https://hooks.zapier.com/hooks/catch/4193197/bagq0s5/?\(params)"

var request = URLRequest(url: URL(string: urlString)!, timeoutInterval: 50)
request.httpMethod = "POST"

let task = URLSession.shared.dataTask(with: request) { data, _, error in
    guard let _ = data else {
        print("Statistical data not sent.")
        print(String(describing: error))
        semaphore.signal()
        return
    }
    print("Statistical data sent.")
    semaphore.signal()
}

task.resume()
semaphore.wait()

printBold("🎉 You are all set here. Follow the rest of the guide from confluence. 🎉")
printBold("Happy coding!")
