//
//  SceneDelegate.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 20.02.26.
//


import UIKit
import SpotifyiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let manager = AuthManager.shared
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }        
        window = UIWindow(windowScene: windowScene)
    
        if manager.isSignedIn {
            AuthManager.shared.loadCredentials { succes in
                DispatchQueue.main.async {
                    if succes {
                        let navigationController = UINavigationController()
                        self.appCoordinator = AppCoordinator(navigationController: navigationController)
                        self.appCoordinator?.start()
                        self.window?.rootViewController = navigationController
                    } else {
                        let navVC = UINavigationController(rootViewController: WelcomeController())
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        self.window?.rootViewController = navVC
                    }
                }
            }
        } else {
            let navVC = UINavigationController(rootViewController: WelcomeController())
            navVC.navigationBar.prefersLargeTitles = true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window?.rootViewController = navVC
        }
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        let parameters = SpotifyPlayBackManager.shared.appRemote.authorizationParameters(from: url)
        if let token = parameters?[SPTAppRemoteAccessTokenKey] {
            KeychainManager.shared.save(token, forKey: "spotify_remote_token")
            SpotifyPlayBackManager.shared.appRemote.connectionParameters.accessToken = token
            SpotifyPlayBackManager.shared.appRemote.connect()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        SpotifyPlayBackManager.shared.connect()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if SpotifyPlayBackManager.shared.appRemote.isConnected {
            SpotifyPlayBackManager.shared.appRemote.disconnect()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
