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
    @State private var exploited = false
    @AppStorage("patched") var patched = false
    let ts = TS.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button("Exploit") {
                        do {
                            try MacDirtyCow.unsandbox()
                            
                            exploited = true
                        } catch {
                            UIApplication.shared.alert(title: "Error", body: "Error: \(error)")
                        }
                    }.disabled(!ts.isiOSVersionInRange())
                        .disabled(patched)
                    
                    Button("Change Tips") {
                        do {
                            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                            
                            if FileManager.default.fileExists(atPath: documentsDirectoryURL!.path().appending("Tips")) {
                                try AbsoluteSolver.delete(at: documentsDirectoryURL!.appendingPathComponent("Tips"))
                            }
                            
                            try AbsoluteSolver.copy(at: URL(fileURLWithPath: ts.getTipsPath()!), to: documentsDirectoryURL!.appendingPathComponent("Tips")) // backup previous binary just in case
                            try MacDirtyCow.overwriteFileWithDataImpl(originPath: ts.getTipsPath()!, replacementData: Data(contentsOf: Bundle.main.url(forResource: "PersistenceHelper_Embedded", withExtension: "")!))
                            
                            patched = true
                            
                            UIApplication.shared.alert(title: "Done, READ!!!", body: "⚠️ PLEASE, DO NOT LAUNCH TIPS AFTER INSTALLATION. REBOOT RIGHT NOW, THEN LAUNCH IT! DO NOT RUN Change Tips AGAIN UNLESS YOU UNINSTALLED EVERYTHING! OTHERWISE YOU MIGHT GET A SEMI-BOOTLOOP (BASED ON HAXI0'S EXPERIENCE!). AFTER TROLLSTORE IS INSTALLED AND EVERYTHING IS WORKING, YOU MAY DELETE THIS APP. ⚠️", withButton: false)
                        } catch {
                            UIApplication.shared.alert(title: "Error", body: "Error: \(error)")
                        }
                    }.disabled(!exploited)
                        .disabled(patched)
                } header: {
                    Label("Hijack Tips", systemImage: "hammer")
                } footer: {
                    Text("Made by C22 and haxi0 with sweat and tears. TrollStore by opa334, method by Alfie.")
                }
            }
            .navigationBarTitle(Text("TipsGotTrolled"), displayMode: .inline)
        }
    }
}
