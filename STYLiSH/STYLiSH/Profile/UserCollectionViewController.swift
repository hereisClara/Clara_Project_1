//
//  UserCollectionView.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/21.
//

import Foundation
import UIKit
import FacebookLogin
import Kingfisher

class UserViewController: UIViewController {
    
    var userName = String()
    var userPhoto = String()
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userphotoImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        userCollectionView?.dataSource = self
        userCollectionView?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if let savedToken = getToken() {
            getUserInfo()
        }
    }
    
    func getUserInfo(){
        
        if let savedToken = UserDefaults.standard.string(forKey: "userToken") {
            
            FacebookUserData.shared.getUserData(token: savedToken) { result in
                switch result {
                case .success(let signInResponse):
                    self.userName = signInResponse.data.name
                    self.userPhoto = signInResponse.data.picture
                    self.updateUI()
                case .failure(let error):
                    break
                }
            }
        } else {
            
        }
    }
    
    func saveToken(token: String) {
        
        UserDefaults.standard.set(token, forKey: "userToken")
    }
    
    func getToken() -> String? {
        
        return UserDefaults.standard.string(forKey: "userToken")
    }
}

extension UserViewController {
    
    func updateUI() {
        
        DispatchQueue.main.async {
            self.userNameLabel.text = self.userName
            self.userphotoImageView.kf.setImage(with: URL(string: self.userPhoto))
            self.userphotoImageView.layer.cornerRadius = self.userphotoImageView.frame.width / 2
            self.userphotoImageView.layer.masksToBounds = true
        }
    }
}

extension UserViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 5
        } else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let userCell = userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCollectionViewCell
        
        let imageName = userCell.collectionViewImageName[indexPath.section][indexPath.item]
        userCell.userCellImage.image = UIImage(named: imageName)
        let labelContent = userCell.collectionViewLabelContent[indexPath.section][indexPath.item]
        userCell.userCellLabel.text = labelContent
        
        return userCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        UIEdgeInsets(
            top: 0,
            left: view.frame.width * 0.06,
            bottom: 0,
            right: view.frame.width * 0.06
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (view.frame.width * 0.765) / 5
        let height: CGFloat = view.frame.height * 0.073
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let spacing: CGFloat
        if section == 0 {
            spacing = (view.frame.width * 0.115) / 4
        } else {
            spacing = (view.frame.width * 0.12) / 3
        }
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let lineSpacing: CGFloat
        lineSpacing = view.frame.height * 0.025
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        CGSize(width: view.frame.width, height: view.frame.height * 0.125)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        
        if indexPath.section == 0 {
            headerView.headerLabel.text = "我的訂單"
            headerView.seeMoreLabel.text = "查看全部"
        } else {
            headerView.headerLabel.text = "更多服務"
            headerView.seeMoreLabel.text = ""
        }
        return headerView
    }
}




