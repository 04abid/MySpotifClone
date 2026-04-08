//
//  WelcomeController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.02.26.
//

import UIKit

class WelcomeController: BaseController {
    private lazy var button: UIButton = {
       let button = UIButton()
        button.setTitle("Sign in with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthManager.shared.loadCredentials {  [weak self] succes in
            if succes {
                DispatchQueue.main.async {
                    self?.button.isEnabled = true
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to load credentials")
                }
            }
        }
    }
    
    override func configureUI() {
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = .init(x: 20,
                             y: view.height - 50 - view.safeAreaInsets.bottom,
                             width: view.width - 40,
                             height: 50)
        
        button.layer.cornerRadius = 12
    }
    

    @objc func buttonTapped() {
        let controller = AuthController(viewModel: AuthViewModel(useCase: AuthManager.shared))
        
//        controller.compleationHandler = { [weak self] succes in
//            DispatchQueue.main.async {
//                self?.handleSignIn(succes:succes)
//            }
        
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.show(controller, sender: nil)
    }
    
//    private func handleSignIn(succes: Bool) {
//        guard succes else {
//            let alert = createAlert(title: "OOPS", message: "shomething went wrong")
//            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//            present(alert, animated: true)
//            return
//        }
////        guard let navController = navigationController else { return }
////        let coordinator = AppCoordinator(navigationController: navController)
////        guard let window = self.view.window else {return}
////        coordinator.start()
////        window.rootViewController = navController
//    }
}
