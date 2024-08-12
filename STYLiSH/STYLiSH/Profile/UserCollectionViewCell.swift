//
//  UserCollectionViewCell.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/22.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userCellImage: UIImageView!
    @IBOutlet weak var userCellLabel: UILabel!
    
    let collectionViewImageName: Array = [
            
            ["Icons_24px_AwaitingPayment",
            "Icons_24px_AwaitingShipment",
            "Icons_24px_Shipped",
            "Icons_24px_AwaitingReview",
            "Icons_24px_Exchange"],
            
            ["Icons_24px_Starred",
             "Icons_24px_Notification",
             "Icons_24px_Refunded",
             "Icons_24px_Address",
             "Icons_24px_CustomerService",
             "Icons_24px_SystemFeedback",
             "Icons_24px_RegisterCellphone",
             "Icons_24px_Settings"]
        ]
    
    let collectionViewLabelContent: Array = [
        ["待付款", "待出貨", "待簽收", "待評價", "退換貨"],
        ["收藏", "貨到通知", "帳戶退款", "地址", "客服訊息", "系統回饋", "手機綁定", "設定"]
    ]
}


