//
//  PlayerViewController.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 16.06.2023.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {

    // MARK: - Properties
    private let channel: Channel
    private let imageLoader: ImageLoaderInterface
    
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
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.isNavigationBarHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(invokeInterfaceAction))
        view.addGestureRecognizer(tapGesture)
        
        view.layer.addSublayer(playerLayer)
        view.backgroundColor = Colors.secondaryBackgroundColor
        view.addSubview(navigationBar)
        
        view.addSubview(bottomBar)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: Size.navBarHeight),
            
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: Size.navBarHeight),
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
        bottomBar.settingsButtonAction = {
            print("show quality set view")
        }
        
        bottomBar.moveToTime = { time in
            // here code to adjust time for player item
        }
    }
    
    private func addPlayer() {
        // на данный момент используется дефолтный URL,
        // тк в API недействующие ссылки
        
//        guard let url = URL(string: "https://sitv.ru/hls/s861024.m3u8") else { return }
//        let player = AVPlayer(url: url)
//        playerLayer.player = player
//        player.play()
    }
    
    // MARK: - Actions
    
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
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.navigationBar.isHidden = true
                self.bottomBar.isHidden = true
                
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
