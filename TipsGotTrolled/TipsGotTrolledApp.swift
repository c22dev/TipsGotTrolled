//
//  TipsGotTrolledApp.swift
//  TipsGotTrolled
//
//  Created by haxi0 on 28.11.2023.
//

import SwiftUI

@main
struct TipsGotTrolledApp: App {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    var body: some Scene {
        WindowGroup {
            ContentView()
            // when content view is loaded let's say user to delete Tips
            .onAppear {
                if isFirstLaunch == true {
                    UIApplication.shared.alert(title: "Please delete Tips app then (re)install it before proceeding", body: "Hi ! It looks like it's the first time you come here. To avoid any corruption, please delete Tips app from Home Screen then reinstall it. Thanks for using this tool!", withButton: true)
                    isFirstLaunch = false
                }
                // is persistance in bundle ?
                // useless but we never know, else QUIT THE APP RAHAHAHAH
                if let url = Bundle.main.url(forResource: "PersistenceHelper_Embedded", withExtension: nil) {
                    let filePath = url.path
                    
                    if FileManager.default.fileExists(atPath: filePath) {
                        print("persistence binary found in bundle (good!)")
                    }
                }
                else {
                    exit(0)
                }
            }
        }
    }
}

var currentUIAlertController: UIAlertController?

extension UIApplication {
    func dismissAlert(animated: Bool) {
        DispatchQueue.main.async {
            currentUIAlertController?.dismiss(animated: animated)
        }
    }
    func alert(title: String, body: String, animated: Bool = true, withButton: Bool = true) {
        DispatchQueue.main.async {
            currentUIAlertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
            if withButton { currentUIAlertController?.addAction(.init(title: "OK", style: .cancel)) }
            self.present(alert: currentUIAlertController!)
        }
    }
    func confirmAlert(title: String, body: String, onOK: @escaping () -> (), noCancel: Bool) {
        DispatchQueue.main.async {
            currentUIAlertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
            if !noCancel {
                currentUIAlertController?.addAction(.init(title: "Cancel", style: .cancel))
            }
            currentUIAlertController?.addAction(.init(title: "OK", style: noCancel ? .cancel : .default, handler: { _ in
                onOK()
            }))
            self.present(alert: currentUIAlertController!)
        }
    }
    func change(title: String, body: String) {
        DispatchQueue.main.async {
            currentUIAlertController?.title = title
            currentUIAlertController?.message = body
        }
    }
    
    func present(alert: UIAlertController) {
        if var topController = self.windows[0].rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alert, animated: true)
            // topController should now be your topmost view controller
        }
    }
}
