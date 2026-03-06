//
//  HomeController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.02.26.
//

import UIKit

protocol HomeControllerDelegate {
    func showProfile()
    func didTapSeeAll(section: HomeSection)
    func didTapTrack(track:Track)
    func didTapAlbum(album:Album)
   }

class HomeController: BaseController {
    private lazy var profilePicture: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.width / 2
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePictureTapped))
        image.addGestureRecognizer(tap)
        return image
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout {sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collection = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.delegate = self
        collection.dataSource = self
        collection.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
        collection.register(LargeCardCell.self, forCellWithReuseIdentifier: LargeCardCell.identifier)
        collection.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.indentifier)
        return collection
        
    }()
    
    private lazy var profileHeaderView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
//    private let profileViewModel = ProfileViewModel(useCase: ProfileManager(manager: CoreManager(), tokenProvider: KeychainManager(), authManager: AuthManager(manager: CoreManager())))
    
    private let profileViewModel = ProfileViewModel(useCase: ProfileManager(tokenManager: .init(manager: CoreManager(),  authManager: AuthManager(manager: CoreManager()))))
    
    private let homeViewModel = HomeViewModel(manager: HomeManager(manager: TokenRefreshManager(manager: CoreManager(), authManager: AuthManager(manager: CoreManager()))))
    
    private var selectedFilterIndex = 0
    
    var delegate: HomeControllerDelegate?
    
    // MARK: RefreshControl
    
    private func refresh() {
        let refreshControl = UIRefreshControl()
         refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collection.refreshControl = refreshControl
    }
    
    
    @objc func refreshData() {
        homeViewModel.getBrowseData()
    }

    
// MARK: configure Profile Header
    private func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterTapped(_ sender: UIButton) {
        selectedFilterIndex = sender.tag
        updateFilterButtons()
        collection.reloadData()
    }
    
    private func updateFilterButtons() {
        for case let button as UIButton in stack.arrangedSubviews {
            if button.tag == selectedFilterIndex {
                button.backgroundColor = UIColor(red: 29/255, green: 185/255, blue: 84/255, alpha: 1) // yaşıl
                button.setTitleColor(.black, for: .normal)
            } else {
                button.backgroundColor = UIColor(white: 0.2, alpha: 1) // tünd boz
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    private func configureStack() {
        let allButton = createButton(title: "Tümü", tag: 0)
        let musicButton = createButton(title: "Müzik", tag: 1)
        let podcastButton = createButton(title: "Podcast", tag: 2)

        stack.addArrangedSubview(allButton)
        stack.addArrangedSubview(musicButton)
        stack.addArrangedSubview(podcastButton)

        profileHeaderView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20)
        ])
    }

    private func configure(data:UserProfile) {
        profilePicture.loadImage(data: data.images?.first?.url ?? "")
    }
    
    @objc func profilePictureTapped() {
        delegate?.showProfile()
    }
    
//  -----------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileHeaderView.frame = CGRect(x: 0, y: Int(view.safeAreaInsets.top) - 45, width: Int(view.width), height: 80)
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        
        view.addSubview(collection)
        collection.frame = CGRect(x: 0, y: profileHeaderView.frame.maxY, width: view.frame.width, height: view.frame.height)
    }
    
    override func configureUI() {
        title = "Home"
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .always
        updateFilterButtons()
        refresh()
    }
    
    
    override func configureConstraint() {
        view.addSubview(profileHeaderView)
        profileHeaderView.addSubview(profilePicture)
        configureStack()
        NSLayoutConstraint.activate([
            profilePicture.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor,constant: 12),
            profilePicture.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 40),
            profilePicture.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    //MARK: ViewModel Configuration
    
    override func configureViewModel() {
        configureProfileViewModel()
        configureHomeViewModel()
    }

    private func configureProfileViewModel() {
        profileViewModel.succes = { [weak self] in
            if let profile = self?.profileViewModel.profile {
                self?.configure(data: profile)
            }
        }
        profileViewModel.failure = { errorMessage in
            DispatchQueue.main.async {
                print("XETA: \(errorMessage)")
            }
        }
        profileViewModel.getProfileData()
    }
    
    private func configureHomeViewModel() {
        homeViewModel.succes = { [weak self]  in
            print("recentlyPlayed: \(self?.homeViewModel.recentlyPlayed.count ?? 0)")
            print("topTracks: \(self?.homeViewModel.topTracks.count ?? 0)")
            print("savedAlbums: \(self?.homeViewModel.savedAlbums.count ?? 0)")
            self?.collection.reloadData()
            self?.collection.refreshControl?.endRefreshing()
        }
       
        homeViewModel.error = { error in
            print("XETA: \(error)")
        }
        
        homeViewModel.getBrowseData()
    }
}

//MARK: CollectionView Configuration

extension HomeController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if selectedFilterIndex == 2 {
            return 0
        }
        return HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = HomeSection(rawValue: section)
        switch section {
        case .recentlyPlayed:
            return homeViewModel.recentlyPlayed.count
        case .savedAlbums:
            return homeViewModel.savedAlbums.count
        case .topTracks:
            return homeViewModel.topTracks.count
        default:
            return homeViewModel.recentlyPlayed.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = HomeSection(rawValue: indexPath.section)
        switch section {
        case .recentlyPlayed:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.identifier, for: indexPath) as! GridCell
            let data = homeViewModel.recentlyPlayed[indexPath.item]
            cell.configure(image: data.track.album.images.first?.url ?? "" ,
                           label: data.track.name)
            return cell
        case .savedAlbums:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCardCell.identifier, for: indexPath) as! LargeCardCell
            let data = homeViewModel.savedAlbums[indexPath.item]
            cell.configure(
                    image: data.album.images.first?.url ?? "",
                    title: data.album.name,
                    subtitle: data.album.artists.first?.name ?? ""
                )
            return cell
        case .topTracks:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCardCell.identifier, for: indexPath) as! LargeCardCell
            let data = homeViewModel.topTracks[indexPath.item]
            cell.configure(
                    image: data.album.images.first?.url ?? "",
                    title: data.name,
                    subtitle: data.artists.first?.name ?? "")
            
            return cell
            
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.identifier, for: indexPath)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else { return }
        switch section {
        case .recentlyPlayed:
            let track = homeViewModel.recentlyPlayed[indexPath.item].track
            delegate?.didTapTrack(track: track)
        case .topTracks:
            let track = homeViewModel.topTracks[indexPath.item]
            delegate?.didTapTrack(track: track)
        case .savedAlbums:
            let album = homeViewModel.savedAlbums[indexPath.item].album
            delegate?.didTapAlbum(album: album)
        }
    }
    
    //MARK: SectionHeader
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.indentifier, for: indexPath) as! SectionHeader
        
        let section = HomeSection(rawValue: indexPath.section)
        switch section {
        case .recentlyPlayed:
            header.configure(title: "Recently Played")
        case .savedAlbums:
            header.configure(title: "Your Albums")
        case .topTracks:
            header.configure(title: "Your Top Tracks")
        default:
            header.configure(title: "")
        }
        
        header.seeAllTapped = { [weak self] in
            guard let section = section else { return }
            self?.delegate?.didTapSeeAll(section: section)
        }
        
        return header
    }
    
    
    
    // MARK: CompositionLayout Configuration
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let section = HomeSection(rawValue: sectionIndex)
        switch section {
        case .recentlyPlayed:
            return createGridSection()
        case .savedAlbums:
            return createHorizontalSection()
        case .topTracks:
            return createHorizontalSection()
        default:
            return createHorizontalSection()
        }
    }
    
    private func createGridSection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension:.absolute(70)), subitems: [item],)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        // Add header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(180),
                                                            heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(180),
                                                                         heightDimension:.absolute(280)), subitems: [item],)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        // Add header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
