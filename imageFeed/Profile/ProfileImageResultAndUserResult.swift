//
//  ProfileImageResultAndUserResult.swift
//  imageFeed
//
//  Created by Maxim on 05.03.2025.
//

import Foundation
struct ProfileImage:Codable{
    let small: String?
    let medium: String?
    let large: String?
    
    enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}
struct UserResult:Codable{
    let profileImage: ProfileImage
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
