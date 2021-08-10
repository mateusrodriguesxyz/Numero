#!/usr/bin/env swift

import Foundation

// MARK: - CodeCoverage
struct CodeCoverage: Codable {
    let coveredLines: Int
    let lineCoverage: Double
    let targets: [Target]
    let executableLines: Int
}

// MARK: - Target
struct Target: Codable {
    let coveredLines: Int
    let lineCoverage: Double
    let files: [File]
    let name: String
    let executableLines: Int
    let buildProductPath: String
}

// MARK: - File
struct File: Codable {
    let coveredLines: Int
    let lineCoverage: Double
    let path: String
    let functions: [Function]
    let name: String
    let executableLines: Int
}

// MARK: - Function
struct Function: Codable {
    let coveredLines: Int
    let lineCoverage: Double
    let lineNumber, executionCount: Int
    let name: String
    let executableLines: Int
}


@discardableResult
func shell(_ args: String...) -> Data? {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    
    let pipe = Pipe()
    task.standardOutput = pipe
    
    task.launch()
    task.waitUntilExit()
 
    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    return data
}

do {
        
    let files = try FileManager.default.contentsOfDirectory(atPath: "Build/Logs/Test")

    if let result = files.first(where: { $0.hasSuffix("xcresult") }) {
        if let data = shell("xcrun", "xccov", "view", "--report", "--json",  "Build/Logs/Test/\(result)") {
            let coverage = try JSONDecoder().decode(CodeCoverage.self, from: data)
            print("::set-output name=lineRate::\(coverage.lineCoverage)")
        }
    }

    
} catch {
    print(error)
}


