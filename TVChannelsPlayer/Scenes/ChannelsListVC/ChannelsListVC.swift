//
//  ChannelsListVC.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 12.06.2023.
//

import UIKit

protocol SearchInputable {
    var searchText: String { get }
    func searchTextDidChanged(to text: String)
}

class ChannelsListVC: UIViewController {
    
    // MARK: - Properties
    private let assosiatedTab: HomeScreenTabs
    
    private let favouritesManager: FavouriteChannelsInterface
    
    private var _searchText = "" {
        didSet {
            print("searchText", _searchText)
        }
    }
    
    private var array: [Channel] = [.mock, .mock]
        
    // MARK: - Views
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FavouriteStateListener method to start listen changes
        startListenFavouriteStatusChanges()
        //
        
        tableView.register(ChannelTableViewCell.nib,
                           forCellReuseIdentifier: ChannelTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupViews()
    }
    
    init(assosiatedTab: HomeScreenTabs, favouritesManager: FavouriteChannelsInterface) {
        self.assosiatedTab = assosiatedTab
        self.favouritesManager = favouritesManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = Size.channelRowHeight
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TabBarDataSourse
extension ChannelsListVC: TabBarDataSourse {
    func configureTabCell(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.reuseIdentifier,
                                                            for: indexPath) as? TabBarCell
                                                            else { return UICollectionViewCell() }
        cell.setTitle(assosiatedTab.title)
        return cell
    }
    
    func registerCell(for collectionView: UICollectionView) {
        collectionView.register(TabBarCell.self, forCellWithReuseIdentifier: TabBarCell.reuseIdentifier)
    }
}

// MARK: - SearchInputable
extension ChannelsListVC: SearchInputable {
    var searchText: String { _searchText }
    
    func searchTextDidChanged(to text: String) {
        _searchText = text
    }
    
    var tabType: HomeScreenTabs { assosiatedTab }
}

// MARK: - UITableViewDelegate
extension ChannelsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("\(indexPath)")
    }
}

// MARK: - UITableViewDataSource
extension ChannelsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.reuseIdentifier,
                                                     for: indexPath) as? ChannelTableViewCell
        else { return UITableViewCell() }
        
        let channel = array[indexPath.row]
        cell.channel = channel
        
        cell.isFavourite = favouritesManager.isInFavourites(channel.id)
        cell.favouriteTapHandler = { [unowned self] channel, isFavourite in
            self.favouritesManager.setFavouriteState(by: channel.id, isFavourite: isFavourite)
        }
        cell.updateFavouriteButton()
        return cell
    }
}

// MARK: - FavouriteStateListener
extension ChannelsListVC: FavouriteStateListener {
    func updateChannelsStatus() {
        tableView.reloadData()
    }
}
