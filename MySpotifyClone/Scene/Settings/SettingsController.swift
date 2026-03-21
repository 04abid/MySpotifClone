//
//  SettingsController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import UIKit

class SettingsController: BaseController {
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private var viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureSections()
    }
    
    private func setupUI() {
        view.addSubview(table)
        title = "Settings"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    private func configureSections() {
        let profileOption = Options(title: "View Your Profile", handler: {
            self.viewYourProfile()
        })
        
        let signOutOption = Options(title: "Sign Out", handler: {
            self.signOut()
        })
        
        let profileSection = Section(title: "Profile", option: [profileOption])
        let accountSection = Section(title: "Account", option: [signOutOption])
        
        viewModel.addSection(profileSection)
        viewModel.addSection(accountSection)
    }
    
    private func viewYourProfile() {
        let controller = ProfileController(viewModel: ProfileViewModel(useCase: ProfileManager(tokenManager: TokenRefreshManager.shared)))
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.show(controller, sender: nil)
    }
    
    private func signOut() {
        
    }
}


extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].option.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let option = viewModel.sections[indexPath.section].option[indexPath.row]
        cell.textLabel?.text = option.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = viewModel.sections[indexPath.section].option[indexPath.row]
        option.handler()
    }
}
