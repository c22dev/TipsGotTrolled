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
    // init console base text
    @State var LogItems: [String.SubSequence] = {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let isVersionInRange = TS.shared.isiOSVersionInRange()

            if isVersionInRange {
                return ["Welcome to TipsGotTrolled v\(version)!", "", "Your device is supported.", "", "Please press Exploit, allow, then Change Tips", "", "by haxi0 and C22"]
            } else {
                return ["Welcome to TipsGotTrolled v\(version)!", "", "Your device is not supported.", "iOS 15.4->15.7.1 or 16.0->16.1.2", "", "by haxi0 and C22"]
            }
        } else {
            return ["Error getting app version!"]
        }
    }()
    @State var debugMode = true
    @State private var exploited = false
    @AppStorage("patched") var patched = false
    let ts = TS.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // exploit button to get r/w on mdc
                    Button("Exploit") {
                        do {
                            try MacDirtyCow.unsandbox()
                            exploited = true
                            UIApplication.shared.alert(title: "DirtyCow exploit completed", body: "MacDirtyCow full disk access was ran. Please press the Change Tips button to continue.")
                        } catch {
                            UIApplication.shared.alert(title: "Error", body: "Error: \(error)")
                        }
                    }.disabled(!ts.isiOSVersionInRange())
                    // change tips app with absolute solver and things
                    Button("Change Tips") {
                        do {
                            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                            let flagFilePath = "\(ts.getTipsDoc(in: URL(fileURLWithPath:"/var/mobile/Containers/Data/Application/"))!)/_trolled"
                            if FileManager.default.fileExists(atPath: flagFilePath) {
                                UIApplication.shared.alert(title: "Please delete Tips app then reinstall it before proceeding", body: "⚠️ It looks like your Tips app have been tweaked. Please, delete it from Home Screen and reinstall it from the App Store. A reboot is recommended after reinstalling the Tips app.⚠️", withButton: false)
                                return
                            }
                            if FileManager.default.fileExists(atPath: documentsDirectoryURL!.appendingPathComponent("Tips").path) {
                                do {
                                    try AbsoluteSolver.delete(at: documentsDirectoryURL!.appendingPathComponent("Tips"))
                                } catch {
                                    UIApplication.shared.alert(title: "Error", body: "Error: \(error)")
                                }
                            }

                            
                            try AbsoluteSolver.copy(at: URL(fileURLWithPath: ts.getTipsPath()!), to: documentsDirectoryURL!.appendingPathComponent("Tips")) // backup previous binary just in case
                            try MacDirtyCow.overwriteFileWithDataImpl(originPath: ts.getTipsPath()!, replacementData: Data(contentsOf: Bundle.main.url(forResource: "PersistenceHelper_Embedded", withExtension: "")!))
                            
                            FileManager.default.createFile(atPath: flagFilePath, contents: nil, attributes: nil)
                            
                            UIApplication.shared.alert(title: "Done, READ!!!", body: "⚠️ PLEASE, DO NOT LAUNCH TIPS AFTER INSTALLATION. REBOOT RIGHT NOW, THEN LAUNCH IT! DO NOT RUN Change Tips AGAIN UNLESS YOU UNINSTALLED EVERYTHING! OTHERWISE YOU MIGHT GET A SEMI-BOOTLOOP (BASED ON HAXI0'S EXPERIENCE!). AFTER TROLLSTORE IS INSTALLED AND EVERYTHING IS WORKING, YOU MAY DELETE THIS APP. ⚠️", withButton: false)
                        } catch {
                            UIApplication.shared.alert(title: "Error", body: "Error: \(error)")
                        }
                    }.disabled(!ts.isiOSVersionInRange())
                } header: {
                    Label("Hijack Tips", systemImage: "hammer")
                }
                Section {
                    HStack {
                        ScrollView {
                            ScrollViewReader { scroll in
                                VStack(alignment: .leading) {
                                    ForEach(0..<LogItems.count, id: \.self) { LogItem in
                                        Text("\(String(LogItems[LogItem]))")
                                            .textSelection(.enabled)
                                            .font(.custom("Menlo", size: 15))
                                    }
                                }
                                .onReceive(NotificationCenter.default.publisher(for: LogStream.shared.reloadNotification)) { obj in
                                    DispatchQueue.global(qos: .utility).async {
                                        FetchLog()
                                        scroll.scrollTo(LogItems.count - 1)
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 80, height: 250)
                    }
                    .padding()
                }
                header: {
                    Label("Console", systemImage: "bolt")
                }
                footer: {
                    Text("Made by C22 and haxi0 with sweat and tears. TrollStore by opa334, method by Alfie. M1 and M2 are also supported.")
                }
            }
            .navigationBarTitle(Text("TipsGotTrolled"), displayMode: .inline)
        }
    }
    func FetchLog() {
        guard let AttributedText = LogStream.shared.outputString.copy() as? NSAttributedString else {
            LogItems = ["Error Getting Log!"]
            return
        }
        LogItems = AttributedText.string.split(separator: "\n")
    }
}
