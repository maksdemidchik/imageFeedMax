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

public struct Profile{
    let username: String
    public let name: String
    public let loginName: String
    public let bio: String?
}
