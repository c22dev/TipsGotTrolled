//
//  ContentView.swift
//  TipsGotTrolled
//
//  Created by haxi0 on 28.11.2023.
//

import SwiftUI
import MacDirtyCow


struct ContentView: View {
    @State private var installState = ""
    @AppStorage("patched") var patched = false
    
    var body: some View {
        NavigationView {
            Form {
                Button("Exploit") {
                    do {
                        try MacDirtyCow.unsandbox()
                        
                        patched.toggle()
                    } catch {
                        installState = "Error: \(error)"
                    }
                }
                Button("Change Tips") {
                    do {
                        try MacDirtyCow.overwriteFileWithDataImpl(originPath: getTipsPath()!, replacementData: Data(contentsOf: Bundle.main.url(forResource: "PersistenceHelper_Embedded", withExtension: "")!))
                        
                        installState = "Done"
                    } catch {
                        installState = "Error: \(error)"
                    }
                }.disabled(patched)
                Text(installState)
            }
            .navigationBarTitle(Text("TipsGotTrolled"), displayMode: .inline)
        }
    }
}
