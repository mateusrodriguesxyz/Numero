// print("::set-output name=lineRate::0.8")

import Foundation

do {
        
    let files = try FileManager.default.contentsOfDirectory(atPath: "Build/Logs/Test")

    if let result = files.first(where: { $0.hasSuffix("xcresult") }) {
        let url = URL(fileURLWithPath: "Build/Logs/Test/\(result)")
        let data = try Data(contentsOf: url)
        print(data)
    }
    
} catch {
    print(error)
}

