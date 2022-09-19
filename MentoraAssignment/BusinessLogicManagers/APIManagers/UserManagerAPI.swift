//
//  UserManagerAPI.swift
//  MentoraAssignment
//
//  Created by Lokesh Lebaka on 17/09/22.
//

import Foundation

class UserManagerAPI {
    
    private init() {}
    static let shared = UserManagerAPI()
    
    private let gitHubURL = "https://api.github.com/users/"

    func getUserDetails(name: String, completion: @escaping (_ error: Error?, _ user: User?) -> Void) {
        
        let url = "\(gitHubURL)\(name)"
        
        URLSessionAPI.sharedAPI.performRequest(urlString: url, type: .get) { statusCode, response, data, error in
            
            if statusCode == .success {
                
                if let userDict = response as? [String: Any] {
                    DispatchQueue.main.async {
                        CoreDataUserManager.shared.saveUserToLocalDB(userDict: userDict, isFollower: false, completion: { (user) in
                            completion(nil, user)
                        })
                    }
                }
                
            } else {
                completion(error, nil)
            }
        }
    }
    
    func getUserFollowersDetails(url: String, completion: @escaping (_ error: Error?, _ user: [User]) -> Void) {
        
        URLSessionAPI.sharedAPI.performRequest(urlString: url, type: .get) { statusCode, response, data, error in
            
            if statusCode == .success {
                
                if let usersDict = response as? [[String: Any]] {
                    var usersArray: [User] = []
                    for userDict in usersDict {
                        CoreDataUserManager.shared.saveUserToLocalDB(userDict: userDict, isFollower: true, completion: { (user) in
                            if let u = user { usersArray.append(u)}
                        })
                    }
                    completion(nil, usersArray)
                }
            } else {
                completion(error, [])
            }
        }
    }
}

