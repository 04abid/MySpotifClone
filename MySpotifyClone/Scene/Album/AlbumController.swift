//
//  AlbumController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import UIKit

protocol AlbumControllerDelegate {
    func albumDetaiTapped(track:Track)
}

class AlbumController: BaseController {
    
    private lazy var table: UITableView = {
       let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .black
        table.register(AlbumDetailCell.self, forCellReuseIdentifier: AlbumDetailCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    var delegate: AlbumControllerDelegate?
    
    private let viewModel: AlbumViewModel
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureViewModel() {
        viewModel.succes = { [weak self] in
            print("data geldi")
            self?.table.reloadData()
        }
    }
    override func configureConstraint() {
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    override func configureUI() {
        let headerView = AlbumHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 320))
        headerView.configure(data: viewModel.album)
        table.tableHeaderView = headerView
        viewModel.getAlbumDetail()
    }
    
}
extension AlbumController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albumDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumDetailCell.identifier) as! AlbumDetailCell
        let track = viewModel.albumDetail[indexPath.row]
        cell.configure(track: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.albumDetaiTapped(track: viewModel.getTrack(at: indexPath.row))
    }
}
