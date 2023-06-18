//
//  PlayerViewController.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 16.06.2023.
//

import UIKit
import AVKit

enum VideoQualityType: String, CaseIterable {
    case fullHD = "1080p"
    case hd = "720p"
    case sd = "480p"
    case lowSD = "360p"
    case auto = "AUTO"
}

class PlayerViewController: UIViewController {

    // MARK: - Properties
    private let channel: Channel
    private let imageLoader: ImageLoaderInterface
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var currentQuality: VideoQualityType = .auto
    
    private var isShowingInterface = false
    private var isAnimationFinished = true
    
    private var hideInterfaceWorkItem: DispatchWorkItem?
    private let barColors = [#colorLiteral(red: 0.05490196078, green: 0.05882352941, blue: 0.05882352941, alpha: 0.9040444303), UIColor.clear]
    
    // MARK: - Views
    
    private lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        return playerLayer
    }()
    
    private var topNavBarTopAnchor: NSLayoutConstraint?
    
    private lazy var navigationBar: PlayerTopBar = {
       let view = PlayerTopBar(colors: barColors)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var bottomBarBottomAnchor: NSLayoutConstraint?
    
    private lazy var bottomBar: PlayerBottomBar = {
        let view = PlayerBottomBar(colors: barColors)
        
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var qualityMenu: CustomizableMenu = {
        let menu = CustomizableMenu(buttonTitles: VideoQualityType.allCases.map({ $0.rawValue }))
        menu.isHidden = true
        menu.layer.opacity = 0
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()
    
    // MARK: - Lifecycle methods
    init(channel: Channel, imageLoader: ImageLoaderInterface) {
        self.channel = channel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addPlayer()
        hideInterface()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = view.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isOnlyLandscape = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isOnlyLandscape = false
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        setupTopBarView()
        setupBottomBarView()
        setupQualityMenu()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.isNavigationBarHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(invokeInterfaceAction))
        view.addGestureRecognizer(tapGesture)
        
        view.layer.addSublayer(playerLayer)
        view.backgroundColor = Colors.secondaryBackgroundColor
        
        view.addSubview(navigationBar)
        view.addSubview(bottomBar)
        view.addSubview(qualityMenu)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: Size.navBarHeight),
            
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: Size.navBarHeight),
            
            qualityMenu.heightAnchor.constraint(equalToConstant: 200),
            qualityMenu.widthAnchor.constraint(equalToConstant: 128),
            qualityMenu.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: -20),
            qualityMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        topNavBarTopAnchor = navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        topNavBarTopAnchor?.isActive = true
        
        bottomBarBottomAnchor = bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomBarBottomAnchor?.isActive = true
    }
    
    private func setupTopBarView() {
        navigationBar.channelDescriptionView.channel = channel
        
        navigationBar.backButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        do {
            try imageLoader.getImage(for: channel.image) { loadedImage, imageURL in
                self.navigationBar.channelDescriptionView.channelImage = loadedImage
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupBottomBarView() {
        bottomBar.settingsButtonAction = { [weak self] in
            self?.toggleSettingsMenuAppearance()
        }
        
        bottomBar.moveToTime = { [weak self] time in
            // here code to adjust time for player item
            
            self?.bottomBar.setMinutesLeftValue(Int(Float.random(in: 0...100)))
        }
        
        // default info
        bottomBar.setMinutesLeftValue(Int(Float.random(in: 0...100)))
    }
    
    private func setupQualityMenu() {
        qualityMenu.buttonActionHandler = { [weak self] title in
            guard let unwrappedTitle = title, let quality = VideoQualityType(rawValue: unwrappedTitle) else { return }
            
            self?.selectQuality(quality)
        }
    }
    
    private func addPlayer() {
        player = AVPlayer()
        playerLayer.player = player
        
        addPlayerItem()
    }
    
    private func addPlayerItem() {
        // на данный момент используется дефолтный URL,
        // тк в API недействующие ссылки
        // в реальном проекте в switch добавить quary URL с качеством ??
        let urlString: String
        switch currentQuality {
        default: urlString = "https://sitv.ru/hls/s861024.m3u8"
        }
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.main.async { [self] in
            let playerItem = AVPlayerItem(url: url)
            self.playerItem = playerItem
            
            player?.replaceCurrentItem(with: playerItem)
            player?.play()
        }
    }
    
    // MARK: - Actions
    
    private func selectQuality(_ quality: VideoQualityType) {
        toggleSettingsMenuAppearance()
        
        currentQuality = quality
        addPlayerItem()
    }
    
    private func toggleSettingsMenuAppearance() {
        guard isAnimationFinished else { return }
        isAnimationFinished = false
        
        let isMenuHidden = qualityMenu.isHidden
        if isMenuHidden {
            qualityMenu.isHidden = !isMenuHidden
        }
        
        UIView.animate(withDuration: 0.5) {
            self.qualityMenu.layer.opacity = isMenuHidden ? 1 : 0
        } completion: { _ in
            if !isMenuHidden {
                self.qualityMenu.isHidden = true
            }
            self.isAnimationFinished = true
        }
    }
    
    private func showInterface() {
        DispatchQueue.executeOnMain { [self] in
            isAnimationFinished = false
            self.navigationBar.isHidden = false
            self.bottomBar.isHidden = false
            
            UIView.animate(withDuration: 0.5) { [self] in
                topNavBarTopAnchor?.constant = 0
                bottomBarBottomAnchor?.constant = 0
                
                navigationBar.layer.opacity = 1
                bottomBar.layer.opacity = 1
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.isShowingInterface = true
                self.isAnimationFinished = true
            }
        }
        
//        scheduleHidingInterface()
    }
    
    private func hideInterface() {
        DispatchQueue.executeOnMain { [self] in
            isAnimationFinished = false
            UIView.animate(withDuration: 0.5) { [self] in
                topNavBarTopAnchor?.constant = -view.safeAreaInsets.top - Size.navBarHeight
                bottomBarBottomAnchor?.constant = Size.navBarHeight
                
                navigationBar.layer.opacity = 0
                bottomBar.layer.opacity = 0
                qualityMenu.layer.opacity = 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.navigationBar.isHidden = true
                self.bottomBar.isHidden = true
                self.qualityMenu.isHidden = true
                
                self.isShowingInterface = false
                self.isAnimationFinished = true
            }
        }
    }
    
    private func scheduleHidingInterface() {
        hideInterfaceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.hideInterface()
        }
        hideInterfaceWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
    }
    
    @objc
    private func invokeInterfaceAction() {
        // начинать действие только после того, как завершилась предыдущая анимация
        guard isAnimationFinished else { return }
        
        isShowingInterface ? hideInterface() : showInterface()
    }
}

extension PlayerViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
