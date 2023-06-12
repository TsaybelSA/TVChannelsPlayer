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
    init(assosiatedTab: HomeScreenTabs) {
        self.assosiatedTab = assosiatedTab
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let assosiatedTab: HomeScreenTabs
    
    private var _searchText = "" {
        didSet {
            print("searchText", _searchText)
        }
    }
        
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.mainBackgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

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

extension ChannelsListVC: SearchInputable {
    var searchText: String { _searchText }
    
    func searchTextDidChanged(to text: String) {
        _searchText = text
    }
    
    var tabType: HomeScreenTabs { assosiatedTab }
}
