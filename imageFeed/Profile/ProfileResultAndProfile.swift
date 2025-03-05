//
//  ProfileResultAndProfile.swift
//  imageFeed
//
//  Created by Maxim on 05.03.2025.
//

import Foundation
struct ProfileResult:Codable{
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
   
}

struct Profile{
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}
