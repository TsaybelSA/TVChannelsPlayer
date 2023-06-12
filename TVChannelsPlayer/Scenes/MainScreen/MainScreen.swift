//
//  ChannelsListVC.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 10.06.2023.
//

import UIKit

enum HomeScreenTabs: String, CaseIterable {
    case all, favourites
    
    var title: String { "k\(self.rawValue.capitalized)".localized }
    
    var assosiatedViewController: UIViewController {
        ChannelsListVC(assosiatedTab: self)
    }
}

class MainScreen: TabBarContainerViewController {
    
    @IBOutlet private weak var tabItemsCollection: UICollectionView! {
        didSet { tabsCollectionView = tabItemsCollection }
    }
    
    @IBOutlet private weak var containerView: UIScrollView! {
        didSet { scrollView = containerView }
    }
        
    @IBOutlet private weak var searchBar: UISearchBar!
        
    var searchInputControllers: [SearchInputable] {
        viewControllers.compactMap({ $0 as? SearchInputable})
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "kWriteChannelName".localized
        
        addEmptySpaceGesture()
        setupSearchBar()
        setupTabBar()
    }
    
    private func setupSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
    }
    
    private func setupTabBar() {
        tabItemsCollection.register(TabBarCell.self, forCellWithReuseIdentifier: TabBarCell.reuseIdentifier)
        self.indicatorHeight = 3
        self.selectedIndicatorColor = #colorLiteral(red: 0, green: 0.5592524409, blue: 1, alpha: 1)
        self.indicatorAdditionWidth = 15
        
        let tabs = HomeScreenTabs.allCases
        self.setupTabBar(viewControllers: tabs.map({ $0.assosiatedViewController }))
        
        self.minimumInteritemSpacing = 10
        self.moveTo(page: 0)
    }
    
    private func addEmptySpaceGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                            action: #selector(stopSearchTextEditing))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - SearchBar resignFirstResponder
    @objc
    private func stopSearchTextEditing() {
        searchBar.resignFirstResponder()
    }
    
    override func moveTo(page: Int, animated: Bool = true) {
        super.moveTo(page: page, animated: animated)
        
        stopSearchTextEditing()
    }
    
    override func currentTabDidChanged() {
        guard let controllerWithSearch = searchInputControllers.safelyGetItem(at: currentPage) else { return }
        searchBar.text = controllerWithSearch.searchText
    }
}

extension MainScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let controllerWithSearch = searchInputControllers.safelyGetItem(at: currentPage) else { return }
        controllerWithSearch.searchTextDidChanged(to: searchText)
    }
}
