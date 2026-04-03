//
//  LibraryController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.02.26.
//

import UIKit

class LibraryController: BaseController {

    private lazy var table: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        return table
    }()
    
    private var viewModel = LibraryViewModel()
    
    override func configureConstraint() {
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNotification()
    }
    
    override func configureViewModel() {
        FavoritesManager.shared.succes = { [weak self] in
            self?.table.reloadData()
        }
        FavoritesManager.shared.fetchData()
    }
    
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(musicLiked), name: .favoritesDidChange, object: nil)
    }
    
    @objc private func musicLiked() {
        table.reloadData()
    }
    
   @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension LibraryController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoritesManager.shared.likedMusics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        let music =  FavoritesManager.shared.likedMusics[indexPath.row]
        cell.configure(data: music)
        return cell
    }
}
