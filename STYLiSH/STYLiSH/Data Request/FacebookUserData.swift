//
//  FacebookuserData.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/8.
//

import Foundation
import Alamofire

class FacebookUserData {
    
    var accessToken = String()
    
    var userName = String()
    var userPhoto = String()
    
    static let shared = FacebookUserData()
    
    private init() {}
    
    func sendSignInDataToServer(token: String, completion: @escaping (Result<SignInResponse, Error>) -> Void) {
        let urlString = "https://api.appworks-school.tw/api/1.0/user/signin"
        
        let parameters: [String: Any] = [
            "provider": "facebook",
            "access_token": token
        ]
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: SignInResponse.self) { response in
                switch response.result {
                case .success(let signInResponse):
                    self.accessToken = signInResponse.data.access_token
                    self.saveToken(token: signInResponse.data.access_token)
                    completion(.success(signInResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getUserData(token: String, completion: @escaping (Result<UserProfileResponse, Error>) -> Void) {
        let urlString2 = "https://api.appworks-school.tw/api/1.0/user/profile"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(urlString2, method: .get, headers: headers)
            .responseDecodable(of: UserProfileResponse.self) { response in
                switch response.result {
                case .success(let userProfileResponse):
                    let user = userProfileResponse.data
                    completion(.success(userProfileResponse))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: "userToken")
    }
}

struct User: Codable {
    let id: Int
    let provider: String
    let name: String
    let email: String
    let picture: String
}

struct SignInResponseData: Codable {
    let access_token: String
    let access_expired: String
    let user: User
}

struct SignInResponse: Codable {
    let data: SignInResponseData
}

struct UserDecode: Codable {
    let provider: String
    let name: String
    let email: String
    let picture: String
}

struct UserProfileResponse: Codable {
    let data: UserDecode
}

