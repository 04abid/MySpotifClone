//
//  ProfileController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import UIKit

class ProfileController: BaseController {
    private lazy var table: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private let profileHeaderView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let profilePicture: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let viewModel: ProfileViewModel
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureViewModel()
        viewModel.getProfileData()
    }
    
    private func setupUI() {
        view.addSubview(table)
        profileHeaderView.addSubview(profilePicture)
        table.tableHeaderView = profileHeaderView
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            profilePicture.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor),
            profilePicture.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 200),
            profilePicture.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    override func configureViewModel() {
        viewModel.succes = { [weak self] in
            DispatchQueue.main.async {
//                print("PROFIL: \(String(describing: self?.viewModel.profileItems))")
                self?.table.reloadData()
                if let profile = self?.viewModel.profile {
                    self?.configure(info: profile)
                }
            }
        }
        
        viewModel.failure = { errorMessage in
            DispatchQueue.main.async {
                print("XETA: \(errorMessage)")
            }
        }
    }
    
    private func configure(info:UserProfile) {
        profilePicture.loadImage(data: info.images?.first?.url ?? "")
    }
}

// MARK: table view configuration

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let items = viewModel.profileItems[indexPath.row]
        cell.textLabel?.text = items.title
        cell.detailTextLabel?.text = items.value
        return cell
    }
}
