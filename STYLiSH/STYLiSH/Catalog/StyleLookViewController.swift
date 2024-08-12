//
//  StyleLookViewController.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/22.
//

import UIKit
import Alamofire
import Kingfisher
import MJRefresh

class StyleLookViewController: ViewController {
    
    var styleLookProduct = [Product]()
    var styleLookDataRequest = StyleLookDataRequest()
    
    @IBOutlet weak var girlStyleButton: UIButton!
    @IBOutlet weak var boyStyleButton: UIButton!
    @IBOutlet weak var accessoryButton: UIButton!
    @IBOutlet weak var styleLookCollectionView: UICollectionView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var underlineViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineView: UIView!
    
    var currentPage: PageType = .girl
    
    enum PageType {
        case girl
        case boy
        case accessory
    }
    
    @IBAction func touchGirlStyleButton(_ sender: Any) {
        
        currentPage = .girl
        setButtonConstraint(button: girlStyleButton)
        resetButtonColors()
        girlStyleButton.tintColor = .darkGray
        styleLookDataRequest.requestWomanData(page: nil)
    }
    
    @IBAction func touchBoyStyleButton(_ sender: Any) {
        
        currentPage = .boy
        setButtonConstraint(button: boyStyleButton)
        resetButtonColors()
        boyStyleButton.tintColor = .darkGray
        styleLookDataRequest.requestManData()
    }
    
    @IBAction func touchAccessoryButton(_ sender: Any) {
        
        currentPage = .accessory
        setButtonConstraint(button: accessoryButton)
        resetButtonColors()
        accessoryButton.tintColor = .darkGray
        styleLookDataRequest.requestAccessoryData()
    }
    
    //    MARK: life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        styleLookDataRequest.requestWomanData(page: nil)
        
        styleLookCollectionView.dataSource = self
        styleLookCollectionView.delegate = self
        
        styleLookDataRequest.delegate = self
        
        girlStyleButton.tintColor = .darkGray
        
        styleLookRefreshDataForHeader()
        styleLookRefreshDataForFooter()
    }
    
    //    MARK: animation for button and underline
    func setButtonConstraint(button: UIButton) {
        
        underlineViewCenterXConstraint.isActive = false
        underlineViewCenterXConstraint = underlineView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        underlineViewCenterXConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func resetButtonColors() {
        
        girlStyleButton.tintColor = .lightGray
        boyStyleButton.tintColor = .lightGray
        accessoryButton.tintColor = .lightGray
    }
}
//    MARK: collection view
extension StyleLookViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleLookProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = view.frame.width * 0.44
        let height: CGFloat = view.frame.height * 0.35
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        UIEdgeInsets(
            top: view.frame.height * 0.01,
            left: view.frame.width * 0.04,
            bottom: view.frame.height * 0.015,
            right: view.frame.width * 0.04
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let styleLookCell = styleLookCollectionView.dequeueReusableCell(withReuseIdentifier: "StyleLookCell", for: indexPath) as! StyleLookCollectionViewCell
        
        styleLookCell.styleLookCellLabel1.textColor = .darkGray
        styleLookCell.styleLookCellLabel2.textColor = .darkGray
        
        let styleLookCellPhoto = styleLookCell.styleLookCellPhoto
        styleLookCellPhoto?.kf.setImage(with: URL(string: styleLookProduct[indexPath.item].mainImage))
        
        styleLookCell.styleLookCellLabel1.text = styleLookProduct[indexPath.item].title
        styleLookCell.styleLookCellLabel2.text = String(styleLookProduct[indexPath.item].price)
        
        return styleLookCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let lineSpacing: CGFloat
        lineSpacing = view.frame.height * 0.025
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        view.frame.width * 0.04
    }
}
//  MARK: get data
extension StyleLookViewController: StyleLookDataDelegate {
    
    func getStyleLookData(_ manager: StyleLookDataRequest, didGet marketingHots: ProductResponse) {
        
        if styleLookDataRequest.nextPagingIsNil == true {
            self.styleLookProduct = marketingHots.data
            self.styleLookCollectionView?.reloadData()
            
        } else {
            
            self.styleLookProduct.append(contentsOf: marketingHots.data)
            self.styleLookCollectionView?.reloadData()
        }
        
        self.styleLookCollectionView?.mj_header?.endRefreshing()
        self.styleLookCollectionView?.mj_footer?.endRefreshing()
    }
    
    func getStyleLookData(_ manager: StyleLookDataRequest, didFailWith error: any Error) {
        
        self.styleLookCollectionView?.mj_header?.endRefreshing()
        self.styleLookCollectionView?.mj_footer?.endRefreshing()
        return
    }
    
    //    MARK: send data in style look page.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = DetailPageViewController()
        let selectedProduct = styleLookProduct[indexPath.item]
        detailVC.selectedProduct = selectedProduct
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func styleLookRefreshDataForHeader() {
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(styleLookSwipeUpRefreshData))
        styleLookCollectionView?.mj_header = header
        MJRefreshConfig.default.languageCode = "en"
    }
    
    @objc func styleLookSwipeUpRefreshData() {
        
        switch currentPage {
            
        case .girl:
            styleLookDataRequest.requestWomanData(page: nil)
        case .boy:
            styleLookDataRequest.requestManData()
        case .accessory:
            styleLookDataRequest.requestAccessoryData()
        }
    }
    
    func styleLookRefreshDataForFooter() {
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(styleLookSwipeDownRefreshData))
        styleLookCollectionView?.mj_footer = footer
        MJRefreshConfig.default.languageCode = "en"
    }
    
    @objc func styleLookSwipeDownRefreshData() {
        
        switch currentPage {
            
        case .girl:
            if styleLookDataRequest.nextPagingIsNil == true {
                styleLookDataRequest.requestWomanData(page: 1)
            } else {
                styleLookCollectionView.mj_footer?.endRefreshingWithNoMoreData()
            }
        case .boy, .accessory:
            styleLookCollectionView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
}
