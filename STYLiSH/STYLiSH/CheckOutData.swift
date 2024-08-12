//
//  CheckOutData.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/9.
//

import Foundation
import Alamofire

class CheckOutData {
    
    static let shared = CheckOutData()
    
    private init() {}
    
    func postOrder( prime: String, subtotal: Int, total: Int, name: String, phone: String, email: String, address: String, time: String, list: [[String: Any]]) {
        
        let urlString = "https://api.appworks-school.tw/api/1.0/order/checkout"
        
        if let getToken = getToken() {
            let headers: HTTPHeaders = [
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(getToken)"
                    ]
            
            let orderData = createJSON(prime: prime, subtotal: subtotal, total: total, name: name, phone: phone, email: email, address: address, time: time, list: list)
                    
                    AF.request(urlString, method: .post, parameters: orderData, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON { response in
                            switch response.result {
                            case .success(let json):
                                if json is [String: Any] {
                                    
                                } else {
                                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"])
                                }
                            case .failure(let error): break
                                
                            }
                        }
        }
    
        
        
        
        
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "userToken")
    }
    
    func createJSON(prime: String, subtotal: Int, total: Int, name: String, phone: String, email: String, address: String, time: String, list: [[String: Any]] ) -> [String: Any]{
        let coreDataOrder: [String: Any] = [
            "prime": prime,
            "order": [
                "shipping": "delivery",
                "payment": "credit_card",
                "subtotal": subtotal,
                "freight": 60,
                "total": total,
                "recipient": [
                    "name": name,
                    "phone": phone,
                    "email": email,
                    "address": address,
                    "time": time
                ],
                "list": list
            ]
        ]
        return coreDataOrder
    }
    
    func createListJSON(name: String, stock: String, price: Int, colorCode: String, colorName: String, size: String, cartNumber: Int, id: String) -> [String: Any]{
        let listItem: [String: Any] = [
                "name": name,
                "stock": stock,
                "size": size,
                "price": price,
                "color": [
                    "code": colorCode,
                    "name": colorName
                ],
                "qty": cartNumber,
                "id": id,
            ]
            return listItem
    }
}






