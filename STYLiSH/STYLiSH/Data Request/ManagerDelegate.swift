//
//  manager.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/18.
//

import Foundation

protocol MarketManagerDelegate {
    
    func manager(_ manager: MarketManager, didGet marketingHots: MarketResponse)
    
    func manager(_ manager: MarketManager, didFailWith error: Error)
}

class MarketManager {
    
    var delegate: MarketManagerDelegate?
    
    func getMarketingHots() {
        
        if let url = URL(string: "https://api.appworks-school.tw/api/1.0/marketing/hots") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let item = try decoder.decode(MarketResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.delegate?.manager(self, didGet: item)
                        }
                    } catch {
                        
                    }
                } else if let error {
                    
                }
            }.resume()
        }
    }
}



struct Colors: Codable {
    let code: String
    let name: String
}

struct Variants: Codable {
    let colorCode: String
    let size: String
    let stock: Int
    
    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size
        case stock
    }
}

struct Products: Codable, ProductProtocol {
    let id: Int
    let category: String
    let title: String
    let description: String
    let price: Int
    let texture: String
    let wash: String
    let place: String
    let note: String
    let story: String
    let colors: [Colors]
    let sizes: [String]
    let variants: [Variants]
    let mainImage: String
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, category, title, description, price, texture, wash, place, note, story, colors, sizes, variants
        case mainImage = "main_image"
        case images
    }
}

struct Item: Codable {
    let title: String
    let products: [Products]
}

struct MarketResponse: Codable {
    let data: [Item]
}
