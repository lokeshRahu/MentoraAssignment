//
//  Helper.swift
//  MentoraAssignment
//
//  Created by Lokesh Lebaka on 17/09/22.
//

import Foundation

class Helper {
    
    private static let locale: Locale = {
        var loc = Locale.current
        if loc.languageCode != "en" {
            loc = Locale(identifier: "en_US")
        }
        return loc
    }()
    
    static func getLastUpdatedDateString(dateString: String?) -> String {
        
        if let date = dateString {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Helper.locale
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            
            if let dt = dateFormatter.date(from: date){
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
                return "Last activity: \(formatter.string(from: dt))"
            }
        }
        return "Date unavailable..."
    }
    
}

