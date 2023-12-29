//
//  SceneDelegate.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import UIKit
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let appState = UserDefaultAppState(with: UserDefaults.standard)
        let apiClient = SevenWindsAPIClient(with: AF, token: appState.token)
        
        window = UIWindow(windowScene: scene)
        window?.backgroundColor = .white
        
        let loginHandler: (Credentials) -> () = { _ in
            let VC = UIViewController()
            VC.view.backgroundColor = .red
            self.window?.rootViewController = VC
        }
        
        window?.rootViewController = LoginRouter.createModule(loginHandler: loginHandler, apiClient: apiClient, credService: appState)
        window?.makeKeyAndVisible()
    }
}

