//
//  SceneDelegate.swift
//  CombineMultipleRequests
//
//  Created by Artem Ekimov on 3/9/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = JokesViewController()
        window?.makeKeyAndVisible()
    }
}

