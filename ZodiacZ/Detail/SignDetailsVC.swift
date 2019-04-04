//
//  SignDetailsVC.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 3/20/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SignDetailsVC: BaseCollectionVC, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, GADBannerViewDelegate {
    
    let cellId = "cellId"
    let cellCompatibility = "cellCompatibility"
    var sign: Sign
    var adBanner = GADBannerView(adSize: kGADAdSizeBanner)
    
    init(sign: Sign) {
        self.sign = sign
        super.init()
    }
   
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinitialization SignDetailsVC")
    }
    
    func loadAdsBanner() {
        adBanner.adUnitID = "ca-app-pub-6518422758055129/3644849669"
        adBanner.rootViewController = self
        adBanner.delegate = self
        let request = GADRequest()
        // request.testDevices = ["0e0424f2376e4f55496b45bd0462653f"];
        adBanner.load(request)
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(adBanner)
        adBanner.fillSuperview(padding: .init(top: view.frame.height - adBanner.bounds.size.height, left: (view.frame.width - adBanner.bounds.size.width) / 2, bottom: 0, right: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        view.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adBanner.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        collectionView.register(SignDetailsCell.self, forCellWithReuseIdentifier: Sign.CellType.normal.rawValue)
        collectionView.register(CompatibilityCell.self, forCellWithReuseIdentifier: Sign.CellType.compatibility.rawValue)
        collectionView.backgroundColor = #colorLiteral(red: 0.9713277284, green: 0.9713277284, blue: 0.9713277284, alpha: 1)
        loadAdsBanner()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sign.getGroup().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = self.sign.getGroup()[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseCollectionCell
        cell.sign = self.sign.getGroup()[indexPath.item]
        return cell        
    }
    
    static let normalSize: CGFloat = 500
    static let smallCell: CGFloat = 300
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = self.sign.getGroup()[indexPath.item].cellType
        let height = (cellType == .normal) ? SignDetailsVC.normalSize : SignDetailsVC.smallCell
        return .init(width: view.frame.width - 64, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        showSingleAppFullScreen(indexPath: indexPath)
    }
    
    fileprivate func showSingleAppFullScreen(indexPath: IndexPath) {
        // setup AppFullscreenController() instance
        setupSingleAppFullscreenController(indexPath)
        // setup fullscreen in its starting position
        setupAppFullscreenStartingPosition(indexPath)
        // begin the fullscreen animation
        beginAnimationAppFullscreen()
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let signFullscreenVC =  SignFullscreenVC()
        signFullscreenVC.sign = self.sign.getGroup()[indexPath.item]
        signFullscreenVC.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        self.signFullscreenVC = signFullscreenVC
        signFullscreenVC.view.layer.cornerRadius = 16
        addChild(signFullscreenVC)
        
        // setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        signFullscreenVC.view.addGestureRecognizer(gesture)
    }
    
    var anchoredConstraint: AnchoredConstraints?
    var startingFrame: CGRect?
    var selectedCell: BaseCollectionCell?
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        // absolute coordinate of the cell
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
        self.selectedCell = cell as? BaseCollectionCell
        self.selectedCell?.alpha = 0
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        self.collectionView.isUserInteractionEnabled = false
        let fullscreenView = self.signFullscreenVC.view!
        view.addSubview(fullscreenView)
        setupStartingCellFrame(indexPath)
        
        // auto layout constraint animations
        guard let startingFrame = self.startingFrame else { return }
        self.anchoredConstraint = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets.init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded()
    }
    
    fileprivate func beginAnimationAppFullscreen() {
        
        navigationController?.isNavigationBarHidden = true
        
        // we are using frames for animation, frames are not reliable enough for animation
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.blurVisualEffectView.alpha = 1
            self.anchoredConstraint?.top?.constant = 0
            self.anchoredConstraint?.leading?.constant = 0
            self.anchoredConstraint?.width?.constant = self.view.frame.width
            self.anchoredConstraint?.height?.constant = self.view.frame.height

            self.view.layoutIfNeeded() // start animation
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)

            guard let cell = self.signFullscreenVC.tableView.cellForRow(at: [0,0]) as? SignFullscreenHeaderCell else { return }
            cell.signDetailsCelll.topConstraint.constant = 48
            cell.layoutIfNeeded()

        }, completion: nil)
    }
    
    var signFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            signFullscreenBeginOffset = signFullscreenVC.tableView.contentOffset.y
        }
        if signFullscreenVC.tableView.contentOffset.y > 0 { return }
        let translationY = gesture.translation(in: signFullscreenVC.view).y
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - signFullscreenBeginOffset
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.signFullscreenVC.view.transform = transform
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    var signFullscreenVC: SignFullscreenVC!
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc fileprivate func handleAppFullscreenDismissal() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.signFullscreenVC.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            self.navigationController?.isNavigationBarHidden = false
            
            guard let startingFrame = self.startingFrame else { return }
            self.anchoredConstraint?.width?.constant = startingFrame.width
            self.anchoredConstraint?.height?.constant = startingFrame.height
            self.signFullscreenVC.view.transform = CGAffineTransform(translationX: startingFrame.origin.x, y: startingFrame.origin.y)
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            self.signFullscreenVC.closeButton.alpha = 0
            self.blurVisualEffectView.alpha = 0
            self.view.layoutIfNeeded()
           
            if let cell = self.signFullscreenVC.tableView.cellForRow(at: [0,0]) as? SignFullscreenHeaderCell {
                cell.signDetailsCelll.descriptionLabel.isHidden = false
                cell.signDetailsCelll.topConstraint.constant = 24
                cell.layoutIfNeeded()
            } else if let cell = self.signFullscreenVC.tableView.cellForRow(at: [0,0]) as? CompatibilityFullscreenHeaderCell  {
                cell.compatibilityCell.descriptionLabel.isHidden = false
                cell.compatibilityCell.topConstraint.constant = 24
                cell.layoutIfNeeded()
            }
        }, completion: { _ in
            self.selectedCell?.alpha = 1
            self.signFullscreenVC.view.removeFromSuperview()
            self.signFullscreenVC.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
}
