//
//  SignFullscreenVC.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 3/21/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

class SignFullscreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.7090422144, green: 0.6409538497, blue: 0.9686274529, alpha: 1)
        return button
    }()
    
    var sign: Sign?
    var dismissHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height + 50
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        
        setupCloseButton()       
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        guard let signDetailsVC = navigationController?.viewControllers[1] as? SignDetailsVC else { return }
        signDetailsVC.adBanner.isHidden = true
        
        guard let sign = sign else { return }
        let items = [sign.title + "\n\n" + ((sign.trait == nil) ? (sign.description) : (sign.trait! + "\n\n" + sign.description))]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.completionWithItemsHandler = {(_,_,_,_) in
            signDetailsVC.adBanner.isHidden = false
        }
        present(ac, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(handleDismiss(button:)), for: .touchUpInside)
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (sign?.cellType == .normal) ? SignDetailsVC.normalSize : SignDetailsVC.smallCell
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            guard let sign = sign else { return UITableViewCell() }
            if sign.cellType == .normal {
                let headerCell = SignFullscreenHeaderCell()
                headerCell.signDetailsCelll.sign = self.sign
                headerCell.signDetailsCelll.backgroundView = nil
                headerCell.signDetailsCelll.descriptionLabel.isHidden = true
                return headerCell
            } else {
                let headerCell = CompatibilityFullscreenHeaderCell()
                headerCell.compatibilityCell.sign = self.sign
                headerCell.compatibilityCell.backgroundView = nil
                headerCell.compatibilityCell.descriptionLabel.isHidden = true
                return headerCell
            }
        }
        let cell = SignFullscreenDescriptionCell()
        cell.sign = self.sign
        cell.shareButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        return cell
    }
    
    deinit {
        print("Deinitialization SignFullscreenVC")
    }
}
