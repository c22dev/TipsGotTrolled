//
//  ContentView.swift
//  TipsGotTrolled
//
//  Created by haxi0 on 28.11.2023.
//

import SwiftUI
import MacDirtyCow

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Button("Xploit") {
                    do {
                        try MacDirtyCow.unsandbox()
                    } catch {
                        print("errora")
                    }
                }
                Button("Troll Tips") {
                    // Example usage
                    if let tipsPath = getTipsPath() {
                        print("Tips Executable Path: \(tipsPath)")
                    } else {
                        print("Tips executable not found in the specified directory or its subdirectories.")
                    }
                }
            }
            .navigationBarTitle(Text("TipsGotTrolled"), displayMode: .inline)
        }
    }
}
