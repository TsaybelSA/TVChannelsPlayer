//
//  TabBarContainerViewController.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 12.06.2023.
//

import UIKit

// Based on Mohamed Shaat TabBarContainerViewController

public protocol TabBarDataSourse {
    func configureTabCell(collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
    func registerCell(for collectionView: UICollectionView)
}

protocol TabBarDelegate {
    func move()
}

public protocol TabItemRegister {
    var tabCellClass: AnyClass { get }
}

enum MoveType {
    case containerScrollMove
    case topBarScrollMove
    case topBarSelection
}

open class TabBarContainerViewController: UIViewController, TabItemRegister {
    // MARK: - Main entities
    /// Collection used to display tab items
    public var tabsCollectionView: UICollectionView!
    
    /// Cell class which is used to register collection view cell
    public var tabCellClass: AnyClass = UICollectionViewCell.self
    
    /// Scroll view used to display main content similar with UITabView
    public var scrollView: UIScrollView!
    
    // MARK: - cell selection indicator
    /// Tab selection indicator view
    public var pageIndicatorView: UIView?
    
    /// Tab selection indicator color
    public var selectedIndicatorColor = UIColor.blue
    
    /// The value in CGFloat by which the indicator will protrude to the left and right of the cell content
    public var indicatorAdditionWidth: CGFloat = 10.0
    
    // MARK: -
    
    private var _currentPage = 0
    public var currentPage: Int {
        get { _currentPage }
        set {
            guard _currentPage != newValue else { return }
            _currentPage = newValue
            currentTabDidChanged()
        }
    }

    public var tabBarShouldFillWidth = false
    public var tabBarWidth = 0.0
    var numberOfItemsAppearInOnePage = 0
    public var indicatorHeight: CGFloat = 1.0
    var moveType: MoveType = .containerScrollMove
    var minimumLineSpacing: CGFloat = 0.0
    var minimumInteritemSpacing: CGFloat = 0.0
    
    private(set) var viewControllers: [UIViewController]  = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tabsCollectionView.delegate = self
    }
    
    override open func viewDidLayoutSubviews() {
        reloadTabBar()
    }
    
    func getBundle(cellIdentifier: String) -> Bundle {
        if cellIdentifier == TabBarCell.reuseIdentifier {
            return Bundle(for: TabBarContainerViewController.classForCoder())
        }
        return Bundle(for: NSObject.classForCoder())
    }
    
    public func setupTabBar(viewControllers : [UIViewController]) {
        self.viewControllers = viewControllers
        tabsCollectionView.dataSource = self
        tabsCollectionView.delegate = self
    }
    
    private func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.scrollDirection = .horizontal
        tabsCollectionView.isPagingEnabled = true
        tabsCollectionView.showsHorizontalScrollIndicator = false
        if tabBarWidth == 0 || tabBarShouldFillWidth {
            numberOfItemsAppearInOnePage = viewControllers.count
            tabBarWidth = Double(tabsCollectionView.frame.size.width) / Double(viewControllers.count) - Double(minimumLineSpacing)
        } else {
            numberOfItemsAppearInOnePage = Int(Double(tabsCollectionView.frame.size.width) / (Double(tabBarWidth) + Double(minimumLineSpacing)))
        }
        layout.itemSize = CGSize(width: CGFloat(tabBarWidth), height: tabsCollectionView.frame.size.height)
        tabsCollectionView.collectionViewLayout = layout
    }
    
    private func setupSlideScrollView() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(viewControllers.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        for i in 0 ..< viewControllers.count {
            viewControllers[i].view.frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            if (UIView.appearance().semanticContentAttribute == .forceRightToLeft) {
                viewControllers[i].view.transform = CGAffineTransform(scaleX: -1,y: 1);
            }
            scrollView.addSubview(viewControllers[i].view)
            self.addChild(viewControllers[i])
        }
    }
    
    public func reloadTabBar() {
        setupSlideScrollView()
        layoutCells()
        setTabBarIndicator()
        self.moveTo(page: self.currentPage,animated: false)
        if (UIView.appearance().semanticContentAttribute == .forceRightToLeft) {
            self.scrollView.transform = CGAffineTransform(scaleX: -1,y: 1);
            self.tabsCollectionView.semanticContentAttribute = .forceRightToLeft
        } else {
            self.tabsCollectionView.semanticContentAttribute = .forceLeftToRight
        }
        changetabsViewFrame()
    }
    
    func changetabsViewFrame(animated: Bool = true) {
        var tabsViewFrame: CGRect = self.tabsCollectionView.frame
        if let frame = getFrameForCurrentCell() {
            tabsViewFrame.origin.x = frame.origin.x - CGFloat(tabBarWidth)
        } else {
            tabsViewFrame.origin.x = 0.0
        }
        tabsViewFrame.size.width = CGFloat(tabBarWidth + Double(minimumLineSpacing)) * CGFloat((numberOfItemsAppearInOnePage))
        tabsViewFrame.origin.y = 0
        self.tabsCollectionView.scrollRectToVisible(tabsViewFrame, animated: true)
        self.moveTo(page: Int( self.currentPage))
        
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView != self.scrollView {
            targetContentOffset.pointee = scrollView.contentOffset
            if velocity.x > 0 {
                if (UIView.appearance().semanticContentAttribute == .forceRightToLeft) {
                    self.currentPage = self.currentPage - 1
                } else {
                    self.currentPage = self.currentPage + 1
                }
            } else if velocity.x < 0 {
                if (UIView.appearance().semanticContentAttribute == .forceRightToLeft) {
                    self.currentPage = self.currentPage + 1
                } else {
                    self.currentPage = self.currentPage - 1
                }
                
            }
            moveType = .topBarScrollMove
            changetabsViewFrame()
        }
    }
    
    public func moveTo(page: Int, animated: Bool = true) {
        currentPage = page
        self.scrollToPage(page: page, animated: animated)
        self.tabsCollectionView.selectItem(at: IndexPath(row: page, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        updateIndicatorView()
        updateItemsSelection()
    }
    
    
    func scrollToPage(page: Int, animated: Bool) {
        currentPage = page
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: animated)
        
    }
    
    private func updateItemsSelection() {
        guard let selectedCellIndexPath = tabsCollectionView.indexPathsForSelectedItems?.first else { return }
        tabsCollectionView.visibleCells.forEach({ cell in
            cell.isSelected = false
        })
        tabsCollectionView.cellForItem(at: selectedCellIndexPath)?.isSelected = true
    }
}

extension TabBarContainerViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            moveType = .containerScrollMove
            currentPage = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
            changetabsViewFrame()
            updateIndicatorView()
        }
    }
}

extension TabBarContainerViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vc = viewControllers[indexPath.row] as? TabBarDataSourse else { return UICollectionViewCell() }
        
        vc.registerCell(for: collectionView)
        
        return vc.configureTabCell(collectionView: collectionView, for: indexPath)
    }
}

extension TabBarContainerViewController : UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveType = .topBarSelection
        self.moveTo(page: indexPath.row)
    }
}

extension TabBarContainerViewController {
    func getCurrentSortInPage() -> Int {
        
        if (self.numberOfItemsAppearInOnePage >= self.viewControllers.count) {
            return self.currentPage
        }
        
        if(self.currentPage < self.viewControllers.count - self.numberOfItemsAppearInOnePage) {
            return 0
        } else {
            return abs(self.viewControllers.count - self.currentPage - self.numberOfItemsAppearInOnePage)
        }
    }
    
    func getFrameForCurrentCell() -> CGRect? {
        let indexPath = IndexPath(item: self.currentPage, section: 0)
        let rect = self.tabsCollectionView.layoutAttributesForItem(at: indexPath)?.frame
        return rect
    }
    
    func setTabBarIndicator(){
        if pageIndicatorView == nil {
            pageIndicatorView = UIView()
            guard let pageIndicatorView else { return }
            let cellFrame = getFrameForCurrentCell()
            if let cellFrame = cellFrame {
                pageIndicatorView.frame = CGRect(x: cellFrame.origin.x,
                                                 y: cellFrame.size.height - indicatorHeight,
                                                 width: cellFrame.size.width,
                                                 height: indicatorHeight )
                pageIndicatorView.backgroundColor = selectedIndicatorColor
                tabsCollectionView.addSubview(pageIndicatorView)
            }
        }
    }
    
    func updateIndicatorView() {
        if let indictaorPage = pageIndicatorView {
            UIView.animate(withDuration: 0.3, animations: {
                indictaorPage.backgroundColor = self.selectedIndicatorColor
                let cellFrame = self.getFrameForCurrentCell()
                if let cellFrame = cellFrame {
                    indictaorPage.frame = CGRect(x: cellFrame.origin.x,
                                                 y: cellFrame.size.height - self.indicatorHeight,
                                                 width: cellFrame.size.width,
                                                 height: self.indicatorHeight)
                }
            })
        }
    }
    
    @objc
    public func currentTabDidChanged() {}
}

extension TabBarContainerViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth: CGFloat = 10.0
        if let cell = collectionView.cellForItem(at: indexPath) as? TabBarCell {
            cellWidth = cell.title.frame.width + indicatorAdditionWidth * 2
        }
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
}
