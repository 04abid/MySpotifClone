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
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let Controller = AuthController(viewModel: AuthViewModel(useCase: AuthManager(manager: CoreManager())))
        Controller.compleationHandler = { [weak self] succes in
            DispatchQueue.main.async {
                self?.handleSignIn(succes:succes)
            }
        }
        Controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.show(Controller, sender: nil)
    }
    
    private func handleSignIn(succes: Bool) {
        guard succes else {
            let alert = createAlert(title: "OOPS", message: "shomething went wrong")
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
            return
        }
        let controller = TabBarController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}
