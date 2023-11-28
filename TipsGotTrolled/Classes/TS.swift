//
//  GetTipsPath.swift
//  TipsGotTrolled
//
//  Created by haxi0 on 28.11.2023.
//

import Foundation
import UIKit

class TS {
    static var shared = TS()
    
    func searchForTips(in directoryPath: String) -> String? {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
            
            for item in contents {
                let fullPath = (directoryPath as NSString).appendingPathComponent(item)
                
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirectory), isDirectory.boolValue {
                    if let result = searchForTips(in: fullPath) {
                        return result
                    }
                } else if item == "Tips" {
                    return fullPath
                }
            }
        } catch {
            UIApplication.shared.alert(title: "Error", body: "Error: \(error)")
        }
        
        return nil
    }
    
    func getTipsPath(in directoryPath: String = "/var/containers/Bundle/Application/") -> String? {
        if let tipsPath = searchForTips(in: directoryPath) {
            return tipsPath
        } else {
            UIApplication.shared.alert(title: "Error", body: "Tips executable not found in the specified directory or its subdirectories. Is the app installed?")
            return nil
        }
    }
    func getTipsDocs(in directoryPath: String = "/var/mobile/Containers/Data/Application") -> String? {
        if let tipsPath = searchForTips(in: directoryPath) {
            return tipsPath
        } else {
            UIApplication.shared.alert(title: "Error", body: "Tips executable not found in the specified directory or its subdirectories. Is the app installed?")
            return nil
        }
    }
    
    func isiOSVersionInRange() -> Bool {
        let systemVersion = UIDevice.current.systemVersion
        let versionComponents = systemVersion.split(separator: ".").compactMap { Int($0) }
        
        if versionComponents.count >= 2 {
            let majorVersion = versionComponents[0]
            let minorVersion = versionComponents[1]
            
            if majorVersion == 16 && minorVersion >= 0 && minorVersion <= 1 {
                return true
            }
        }
        
        return false
    }
}
