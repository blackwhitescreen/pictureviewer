//
//  AppDelegate.swift
//  PictureViewer
//
//  Created by Anton Konev on 09.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createMainModule()
        window?.makeKeyAndVisible()
        return true
    }

    // Building main module from its components

    private func createMainModule() -> UINavigationController {
        let navigationController = UINavigationController()
        UINavigationBar.appearance().backgroundColor = .systemGray5
        let assemblyBuilder = MainModuleAssembly()
        let router = MainModuleRouter(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        router.rootVC()

        return navigationController
    }

}

