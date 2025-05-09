//
//  PhotoResultAndPhoto.swift
//  imageFeed
//
//  Created by Maxim on 20.03.2025.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let description: String?
    let isLiked: Bool
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case description
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let thumb: String
    let full: String
}
