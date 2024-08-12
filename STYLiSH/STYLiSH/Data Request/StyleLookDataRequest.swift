//
//  StyleLookDataRequest.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/23.
//

import Foundation
import Alamofire

protocol StyleLookDataDelegate {
    
    func getStyleLookData(_ manager: StyleLookDataRequest, didGet marketingHots: ProductResponse)
    
    func getStyleLookData(_ manager: StyleLookDataRequest, didFailWith error: Error)
}

protocol ProductProtocol {
    var id: Int { get }
    var category: String { get }
    var title: String { get }
    var description: String { get }
    var price: Int { get }
    var texture: String { get }
    var wash: String { get }
    var place: String { get }
    var note: String { get }
    var story: String { get }
    var colors: [Colors] { get }
    var sizes: [String] { get }
    var variants: [Variants] { get }
    var mainImage: String { get }
    var images: [String] { get }
}

class StyleLookDataRequest {
    
    var delegate: StyleLookDataDelegate?
    var nextPagingIsNil: Bool?
    
    func requestWomanData(page: Int?) {
        
        var url = String()
        
        if page == nil {
            nextPagingIsNil = true
            url = "https://api.appworks-school.tw/api/1.0/products/women"
        } else {
            nextPagingIsNil = false
            url = "https://api.appworks-school.tw/api/1.0/products/women?paging=1"
        }
        
        AF.request(url).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let response):
                DispatchQueue.main.async{
                    self.delegate?.getStyleLookData(self, didGet: response)
                }
            case .failure(let error):
                break
            }
        }
    }
    
    func requestManData() {
        nextPagingIsNil = true
        let url = "https://api.appworks-school.tw/api/1.0/products/men"
        AF.request(url).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.delegate?.getStyleLookData(self, didGet: response)
                }
            case .failure(let error):
                break
            }
        }
    }
    
    func requestAccessoryData() {
        nextPagingIsNil = true
        let url = "https://api.appworks-school.tw/api/1.0/products/accessories"
        AF.request(url).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.delegate?.getStyleLookData(self, didGet: response)
                }
            case .failure(let error):
                break
            }
        }
    }
}

struct ProductResponse: Decodable {
    let data: [Product]
    let nextPaging: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextPaging = "next_paging"
    }
}

struct Product: Decodable, ProductProtocol {
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


