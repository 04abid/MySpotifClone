//
//  SearchResultsController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.03.26.
//

import UIKit

protocol SearchMusicDelegate {
    func searchMusicTapped(trackID:Track)
}

class SearchResultsController: BaseController {

    private lazy var table: UITableView = {
       let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        table.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        table.backgroundColor = .black
        return table
    }()
    
    var searchData: Search?
    
    var delegate: SearchMusicDelegate?
    
    var viewModel = SearchViewModel(useCase: SearchManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func updateSearch(data: Search) {
        self.searchData = data
        print("Tracks: \(data.searchTracks?.items.count ?? 0)")
        print("Artists: \(data.searchArtists?.items.count ?? 0)")
        print("Albums: \(data.searchAlbums?.items.count ?? 0)")
        table.reloadData()
    }
}

extension SearchResultsController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SearchSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black
        let label = UILabel()
        label.text = SearchSection(rawValue: section)?.title
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = searchData,
                 let sectionType = SearchSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .tracks: return data.searchTracks?.items.count ?? 0
        case .albums: return data.searchAlbums?.items.count ?? 0
        case .artists: return data.searchArtists?.items.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        guard let data = searchData,
              let sectionType = SearchSection(rawValue: indexPath.section) else { return cell }
        
        switch sectionType {
        case .tracks:
            guard  let tracks = data.searchTracks?.items[indexPath.row] else {return cell}
            cell.configure(data: tracks)
        case .artists:
            guard let artist = data.searchArtists?.items[indexPath.row] else {return cell}
            cell.configure(data: artist)
        case .albums:
            guard let album = data.searchAlbums?.items[indexPath.row] else {return cell}
            cell.configure(data: album)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = searchData,
              let sectionType = SearchSection(rawValue: indexPath.section) else {return}
        
        switch sectionType {
            
        case .tracks:
            guard let track = data.searchTracks?.items[indexPath.row] else {return}
            delegate?.searchMusicTapped(trackID: track)
        case .albums:
            print("salam")
        case .artists:
            print("salam")
        }
    }
}
