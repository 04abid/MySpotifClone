//
//  LibraryController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.02.26.
//

import UIKit

protocol LibraryControllerDelegate: AnyObject {
    func sendData(musicID: Track)
}

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
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        headerView.backgroundColor = .black
        let label = UILabel()
        label.text = "liked Musics"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }()
    
    private var viewModel = LibraryViewModel()
    weak var delegate: LibraryControllerDelegate?
    
    override func configureConstraint() {
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        table.tableHeaderView = headerView
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let music = FavoritesManager.shared.likedMusics[indexPath.row]
        delegate?.sendData(musicID: music)
    }
    
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let music = FavoritesManager.shared.likedMusics[indexPath.row]
            FavoritesManager.shared.toggleLike(music: music)
        }
    }
}
