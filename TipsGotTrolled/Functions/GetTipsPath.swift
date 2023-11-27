//
//  GetTipsPath.swift
//  TipsGotTrolled
//
//  Created by haxi0 on 28.11.2023.
//

import Foundation

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
        print("Error: \(error)")
    }

    return nil
}

func getTipsPath(in directoryPath: String = "/var/containers/Bundle/Application/") -> String? {
    if let tipsPath = searchForTips(in: directoryPath) {
        return tipsPath
    } else {
        print("Tips executable not found in the specified directory or its subdirectories.")
        return nil
    }
}


