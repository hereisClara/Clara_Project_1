//
//  URLSession.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/18.
//

import Foundation

protocol MarketManagerDelegate {

    func manager(_ manager: MarketManager, didGet marketingHots: [Hots])

    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {

    func getMarketingHots() {
        let url = URL(string: "https://api.appworks-school.tw/api/1.0/marketing/hots")!
        let session = URLSession.shared
        let task = session.dataTask(with: url){
            (data, response, error) in
        }
    }
}

struct product {
    let title: String
    let 
}
