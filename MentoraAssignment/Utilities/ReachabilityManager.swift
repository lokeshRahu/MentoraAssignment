//
//  ReachabilityManager.swift
//  GitHubUserSearch
//
//  Created by Lokesh Lebaka on 18/09/22.
//

import Foundation
import Reachability

class ReachabilityManager {
    
    private init() {}
    static let shared = ReachabilityManager()
    
    let reachability = try! Reachability()
    
    func isReachable() -> Bool{
        return reachability.connection != .unavailable ? true : false
    }
}
