//
//  ContentView.swift
//  TipsGotTrolled
//
//  Created by haxi0 on 28.11.2023.
//

import SwiftUI
import MacDirtyCow
import AbsoluteSolver

struct ContentView: View {
    @State private var installState = ""
    
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
                Button("Change Tips") {
                    do {
                        if let tipsURL = try getTipsURL(), let fileData = getDataFromBundleFile(folderName: "Binary", fileName: "PersistenceHelper_Embedded") {
                            try AbsoluteSolver.replace(at: tipsURL, with: fileData as NSData)
                            print("Replacement completed.")
                        } else {
                            print("Unable to perform replacement.")
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
                Text(installState)
            }
            .navigationBarTitle(Text("TipsGotTrolled"), displayMode: .inline)
        }
    }
}
